Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36273189207
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgCQX2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:07 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53636 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgCQX2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6uMT9RhHHj6uY4LeOtjetTC5Yu0VGLO6Y2HHRy+Pops=;
        b=I6IJydiM/2ZcDmHoKXWr/wSioQtpleNt2Np2oQyigbZPxpHgM2cr+auBFpIybRWB+KbX2t
        n9VICiP+d0SZNxFv4C0IiaujPR/SnM0FkGv8+g5+7bNguwaYsFQdWvcqiLlQ8WMoYqCj8f
        fFA17ObXAFqG6PGh63GYbWgS90C64kA=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 24/48] batman-adv: Add missing refcnt for last_candidate
Date:   Wed, 18 Mar 2020 00:27:10 +0100
Message-Id: <20200317232734.6127-25-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 936523441bb64cdc9a5b263e8fd2782e70313a57 upstream.

batadv_find_router dereferences last_bonding_candidate from
orig_node without making sure that it has a valid reference. This reference
has to be retrieved by increasing the reference counter while holding
neigh_list_lock. The lock is required to avoid that
batadv_last_bonding_replace removes the current last_bonding_candidate,
reduces the reference counter and maybe destroys the object in this
process.

Fixes: f3b3d9018975 ("batman-adv: add bonding again")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/routing.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index ff9aefddb6ef..39b4c6ab3e71 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -439,6 +439,29 @@ static int batadv_check_unicast_packet(struct batadv_priv *bat_priv,
 	return 0;
 }
 
+/**
+ * batadv_last_bonding_get - Get last_bonding_candidate of orig_node
+ * @orig_node: originator node whose last bonding candidate should be retrieved
+ *
+ * Return: last bonding candidate of router or NULL if not found
+ *
+ * The object is returned with refcounter increased by 1.
+ */
+static struct batadv_orig_ifinfo *
+batadv_last_bonding_get(struct batadv_orig_node *orig_node)
+{
+	struct batadv_orig_ifinfo *last_bonding_candidate;
+
+	spin_lock_bh(&orig_node->neigh_list_lock);
+	last_bonding_candidate = orig_node->last_bonding_candidate;
+
+	if (last_bonding_candidate)
+		atomic_inc(&last_bonding_candidate->refcount);
+	spin_unlock_bh(&orig_node->neigh_list_lock);
+
+	return last_bonding_candidate;
+}
+
 /**
  * batadv_last_bonding_replace - Replace last_bonding_candidate of orig_node
  * @orig_node: originator node whose bonding candidates should be replaced
@@ -509,7 +532,7 @@ batadv_find_router(struct batadv_priv *bat_priv,
 	 * router - obviously there are no other candidates.
 	 */
 	rcu_read_lock();
-	last_candidate = orig_node->last_bonding_candidate;
+	last_candidate = batadv_last_bonding_get(orig_node);
 	if (last_candidate)
 		last_cand_router = rcu_dereference(last_candidate->router);
 
@@ -601,6 +624,9 @@ next:
 		batadv_orig_ifinfo_free_ref(next_candidate);
 	}
 
+	if (last_candidate)
+		batadv_orig_ifinfo_free_ref(last_candidate);
+
 	return router;
 }
 
-- 
2.20.1

