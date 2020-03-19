Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD7218B802
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgCSNIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbgCSNIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:08:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA7BE208FE;
        Thu, 19 Mar 2020 13:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623293;
        bh=BzyWt1yyJqFGlxsed1AfS2TSjeJTUbCBPz4Zprclf18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NJuTndmjYKo/Wm1hZb6wvGcxI2Vjmybjin0lvGnW1rk4x/5QSvTdQu6FNn1FJJWt
         PYCfModfX8mUZF4Kz67KamNaOOdHjjb/gn1bMi6uxm6zPJbbEEo4S19EM/43La8Ws6
         IK9YiSBh4QaEKYQ15mHKVK/9kq5HfNYMKBdwysQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 57/93] batman-adv: Fix non-atomic bla_claim::backbone_gw access
Date:   Thu, 19 Mar 2020 14:00:01 +0100
Message-Id: <20200319123943.003265441@linuxfoundation.org>
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

commit 3db0decf1185357d6ab2256d0dede1ca9efda03d upstream.

The pointer batadv_bla_claim::backbone_gw can be changed at any time.
Therefore, access to it must be protected to ensure that two function
accessing the same backbone_gw are actually accessing the same. This is
especially important when the crc_lock is used or when the backbone_gw of a
claim is exchanged.

Not doing so leads to invalid memory access and/or reference leaks.

Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Fixes: 5a1dd8a4773d ("batman-adv: lock crc access in bridge loop avoidance")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |  112 ++++++++++++++++++++++++++-------
 net/batman-adv/types.h                 |    1 
 2 files changed, 90 insertions(+), 23 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -129,7 +129,19 @@ batadv_backbone_gw_free_ref(struct batad
 /* finally deinitialize the claim */
 static void batadv_claim_release(struct batadv_bla_claim *claim)
 {
-	batadv_backbone_gw_free_ref(claim->backbone_gw);
+	struct batadv_bla_backbone_gw *old_backbone_gw;
+
+	spin_lock_bh(&claim->backbone_lock);
+	old_backbone_gw = claim->backbone_gw;
+	claim->backbone_gw = NULL;
+	spin_unlock_bh(&claim->backbone_lock);
+
+	spin_lock_bh(&old_backbone_gw->crc_lock);
+	old_backbone_gw->crc ^= crc16(0, claim->addr, ETH_ALEN);
+	spin_unlock_bh(&old_backbone_gw->crc_lock);
+
+	batadv_backbone_gw_free_ref(old_backbone_gw);
+
 	kfree_rcu(claim, rcu);
 }
 
@@ -579,8 +591,10 @@ static void batadv_bla_add_claim(struct
 				 const u8 *mac, const unsigned short vid,
 				 struct batadv_bla_backbone_gw *backbone_gw)
 {
+	struct batadv_bla_backbone_gw *old_backbone_gw;
 	struct batadv_bla_claim *claim;
 	struct batadv_bla_claim search_claim;
+	bool remove_crc = false;
 	int hash_added;
 
 	ether_addr_copy(search_claim.addr, mac);
@@ -594,8 +608,10 @@ static void batadv_bla_add_claim(struct
 			return;
 
 		ether_addr_copy(claim->addr, mac);
+		spin_lock_init(&claim->backbone_lock);
 		claim->vid = vid;
 		claim->lasttime = jiffies;
+		atomic_inc(&backbone_gw->refcount);
 		claim->backbone_gw = backbone_gw;
 
 		atomic_set(&claim->refcount, 2);
@@ -622,15 +638,26 @@ static void batadv_bla_add_claim(struct
 			   "bla_add_claim(): changing ownership for %pM, vid %d\n",
 			   mac, BATADV_PRINT_VID(vid));
 
-		spin_lock_bh(&claim->backbone_gw->crc_lock);
-		claim->backbone_gw->crc ^= crc16(0, claim->addr, ETH_ALEN);
-		spin_unlock_bh(&claim->backbone_gw->crc_lock);
-		batadv_backbone_gw_free_ref(claim->backbone_gw);
+		remove_crc = true;
 	}
-	/* set (new) backbone gw */
+
+	/* replace backbone_gw atomically and adjust reference counters */
+	spin_lock_bh(&claim->backbone_lock);
+	old_backbone_gw = claim->backbone_gw;
 	atomic_inc(&backbone_gw->refcount);
 	claim->backbone_gw = backbone_gw;
+	spin_unlock_bh(&claim->backbone_lock);
 
+	if (remove_crc) {
+		/* remove claim address from old backbone_gw */
+		spin_lock_bh(&old_backbone_gw->crc_lock);
+		old_backbone_gw->crc ^= crc16(0, claim->addr, ETH_ALEN);
+		spin_unlock_bh(&old_backbone_gw->crc_lock);
+	}
+
+	batadv_backbone_gw_free_ref(old_backbone_gw);
+
+	/* add claim address to new backbone_gw */
 	spin_lock_bh(&backbone_gw->crc_lock);
 	backbone_gw->crc ^= crc16(0, claim->addr, ETH_ALEN);
 	spin_unlock_bh(&backbone_gw->crc_lock);
@@ -640,6 +667,26 @@ claim_free_ref:
 	batadv_claim_free_ref(claim);
 }
 
+/**
+ * batadv_bla_claim_get_backbone_gw - Get valid reference for backbone_gw of
+ *  claim
+ * @claim: claim whose backbone_gw should be returned
+ *
+ * Return: valid reference to claim::backbone_gw
+ */
+static struct batadv_bla_backbone_gw *
+batadv_bla_claim_get_backbone_gw(struct batadv_bla_claim *claim)
+{
+	struct batadv_bla_backbone_gw *backbone_gw;
+
+	spin_lock_bh(&claim->backbone_lock);
+	backbone_gw = claim->backbone_gw;
+	atomic_inc(&backbone_gw->refcount);
+	spin_unlock_bh(&claim->backbone_lock);
+
+	return backbone_gw;
+}
+
 /* Delete a claim from the claim hash which has the
  * given mac address and vid.
  */
@@ -661,10 +708,6 @@ static void batadv_bla_del_claim(struct
 			   batadv_choose_claim, claim);
 	batadv_claim_free_ref(claim); /* reference from the hash is gone */
 
-	spin_lock_bh(&claim->backbone_gw->crc_lock);
-	claim->backbone_gw->crc ^= crc16(0, claim->addr, ETH_ALEN);
-	spin_unlock_bh(&claim->backbone_gw->crc_lock);
-
 	/* don't need the reference from hash_find() anymore */
 	batadv_claim_free_ref(claim);
 }
