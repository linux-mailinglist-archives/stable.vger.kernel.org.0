Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2192189204
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCQX2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:05 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53636 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCQX2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TQMknA0FfjE2SIYy9M30XaO2dPN1zQ6N3eKBGsbbuSI=;
        b=Iql7fH8EoiyN0Yn450QPzh6As7bhkwu7iAKlWhgyWiaFSnPNap5D4H2ERSBR+tCtyEzFnV
        gr080Z0nNZtyRffuvSGAev61KbHWM7T5jDtmrNMdgpftsKaF0O2TNucmWR6OC/0UHQvUdm
        XLTu3gvXKkGG4zxIF3uS7gkeTCaeqtI=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 21/48] batman-adv: Fix reference leak in batadv_find_router
Date:   Wed, 18 Mar 2020 00:27:07 +0100
Message-Id: <20200317232734.6127-22-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 15c2ed753cd9e3e746472deab8151337a5b6da56 upstream.

The replacement of last_bonding_candidate in batadv_orig_node has to be an
atomic operation. Otherwise it is possible that the reference counter of a
batadv_orig_ifinfo is reduced which was no longer the
last_bonding_candidate when the new candidate is added. This can either
lead to an invalid memory access or to reference leaks which make it
impossible to an interface which was added to batman-adv.

Fixes: f3b3d9018975 ("batman-adv: add bonding again")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/routing.c | 52 ++++++++++++++++++++++++++++++----------
 net/batman-adv/types.h   |  4 +++-
 2 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 477899ba7616..ff9aefddb6ef 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -439,6 +439,29 @@ static int batadv_check_unicast_packet(struct batadv_priv *bat_priv,
 	return 0;
 }
 
+/**
+ * batadv_last_bonding_replace - Replace last_bonding_candidate of orig_node
+ * @orig_node: originator node whose bonding candidates should be replaced
+ * @new_candidate: new bonding candidate or NULL
+ */
+static void
+batadv_last_bonding_replace(struct batadv_orig_node *orig_node,
+			    struct batadv_orig_ifinfo *new_candidate)
+{
+	struct batadv_orig_ifinfo *old_candidate;
+
+	spin_lock_bh(&orig_node->neigh_list_lock);
+	old_candidate = orig_node->last_bonding_candidate;
+
+	if (new_candidate)
+		atomic_inc(&new_candidate->refcount);
+	orig_node->last_bonding_candidate = new_candidate;
+	spin_unlock_bh(&orig_node->neigh_list_lock);
+
+	if (old_candidate)
+		batadv_orig_ifinfo_free_ref(old_candidate);
+}
+
 /**
  * batadv_find_router - find a suitable router for this originator
  * @bat_priv: the bat priv with all the soft interface information
@@ -546,10 +569,6 @@ next:
 	}
 	rcu_read_unlock();
 
-	/* last_bonding_candidate is reset below, remove the old reference. */
-	if (orig_node->last_bonding_candidate)
-		batadv_orig_ifinfo_free_ref(orig_node->last_bonding_candidate);
-
 	/* After finding candidates, handle the three cases:
 	 * 1) there is a next candidate, use that
 	 * 2) there is no next candidate, use the first of the list
@@ -558,21 +577,28 @@ next:
 	if (next_candidate) {
 		batadv_neigh_node_free_ref(router);
 
-		/* remove references to first candidate, we don't need it. */
-		if (first_candidate) {
-			batadv_neigh_node_free_ref(first_candidate_router);
-			batadv_orig_ifinfo_free_ref(first_candidate);
-		}
+		atomic_inc(&next_candidate_router->refcount);
 		router = next_candidate_router;
-		orig_node->last_bonding_candidate = next_candidate;
+		batadv_last_bonding_replace(orig_node, next_candidate);
 	} else if (first_candidate) {
 		batadv_neigh_node_free_ref(router);
 
-		/* refcounting has already been done in the loop above. */
+		atomic_inc(&first_candidate_router->refcount);
 		router = first_candidate_router;
-		orig_node->last_bonding_candidate = first_candidate;
+		batadv_last_bonding_replace(orig_node, first_candidate);
 	} else {
-		orig_node->last_bonding_candidate = NULL;
+		batadv_last_bonding_replace(orig_node, NULL);
+	}
+
+	/* cleanup of candidates */
+	if (first_candidate) {
+		batadv_neigh_node_free_ref(first_candidate_router);
+		batadv_orig_ifinfo_free_ref(first_candidate);
+	}
+
+	if (next_candidate) {
+		batadv_neigh_node_free_ref(next_candidate_router);
+		batadv_orig_ifinfo_free_ref(next_candidate);
 	}
 
 	return router;
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index d3ebc3fd7d06..375c27a68cbc 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -287,7 +287,9 @@ struct batadv_orig_node {
 	DECLARE_BITMAP(bcast_bits, BATADV_TQ_LOCAL_WINDOW_SIZE);
 	u32 last_bcast_seqno;
 	struct hlist_head neigh_list;
-	/* neigh_list_lock protects: neigh_list and router */
+	/* neigh_list_lock protects: neigh_list, ifinfo_list,
+	 * last_bonding_candidate and router
+	 */
 	spinlock_t neigh_list_lock;
 	struct hlist_node hash_entry;
 	struct batadv_priv *bat_priv;
-- 
2.20.1

