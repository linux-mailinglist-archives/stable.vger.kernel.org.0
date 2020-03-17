Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD631891FC
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCQX15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:57 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53636 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgCQX15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IeCbEGNIUvqVmXpxGg8Or4qYuorXIimv35JCT7nsHKo=;
        b=XaswzOIyqmg68JlmaA2aqiumdNuq4K2bim+dQx4Y7O7MvY/BkcSWLqJDo6hnsE59nf47fX
        chyXywHMudyIOt2lm4WxnnYP/XpFHYgghGoiB/THPYSia818FDja/GrmZhoPlf6Z2MTetx
        wvnRuiOVJm9tD+Yud/4spB4LGeiUfBs=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Martin Weinelt <martin@darmstadt.freifunk.net>,
        Amadeus Alfa <amadeus@chemnitz.freifunk.net>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 13/48] batman-adv: Fix use-after-free/double-free of tt_req_node
Date:   Wed, 18 Mar 2020 00:26:59 +0100
Message-Id: <20200317232734.6127-14-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9c4604a298e0a9807eaf2cd912d1ebf24d98fbeb upstream.

The tt_req_node is added and removed from a list inside a spinlock. But the
locking is sometimes removed even when the object is still referenced and
will be used later via this reference. For example batadv_send_tt_request
can create a new tt_req_node (including add to a list) and later
re-acquires the lock to remove it from the list and to free it. But at this
time another context could have already removed this tt_req_node from the
list and freed it.

CPU#0

    batadv_batman_skb_recv from net_device 0
    -> batadv_iv_ogm_receive
      -> batadv_iv_ogm_process
        -> batadv_iv_ogm_process_per_outif
          -> batadv_tvlv_ogm_receive
            -> batadv_tvlv_ogm_receive
              -> batadv_tvlv_containers_process
                -> batadv_tvlv_call_handler
                  -> batadv_tt_tvlv_ogm_handler_v1
                    -> batadv_tt_update_orig
                      -> batadv_send_tt_request
                        -> batadv_tt_req_node_new
                           spin_lock(...)
                           allocates new tt_req_node and adds it to list
                           spin_unlock(...)
                           return tt_req_node

CPU#1

    batadv_batman_skb_recv from net_device 1
    -> batadv_recv_unicast_tvlv
      -> batadv_tvlv_containers_process
        -> batadv_tvlv_call_handler
          -> batadv_tt_tvlv_unicast_handler_v1
            -> batadv_handle_tt_response
               spin_lock(...)
               tt_req_node gets removed from list and is freed
               spin_unlock(...)

CPU#0

                      <- returned to batadv_send_tt_request
                         spin_lock(...)
                         tt_req_node gets removed from list and is freed
                         MEMORY CORRUPTION/SEGFAULT/...
                         spin_unlock(...)

This can only be solved via reference counting to allow multiple contexts
to handle the list manipulation while making sure that only the last
context holding a reference will free the object.

Fixes: a73105b8d4c7 ("batman-adv: improved client announcement mechanism")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Tested-by: Martin Weinelt <martin@darmstadt.freifunk.net>
Tested-by: Amadeus Alfa <amadeus@chemnitz.freifunk.net>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/batman-adv/translation-table.c | 43 +++++++++++++++++++++++++-----
 net/batman-adv/types.h             |  2 ++
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 4014e5130879..a30a77d1a220 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -2206,6 +2206,29 @@ static u32 batadv_tt_local_crc(struct batadv_priv *bat_priv,
 	return crc;
 }
 
