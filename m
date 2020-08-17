Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE4E2472F2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403850AbgHQSs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388002AbgHQPyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:54:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BC5320657;
        Mon, 17 Aug 2020 15:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679678;
        bh=Npu3UeR3EM6VyxZdke2f0joPg//KAUdcSv7WEvWzGj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jruYTLusaVXWdbWsGH/pntRCt+2nIe6hvZN3/LFvzCGMX5e0e0GPEa7NIHHcZ9cYl
         zWodsqrCDRmzLdGTrP/Ish9ZTjmCPTPUxJnsNqWQvu959Zsx6JLM4APVVviBEpp8MU
         LXkePC7dmepsygXt2KSZrO7SDm39G+kqQLpj9FcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rick Farrington <ricardo.farrington@cavium.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 297/393] liquidio: Fix wrong return value in cn23xx_get_pf_num()
Date:   Mon, 17 Aug 2020 17:15:47 +0200
Message-Id: <20200817143834.023942814@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit aa027850a292ea65524b8fab83eb91a124ad362c ]

On an error exit path, a negative error code should be returned
instead of a positive return value.

Fixes: 0c45d7fe12c7e ("liquidio: fix use of pf in pass-through mode in a virtual machine")
Cc: Rick Farrington <ricardo.farrington@cavium.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
index 43d11c38b38a9..4cddd628d41b2 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
@@ -1167,7 +1167,7 @@ static int cn23xx_get_pf_num(struct octeon_device *oct)
 		oct->pf_num = ((fdl_bit >> CN23XX_PCIE_SRIOV_FDL_BIT_POS) &
 			       CN23XX_PCIE_SRIOV_FDL_MASK);
 	} else {
-		ret = EINVAL;
+		ret = -EINVAL;
 
 		/* Under some virtual environments, extended PCI regs are
 		 * inaccessible, in which case the above read will have failed.
-- 
2.25.1



