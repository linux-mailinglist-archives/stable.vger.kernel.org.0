Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE90189203
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgCQX2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:04 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53676 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgCQX2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+OTwEs7Amgmoc24WQSSPX4T+geLlX1ac3wuGLn4brRw=;
        b=tIHFi2uxzJWez3QLlMZQtoAHKppHu8CI651fE7TB4Yu230o66C3We9ZnkA7f3wZnku/hVj
        rfAuQ+zIxo3ov+4GKR/zrpfxYvZYhZ0u3YLLlKLuWav9tiRIQuv1s8IAJO4a2PpV1/V8kL
        VSzrg65TgBxiCQhSGL4DKueLmtvfYfs=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 20/48] batman-adv: Fix non-atomic bla_claim::backbone_gw access
Date:   Wed, 18 Mar 2020 00:27:06 +0100
Message-Id: <20200317232734.6127-21-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 net/batman-adv/bridge_loop_avoidance.c | 112 ++++++++++++++++++++-----
 net/batman-adv/types.h                 |   1 +
 2 files changed, 90 insertions(+), 23 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index f7b30d8ec63b..6e2a5d02ce1f 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -129,7 +129,19 @@ batadv_backbone_gw_free_ref(struct batadv_bla_backbone_gw *backbone_gw)
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
 
@@ -579,8 +591,10 @@ static void batadv_bla_add_claim(struct batadv_priv *bat_priv,
 				 const u8 *mac, const unsigned short vid,
 				 struct batadv_bla_backbone_gw *backbone_gw)
 {
+	struct batadv_bla_backbone_gw *old_backbone_gw;
 	struct batadv_bla_claim *claim;
 	struct batadv_bla_claim search_claim;
+	bool remove_crc = false;
 	int hash_added;
 
 	ether_addr_copy(search_claim.addr, mac);
@@ -594,8 +608,10 @@ static void batadv_bla_add_claim(struct batadv_priv *bat_priv,
 			return;
 
 		ether_addr_copy(claim->addr, mac);
+		spin_lock_init(&claim->backbone_lock);
 		claim->vid = vid;
 		claim->lasttime = jiffies;
+		atomic_inc(&backbone_gw->refcount);
 		claim->backbone_gw = backbone_gw;
 
 		atomic_set(&claim->refcount, 2);
@@ -622,15 +638,26 @@ static void batadv_bla_add_claim(struct batadv_priv *bat_priv,
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
@@ -661,10 +708,6 @@ static void batadv_bla_del_claim(struct batadv_priv *bat_priv,
 			   batadv_choose_claim, claim);
 	batadv_claim_free_ref(claim); /* reference from the hash is gone */
 
-	spin_lock_bh(&claim->backbone_gw->crc_lock);
-	claim->backbone_gw->crc ^= crc16(0, claim->addr, ETH_ALEN);
-	spin_unlock_bh(&claim->backbone_gw->crc_lock);
-
 	/* don't need the reference from hash_find() anymore */
 	batadv_claim_free_ref(claim);
 }
@@ -1074,6 +1117,7 @@ static void batadv_bla_purge_claims(struct batadv_priv *bat_priv,
 				    struct batadv_hard_iface *primary_if,
 				    int now)
 {
+	struct batadv_bla_backbone_gw *backbone_gw;
 	struct batadv_bla_claim *claim;
 	struct hlist_head *head;
 	struct batadv_hashtable *hash;
@@ -1088,14 +1132,17 @@ static void batadv_bla_purge_claims(struct batadv_priv *bat_priv,
 
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
@@ -1103,8 +1150,10 @@ static void batadv_bla_purge_claims(struct batadv_priv *bat_priv,
 
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
@@ -1488,9 +1537,11 @@ void batadv_bla_free(struct batadv_priv *bat_priv)
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
@@ -1522,8 +1573,12 @@ int batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
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
@@ -1586,7 +1641,9 @@ int batadv_bla_tx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 {
 	struct ethhdr *ethhdr;
 	struct batadv_bla_claim search_claim, *claim = NULL;
+	struct batadv_bla_backbone_gw *backbone_gw;
 	struct batadv_hard_iface *primary_if;
+	bool client_roamed;
 	int ret = 0;
 
 	primary_if = batadv_primary_if_get_selected(bat_priv);
@@ -1616,8 +1673,12 @@ int batadv_bla_tx(struct batadv_priv *bat_priv, struct sk_buff *skb,
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
@@ -1670,6 +1731,7 @@ int batadv_bla_claim_table_seq_print_text(struct seq_file *seq, void *offset)
 	struct net_device *net_dev = (struct net_device *)seq->private;
 	struct batadv_priv *bat_priv = netdev_priv(net_dev);
 	struct batadv_hashtable *hash = bat_priv->bla.claim_hash;
+	struct batadv_bla_backbone_gw *backbone_gw;
 	struct batadv_bla_claim *claim;
 	struct batadv_hard_iface *primary_if;
 	struct hlist_head *head;
@@ -1694,17 +1756,21 @@ int batadv_bla_claim_table_seq_print_text(struct seq_file *seq, void *offset)
 
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
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 4764495b4071..d3ebc3fd7d06 100644
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
-- 
2.20.1

