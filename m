Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0F03B61C4
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhF1Oib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235445AbhF1Og3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:36:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9009861CAC;
        Mon, 28 Jun 2021 14:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890638;
        bh=8w+9oueYapVKhPyZ+eIOgMXrcrtDNQfpPbh9OJYyziY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIHCkShHSfFpnLxXHy4RmsnvTGTc5l3BXuZXTvQaPxlZ5R3vPRbIn3NIvy6J5o2PH
         I1qwV0ptfVJUFYAPLTfgzK6PigkBkucNJT8o87ls4JJQq/nPudiF5whkUC3T9iZg9X
         8MyJAYntjOJx1CmGMOz0swAoNp73LcAC7haV9j9BJG/zk/mN6fdILJ+8BcKKW/pZhU
         WsZlNFGOIkzmMNQeT2AOvDU1xb4HfzGvorZO18j91t7TKdEaTtm+OhaLDsNWgZ5QPq
         /gA71Ya4E5TkWVnLdS4py4hBc3vGxo9ItSt/IJ5eGUJ4jD9xiYVfyGFR8qplBhoSwi
         qiEG7BRjkZiRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/71] net: ll_temac: Add memory-barriers for TX BD access
Date:   Mon, 28 Jun 2021 10:29:30 -0400
Message-Id: <20210628143004.32596-38-sashal@kernel.org>
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

[ Upstream commit 28d9fab458b16bcd83f9dd07ede3d585c3e1a69e ]

Add a couple of memory-barriers to ensure correct ordering of read/write
access to TX BDs.

In xmit_done, we should ensure that reading the additional BD fields are
only done after STS_CTRL_APP0_CMPLT bit is set.

When xmit_done marks the BD as free by setting APP0=0, we need to ensure
that the other BD fields are reset first, so we avoid racing with the xmit
path, which writes to the same fields.

Finally, making sure to read APP0 of next BD after the current BD, ensures
that we see all available buffers.

Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 9b55fbdc3a7c..d3d9f7046913 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -770,12 +770,15 @@ static void temac_start_xmit_done(struct net_device *ndev)
 	stat = be32_to_cpu(cur_p->app0);
 
 	while (stat & STS_CTRL_APP0_CMPLT) {
+		/* Make sure that the other fields are read after bd is
+		 * released by dma
+		 */
+		rmb();
 		dma_unmap_single(ndev->dev.parent, be32_to_cpu(cur_p->phys),
 				 be32_to_cpu(cur_p->len), DMA_TO_DEVICE);
 		skb = (struct sk_buff *)ptr_from_txbd(cur_p);
 		if (skb)
 			dev_consume_skb_irq(skb);
-		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
 		cur_p->app3 = 0;
@@ -784,6 +787,12 @@ static void temac_start_xmit_done(struct net_device *ndev)
 		ndev->stats.tx_packets++;
 		ndev->stats.tx_bytes += be32_to_cpu(cur_p->len);
 
+		/* app0 must be visible last, as it is used to flag
+		 * availability of the bd
+		 */
+		smp_mb();
+		cur_p->app0 = 0;
+
 		lp->tx_bd_ci++;
 		if (lp->tx_bd_ci >= TX_BD_NUM)
 			lp->tx_bd_ci = 0;
@@ -810,6 +819,9 @@ static inline int temac_check_tx_bd_space(struct temac_local *lp, int num_frag)
 		if (cur_p->app0)
 			return NETDEV_TX_BUSY;
 
+		/* Make sure to read next bd app0 after this one */
+		rmb();
+
 		tail++;
 		if (tail >= TX_BD_NUM)
 			tail = 0;
-- 
2.30.2

