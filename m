Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4485A480009
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbhL0Pmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:40 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42470 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhL0Pk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30FF2CE10CB;
        Mon, 27 Dec 2021 15:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F30C36AEA;
        Mon, 27 Dec 2021 15:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619653;
        bh=T259kveAyqWBnm6IFflor1y9hBdiEjqyuQic2JzCDqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPcfw5ZandAJI3bFTDMI4I2yUdprp/29uQUUkKx9vB1k/53V3pD3qY1SJr+xUXxXQ
         jJeXw4/ScgIcXptHzrx8A311FlUaSYQ8SCPce8SJ6OyONYivwYKnUsgCjYBXbb45/f
         61tWmc/c4O/CKRq82j0zpt10apWb/NaUGjCakHWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/128] ice: Use xdp_buf instead of rx_buf for xsk zero-copy
Date:   Mon, 27 Dec 2021 16:29:58 +0100
Message-Id: <20211227151332.290479241@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 57f7f8b6bc0bc80d94443f94fe5f21f266499a2b ]

In order to use the new xsk batched buffer allocation interface, a
pointer to an array of struct xsk_buff pointers need to be provided so
that the function can put the result of the allocation there. In the
ice driver, we already have a ring that stores pointers to
xdp_buffs. This is only used for the xsk zero-copy driver and is a
union with the structure that is used for the regular non zero-copy
path. Unfortunately, that structure is larger than the xdp_buffs
pointers which mean that there will be a stride (of 20 bytes) between
each xdp_buff pointer. And feeding this into the xsk_buff_alloc_batch
interface will not work since it assumes a regular array of xdp_buff
pointers (each 8 bytes with 0 bytes in-between them on a 64-bit
system).

