Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D714189219
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgCQX2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:23 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53960 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCQX2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yO3ZM0TevCCt0Z+Pj0dg4AFkD3lg8ZubtyttUqplkIg=;
        b=n8+N0yM6t1rR1ihOesprUJDFbTCxJ0/OeDZIaKbH7a9LAb5ht5Fjy/+1Tui7gh7myDh9+x
        xQZihwH+QbSTBAklyMY1o/YinLjtliodJT3jh4hCFg98MuO6v8FZbZVYMl41kOJwSxkf33
        7LsEI0HEGm4ZSKxf0t2fLT71xb41Vxk=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 40/48] batman-adv: Prevent duplicated nc_node entry
Date:   Wed, 18 Mar 2020 00:27:26 +0100
Message-Id: <20200317232734.6127-41-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fa122fec8640eb7186ce5a41b83a4c1744ceef8f upstream.

The function batadv_nc_get_nc_node is responsible for adding new nc_nodes
to the in_coding_list and out_coding_list. It first checks whether the
entry already is in the list or not. If it is, then the creation of a new
entry is aborted.

But the lock for the list is only held when the list is really modified.
This could lead to duplicated entries because another context could create
an entry with the same key between the check and the list manipulation.

The check and the manipulation of the list must therefore be in the same
locked code section.

Fixes: d56b1705e28c ("batman-adv: network coding - detect coding nodes and remove these after timeout")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/network-coding.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index d0956f726547..86c69208da2b 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -828,19 +828,29 @@ static struct batadv_nc_node
 	spinlock_t *lock; /* Used to lock list selected by "int in_coding" */
 	struct list_head *list;
 
+	/* Select ingoing or outgoing coding node */
+	if (in_coding) {
+		lock = &orig_neigh_node->in_coding_list_lock;
+		list = &orig_neigh_node->in_coding_list;
+	} else {
+		lock = &orig_neigh_node->out_coding_list_lock;
+		list = &orig_neigh_node->out_coding_list;
+	}
+
+	spin_lock_bh(lock);
+
 	/* Check if nc_node is already added */
 	nc_node = batadv_nc_find_nc_node(orig_node, orig_neigh_node, in_coding);
 
 	/* Node found */
 	if (nc_node)
-		return nc_node;
+		goto unlock;
 
 	nc_node = kzalloc(sizeof(*nc_node), GFP_ATOMIC);
 	if (!nc_node)
-		return NULL;
+		goto unlock;
 
-	if (!atomic_inc_not_zero(&orig_neigh_node->refcount))
-		goto free;
+	atomic_inc(&orig_neigh_node->refcount);
 
 	/* Initialize nc_node */
 	INIT_LIST_HEAD(&nc_node->list);
@@ -848,28 +858,15 @@ static struct batadv_nc_node
 	nc_node->orig_node = orig_neigh_node;
 	atomic_set(&nc_node->refcount, 2);
 
-	/* Select ingoing or outgoing coding node */
-	if (in_coding) {
-		lock = &orig_neigh_node->in_coding_list_lock;
-		list = &orig_neigh_node->in_coding_list;
-	} else {
-		lock = &orig_neigh_node->out_coding_list_lock;
-		list = &orig_neigh_node->out_coding_list;
-	}
-
 	batadv_dbg(BATADV_DBG_NC, bat_priv, "Adding nc_node %pM -> %pM\n",
 		   nc_node->addr, nc_node->orig_node->orig);
 
 	/* Add nc_node to orig_node */
-	spin_lock_bh(lock);
 	list_add_tail_rcu(&nc_node->list, list);
+unlock:
 	spin_unlock_bh(lock);
 
 	return nc_node;
-
-free:
-	kfree(nc_node);
-	return NULL;
 }
 
 /**
-- 
2.20.1

