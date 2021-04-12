Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA3A35BC85
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237515AbhDLIn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237497AbhDLInW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:43:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43EC360241;
        Mon, 12 Apr 2021 08:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618216984;
        bh=/N3hSQfc35q2PupKakidvz8lrSIWzrpqg6I3nnRTn1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3hf9Ql4HCV5N75Oy+V9XFVGiuhi1UPRJLQ6nr8qL+RyxXkc2dOzrB6bpcEy7j1aY
         MVfY/5fACtc97j7jNG519GttWUpKmmENVcBpl2R6JwrnmOAQ/ep9Q9G70sl91iUj7f
         LAKUIC1jXTaZIE+PYZS91/fJaED20SotTznYmme4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuya Kusakabe <yuya.kusakabe@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/66] virtio_net: Add XDP meta data support
Date:   Mon, 12 Apr 2021 10:40:33 +0200
Message-Id: <20210412083959.009036799@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
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
index d41d5f63f211..0b1c6a8906b9 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -383,7 +383,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct receive_queue *rq,
 				   struct page *page, unsigned int offset,
 				   unsigned int len, unsigned int truesize,
-				   bool hdr_valid)
+				   bool hdr_valid, unsigned int metasize)
 {
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
@@ -405,6 +405,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
+	/* hdr_valid means no XDP, so we can copy the vnet header */
 	if (hdr_valid)
 		memcpy(hdr, p, hdr_len);
 
@@ -417,6 +418,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		copy = skb_tailroom(skb);
 	skb_put_data(skb, p, copy);
 
+	if (metasize) {
+		__skb_pull(skb, metasize);
+		skb_metadata_set(skb, metasize);
+	}
+
 	len -= copy;
 	offset += copy;
 
@@ -462,10 +468,6 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	int err;
 
-	/* virtqueue want to use data area in-front of packet */
-	if (unlikely(xdpf->metasize > 0))
-		return -EOPNOTSUPP;
-
 	if (unlikely(xdpf->headroom < vi->hdr_len))
 		return -EOVERFLOW;
 
@@ -656,6 +658,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	unsigned int delta = 0;
 	struct page *xdp_page;
 	int err;
+	unsigned int metasize = 0;
 
 	len -= vi->hdr_len;
 	stats->bytes += len;
@@ -695,8 +698,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
 		xdp.data = xdp.data_hard_start + xdp_headroom;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -707,6 +710,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			/* Recalculate length in case bpf program changed it */
 			delta = orig_data - xdp.data;
 			len = xdp.data_end - xdp.data;
+			metasize = xdp.data - xdp.data_meta;
 			break;
 		case XDP_TX:
 			stats->xdp_tx++;
@@ -752,6 +756,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
 	} /* keep zeroed vnet hdr since packet was changed by bpf */
 
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 err:
 	return skb;
 
@@ -772,8 +779,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
 				   struct virtnet_rq_stats *stats)
 {
 	struct page *page = buf;
-	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
-					  PAGE_SIZE, true);
+	struct sk_buff *skb =
+		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -805,6 +812,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	unsigned int truesize;
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
 	int err;
+	unsigned int metasize = 0;
 
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
@@ -851,8 +859,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		data = page_address(xdp_page) + offset;
 		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
 		xdp.data = data + vi->hdr_len;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + (len - vi->hdr_len);
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -860,24 +868,27 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 
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
@@ -933,7 +944,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
+	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
+			       metasize);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.30.2



