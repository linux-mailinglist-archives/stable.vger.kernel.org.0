Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9702C469A5A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345518AbhLFPHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:07:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55636 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346114AbhLFPFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:05:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 903D961326;
        Mon,  6 Dec 2021 15:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AD8C341C1;
        Mon,  6 Dec 2021 15:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802941;
        bh=JiUTpmCJ3kuT5y8btKcclwPu0RQL2i1nNwLdrHKTb7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECpjn3AZXfCIeBcNXXp16E1ekUXDWeoMFLLkp44wT8AWWdzUuzZkplGSLz8UxltSn
         CJ6e9fyXUA24lfVPQgT8mqopeYUQtsv4Q6rdUhft/o/TlLJoubNlgJk7S/Qn8V6G3w
         AYTro78HxW7J4ZUqv3+SsVe1b2m/RcnXE8S10/A8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 34/62] xen/netfront: disentangle tx_skb_freelist
Date:   Mon,  6 Dec 2021 15:56:17 +0100
Message-Id: <20211206145550.358232989@linuxfoundation.org>
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

commit 21631d2d741a64a073e167c27769e73bc7844a2f upstream.

The tx_skb_freelist elements are in a single linked list with the
request id used as link reference. The per element link field is in a
union with the skb pointer of an in use request.

Move the link reference out of the union in order to enable a later
reuse of it for requests which need a populated skb pointer.

Rename add_id_to_freelist() and get_id_from_freelist() to
add_id_to_list() and get_id_from_list() in order to prepare using
those for other lists as well. Define ~0 as value to indicate the end
of a list and place that value into the link for a request not being
on the list.

When freeing a skb zero the skb pointer in the request. Use a NULL
value of the skb pointer instead of skb_entry_is_link() for deciding
whether a request has a skb linked to it.

Remove skb_entry_set_link() and open code it instead as it is really
trivial now.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   61 ++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -120,17 +120,11 @@ struct netfront_queue {
 
 	/*
 	 * {tx,rx}_skbs store outstanding skbuffs. Free tx_skb entries
-	 * are linked from tx_skb_freelist through skb_entry.link.
-	 *
-	 *  NB. Freelist index entries are always going to be less than
-	 *  PAGE_OFFSET, whereas pointers to skbs will always be equal or
-	 *  greater than PAGE_OFFSET: we use this property to distinguish
-	 *  them.
+	 * are linked from tx_skb_freelist through tx_link.
 	 */
-	union skb_entry {
-		struct sk_buff *skb;
-		unsigned long link;
-	} tx_skbs[NET_TX_RING_SIZE];
+	struct sk_buff *tx_skbs[NET_TX_RING_SIZE];
+	unsigned short tx_link[NET_TX_RING_SIZE];
+#define TX_LINK_NONE 0xffff
 	grant_ref_t gref_tx_head;
 	grant_ref_t grant_tx_ref[NET_TX_RING_SIZE];
 	struct page *grant_tx_page[NET_TX_RING_SIZE];
@@ -168,33 +162,25 @@ struct netfront_rx_info {
 	struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX - 1];
 };
 
-static void skb_entry_set_link(union skb_entry *list, unsigned short id)
-{
-	list->link = id;
-}
-
-static int skb_entry_is_link(const union skb_entry *list)
-{
-	BUILD_BUG_ON(sizeof(list->skb) != sizeof(list->link));
-	return (unsigned long)list->skb < PAGE_OFFSET;
-}
-
 /*
  * Access macros for acquiring freeing slots in tx_skbs[].
  */
 
-static void add_id_to_freelist(unsigned *head, union skb_entry *list,
-			       unsigned short id)
+static void add_id_to_list(unsigned *head, unsigned short *list,
+			   unsigned short id)
 {
-	skb_entry_set_link(&list[id], *head);
+	list[id] = *head;
 	*head = id;
 }
 
-static unsigned short get_id_from_freelist(unsigned *head,
-					   union skb_entry *list)
+static unsigned short get_id_from_list(unsigned *head, unsigned short *list)
 {
 	unsigned int id = *head;
-	*head = list[id].link;
+
+	if (id != TX_LINK_NONE) {
+		*head = list[id];
+		list[id] = TX_LINK_NONE;
+	}
 	return id;
 }
 