@@ -1074,6 +1117,7 @@ static void batadv_bla_purge_claims(stru
 				    struct batadv_hard_iface *primary_if,
 				    int now)
 {
+	struct batadv_bla_backbone_gw *backbone_gw;
 	struct batadv_bla_claim *claim;
 	struct hlist_head *head;
 	struct batadv_hashtable *hash;
@@ -1088,14 +1132,17 @@ static void batadv_bla_purge_claims(stru
 
 		rcu_read_lock();
 		hlist_for_each_entry_rcu(claim, head, hash_entry) {
+			backbone_gw = batadv_bla_claim_get_backbone_gw(claim);
 			if (now)
 				goto purge_now;
-			if (!batadv_compare_eth(claim->backbone_gw->orig,
+
+			if (!batadv_compare_eth(backbone_gw->orig,
 						primary_if->net_dev->dev_addr))
-				continue;
+				goto skip;
+
 			if (!batadv_has_timed_out(claim->lasttime,
 						  BATADV_BLA_CLAIM_TIMEOUT))
-				continue;
+				goto skip;
 
 			batadv_dbg(BATADV_DBG_BLA, bat_priv,
 				   "bla_purge_claims(): %pM, vid %d, time out\n",
@@ -1103,8 +1150,10 @@ static void batadv_bla_purge_claims(stru
 
 purge_now:
 			batadv_handle_unclaim(bat_priv, primary_if,
-					      claim->backbone_gw->orig,
+					      backbone_gw->orig,
 					      claim->addr, claim->vid);
+skip:
+			batadv_backbone_gw_free_ref(backbone_gw);
 		}
 		rcu_read_unlock();
 	}
@@ -1488,9 +1537,11 @@ void batadv_bla_free(struct batadv_priv
 int batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		  unsigned short vid, bool is_bcast)
 {
+	struct batadv_bla_backbone_gw *backbone_gw;
 	struct ethhdr *ethhdr;
 	struct batadv_bla_claim search_claim, *claim = NULL;
 	struct batadv_hard_iface *primary_if;
+	bool own_claim;
 	int ret;
 
 	ethhdr = eth_hdr(skb);
@@ -1522,8 +1573,12 @@ int batadv_bla_rx(struct batadv_priv *ba
 	}
 
 	/* if it is our own claim ... */
-	if (batadv_compare_eth(claim->backbone_gw->orig,
-			       primary_if->net_dev->dev_addr)) {
+	backbone_gw = batadv_bla_claim_get_backbone_gw(claim);
+	own_claim = batadv_compare_eth(backbone_gw->orig,
+				       primary_if->net_dev->dev_addr);
+	batadv_backbone_gw_free_ref(backbone_gw);
+
+	if (own_claim) {
 		/* ... allow it in any case */
 		claim->lasttime = jiffies;
 		goto allow;
@@ -1586,7 +1641,9 @@ int batadv_bla_tx(struct batadv_priv *ba
 {
 	struct ethhdr *ethhdr;
 	struct batadv_bla_claim search_claim, *claim = NULL;
+	struct batadv_bla_backbone_gw *backbone_gw;
 	struct batadv_hard_iface *primary_if;
+	bool client_roamed;
 	int ret = 0;
 
 	primary_if = batadv_primary_if_get_selected(bat_priv);
@@ -1616,8 +1673,12 @@ int batadv_bla_tx(struct batadv_priv *ba
 		goto allow;
 
 	/* check if we are responsible. */
-	if (batadv_compare_eth(claim->backbone_gw->orig,
-			       primary_if->net_dev->dev_addr)) {
+	backbone_gw = batadv_bla_claim_get_backbone_gw(claim);
+	client_roamed = batadv_compare_eth(backbone_gw->orig,
+					   primary_if->net_dev->dev_addr);
+	batadv_backbone_gw_free_ref(backbone_gw);
+
+	if (client_roamed) {
 		/* if yes, the client has roamed and we have
 		 * to unclaim it.
 		 */
@@ -1670,6 +1731,7 @@ int batadv_bla_claim_table_seq_print_tex
 	struct net_device *net_dev = (struct net_device *)seq->private;
 	struct batadv_priv *bat_priv = netdev_priv(net_dev);
 	struct batadv_hashtable *hash = bat_priv->bla.claim_hash;
+	struct batadv_bla_backbone_gw *backbone_gw;
 	struct batadv_bla_claim *claim;
 	struct batadv_hard_iface *primary_if;
 	struct hlist_head *head;
@@ -1694,17 +1756,21 @@ int batadv_bla_claim_table_seq_print_tex
 
 		rcu_read_lock();
 		hlist_for_each_entry_rcu(claim, head, hash_entry) {
-			is_own = batadv_compare_eth(claim->backbone_gw->orig,
+			backbone_gw = batadv_bla_claim_get_backbone_gw(claim);
+
+			is_own = batadv_compare_eth(backbone_gw->orig,
 						    primary_addr);
 
-			spin_lock_bh(&claim->backbone_gw->crc_lock);
-			backbone_crc = claim->backbone_gw->crc;
-			spin_unlock_bh(&claim->backbone_gw->crc_lock);
+			spin_lock_bh(&backbone_gw->crc_lock);
+			backbone_crc = backbone_gw->crc;
+			spin_unlock_bh(&backbone_gw->crc_lock);
 			seq_printf(seq, " * %pM on %5d by %pM [%c] (%#.4x)\n",
 				   claim->addr, BATADV_PRINT_VID(claim->vid),
-				   claim->backbone_gw->orig,
+				   backbone_gw->orig,
 				   (is_own ? 'x' : ' '),
 				   backbone_crc);
+
+			batadv_backbone_gw_free_ref(backbone_gw);
 		}
 		rcu_read_unlock();
 	}
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -917,6 +917,7 @@ struct batadv_bla_claim {
 	u8 addr[ETH_ALEN];
 	unsigned short vid;
 	struct batadv_bla_backbone_gw *backbone_gw;
+	spinlock_t backbone_lock; /* protects backbone_gw */
 	unsigned long lasttime;
 	struct hlist_node hash_entry;
 	struct rcu_head rcu;


