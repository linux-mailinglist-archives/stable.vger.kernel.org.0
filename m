Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75210469A43
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346102AbhLFPG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346094AbhLFPFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:05:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E36C0698C0;
        Mon,  6 Dec 2021 07:02:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B85106130D;
        Mon,  6 Dec 2021 15:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB2BC341C2;
        Mon,  6 Dec 2021 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802938;
        bh=FcbuHZfhQor/wXaa3ulIMaaXHw2J9/Y894AlTHu/C84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6QGPYGxNhIBG3d9MHAKl4Jsf/oeRIzGO/yMP+aClzDvlZTGpUxeX/G5Y0u5kXWi6
         GAgapTFrYzny4b13GMEYPnRSfyPMAw13NL1PuBp4Xeo1Dvuf1eIXiza2Ifkny2MbvR
         IRy9mut6xXMBd7iydcWQyb1TLPOfoE2TS1gvaN7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 33/62] xen/netfront: dont read data from request on the ring page
Date:   Mon,  6 Dec 2021 15:56:16 +0100
Message-Id: <20211206145550.318795852@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 162081ec33c2686afa29d91bf8d302824aa846c7 upstream.

In order to avoid a malicious backend being able to influence the local
processing of a request build the request locally first and then copy
it to the ring page. Any reading from the request influencing the
processing in the frontend needs to be done on the local instance.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   80 ++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 43 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -424,7 +424,8 @@ struct xennet_gnttab_make_txreq {
 	struct netfront_queue *queue;
 	struct sk_buff *skb;
 	struct page *page;
-	struct xen_netif_tx_request *tx; /* Last request */
+	struct xen_netif_tx_request *tx;      /* Last request on ring page */
+	struct xen_netif_tx_request tx_local; /* Last request local copy*/
 	unsigned int size;
 };
 
@@ -452,30 +453,27 @@ static void xennet_tx_setup_grant(unsign
 	queue->grant_tx_page[id] = page;
 	queue->grant_tx_ref[id] = ref;
 
-	tx->id = id;
-	tx->gref = ref;
-	tx->offset = offset;
-	tx->size = len;
-	tx->flags = 0;
+	info->tx_local.id = id;
+	info->tx_local.gref = ref;
+	info->tx_local.offset = offset;
+	info->tx_local.size = len;
+	info->tx_local.flags = 0;
+
+	*tx = info->tx_local;
 
 	info->tx = tx;
-	info->size += tx->size;
+	info->size += info->tx_local.size;
 }
 
 static struct xen_netif_tx_request *xennet_make_first_txreq(
-	struct netfront_queue *queue, struct sk_buff *skb,
-	struct page *page, unsigned int offset, unsigned int len)
+	struct xennet_gnttab_make_txreq *info,
+	unsigned int offset, unsigned int len)
 {
-	struct xennet_gnttab_make_txreq info = {
-		.queue = queue,
-		.skb = skb,
-		.page = page,
-		.size = 0,
-	};
+	info->size = 0;
 
-	gnttab_for_one_grant(page, offset, len, xennet_tx_setup_grant, &info);
+	gnttab_for_one_grant(info->page, offset, len, xennet_tx_setup_grant, info);
 
-	return info.tx;
+	return info->tx;
 }
 
 static void xennet_make_one_txreq(unsigned long gfn, unsigned int offset,
@@ -488,35 +486,27 @@ static void xennet_make_one_txreq(unsign
 	xennet_tx_setup_grant(gfn, offset, len, data);
 }
 
-static struct xen_netif_tx_request *xennet_make_txreqs(
-	struct netfront_queue *queue, struct xen_netif_tx_request *tx,
-	struct sk_buff *skb, struct page *page,
+static void xennet_make_txreqs(
+	struct xennet_gnttab_make_txreq *info,
+	struct page *page,
 	unsigned int offset, unsigned int len)
 {
-	struct xennet_gnttab_make_txreq info = {
-		.queue = queue,
-		.skb = skb,
-		.tx = tx,
-	};
-
 	/* Skip unused frames from start of page */
 	page += offset >> PAGE_SHIFT;
 	offset &= ~PAGE_MASK;
 
 	while (len) {
-		info.page = page;
-		info.size = 0;
+		info->page = page;
+		info->size = 0;
 
 		gnttab_foreach_grant_in_range(page, offset, len,
 					      xennet_make_one_txreq,
-					      &info);
+					      info);
 
 		page++;
 		offset = 0;
-		len -= info.size;
+		len -= info->size;
 	}
-
-	return info.tx;
 }
 
 /*
@@ -569,7 +559,7 @@ static int xennet_start_xmit(struct sk_b
 {
 	struct netfront_info *np = netdev_priv(dev);
 	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
-	struct xen_netif_tx_request *tx, *first_tx;
+	struct xen_netif_tx_request *first_tx;
 	unsigned int i;
 	int notify;
 	int slots;
@@ -578,6 +568,7 @@ static int xennet_start_xmit(struct sk_b
 	unsigned int len;
 	unsigned long flags;
 	struct netfront_queue *queue = NULL;
+	struct xennet_gnttab_make_txreq info = { };
 	unsigned int num_queues = dev->real_num_tx_queues;
 	u16 queue_index;
 	struct sk_buff *nskb;
@@ -635,21 +626,24 @@ static int xennet_start_xmit(struct sk_b
 	}
 
 	/* First request for the linear area. */
-	first_tx = tx = xennet_make_first_txreq(queue, skb,
-						page, offset, len);
-	offset += tx->size;
+	info.queue = queue;
+	info.skb = skb;
+	info.page = page;
+	first_tx = xennet_make_first_txreq(&info, offset, len);
+	offset += info.tx_local.size;
 	if (offset == PAGE_SIZE) {
 		page++;
 		offset = 0;
 	}
-	len -= tx->size;
+	len -= info.tx_local.size;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		/* local packet? */
-		tx->flags |= XEN_NETTXF_csum_blank | XEN_NETTXF_data_validated;
+		first_tx->flags |= XEN_NETTXF_csum_blank |
+				   XEN_NETTXF_data_validated;
 	else if (skb->ip_summed == CHECKSUM_UNNECESSARY)
 		/* remote but checksummed. */
-		tx->flags |= XEN_NETTXF_data_validated;
+		first_tx->flags |= XEN_NETTXF_data_validated;
 
 	/* Optional extra info after the first request. */
 	if (skb_shinfo(skb)->gso_size) {
@@ -658,7 +652,7 @@ static int xennet_start_xmit(struct sk_b
 		gso = (struct xen_netif_extra_info *)
 			RING_GET_REQUEST(&queue->tx, queue->tx.req_prod_pvt++);
 
-		tx->flags |= XEN_NETTXF_extra_info;
+		first_tx->flags |= XEN_NETTXF_extra_info;
 
 		gso->u.gso.size = skb_shinfo(skb)->gso_size;
 		gso->u.gso.type = (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6) ?
@@ -672,13 +666,13 @@ static int xennet_start_xmit(struct sk_b
 	}
 
 	/* Requests for the rest of the linear area. */
-	tx = xennet_make_txreqs(queue, tx, skb, page, offset, len);
+	xennet_make_txreqs(&info, page, offset, len);
 
 	/* Requests for all the frags. */
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		tx = xennet_make_txreqs(queue, tx, skb,
-					skb_frag_page(frag), frag->page_offset,
+		xennet_make_txreqs(&info, skb_frag_page(frag),
+					frag->page_offset,
 					skb_frag_size(frag));
 	}
 


