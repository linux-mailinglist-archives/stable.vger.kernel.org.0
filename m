Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBB3111F1E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfLCWn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:43:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbfLCWn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:43:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BFF42073C;
        Tue,  3 Dec 2019 22:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413035;
        bh=5CfqdPpLGQxt/doP6KHgiyWtQhtxDNWKoNiJXqVrP78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ic17hu0Baswhj78MZ/X2TgPE23LcnqCC6joQ8RwxXq6TR6+Yr66bt8RmzaaJT/q8H
         Iw6Nf1cVLkTKz7S06iNHjsQxJuqJDbMbwLS596B8y0Oa541JdAbntCzyBxkyrBji9B
         GEzyFKapX+61sbAffvAb4bkLpm9QaUMW9lY0vkaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 084/135] net: stmmac: gmac4: bitrev32 returns u32
Date:   Tue,  3 Dec 2019 23:35:24 +0100
Message-Id: <20191203213033.340861877@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 4d7c47e34fab0d25790bb6e85b85e26fdf0090d5 ]

The bitrev32 function returns an u32 var, not an int. Fix it.

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 9c73fb759b575..ff830bb5fcaf7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -438,7 +438,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 			 * bits used depends on the hardware configuration
 			 * selected at core configuration time.
 			 */
-			int bit_nr = bitrev32(~crc32_le(~0, ha->addr,
+			u32 bit_nr = bitrev32(~crc32_le(~0, ha->addr,
 					ETH_ALEN)) >> (32 - mcbitslog2);
 			/* The most significant bit determines the register to
 			 * use (H/L) while the other 5 bits determine the bit
-- 
2.20.1



