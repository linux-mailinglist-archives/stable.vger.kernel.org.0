Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E12637C9F3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbhELQXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240611AbhELQS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5FF061D7B;
        Wed, 12 May 2021 15:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834291;
        bh=uidAe+Es+/+PmreWX+fJb2EbtdDpLV3OhFvWEUt83cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXpssMvJorf39cG6Tk7JkELcaTScaPyQvRysftEV/3zT3Y02dLRJLfDu1LBMTl9Xx
         U//NLzS7jRj3QmrExa+5+um+kuSlHjLGPuIZQaBoyYRRnfQv+DDVkqqYHGAjc/pbGo
         SLfLWdEarzyKLDzQ64khnvv6Qjivuc3bfx+6bPpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 450/601] liquidio: Fix unintented sign extension of a left shift of a u16
Date:   Wed, 12 May 2021 16:48:47 +0200
Message-Id: <20210512144842.668091000@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 298b58f00c0f86868ea717426beb5c1198772f81 ]

The macro CN23XX_PEM_BAR1_INDEX_REG is being used to shift oct->pcie_port
(a u16) left 24 places. There are two subtle issues here, first the
shift gets promoted to an signed int and then sign extended to a u64.
If oct->pcie_port is 0x80 or more then the upper bits get sign extended
to 1. Secondly shfiting a u16 24 bits will lead to an overflow so it
needs to be cast to a u64 for all the bits to not overflow.

It is entirely possible that the u16 port value is never large enough
for this to fail, but it is useful to fix unintended overflows such
as this.

Fix this by casting the port parameter to the macro to a u64 before
the shift.

Addresses-Coverity: ("Unintended sign extension")
Fixes: 5bc67f587ba7 ("liquidio: CN23XX register definitions")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
index e6d4ad99cc38..3f1c189646f4 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
@@ -521,7 +521,7 @@
 #define    CN23XX_BAR1_INDEX_OFFSET                3
 
 #define    CN23XX_PEM_BAR1_INDEX_REG(port, idx)		\
-		(CN23XX_PEM_BAR1_INDEX_START + ((port) << CN23XX_PEM_OFFSET) + \
+		(CN23XX_PEM_BAR1_INDEX_START + (((u64)port) << CN23XX_PEM_OFFSET) + \
 		 ((idx) << CN23XX_BAR1_INDEX_OFFSET))
 
 /*############################ DPI #########################*/
-- 
2.30.2



