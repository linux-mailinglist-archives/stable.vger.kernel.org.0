Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384ED46261B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhK2WrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbhK2Wo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:44:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAACCC14264A;
        Mon, 29 Nov 2021 10:32:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94204B815C3;
        Mon, 29 Nov 2021 18:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E14C53FAD;
        Mon, 29 Nov 2021 18:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210775;
        bh=z+1Fw7AYeWKGJwuiauZFEH2cTMcTUdCvOyr8eE/Vuwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0pOZWTNvAAFbIvOIo1hKSMWcj5HivifPZd4IMHa/u+aU+tf7xzMPkM8z9zJHYeYp
         KVAnfmgBj0zgM3QuEO6aWKdPXFd/KIjsTvrSMUQmUR9MABGpVA5UwJj+uZIiIZm7O/
         XIV9pfdxsE5/ROJqgvzBHq78em0nbur93K7a27YA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 113/121] xen/netfront: read response from backend only once
Date:   Mon, 29 Nov 2021 19:19:04 +0100
Message-Id: <20211129181715.462777659@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 8446066bf8c1f9f7b7412c43fbea0fb87464d75b upstream.

In order to avoid problems in case the backend is modifying a response
on the ring page while the frontend has already seen it, just read the
response into a local buffer in one go and then operate on that buffer
only.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -399,13 +399,13 @@ static void xennet_tx_buf_gc(struct netf
 		rmb(); /* Ensure we see responses up to 'rp'. */
 
 		for (cons = queue->tx.rsp_cons; cons != prod; cons++) {
-			struct xen_netif_tx_response *txrsp;
+			struct xen_netif_tx_response txrsp;
 
-			txrsp = RING_GET_RESPONSE(&queue->tx, cons);
-			if (txrsp->status == XEN_NETIF_RSP_NULL)
+			RING_COPY_RESPONSE(&queue->tx, cons, &txrsp);
+			if (txrsp.status == XEN_NETIF_RSP_NULL)
 				continue;
 
-			id  = txrsp->id;
+			id  = txrsp.id;
 			skb = queue->tx_skbs[id].skb;
 			if (unlikely(gnttab_query_foreign_access(
 				queue->grant_tx_ref[id]) != 0)) {
@@ -816,7 +816,7 @@ static int xennet_get_extras(struct netf
 			     RING_IDX rp)
 
 {
-	struct xen_netif_extra_info *extra;
+	struct xen_netif_extra_info extra;
 	struct device *dev = &queue->info->netdev->dev;
 	RING_IDX cons = queue->rx.rsp_cons;
 	int err = 0;
@@ -832,24 +832,22 @@ static int xennet_get_extras(struct netf
 			break;
 		}
 
-		extra = (struct xen_netif_extra_info *)
-			RING_GET_RESPONSE(&queue->rx, ++cons);
+		RING_COPY_RESPONSE(&queue->rx, ++cons, &extra);
 
-		if (unlikely(!extra->type ||
-			     extra->type >= XEN_NETIF_EXTRA_TYPE_MAX)) {
+		if (unlikely(!extra.type ||
+			     extra.type >= XEN_NETIF_EXTRA_TYPE_MAX)) {
 			if (net_ratelimit())
 				dev_warn(dev, "Invalid extra type: %d\n",
-					extra->type);
+					 extra.type);
 			err = -EINVAL;
 		} else {
-			memcpy(&extras[extra->type - 1], extra,
-			       sizeof(*extra));
+			extras[extra.type - 1] = extra;
 		}
 
 		skb = xennet_get_rx_skb(queue, cons);
 		ref = xennet_get_rx_ref(queue, cons);
 		xennet_move_rx_slot(queue, skb, ref);
-	} while (extra->flags & XEN_NETIF_EXTRA_FLAG_MORE);
+	} while (extra.flags & XEN_NETIF_EXTRA_FLAG_MORE);
 
 	queue->rx.rsp_cons = cons;
 	return err;
@@ -907,7 +905,7 @@ static int xennet_get_responses(struct n
 				struct sk_buff_head *list,
 				bool *need_xdp_flush)
 {
-	struct xen_netif_rx_response *rx = &rinfo->rx;
+	struct xen_netif_rx_response *rx = &rinfo->rx, rx_local;
 	int max = XEN_NETIF_NR_SLOTS_MIN + (rx->status <= RX_COPY_THRESHOLD);
 	RING_IDX cons = queue->rx.rsp_cons;
 	struct sk_buff *skb = xennet_get_rx_skb(queue, cons);
@@ -991,7 +989,8 @@ next:
 			break;
 		}
 
-		rx = RING_GET_RESPONSE(&queue->rx, cons + slots);
+		RING_COPY_RESPONSE(&queue->rx, cons + slots, &rx_local);
+		rx = &rx_local;
 		skb = xennet_get_rx_skb(queue, cons + slots);
 		ref = xennet_get_rx_ref(queue, cons + slots);
 		slots++;
@@ -1046,10 +1045,11 @@ static int xennet_fill_frags(struct netf
 	struct sk_buff *nskb;
 
 	while ((nskb = __skb_dequeue(list))) {
-		struct xen_netif_rx_response *rx =
-			RING_GET_RESPONSE(&queue->rx, ++cons);
+		struct xen_netif_rx_response rx;
 		skb_frag_t *nfrag = &skb_shinfo(nskb)->frags[0];
 
+		RING_COPY_RESPONSE(&queue->rx, ++cons, &rx);
+
 		if (skb_shinfo(skb)->nr_frags == MAX_SKB_FRAGS) {
 			unsigned int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
 
@@ -1064,7 +1064,7 @@ static int xennet_fill_frags(struct netf
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				skb_frag_page(nfrag),
-				rx->offset, rx->status, PAGE_SIZE);
+				rx.offset, rx.status, PAGE_SIZE);
 
 		skb_shinfo(nskb)->nr_frags = 0;
 		kfree_skb(nskb);
@@ -1163,7 +1163,7 @@ static int xennet_poll(struct napi_struc
 	i = queue->rx.rsp_cons;
 	work_done = 0;
 	while ((i != rp) && (work_done < budget)) {
-		memcpy(rx, RING_GET_RESPONSE(&queue->rx, i), sizeof(*rx));
+		RING_COPY_RESPONSE(&queue->rx, i, rx);
 		memset(extras, 0, sizeof(rinfo.extras));
 
 		err = xennet_get_responses(queue, &rinfo, rp, &tmpq,