+/**
+ * batadv_tt_req_node_release - free tt_req node entry
+ * @ref: kref pointer of the tt req_node entry
+ */
+static void batadv_tt_req_node_release(struct kref *ref)
+{
+	struct batadv_tt_req_node *tt_req_node;
+
+	tt_req_node = container_of(ref, struct batadv_tt_req_node, refcount);
+
+	kfree(tt_req_node);
+}
+
+/**
+ * batadv_tt_req_node_put - decrement the tt_req_node refcounter and
+ *  possibly release it
+ * @tt_req_node: tt_req_node to be free'd
+ */
+static void batadv_tt_req_node_put(struct batadv_tt_req_node *tt_req_node)
+{
+	kref_put(&tt_req_node->refcount, batadv_tt_req_node_release);
+}
+
 static void batadv_tt_req_list_free(struct batadv_priv *bat_priv)
 {
 	struct batadv_tt_req_node *node;
@@ -2215,7 +2238,7 @@ static void batadv_tt_req_list_free(struct batadv_priv *bat_priv)
 
 	hlist_for_each_entry_safe(node, safe, &bat_priv->tt.req_list, list) {
 		hlist_del_init(&node->list);
-		kfree(node);
+		batadv_tt_req_node_put(node);
 	}
 
 	spin_unlock_bh(&bat_priv->tt.req_list_lock);
@@ -2252,7 +2275,7 @@ static void batadv_tt_req_purge(struct batadv_priv *bat_priv)
 		if (batadv_has_timed_out(node->issued_at,
 					 BATADV_TT_REQUEST_TIMEOUT)) {
 			hlist_del_init(&node->list);
-			kfree(node);
+			batadv_tt_req_node_put(node);
 		}
 	}
 	spin_unlock_bh(&bat_priv->tt.req_list_lock);
@@ -2284,9 +2307,11 @@ batadv_tt_req_node_new(struct batadv_priv *bat_priv,
 	if (!tt_req_node)
 		goto unlock;
 
+	kref_init(&tt_req_node->refcount);
 	ether_addr_copy(tt_req_node->addr, orig_node->orig);
 	tt_req_node->issued_at = jiffies;
 
+	kref_get(&tt_req_node->refcount);
 	hlist_add_head(&tt_req_node->list, &bat_priv->tt.req_list);
 unlock:
 	spin_unlock_bh(&bat_priv->tt.req_list_lock);
@@ -2536,13 +2561,19 @@ static int batadv_send_tt_request(struct batadv_priv *bat_priv,
 out:
 	if (primary_if)
 		batadv_hardif_free_ref(primary_if);
+
 	if (ret && tt_req_node) {
 		spin_lock_bh(&bat_priv->tt.req_list_lock);
-		/* hlist_del_init() verifies tt_req_node still is in the list */
-		hlist_del_init(&tt_req_node->list);
+		if (!hlist_unhashed(&tt_req_node->list)) {
+			hlist_del_init(&tt_req_node->list);
+			batadv_tt_req_node_put(tt_req_node);
+		}
 		spin_unlock_bh(&bat_priv->tt.req_list_lock);
-		kfree(tt_req_node);
 	}
+
+	if (tt_req_node)
+		batadv_tt_req_node_put(tt_req_node);
+
 	kfree(tvlv_tt_data);
 	return ret;
 }
@@ -2978,7 +3009,7 @@ static void batadv_handle_tt_response(struct batadv_priv *bat_priv,
 		if (!batadv_compare_eth(node->addr, resp_src))
 			continue;
 		hlist_del_init(&node->list);
-		kfree(node);
+		batadv_tt_req_node_put(node);
 	}
 
 	spin_unlock_bh(&bat_priv->tt.req_list_lock);
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index dcf285fae2e6..3188907c2b4b 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1001,11 +1001,13 @@ struct batadv_tt_change_node {
  * struct batadv_tt_req_node - data to keep track of the tt requests in flight
  * @addr: mac address address of the originator this request was sent to
  * @issued_at: timestamp used for purging stale tt requests
+ * @refcount: number of contexts the object is used by
  * @list: list node for batadv_priv_tt::req_list
  */
 struct batadv_tt_req_node {
 	u8 addr[ETH_ALEN];
 	unsigned long issued_at;
+	struct kref refcount;
 	struct hlist_node list;
 };
 
-- 
2.20.1

