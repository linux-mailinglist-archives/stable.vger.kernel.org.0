Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C31C3189205
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgCQX2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:06 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53786 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgCQX2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F7NEI2zZc7i7etVHqh0e57+rybsC9yeNSqPk/vr3njg=;
        b=lfWGcAt5wU1FZsRQCCdxgRjsHSorcNgxyVnyvduIqgacnacW6NvfQpWCf37A4a7LbPd4xz
        3AeQrJsnskxRtCC+tneySFe4wOZMLNdEAly166fdCI/FmAFURbn1SEIhav999KJ7xJlV4z
        vjemuWV2JlmIeko2rwVhlWP8FkzdaHw=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 22/48] batman-adv: Free last_bonding_candidate on release of orig_node
Date:   Wed, 18 Mar 2020 00:27:08 +0100
Message-Id: <20200317232734.6127-23-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit cbef1e102003edb236c6b2319ab269ccef963731 upstream.

The orig_ifinfo reference counter for last_bonding_candidate in
batadv_orig_node has to be reduced when an originator node is released.
Otherwise the orig_ifinfo is leaked and the reference counter the netdevice
is not reduced correctly.

Fixes: f3b3d9018975 ("batman-adv: add bonding again")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/originator.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index ce9743aa8a14..ce5b991707d0 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -565,6 +565,7 @@ static void batadv_orig_node_release(struct batadv_orig_node *orig_node)
 	struct batadv_neigh_node *neigh_node;
 	struct batadv_orig_ifinfo *orig_ifinfo;
 	struct batadv_orig_node_vlan *vlan;
+	struct batadv_orig_ifinfo *last_candidate;
 
 	spin_lock_bh(&orig_node->neigh_list_lock);
 
@@ -580,8 +581,14 @@ static void batadv_orig_node_release(struct batadv_orig_node *orig_node)
 		hlist_del_rcu(&orig_ifinfo->list);
 		batadv_orig_ifinfo_free_ref(orig_ifinfo);
 	}
+
+	last_candidate = orig_node->last_bonding_candidate;
+	orig_node->last_bonding_candidate = NULL;
 	spin_unlock_bh(&orig_node->neigh_list_lock);
 
+	if (last_candidate)
+		batadv_orig_ifinfo_free_ref(last_candidate);
+
 	spin_lock_bh(&orig_node->vlan_list_lock);
 	hlist_for_each_entry_safe(vlan, node_tmp, &orig_node->vlan_list, list) {
 		hlist_del_rcu(&vlan->list);
-- 
2.20.1

