Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D029118B7EE
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgCSNI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727364AbgCSNI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:08:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD0532098B;
        Thu, 19 Mar 2020 13:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623306;
        bh=7VabYY/a+687CfbmUMYRo1vSlqDyYoJLEYmvvyOx+gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hC/mxGO/qLivMcnZ3fvDUSt0TGsf1DYlpcAldXvOvH/+qbTbtGSEhRSPR2uA3Nj7O
         SvXVYz8GBLiHoXBZrTUxHCxURuqCmrJwUafsZmBCalUz7tCK3FobkeurgJtIugaNO1
         NUcYLYwB33dUqVtv4dMCRVa/eISrbhwMKmf29NbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 61/93] batman-adv: Add missing refcnt for last_candidate
Date:   Thu, 19 Mar 2020 14:00:05 +0100
Message-Id: <20200319123944.216656894@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -440,6 +440,29 @@ static int batadv_check_unicast_packet(s
 }
 
 /**
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
+/**
  * batadv_last_bonding_replace - Replace last_bonding_candidate of orig_node
  * @orig_node: originator node whose bonding candidates should be replaced
  * @new_candidate: new bonding candidate or NULL
@@ -509,7 +532,7 @@ batadv_find_router(struct batadv_priv *b
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
 


