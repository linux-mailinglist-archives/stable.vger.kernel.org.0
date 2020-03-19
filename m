Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A23F918B450
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgCSNIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgCSNIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:08:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22DF12098B;
        Thu, 19 Mar 2020 13:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623317;
        bh=XZcoHT4alxxJ/xeT/x+3XVa9SFNV3yfvrBKNuJtrCB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ijn1XzDGtU0C9QhweFdxpMdJGROrqxveDy6w5qyjnuF55H0z/VpSx7jEB2jsRj3U9
         bEHXYQD3GpLszn186qYCik21gE7fPWfE348SUOWityMbddED3H7Xfe94/fV8yEphMB
         IGPnQixvdfA7w0AwJ4V5hKuvxG29/VhAMXUSJGW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 55/93] batman-adv: Fix orig_node_vlan leak on orig_node_release
Date:   Thu, 19 Mar 2020 13:59:59 +0100
Message-Id: <20200319123942.385655818@linuxfoundation.org>
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

commit 33fbb1f3db87ce53da925b3e034b4dd446d483f8 upstream.

batadv_orig_node_new uses batadv_orig_node_vlan_new to allocate a new
batadv_orig_node_vlan and add it to batadv_orig_node::vlan_list. References
to this list have also to be cleaned when the batadv_orig_node is removed.

Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/originator.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -564,6 +564,7 @@ static void batadv_orig_node_release(str
 	struct hlist_node *node_tmp;
 	struct batadv_neigh_node *neigh_node;
 	struct batadv_orig_ifinfo *orig_ifinfo;
+	struct batadv_orig_node_vlan *vlan;
 
 	spin_lock_bh(&orig_node->neigh_list_lock);
 
@@ -581,6 +582,13 @@ static void batadv_orig_node_release(str
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
 


