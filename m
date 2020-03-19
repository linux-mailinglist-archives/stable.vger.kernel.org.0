Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADD718B7AE
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgCSNL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728799AbgCSNLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:11:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECDFA208D6;
        Thu, 19 Mar 2020 13:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623514;
        bh=FU4WyfQvIhbjeHX3WokTysTLIe/V+NR3fCkHiRcOJww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWhEaG8zrGnZabN1EBQ+w4JrJX17yMO+iL2eOQ6KHMBVeDmrmhkVb0FulHCTdH7mP
         yWbkkj83ZJpiD7I6x9+EDMQPPK2VZVxwRRdzydpIWOOhMnXSM6wKO4AKGthShn/S0t
         TTBVryakqFyRopMrUsc4EXcj+ufPm/8splflNqXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 53/90] batman-adv: Initialize gw sel_class via batadv_algo
Date:   Thu, 19 Mar 2020 14:00:15 +0100
Message-Id: <20200319123944.801016349@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 1a9070ec91b37234fe915849b767c61584c64a44 upstream.

The gateway selection class variable is shared between different algorithm
versions. But the interpretation of the content is algorithm specific. The
initialization is therefore also algorithm specific.

But this was implemented incorrectly and the initialization for BATMAN_V
always overwrote the value previously written for BATMAN_IV. This could
only be avoided when BATMAN_V was disabled during compile time.

Using a special batadv_algo hook for this initialization avoids this
problem.

Fixes: 50164d8f500f ("batman-adv: B.A.T.M.A.N. V - implement GW selection logic")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c     |   11 +++++++++++
 net/batman-adv/bat_v.c          |   14 +++++++++++---
 net/batman-adv/gateway_common.c |    5 +++++
 net/batman-adv/soft-interface.c |    1 -
 net/batman-adv/types.h          |    2 ++
 5 files changed, 29 insertions(+), 4 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -2479,6 +2479,16 @@ static void batadv_iv_iface_activate(str
 	batadv_iv_ogm_schedule(hard_iface);
 }
 
+/**
+ * batadv_iv_init_sel_class - initialize GW selection class
+ * @bat_priv: the bat priv with all the soft interface information
+ */
+static void batadv_iv_init_sel_class(struct batadv_priv *bat_priv)
+{
+	/* set default TQ difference threshold to 20 */
+	atomic_set(&bat_priv->gw.sel_class, 20);
+}
+
 static struct batadv_gw_node *
 batadv_iv_gw_get_best_gw_node(struct batadv_priv *bat_priv)
 {
@@ -2827,6 +2837,7 @@ static struct batadv_algo_ops batadv_bat
 		.del_if = batadv_iv_ogm_orig_del_if,
 	},
 	.gw = {
+		.init_sel_class = batadv_iv_init_sel_class,
 		.get_best_gw_node = batadv_iv_gw_get_best_gw_node,
 		.is_eligible = batadv_iv_gw_is_eligible,
 #ifdef CONFIG_BATMAN_ADV_DEBUGFS
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -668,6 +668,16 @@ err_ifinfo1:
 	return ret;
 }
 
+/**
+ * batadv_v_init_sel_class - initialize GW selection class
+ * @bat_priv: the bat priv with all the soft interface information
+ */
+static void batadv_v_init_sel_class(struct batadv_priv *bat_priv)
+{
+	/* set default throughput difference threshold to 5Mbps */
+	atomic_set(&bat_priv->gw.sel_class, 50);
+}
+
 static ssize_t batadv_v_store_sel_class(struct batadv_priv *bat_priv,
 					char *buff, size_t count)
 {
@@ -1054,6 +1064,7 @@ static struct batadv_algo_ops batadv_bat
 		.dump = batadv_v_orig_dump,
 	},
 	.gw = {
+		.init_sel_class = batadv_v_init_sel_class,
 		.store_sel_class = batadv_v_store_sel_class,
 		.show_sel_class = batadv_v_show_sel_class,
 		.get_best_gw_node = batadv_v_gw_get_best_gw_node,
@@ -1094,9 +1105,6 @@ int batadv_v_mesh_init(struct batadv_pri
 	if (ret < 0)
 		return ret;
 
-	/* set default throughput difference threshold to 5Mbps */
-	atomic_set(&bat_priv->gw.sel_class, 50);
-
 	return 0;
 }
 
--- a/net/batman-adv/gateway_common.c
+++ b/net/batman-adv/gateway_common.c
@@ -253,6 +253,11 @@ static void batadv_gw_tvlv_ogm_handler_v
  */
 void batadv_gw_init(struct batadv_priv *bat_priv)
 {
+	if (bat_priv->algo_ops->gw.init_sel_class)
+		bat_priv->algo_ops->gw.init_sel_class(bat_priv);
+	else
+		atomic_set(&bat_priv->gw.sel_class, 1);
+
 	batadv_tvlv_handler_register(bat_priv, batadv_gw_tvlv_ogm_handler_v1,
 				     NULL, BATADV_TVLV_GW, 1,
 				     BATADV_TVLV_HANDLER_OGM_CIFNOTFND);
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -808,7 +808,6 @@ static int batadv_softif_init_late(struc
 	atomic_set(&bat_priv->mcast.num_want_all_ipv6, 0);
 #endif
 	atomic_set(&bat_priv->gw.mode, BATADV_GW_MODE_OFF);
-	atomic_set(&bat_priv->gw.sel_class, 20);
 	atomic_set(&bat_priv->gw.bandwidth_down, 100);
 	atomic_set(&bat_priv->gw.bandwidth_up, 20);
 	atomic_set(&bat_priv->orig_interval, 1000);
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1466,6 +1466,7 @@ struct batadv_algo_orig_ops {
 
 /**
  * struct batadv_algo_gw_ops - mesh algorithm callbacks (GW specific)
+ * @init_sel_class: initialize GW selection class (optional)
  * @store_sel_class: parse and stores a new GW selection class (optional)
  * @show_sel_class: prints the current GW selection class (optional)
  * @get_best_gw_node: select the best GW from the list of available nodes
@@ -1476,6 +1477,7 @@ struct batadv_algo_orig_ops {
  * @dump: dump gateways to a netlink socket (optional)
  */
 struct batadv_algo_gw_ops {
+	void (*init_sel_class)(struct batadv_priv *bat_priv);
 	ssize_t (*store_sel_class)(struct batadv_priv *bat_priv, char *buff,
 				   size_t count);
 	ssize_t (*show_sel_class)(struct batadv_priv *bat_priv, char *buff);