@@ -395,7 +381,8 @@ static void xennet_tx_buf_gc(struct netf
 				continue;
 
 			id  = txrsp.id;
-			skb = queue->tx_skbs[id].skb;
+			skb = queue->tx_skbs[id];
+			queue->tx_skbs[id] = NULL;
 			if (unlikely(gnttab_query_foreign_access(
 				queue->grant_tx_ref[id]) != 0)) {
 				pr_alert("%s: warning -- grant still in use by backend domain\n",
@@ -408,7 +395,7 @@ static void xennet_tx_buf_gc(struct netf
 				&queue->gref_tx_head, queue->grant_tx_ref[id]);
 			queue->grant_tx_ref[id] = GRANT_INVALID_REF;
 			queue->grant_tx_page[id] = NULL;
-			add_id_to_freelist(&queue->tx_skb_freelist, queue->tx_skbs, id);
+			add_id_to_list(&queue->tx_skb_freelist, queue->tx_link, id);
 			dev_kfree_skb_irq(skb);
 		}
 
@@ -441,7 +428,7 @@ static void xennet_tx_setup_grant(unsign
 	struct netfront_queue *queue = info->queue;
 	struct sk_buff *skb = info->skb;
 
-	id = get_id_from_freelist(&queue->tx_skb_freelist, queue->tx_skbs);
+	id = get_id_from_list(&queue->tx_skb_freelist, queue->tx_link);
 	tx = RING_GET_REQUEST(&queue->tx, queue->tx.req_prod_pvt++);
 	ref = gnttab_claim_grant_reference(&queue->gref_tx_head);
 	WARN_ON_ONCE(IS_ERR_VALUE((unsigned long)(int)ref));
@@ -449,7 +436,7 @@ static void xennet_tx_setup_grant(unsign
 	gnttab_grant_foreign_access_ref(ref, queue->info->xbdev->otherend_id,
 					gfn, GNTMAP_readonly);
 
-	queue->tx_skbs[id].skb = skb;
+	queue->tx_skbs[id] = skb;
 	queue->grant_tx_page[id] = page;
 	queue->grant_tx_ref[id] = ref;
 
@@ -1132,17 +1119,18 @@ static void xennet_release_tx_bufs(struc
 
 	for (i = 0; i < NET_TX_RING_SIZE; i++) {
 		/* Skip over entries which are actually freelist references */
-		if (skb_entry_is_link(&queue->tx_skbs[i]))
+		if (!queue->tx_skbs[i])
 			continue;
 
-		skb = queue->tx_skbs[i].skb;
+		skb = queue->tx_skbs[i];
+		queue->tx_skbs[i] = NULL;
 		get_page(queue->grant_tx_page[i]);
 		gnttab_end_foreign_access(queue->grant_tx_ref[i],
 					  GNTMAP_readonly,
 					  (unsigned long)page_address(queue->grant_tx_page[i]));
 		queue->grant_tx_page[i] = NULL;
 		queue->grant_tx_ref[i] = GRANT_INVALID_REF;
-		add_id_to_freelist(&queue->tx_skb_freelist, queue->tx_skbs, i);
+		add_id_to_list(&queue->tx_skb_freelist, queue->tx_link, i);
 		dev_kfree_skb_irq(skb);
 	}
 }
@@ -1643,13 +1631,14 @@ static int xennet_init_queue(struct netf
 	snprintf(queue->name, sizeof(queue->name), "vif%s-q%u",
 		 devid, queue->id);
 
-	/* Initialise tx_skbs as a free chain containing every entry. */
+	/* Initialise tx_skb_freelist as a free chain containing every entry. */
 	queue->tx_skb_freelist = 0;
 	for (i = 0; i < NET_TX_RING_SIZE; i++) {
-		skb_entry_set_link(&queue->tx_skbs[i], i+1);
+		queue->tx_link[i] = i + 1;
 		queue->grant_tx_ref[i] = GRANT_INVALID_REF;
 		queue->grant_tx_page[i] = NULL;
 	}
+	queue->tx_link[NET_TX_RING_SIZE - 1] = TX_LINK_NONE;
 
 	/* Clear out rx_skbs */
 	for (i = 0; i < NET_RX_RING_SIZE; i++) {


