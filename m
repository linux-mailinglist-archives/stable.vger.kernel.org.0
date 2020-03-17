Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD1C189201
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgCQX2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:01 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53676 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgCQX2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rapOOHtkLhYTX2IACxbwA/f7Pre6w+XST23rWOyUyEI=;
        b=YGCTFhnsLA0uywilwafSzxf5d9q1FgyNEOwG6uVBhnEeJP/G0j9GtlX5EmlN2ZI9HHPuF6
        d38Td7UiOWcv1spqYz6lK9g2o8+0X5+H/7O+ga/ABE3JRwcwcQNvraK9xFGSD3GOU8y3cn
        RDABx+0rWb6FBw25CjYaGjBcTXp2rew=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 18/48] batman-adv: Fix orig_node_vlan leak on orig_node_release
Date:   Wed, 18 Mar 2020 00:27:04 +0100
Message-Id: <20200317232734.6127-19-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 33fbb1f3db87ce53da925b3e034b4dd446d483f8 upstream.

batadv_orig_node_new uses batadv_orig_node_vlan_new to allocate a new
batadv_orig_node_vlan and add it to batadv_orig_node::vlan_list. References
to this list have also to be cleaned when the batadv_orig_node is removed.

Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/originator.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 71d0f6deb8aa..ce9743aa8a14 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -564,6 +564,7 @@ static void batadv_orig_node_release(struct batadv_orig_node *orig_node)
 	struct hlist_node *node_tmp;
 	struct batadv_neigh_node *neigh_node;
 	struct batadv_orig_ifinfo *orig_ifinfo;
+	struct batadv_orig_node_vlan *vlan;
 
 	spin_lock_bh(&orig_node->neigh_list_lock);
 
@@ -581,6 +582,13 @@ static void batadv_orig_node_release(struct batadv_orig_node *orig_node)
 	}
 	spin_unlock_bh(&orig_node->neigh_list_lock);
 
+	spin_lock_bh(&orig_node->vlan_list_lock);
+	hlist_for_each_entry_safe(vlan, node_tmp, &orig_node->vlan_list, list) {
+		hlist_del_rcu(&vlan->list);
+		batadv_orig_node_vlan_free_ref(vlan);
+	}
+	spin_unlock_bh(&orig_node->vlan_list_lock);
+
 	/* Free nc_nodes */
 	batadv_nc_purge_orig(orig_node->bat_priv, orig_node, NULL);
 
-- 
2.20.1

