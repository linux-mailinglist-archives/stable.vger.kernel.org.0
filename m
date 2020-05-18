Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683BA1D84C0
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgERSOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:14:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729586AbgERSA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9776720829;
        Mon, 18 May 2020 18:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824857;
        bh=4AIvEY9iTudlGVII25hYYeK4faPYN4d8s27VyEgFm8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0J2gpepEbBGDgQrZWkcVIJL1W0S7TIOnryOtz4pwgzZOgOQED8owGtqJM4ePgTtJ
         K1KrEqabi2NS+b/pjArcQ+veSkwwhkN2rNPk3oLk7SKQkvFt8AwL9gmy96M3irDAuy
         Yenh4imJ9WYbviwzudJxlWdS8HtBh4EZDpuinxPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 030/194] dpaa2-eth: properly handle buffer size restrictions
Date:   Mon, 18 May 2020 19:35:20 +0200
Message-Id: <20200518173534.050699985@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit efa6a7d07523ffbbf6503c1a7eeb52201c15c0e3 ]

Depending on the WRIOP version, the buffer size on the RX path must by a
multiple of 64 or 256. Handle this restriction properly by aligning down
the buffer size to the necessary value. Also, use the new buffer size
dynamically computed instead of the compile time one.

Fixes: 27c874867c4e ("dpaa2-eth: Use a single page per Rx buffer")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |   29 +++++++++++++----------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |    1 
 2 files changed, 18 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -86,7 +86,7 @@ static void free_rx_fd(struct dpaa2_eth_
 	for (i = 1; i < DPAA2_ETH_MAX_SG_ENTRIES; i++) {
 		addr = dpaa2_sg_get_addr(&sgt[i]);
 		sg_vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
-		dma_unmap_page(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
+		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 
 		free_pages((unsigned long)sg_vaddr, 0);
@@ -144,7 +144,7 @@ static struct sk_buff *build_frag_skb(st
 		/* Get the address and length from the S/G entry */
 		sg_addr = dpaa2_sg_get_addr(sge);
 		sg_vaddr = dpaa2_iova_to_virt(priv->iommu_domain, sg_addr);
-		dma_unmap_page(dev, sg_addr, DPAA2_ETH_RX_BUF_SIZE,
+		dma_unmap_page(dev, sg_addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 
 		sg_length = dpaa2_sg_get_len(sge);
@@ -185,7 +185,7 @@ static struct sk_buff *build_frag_skb(st
 				(page_address(page) - page_address(head_page));
 
 			skb_add_rx_frag(skb, i - 1, head_page, page_offset,
-					sg_length, DPAA2_ETH_RX_BUF_SIZE);
+					sg_length, priv->rx_buf_size);
 		}
 
 		if (dpaa2_sg_is_final(sge))
@@ -211,7 +211,7 @@ static void free_bufs(struct dpaa2_eth_p
 
 	for (i = 0; i < count; i++) {
 		vaddr = dpaa2_iova_to_virt(priv->iommu_domain, buf_array[i]);
-		dma_unmap_page(dev, buf_array[i], DPAA2_ETH_RX_BUF_SIZE,
+		dma_unmap_page(dev, buf_array[i], priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 		free_pages((unsigned long)vaddr, 0);
 	}
@@ -335,7 +335,7 @@ static u32 run_xdp(struct dpaa2_eth_priv
 		break;
 	case XDP_REDIRECT:
 		dma_unmap_page(priv->net_dev->dev.parent, addr,
-			       DPAA2_ETH_RX_BUF_SIZE, DMA_BIDIRECTIONAL);
+			       priv->rx_buf_size, DMA_BIDIRECTIONAL);
 		ch->buf_count--;
 		xdp.data_hard_start = vaddr;
 		err = xdp_do_redirect(priv->net_dev, &xdp, xdp_prog);
@@ -374,7 +374,7 @@ static void dpaa2_eth_rx(struct dpaa2_et
 	trace_dpaa2_rx_fd(priv->net_dev, fd);
 
 	vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
-	dma_sync_single_for_cpu(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
+	dma_sync_single_for_cpu(dev, addr, priv->rx_buf_size,
 				DMA_BIDIRECTIONAL);
 
 	fas = dpaa2_get_fas(vaddr, false);
@@ -393,13 +393,13 @@ static void dpaa2_eth_rx(struct dpaa2_et
 			return;
 		}
 
-		dma_unmap_page(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
+		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 		skb = build_linear_skb(ch, fd, vaddr);
 	} else if (fd_format == dpaa2_fd_sg) {
 		WARN_ON(priv->xdp_prog);
 
-		dma_unmap_page(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
+		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 		skb = build_frag_skb(priv, ch, buf_data);
 		free_pages((unsigned long)vaddr, 0);
@@ -974,7 +974,7 @@ static int add_bufs(struct dpaa2_eth_pri
 		if (!page)
 			goto err_alloc;
 
-		addr = dma_map_page(dev, page, 0, DPAA2_ETH_RX_BUF_SIZE,
+		addr = dma_map_page(dev, page, 0, priv->rx_buf_size,
 				    DMA_BIDIRECTIONAL);
 		if (unlikely(dma_mapping_error(dev, addr)))
 			goto err_map;
@@ -984,7 +984,7 @@ static int add_bufs(struct dpaa2_eth_pri
 		/* tracing point */
 		trace_dpaa2_eth_buf_seed(priv->net_dev,
 					 page, DPAA2_ETH_RX_BUF_RAW_SIZE,
-					 addr, DPAA2_ETH_RX_BUF_SIZE,
+					 addr, priv->rx_buf_size,
 					 bpid);
 	}
 
@@ -1715,7 +1715,7 @@ static bool xdp_mtu_valid(struct dpaa2_e
 	int mfl, linear_mfl;
 
 	mfl = DPAA2_ETH_L2_MAX_FRM(mtu);
-	linear_mfl = DPAA2_ETH_RX_BUF_SIZE - DPAA2_ETH_RX_HWA_SIZE -
+	linear_mfl = priv->rx_buf_size - DPAA2_ETH_RX_HWA_SIZE -
 		     dpaa2_eth_rx_head_room(priv) - XDP_PACKET_HEADROOM;
 
 	if (mfl > linear_mfl) {
@@ -2457,6 +2457,11 @@ static int set_buffer_layout(struct dpaa
 	else
 		rx_buf_align = DPAA2_ETH_RX_BUF_ALIGN;
 
+	/* We need to ensure that the buffer size seen by WRIOP is a multiple
+	 * of 64 or 256 bytes depending on the WRIOP version.
+	 */
+	priv->rx_buf_size = ALIGN_DOWN(DPAA2_ETH_RX_BUF_SIZE, rx_buf_align);
+
 	/* tx buffer */
 	buf_layout.private_data_size = DPAA2_ETH_SWA_SIZE;
 	buf_layout.pass_timestamp = true;
@@ -3121,7 +3126,7 @@ static int bind_dpni(struct dpaa2_eth_pr
 	pools_params.num_dpbp = 1;
 	pools_params.pools[0].dpbp_id = priv->dpbp_dev->obj_desc.id;
 	pools_params.pools[0].backup_pool = 0;
-	pools_params.pools[0].buffer_size = DPAA2_ETH_RX_BUF_SIZE;
+	pools_params.pools[0].buffer_size = priv->rx_buf_size;
 	err = dpni_set_pools(priv->mc_io, 0, priv->mc_token, &pools_params);
 	if (err) {
 		dev_err(dev, "dpni_set_pools() failed\n");
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -382,6 +382,7 @@ struct dpaa2_eth_priv {
 	u16 tx_data_offset;
 
 	struct fsl_mc_device *dpbp_dev;
+	u16 rx_buf_size;
 	u16 bpid;
 	struct iommu_domain *iommu_domain;
 


