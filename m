Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB9F469BE0
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350542AbhLFPRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356078AbhLFPOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:14:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE25C07E5EA;
        Mon,  6 Dec 2021 07:06:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0416FB8111C;
        Mon,  6 Dec 2021 15:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F990C341C1;
        Mon,  6 Dec 2021 15:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803205;
        bh=qejBpjyqLcXNBhL7Bh4tLIPg3I3TpfU6XzUMto+RJSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImyjQ53fihj/uhO2sbRFG28JYXbshD9Z89vNOR8E2XDdS23AhlhJL4OBPLR6+WORi
         UDaT5Ry5gmG9mFASfyjaFb+IcIqMDSsxmaV++IvqJF0qafY7EnKVwOK5D1JhcA0f5r
         NZkXJR+V+s6RG+XQehxKLx8Ss4y5LH9Da4NhdgEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 065/106] xen/netfront: dont read data from request on the ring page
Date:   Mon,  6 Dec 2021 15:56:13 +0100
Message-Id: <20211206145557.702036108@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
@@ -425,7 +425,8 @@ struct xennet_gnttab_make_txreq {
 	struct netfront_queue *queue;
 	struct sk_buff *skb;
 	struct page *page;
-	struct xen_netif_tx_request *tx; /* Last request */
+	struct xen_netif_tx_request *tx;      /* Last request on ring page */
+	struct xen_netif_tx_request tx_local; /* Last request local copy*/
 	unsigned int size;
 };
 
@@ -453,30 +454,27 @@ static void xennet_tx_setup_grant(unsign
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
@@ -489,35 +487,27 @@ static void xennet_make_one_txreq(unsign
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
@@ -570,7 +560,7 @@ static int xennet_start_xmit(struct sk_b
 {
 	struct netfront_info *np = netdev_priv(dev);
 	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
-	struct xen_netif_tx_request *tx, *first_tx;
+	struct xen_netif_tx_request *first_tx;
 	unsigned int i;
 	int notify;
 	int slots;
@@ -579,6 +569,7 @@ static int xennet_start_xmit(struct sk_b
 	unsigned int len;
 	unsigned long flags;
 	struct netfront_queue *queue = NULL;
+	struct xennet_gnttab_make_txreq info = { };
 	unsigned int num_queues = dev->real_num_tx_queues;
 	u16 queue_index;
 	struct sk_buff *nskb;
@@ -636,21 +627,24 @@ static int xennet_start_xmit(struct sk_b
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
@@ -659,7 +653,7 @@ static int xennet_start_xmit(struct sk_b
 		gso = (struct xen_netif_extra_info *)
 			RING_GET_REQUEST(&queue->tx, queue->tx.req_prod_pvt++);
 
-		tx->flags |= XEN_NETTXF_extra_info;
+		first_tx->flags |= XEN_NETTXF_extra_info;
 
 		gso->u.gso.size = skb_shinfo(skb)->gso_size;
 		gso->u.gso.type = (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6) ?
@@ -673,13 +667,13 @@ static int xennet_start_xmit(struct sk_b
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
 


