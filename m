Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513AE18B7ED
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgCSNIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:08:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgCSNIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:08:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02482208CA;
        Thu, 19 Mar 2020 13:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623297;
        bh=WRNAJSS9zb45qYYOzxUaYETzy2dEs9EzjRak77fgHKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4uWHYUzbRlrkEPHNS3TLiFs4yFGeUZegQj73bZGcUqsexlOERWLKj1LmIFMr4BiU
         c0pWhdOueTnAvh5K9qyyiFTGaYkXNIkif96MtyRIzv9rsnSCfdme3jYcohojcn8/Wk
         VHUvq3VtwdJOk6C61EvJRu6wnLsMg7vcr89tqzP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 58/93] batman-adv: Fix reference leak in batadv_find_router
Date:   Thu, 19 Mar 2020 14:00:02 +0100
Message-Id: <20200319123943.302002256@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |   52 +++++++++++++++++++++++++++++++++++------------
 net/batman-adv/types.h   |    4 ++-
 2 files changed, 42 insertions(+), 14 deletions(-)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -440,6 +440,29 @@ static int batadv_check_unicast_packet(s
 }
 
 /**
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
+/**
  * batadv_find_router - find a suitable router for this originator
  * @bat_priv: the bat priv with all the soft interface information
  * @orig_node: the destination node
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


