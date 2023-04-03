Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938FD6D4903
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbjDCOeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbjDCOeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:34:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EAC35024
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:33:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D399CB81C85
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C920C4339C;
        Mon,  3 Apr 2023 14:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532416;
        bh=rvDxnpxMCENmFryhKk66DKvKmEFYKucWaQbQmY1G3wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6RDuD8pNr1j0Zm6KnbH2G8tE65bt+wLHKpqbYoe4LFsNzo/A6PUailakLkt9yNB1
         SA34vP0q9SRh8bGZI8wlW0pC5W1Qkql9/qUD077Gm+GZO4a7cH8UOMdFtAFvI2h0fg
         tr/whhth063mHzbXMGxjWzApazzXZ+x4A7R3iBU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juergen Gross <jgross@suse.com>,
        Paul Durrant <paul@xen.org>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 74/99] xen/netback: dont do grant copy across page boundary
Date:   Mon,  3 Apr 2023 16:09:37 +0200
Message-Id: <20230403140406.260121909@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 05310f31ca74673a96567fb14637b7d5d6c82ea5 upstream.

Fix xenvif_get_requests() not to do grant copy operations across local
page boundaries. This requires to double the maximum number of copy
operations per queue, as each copy could now be split into 2.

Make sure that struct xenvif_tx_cb doesn't grow too large.

Cc: stable@vger.kernel.org
Fixes: ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in the non-linear area")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/common.h  |    2 +-
 drivers/net/xen-netback/netback.c |   25 +++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -166,7 +166,7 @@ struct xenvif_queue { /* Per-queue data
 	struct pending_tx_info pending_tx_info[MAX_PENDING_REQS];
 	grant_handle_t grant_tx_handle[MAX_PENDING_REQS];
 
-	struct gnttab_copy tx_copy_ops[MAX_PENDING_REQS];
+	struct gnttab_copy tx_copy_ops[2 * MAX_PENDING_REQS];
 	struct gnttab_map_grant_ref tx_map_ops[MAX_PENDING_REQS];
 	struct gnttab_unmap_grant_ref tx_unmap_ops[MAX_PENDING_REQS];
 	/* passed to gnttab_[un]map_refs with pages under (un)mapping */
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -334,6 +334,7 @@ static int xenvif_count_requests(struct
 struct xenvif_tx_cb {
 	u16 copy_pending_idx[XEN_NETBK_LEGACY_SLOTS_MAX + 1];
 	u8 copy_count;
+	u32 split_mask;
 };
 
 #define XENVIF_TX_CB(skb) ((struct xenvif_tx_cb *)(skb)->cb)
@@ -361,6 +362,8 @@ static inline struct sk_buff *xenvif_all
 	struct sk_buff *skb =
 		alloc_skb(size + NET_SKB_PAD + NET_IP_ALIGN,
 			  GFP_ATOMIC | __GFP_NOWARN);
+
+	BUILD_BUG_ON(sizeof(*XENVIF_TX_CB(skb)) > sizeof(skb->cb));
 	if (unlikely(skb == NULL))
 		return NULL;
 
@@ -396,11 +399,13 @@ static void xenvif_get_requests(struct x
 	nr_slots = shinfo->nr_frags + 1;
 
 	copy_count(skb) = 0;
+	XENVIF_TX_CB(skb)->split_mask = 0;
 
 	/* Create copy ops for exactly data_len bytes into the skb head. */
 	__skb_put(skb, data_len);
 	while (data_len > 0) {
 		int amount = data_len > txp->size ? txp->size : data_len;
+		bool split = false;
 
 		cop->source.u.ref = txp->gref;
 		cop->source.domid = queue->vif->domid;
@@ -413,6 +418,13 @@ static void xenvif_get_requests(struct x
 		cop->dest.u.gmfn = virt_to_gfn(skb->data + skb_headlen(skb)
 				               - data_len);
 
+		/* Don't cross local page boundary! */
+		if (cop->dest.offset + amount > XEN_PAGE_SIZE) {
+			amount = XEN_PAGE_SIZE - cop->dest.offset;
+			XENVIF_TX_CB(skb)->split_mask |= 1U << copy_count(skb);
+			split = true;
+		}
+
 		cop->len = amount;
 		cop->flags = GNTCOPY_source_gref;
 
@@ -420,7 +432,8 @@ static void xenvif_get_requests(struct x
 		pending_idx = queue->pending_ring[index];
 		callback_param(queue, pending_idx).ctx = NULL;
 		copy_pending_idx(skb, copy_count(skb)) = pending_idx;
-		copy_count(skb)++;
+		if (!split)
+			copy_count(skb)++;
 
 		cop++;
 		data_len -= amount;
@@ -441,7 +454,8 @@ static void xenvif_get_requests(struct x
 			nr_slots--;
 		} else {
 			/* The copy op partially covered the tx_request.
-			 * The remainder will be mapped.
+			 * The remainder will be mapped or copied in the next
+			 * iteration.
 			 */
 			txp->offset += amount;
 			txp->size -= amount;
@@ -539,6 +553,13 @@ static int xenvif_tx_check_gop(struct xe
 		pending_idx = copy_pending_idx(skb, i);
 
 		newerr = (*gopp_copy)->status;
+
+		/* Split copies need to be handled together. */
+		if (XENVIF_TX_CB(skb)->split_mask & (1U << i)) {
+			(*gopp_copy)++;
+			if (!newerr)
+				newerr = (*gopp_copy)->status;
+		}
 		if (likely(!newerr)) {
 			/* The first frag might still have this slot mapped */
 			if (i < copy_count(skb) - 1 || !sharedslot)


