Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968863B61CA
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhF1Ois (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43895 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233296AbhF1Ogq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:36:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5543B61CA7;
        Mon, 28 Jun 2021 14:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890638;
        bh=gIQEBC/KVGZS9UUGTzje3enWCQ/rLsBchfEZWL/OtQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwc0vCMf981+0DbBI0TZSrwB87oikc6DprndJ3SLn8D7Oy7tUMoQ66wXcbgvm6M7v
         OyfklAMwcRXVsJ9H0T4O3f5jN1PIkGxtwS8JHa9BsnE+QEOIUkpuBiJM/JbE4hUf2p
         P9RXw7FkRkfNu6rQpTZpTRm80PRF5n+QkxD0GP3tVJvV1FBbn2ERo5VaSUKqJZlnZZ
         +OMnRgppT4Dnbhz+vpqRKvTAOczBGl58xa6o5Lx/pFGXdk/dscYkjdWivRmm271i3s
         u5K3Ya0kvav8ipbIT43n+bu4P8tMwSqeTlAR2k6PKDgoHl7Nv6FsS5jqIHP0x+VRvp
         J6+GPaFdD2WmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/71] net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY
Date:   Mon, 28 Jun 2021 10:29:31 -0400
Message-Id: <20210628143004.32596-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit f6396341194234e9b01cd7538bc2c6ac4501ab14 ]

As documented in Documentation/networking/driver.rst, the ndo_start_xmit
method must not return NETDEV_TX_BUSY under any normal circumstances, and
as recommended, we simply stop the tx queue in advance, when there is a
risk that the next xmit would cause a NETDEV_TX_BUSY return.

Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index d3d9f7046913..9a7af7dda70d 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -939,6 +939,11 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	wmb();
 	lp->dma_out(lp, TX_TAILDESC_PTR, tail_p); /* DMA start */
 
+	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
+		netdev_info(ndev, "%s -> netif_stop_queue\n", __func__);
+		netif_stop_queue(ndev);
+	}
+
 	return NETDEV_TX_OK;
 }
 
-- 
2.30.2

