Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8D73B6025
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhF1OWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233253AbhF1OVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 572BA61C88;
        Mon, 28 Jun 2021 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889958;
        bh=stz5r8xqtps6azfB/g+KpMjwljvXV6hjgWBN+qI08/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTbpEfpvS4/ovVx0WtsbuRnDDzl3EVYNFnofsNE3dl9bDFB/p9rnLLtAnBARA9Re+
         Xr6mXl7cmbv5BwVMNJDzb0U4SxUzEJyjUKY4B4101sBj1wtAoLvB5WtYuT1jIMhEcX
         W7PtZDhfljcWs5tKuy77gC/WfJePTqk9X57aQe7xwMITxXGa+SP2F1CxY1iwtwuchW
         vM6zf8a6EG/UGO/qfnRxSnJmgdcAt+DJRcy68M/FSveJl4Njqp4vw6DPaQeg/a8778
         IvnJLTtTlqk3YSIcbcIzIaT+aa7gx8+z6i/bsozoMR7k5Sl26SwKUiRTZeN61TygTS
         FT2Eb/G36uLCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 058/110] net: ll_temac: Add memory-barriers for TX BD access
Date:   Mon, 28 Jun 2021 10:17:36 -0400
Message-Id: <20210628141828.31757-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index 01bb36e7cff0..b105e1d35d15 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -774,12 +774,15 @@ static void temac_start_xmit_done(struct net_device *ndev)
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
@@ -788,6 +791,12 @@ static void temac_start_xmit_done(struct net_device *ndev)
 		ndev->stats.tx_packets++;
 		ndev->stats.tx_bytes += be32_to_cpu(cur_p->len);
 
+		/* app0 must be visible last, as it is used to flag
+		 * availability of the bd
+		 */
+		smp_mb();
+		cur_p->app0 = 0;
+
 		lp->tx_bd_ci++;
 		if (lp->tx_bd_ci >= lp->tx_bd_num)
 			lp->tx_bd_ci = 0;
@@ -814,6 +823,9 @@ static inline int temac_check_tx_bd_space(struct temac_local *lp, int num_frag)
 		if (cur_p->app0)
 			return NETDEV_TX_BUSY;
 
+		/* Make sure to read next bd app0 after this one */
+		rmb();
+
 		tail++;
 		if (tail >= lp->tx_bd_num)
 			tail = 0;
-- 
2.30.2

