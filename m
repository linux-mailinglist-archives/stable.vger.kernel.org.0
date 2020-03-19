Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE518B7E0
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgCSNJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgCSNJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:09:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C16F520722;
        Thu, 19 Mar 2020 13:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623360;
        bh=7XS8OHBApcyUM7SsocyIfhCZel6pYeXzBAVonk65o3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADHoD+/kxiDQcWpY99KxKNmftimW6ttiR2A8pnLrun/rnGi1LbAP7AltP/M5eCPVW
         834mZeAdVOCtLKXqqCx/2ydDlxsO+R2V9x+P+lkntU7VWATdWGtN76S1ZE6UA2W6sj
         kYavXkll9fQHFJVXMWQTWHzeQ10Fq1aQxQe8htiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 77/93] batman-adv: Prevent duplicated nc_node entry
Date:   Thu, 19 Mar 2020 14:00:21 +0100
Message-Id: <20200319123949.150591940@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/network-coding.c |   33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

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


