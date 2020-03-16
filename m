Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11BE918759D
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732743AbgCPWbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:12 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49114 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732770AbgCPWbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u5BoueoSl316g9BlxCBkJUAnvid4QVrNKbHZ1C1V7kA=;
        b=uUO/YNwkEijOfzANOGNYAd7SED/N2rhDSHzukcIkMf8GewlmNOEHDFD2z2guDgkWETZBZK
        8Q2pZo3mbScOJiv3hQvpbnd9GEsm+46hXlryjqRiRFQ+P06xomgN7mDvTYOTRQL0CSmN6L
        mgSQAtGoP9uHIUsJh8V7OPQtubljUoQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 01/24] batman-adv: Fix double free during fragment merge error
Date:   Mon, 16 Mar 2020 23:30:42 +0100
Message-Id: <20200316223105.6333-2-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 248e23b50e2da0753f3b5faa068939cbe9f8a75a upstream.

The function batadv_frag_skb_buffer was supposed not to consume the skbuff
on errors. This was followed in the helper function
batadv_frag_insert_packet when the skb would potentially be inserted in the
fragment queue. But it could happen that the next helper function
batadv_frag_merge_packets would try to merge the fragments and fail. This
results in a kfree_skb of all the enqueued fragments (including the just
inserted one). batadv_recv_frag_packet would detect the error in
batadv_frag_skb_buffer and try to free the skb again.

The behavior of batadv_frag_skb_buffer (and its helper
batadv_frag_insert_packet) must therefore be changed to always consume the
skbuff to have a common behavior and avoid the double kfree_skb.

Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/fragmentation.c | 8 +++++---
 net/batman-adv/routing.c       | 6 ++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index a06b6041f3e0..384a1014da07 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -232,8 +232,10 @@ static bool batadv_frag_insert_packet(struct batadv_orig_node *orig_node,
 	spin_unlock_bh(&chain->lock);
 
 err:
-	if (!ret)
+	if (!ret) {
 		kfree(frag_entry_new);
+		kfree_skb(skb);
+	}
 
 	return ret;
 }
@@ -305,7 +307,7 @@ batadv_frag_merge_packets(struct hlist_head *chain)
  *
  * There are three possible outcomes: 1) Packet is merged: Return true and
  * set *skb to merged packet; 2) Packet is buffered: Return true and set *skb
- * to NULL; 3) Error: Return false and leave skb as is.
+ * to NULL; 3) Error: Return false and free skb.
  *
  * Return: true when packet is merged or buffered, false when skb is not not
  * used.
@@ -330,9 +332,9 @@ bool batadv_frag_skb_buffer(struct sk_buff **skb,
 		goto out_err;
 
 out:
-	*skb = skb_out;
 	ret = true;
 out_err:
+	*skb = skb_out;
 	return ret;
 }
 
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 8b98609ebc1e..f9ffb1825f6d 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1080,6 +1080,12 @@ int batadv_recv_frag_packet(struct sk_buff *skb,
 	batadv_inc_counter(bat_priv, BATADV_CNT_FRAG_RX);
 	batadv_add_counter(bat_priv, BATADV_CNT_FRAG_RX_BYTES, skb->len);
 
+	/* batadv_frag_skb_buffer will always consume the skb and
+	 * the caller should therefore never try to free the
+	 * skb after this point
+	 */
+	ret = NET_RX_SUCCESS;
+
 	/* Add fragment to buffer and merge if possible. */
 	if (!batadv_frag_skb_buffer(&skb, orig_node_src))
 		goto out;
-- 
2.20.1

