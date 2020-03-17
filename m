Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03EB9189208
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgCQX2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:08 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53786 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCQX2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=62DBp7+DAaVNKLZZN0SVrqWdYTSfNttg2+6dYKFYf3A=;
        b=xgvvUfo5Mlz0+RmStm2aSvcwHZ2CxtBCiaE2OzMKJVbUNMPGZPVzowwjYLNzKh14EK66Sm
        eH4PSof/qtTvq57YOY6T6XWnP9UeC6aVkqYt2knn+mGjtBS9FShqUvR4GHunc+3d6suiS/
        PzYSg56cMFwt2WcCJoeICBLfOtU3Wjc=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 25/48] batman-adv: Fix double free during fragment merge error
Date:   Wed, 18 Mar 2020 00:27:11 +0100
Message-Id: <20200317232734.6127-26-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
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
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/fragmentation.c | 6 ++++--
 net/batman-adv/routing.c       | 6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index d50c3b003dc9..8605e3c7958d 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -233,8 +233,10 @@ err_unlock:
 	spin_unlock_bh(&chain->lock);
 
 err:
-	if (!ret)
+	if (!ret) {
 		kfree(frag_entry_new);
+		kfree_skb(skb);
+	}
 
 	return ret;
 }
@@ -329,9 +331,9 @@ bool batadv_frag_skb_buffer(struct sk_buff **skb,
 		goto out_err;
 
 out:
-	*skb = skb_out;
 	ret = true;
 out_err:
+	*skb = skb_out;
 	return ret;
 }
 
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 39b4c6ab3e71..6c3dfd65023f 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1053,6 +1053,12 @@ int batadv_recv_frag_packet(struct sk_buff *skb,
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