To fix this, remove the xdp_buff pointer from the rx_buf union and
move it one step higher to the union above which only has pointers to
arrays in it. This solves the problem and we can directly feed the SW
ring of xdp_buff pointers straight into the allocation function in the
next patch when that interface is used. This will improve performance.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210922075613.12186-4-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h | 16 ++-----
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 56 +++++++++++------------
 2 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 1e46e80f3d6f8..7c2328529ff8e 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -164,17 +164,10 @@ struct ice_tx_offload_params {
 };
 
 struct ice_rx_buf {
-	union {
-		struct {
-			dma_addr_t dma;
-			struct page *page;
-			unsigned int page_offset;
-			u16 pagecnt_bias;
-		};
-		struct {
-			struct xdp_buff *xdp;
-		};
-	};
+	dma_addr_t dma;
+	struct page *page;
+	unsigned int page_offset;
+	u16 pagecnt_bias;
 };
 
 struct ice_q_stats {
@@ -270,6 +263,7 @@ struct ice_ring {
 	union {
 		struct ice_tx_buf *tx_buf;
 		struct ice_rx_buf *rx_buf;
+		struct xdp_buff **xdp_buf;
 	};
 	/* CL2 - 2nd cacheline starts here */
 	u16 q_index;			/* Queue number of ring */
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 5a9f61deeb38d..f4ab5259a56cc 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -364,7 +364,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 {
 	union ice_32b_rx_flex_desc *rx_desc;
 	u16 ntu = rx_ring->next_to_use;
-	struct ice_rx_buf *rx_buf;
+	struct xdp_buff **xdp;
 	bool ok = true;
 	dma_addr_t dma;
 
@@ -372,26 +372,26 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 		return true;
 
 	rx_desc = ICE_RX_DESC(rx_ring, ntu);
-	rx_buf = &rx_ring->rx_buf[ntu];
+	xdp = &rx_ring->xdp_buf[ntu];
 
 	do {
-		rx_buf->xdp = xsk_buff_alloc(rx_ring->xsk_pool);
-		if (!rx_buf->xdp) {
+		*xdp = xsk_buff_alloc(rx_ring->xsk_pool);
+		if (!xdp) {
 			ok = false;
 			break;
 		}
 
-		dma = xsk_buff_xdp_get_dma(rx_buf->xdp);
+		dma = xsk_buff_xdp_get_dma(*xdp);
 		rx_desc->read.pkt_addr = cpu_to_le64(dma);
 		rx_desc->wb.status_error0 = 0;
 
 		rx_desc++;
-		rx_buf++;
+		xdp++;
 		ntu++;
 
 		if (unlikely(ntu == rx_ring->count)) {
 			rx_desc = ICE_RX_DESC(rx_ring, 0);
-			rx_buf = rx_ring->rx_buf;
+			xdp = rx_ring->xdp_buf;
 			ntu = 0;
 		}
 	} while (--count);
@@ -421,19 +421,19 @@ static void ice_bump_ntc(struct ice_ring *rx_ring)
 /**
  * ice_construct_skb_zc - Create an sk_buff from zero-copy buffer
  * @rx_ring: Rx ring
- * @rx_buf: zero-copy Rx buffer
+ * @xdp_arr: Pointer to the SW ring of xdp_buff pointers
  *
  * This function allocates a new skb from a zero-copy Rx buffer.
  *
  * Returns the skb on success, NULL on failure.
  */
 static struct sk_buff *
-ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
+ice_construct_skb_zc(struct ice_ring *rx_ring, struct xdp_buff **xdp_arr)
 {
-	unsigned int metasize = rx_buf->xdp->data - rx_buf->xdp->data_meta;
-	unsigned int datasize = rx_buf->xdp->data_end - rx_buf->xdp->data;
-	unsigned int datasize_hard = rx_buf->xdp->data_end -
-				     rx_buf->xdp->data_hard_start;
+	struct xdp_buff *xdp = *xdp_arr;
+	unsigned int metasize = xdp->data - xdp->data_meta;
+	unsigned int datasize = xdp->data_end - xdp->data;
+	unsigned int datasize_hard = xdp->data_end - xdp->data_hard_start;
 	struct sk_buff *skb;
 
 	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize_hard,
@@ -441,13 +441,13 @@ ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_reserve(skb, rx_buf->xdp->data - rx_buf->xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), rx_buf->xdp->data, datasize);
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
+	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-	xsk_buff_free(rx_buf->xdp);
-	rx_buf->xdp = NULL;
+	xsk_buff_free(xdp);
+	*xdp_arr = NULL;
 	return skb;
 }
 
@@ -521,7 +521,7 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
 		unsigned int size, xdp_res = 0;
-		struct ice_rx_buf *rx_buf;
+		struct xdp_buff **xdp;
 		struct sk_buff *skb;
 		u16 stat_err_bits;
 		u16 vlan_tag = 0;
@@ -544,18 +544,18 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		if (!size)
 			break;
 
-		rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
-		rx_buf->xdp->data_end = rx_buf->xdp->data + size;
-		xsk_buff_dma_sync_for_cpu(rx_buf->xdp, rx_ring->xsk_pool);
+		xdp = &rx_ring->xdp_buf[rx_ring->next_to_clean];
+		(*xdp)->data_end = (*xdp)->data + size;
+		xsk_buff_dma_sync_for_cpu(*xdp, rx_ring->xsk_pool);
 
-		xdp_res = ice_run_xdp_zc(rx_ring, rx_buf->xdp);
+		xdp_res = ice_run_xdp_zc(rx_ring, *xdp);
 		if (xdp_res) {
 			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))
 				xdp_xmit |= xdp_res;
 			else
-				xsk_buff_free(rx_buf->xdp);
+				xsk_buff_free(*xdp);
 
-			rx_buf->xdp = NULL;
+			*xdp = NULL;
 			total_rx_bytes += size;
 			total_rx_packets++;
 			cleaned_count++;
@@ -565,7 +565,7 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		}
 
 		/* XDP_PASS path */
-		skb = ice_construct_skb_zc(rx_ring, rx_buf);
+		skb = ice_construct_skb_zc(rx_ring, xdp);
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buf_failed++;
 			break;
@@ -813,12 +813,12 @@ void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring)
 	u16 i;
 
 	for (i = 0; i < rx_ring->count; i++) {
-		struct ice_rx_buf *rx_buf = &rx_ring->rx_buf[i];
+		struct xdp_buff **xdp = &rx_ring->xdp_buf[i];
 
-		if (!rx_buf->xdp)
+		if (!xdp)
 			continue;
 
-		rx_buf->xdp = NULL;
+		*xdp = NULL;
 	}
 }
 
-- 
2.34.1



