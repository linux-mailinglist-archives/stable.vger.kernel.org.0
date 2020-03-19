Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32DF718B811
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCSNHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgCSNHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F5A3207FC;
        Thu, 19 Mar 2020 13:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623224;
        bh=5GdR2swVliXuxsOsPP7mk6l4w61TEMDgCeFcDYqZRx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/wZ4H2xSMngR7OcPHfjLtmIyTa5z5p9+Mofm1EiduS+bTru4OYV4cBicHuiRInme
         WJu0prS7oANOfwdUAVaOx5LyKeRLWg3YmIcq/TQvjy8iEXUGYsrHX+8OwsC7pXPyJp
         iym4K4Cm2z5p5eTw0hzH2Db4eLag2siTd/cidF70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Martin Weinelt <martin@darmstadt.freifunk.net>,
        Amadeus Alfa <amadeus@chemnitz.freifunk.net>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 50/93] batman-adv: Fix use-after-free/double-free of tt_req_node
Date:   Thu, 19 Mar 2020 13:59:54 +0100
Message-Id: <20200319123940.847996821@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |   43 +++++++++++++++++++++++++++++++------
 net/batman-adv/types.h             |    2 +
 2 files changed, 39 insertions(+), 6 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -2206,6 +2206,29 @@ static u32 batadv_tt_local_crc(struct ba
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
@@ -2215,7 +2238,7 @@ static void batadv_tt_req_list_free(stru
 
 	hlist_for_each_entry_safe(node, safe, &bat_priv->tt.req_list, list) {
 		hlist_del_init(&node->list);
-		kfree(node);
+		batadv_tt_req_node_put(node);
 	}
 
 	spin_unlock_bh(&bat_priv->tt.req_list_lock);
@@ -2252,7 +2275,7 @@ static void batadv_tt_req_purge(struct b
 		if (batadv_has_timed_out(node->issued_at,
 					 BATADV_TT_REQUEST_TIMEOUT)) {
 			hlist_del_init(&node->list);
-			kfree(node);
+			batadv_tt_req_node_put(node);
 		}
 	}
 	spin_unlock_bh(&bat_priv->tt.req_list_lock);
@@ -2284,9 +2307,11 @@ batadv_tt_req_node_new(struct batadv_pri
 	if (!tt_req_node)
 		goto unlock;
 
+	kref_init(&tt_req_node->refcount);
 	ether_addr_copy(tt_req_node->addr, orig_node->orig);
 	tt_req_node->issued_at = jiffies;
 
+	kref_get(&tt_req_node->refcount);
 	hlist_add_head(&tt_req_node->list, &bat_priv->tt.req_list);
 unlock:
 	spin_unlock_bh(&bat_priv->tt.req_list_lock);
@@ -2536,13 +2561,19 @@ static int batadv_send_tt_request(struct
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
@@ -2978,7 +3009,7 @@ static void batadv_handle_tt_response(st
 		if (!batadv_compare_eth(node->addr, resp_src))
 			continue;
 		hlist_del_init(&node->list);
-		kfree(node);
+		batadv_tt_req_node_put(node);
 	}
 
 	spin_unlock_bh(&bat_priv->tt.req_list_lock);
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
 


