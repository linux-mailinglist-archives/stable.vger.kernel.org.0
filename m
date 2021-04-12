Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17E535BD2A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbhDLIs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237996AbhDLIrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:47:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4601261221;
        Mon, 12 Apr 2021 08:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217206;
        bh=t7XBKXfhQ8LYhu6wfrJX+sDRVHvyuCdsNJBYfV5jCiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAIqaYtEfHXRQmic6B8kkvtnfAn/NXP65MjK1DbcJkxHW0hAZqL2Kb0TOVTQ8/CxJ
         HYJXSr3EIUcg10UUbOCW1ZsNZvDilaUwf6ApnL6A0ZnqEog3fVRvLMN4w3tzivdLRB
         QSQAw98LB2CqiYRIth6hD154Mw/9yTizRyjktHsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuya Kusakabe <yuya.kusakabe@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/111] virtio_net: Add XDP meta data support
Date:   Mon, 12 Apr 2021 10:40:19 +0200
Message-Id: <20210412084005.618418867@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuya Kusakabe <yuya.kusakabe@gmail.com>

[ Upstream commit 503d539a6e417b018616bf3060e0b5814fafce47 ]

Implement support for transferring XDP meta data into skb for
virtio_net driver; before calling into the program, xdp.data_meta points
to xdp.data, where on program return with pass verdict, we call
into skb_metadata_set().

Tested with the script at
https://github.com/higebu/virtio_net-xdp-metadata-test.

Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/bpf/20200225033212.437563-2-yuya.kusakabe@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 52 ++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0ef85819665c..b67460864b3c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -376,7 +376,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct receive_queue *rq,
 				   struct page *page, unsigned int offset,
 				   unsigned int len, unsigned int truesize,
-				   bool hdr_valid)
+				   bool hdr_valid, unsigned int metasize)
 {
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
@@ -398,6 +398,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
+	/* hdr_valid means no XDP, so we can copy the vnet header */
 	if (hdr_valid)
 		memcpy(hdr, p, hdr_len);
 
@@ -410,6 +411,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		copy = skb_tailroom(skb);
 	skb_put_data(skb, p, copy);
 
+	if (metasize) {
+		__skb_pull(skb, metasize);
+		skb_metadata_set(skb, metasize);
+	}
+
 	len -= copy;
 	offset += copy;
 
@@ -455,10 +461,6 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	int err;
 
-	/* virtqueue want to use data area in-front of packet */
-	if (unlikely(xdpf->metasize > 0))
-		return -EOPNOTSUPP;
-
 	if (unlikely(xdpf->headroom < vi->hdr_len))
 		return -EOVERFLOW;
 
@@ -649,6 +651,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	unsigned int delta = 0;
 	struct page *xdp_page;
 	int err;
+	unsigned int metasize = 0;
 
 	len -= vi->hdr_len;
 	stats->bytes += len;
@@ -688,8 +691,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
 		xdp.data = xdp.data_hard_start + xdp_headroom;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -700,6 +703,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			/* Recalculate length in case bpf program changed it */
 			delta = orig_data - xdp.data;
 			len = xdp.data_end - xdp.data;
+			metasize = xdp.data - xdp.data_meta;
 			break;
 		case XDP_TX:
 			stats->xdp_tx++;
@@ -745,6 +749,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
 	} /* keep zeroed vnet hdr since packet was changed by bpf */
 
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 err:
 	return skb;
 
@@ -765,8 +772,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
 				   struct virtnet_rq_stats *stats)
 {
 	struct page *page = buf;
-	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
-					  PAGE_SIZE, true);
+	struct sk_buff *skb =
+		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -798,6 +805,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	unsigned int truesize;
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
 	int err;
+	unsigned int metasize = 0;
 
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
@@ -844,8 +852,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		data = page_address(xdp_page) + offset;
 		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
 		xdp.data = data + vi->hdr_len;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + (len - vi->hdr_len);
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -853,24 +861,27 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 
 		switch (act) {
 		case XDP_PASS:
+			metasize = xdp.data - xdp.data_meta;
+
 			/* recalculate offset to account for any header
-			 * adjustments. Note other cases do not build an
-			 * skb and avoid using offset
+			 * adjustments and minus the metasize to copy the
+			 * metadata in page_to_skb(). Note other cases do not
+			 * build an skb and avoid using offset
 			 */
-			offset = xdp.data -
-					page_address(xdp_page) - vi->hdr_len;
+			offset = xdp.data - page_address(xdp_page) -
+				 vi->hdr_len - metasize;
 
-			/* recalculate len if xdp.data or xdp.data_end were
-			 * adjusted
+			/* recalculate len if xdp.data, xdp.data_end or
+			 * xdp.data_meta were adjusted
 			 */
-			len = xdp.data_end - xdp.data + vi->hdr_len;
+			len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
 			/* We can only create skb based on xdp_page. */
 			if (unlikely(xdp_page != page)) {
 				rcu_read_unlock();
 				put_page(page);
-				head_skb = page_to_skb(vi, rq, xdp_page,
-						       offset, len,
-						       PAGE_SIZE, false);
+				head_skb = page_to_skb(vi, rq, xdp_page, offset,
+						       len, PAGE_SIZE, false,
+						       metasize);
 				return head_skb;
 			}
 			break;
@@ -926,7 +937,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
+	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
+			       metasize);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.30.2



