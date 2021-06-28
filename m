Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D058C3B62DE
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhF1OuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236211AbhF1Oq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:46:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A3B961D2F;
        Mon, 28 Jun 2021 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890878;
        bh=Jqt3hR+Jp41pR6IvveiJL44RhOEw7yUt+5UF1OyRxm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgfmQURRT/rSwwNQ8bsszh56cJku1DgI4OfzOT/ThvyiqViz6HUg6nZ4L6uZgz1SP
         kpRmuZciToD6lUhBUiG5Ni2WBWXqPvrZSbzdPzEZ5ndw9dm4nlvwpLKN4Jcn9zzcoI
         Vxc6l1jzU0uh9sCEF20TkuKLUmJyLfuMqFA57uLeJG5+++sRKibHkdTG1suL8bFlr+
         bbqydZbgbw+mvcnb0SMLUsYgL7lA7KKKBBe9J+Zunh4f7KDgEJ4OYC0035azR/tXt4
         Fyc7tcieVIisyPTowbEaOGVyeovBC+m4BrGVaq1guFDupKgMudL8EiQjTFcB4sCf70
         2aBcSuTPjdSSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/109] net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY
Date:   Mon, 28 Jun 2021 10:33:01 -0400
Message-Id: <20210628143305.32978-106-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index 2241f9897092..939de185bc6b 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -736,6 +736,11 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Kick off the transfer */
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

