Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88920189218
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgCQX2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:22 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53930 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgCQX2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Gtw2jE2dDyV1r9S3JWafVrAh1G5r8gwBWVmkYsXZ2k=;
        b=ZR2czxQjj/Z73XA7yCUqdaTdWwdwTnS1VqoQD1MSFSlz1xWvTpP9+Glu65bczjM4QFcMez
        c0MWlzG05z5ALRmWL/+InLwZR9r5k0HgebkP4TnWS5/mmdUyYC/z2fN4phkDm7k6u/YRzR
        OmGTd/qyRZCJuANpHpI6SDYbLaSAHLM=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 39/48] batman-adv: Prevent duplicated gateway_node entry
Date:   Wed, 18 Mar 2020 00:27:25 +0100
Message-Id: <20200317232734.6127-40-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit dff9bc42ab0b2d38c5e90ddd79b238fed5b4c7ad upstream.

The function batadv_gw_node_add is responsible for adding new gw_node to
the gateway_list. It is expecting that the caller already checked that
there is not already an entry with the same key or not.

But the lock for the list is only held when the list is really modified.
This could lead to duplicated entries because another context could create
an entry with the same key between the check and the list manipulation.

The check and the manipulation of the list must therefore be in the same
locked code section.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/gateway_client.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 055baa396260..a88b529b7ca0 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -29,6 +29,7 @@
 #include <linux/ipv6.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -413,6 +414,9 @@ out:
  * @bat_priv: the bat priv with all the soft interface information
  * @orig_node: originator announcing gateway capabilities
  * @gateway: announced bandwidth information
+ *
+ * Has to be called with the appropriate locks being acquired
+ * (gw.list_lock).
  */
 static void batadv_gw_node_add(struct batadv_priv *bat_priv,
 			       struct batadv_orig_node *orig_node,
@@ -420,6 +424,8 @@ static void batadv_gw_node_add(struct batadv_priv *bat_priv,
 {
 	struct batadv_gw_node *gw_node;
 
+	lockdep_assert_held(&bat_priv->gw.list_lock);
+
 	if (gateway->bandwidth_down == 0)
 		return;
 
@@ -438,9 +444,7 @@ static void batadv_gw_node_add(struct batadv_priv *bat_priv,
 	gw_node->bandwidth_up = ntohl(gateway->bandwidth_up);
 	atomic_set(&gw_node->refcount, 1);
 
-	spin_lock_bh(&bat_priv->gw.list_lock);
 	hlist_add_head_rcu(&gw_node->list, &bat_priv->gw.list);
-	spin_unlock_bh(&bat_priv->gw.list_lock);
 
 	batadv_dbg(BATADV_DBG_BATMAN, bat_priv,
 		   "Found new gateway %pM -> gw bandwidth: %u.%u/%u.%u MBit\n",
@@ -493,11 +497,14 @@ void batadv_gw_node_update(struct batadv_priv *bat_priv,
 {
 	struct batadv_gw_node *gw_node, *curr_gw = NULL;
 
+	spin_lock_bh(&bat_priv->gw.list_lock);
 	gw_node = batadv_gw_node_get(bat_priv, orig_node);
 	if (!gw_node) {
 		batadv_gw_node_add(bat_priv, orig_node, gateway);
+		spin_unlock_bh(&bat_priv->gw.list_lock);
 		goto out;
 	}
+	spin_unlock_bh(&bat_priv->gw.list_lock);
 
 	if ((gw_node->bandwidth_down == ntohl(gateway->bandwidth_down)) &&
 	    (gw_node->bandwidth_up == ntohl(gateway->bandwidth_up)))
-- 
2.20.1

