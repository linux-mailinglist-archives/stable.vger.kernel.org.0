Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77DD452F82
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 11:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhKPKyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 05:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234398AbhKPKyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 05:54:09 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C52EC061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 02:51:12 -0800 (PST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.4] net: batman-adv: fix error handling
Date:   Tue, 16 Nov 2021 11:50:28 +0100
Message-Id: <20211116105028.188548-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 6f68cd634856f8ca93bafd623ba5357e0f648c68 upstream.

Syzbot reported ODEBUG warning in batadv_nc_mesh_free(). The problem was
in wrong error handling in batadv_mesh_init().

Before this patch batadv_mesh_init() was calling batadv_mesh_free() in case
of any batadv_*_init() calls failure. This approach may work well, when
there is some kind of indicator, which can tell which parts of batadv are
initialized; but there isn't any.

All written above lead to cleaning up uninitialized fields. Even if we hide
ODEBUG warning by initializing bat_priv->nc.work, syzbot was able to hit
GPF in batadv_nc_purge_paths(), because hash pointer in still NULL. [1]

To fix these bugs we can unwind batadv_*_init() calls one by one.
It is good approach for 2 reasons: 1) It fixes bugs on error handling
path 2) It improves the performance, since we won't call unneeded
batadv_*_free() functions.

So, this patch makes all batadv_*_init() clean up all allocated memory
before returning with an error to no call correspoing batadv_*_free()
and open-codes batadv_mesh_free() with proper order to avoid touching
uninitialized fields.

Link: https://lore.kernel.org/netdev/000000000000c87fbd05cef6bcb0@google.com/ [1]
Reported-and-tested-by: syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ bp: 4.4 backport: Drop batadv_v_mesh_{init,free} which are not there yet. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
Submission according to the request in
https://lore.kernel.org/all/163559888490194@kroah.com/

 net/batman-adv/bridge_loop_avoidance.c |  8 +++--
 net/batman-adv/main.c                  | 44 +++++++++++++++++++-------
 net/batman-adv/network-coding.c        |  4 ++-
 net/batman-adv/translation-table.c     |  4 ++-
 4 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 1267cbb1a329..5e59a6ecae42 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1346,10 +1346,14 @@ int batadv_bla_init(struct batadv_priv *bat_priv)
 		return 0;
 
 	bat_priv->bla.claim_hash = batadv_hash_new(128);
-	bat_priv->bla.backbone_hash = batadv_hash_new(32);
+	if (!bat_priv->bla.claim_hash)
+		return -ENOMEM;
 
-	if (!bat_priv->bla.claim_hash || !bat_priv->bla.backbone_hash)
+	bat_priv->bla.backbone_hash = batadv_hash_new(32);
+	if (!bat_priv->bla.backbone_hash) {
+		batadv_hash_destroy(bat_priv->bla.claim_hash);
 		return -ENOMEM;
+	}
 
 	batadv_hash_set_lock_class(bat_priv->bla.claim_hash,
 				   &batadv_claim_hash_lock_class_key);
diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 88cea5154113..8ba7b86579d4 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -159,24 +159,34 @@ int batadv_mesh_init(struct net_device *soft_iface)
 	INIT_HLIST_HEAD(&bat_priv->softif_vlan_list);
 
 	ret = batadv_originator_init(bat_priv);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_orig;
+	}
 
 	ret = batadv_tt_init(bat_priv);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_tt;
+	}
 
 	ret = batadv_bla_init(bat_priv);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_bla;
+	}
 
 	ret = batadv_dat_init(bat_priv);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_dat;
+	}
 
 	ret = batadv_nc_mesh_init(bat_priv);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_nc;
+	}
 
 	batadv_gw_init(bat_priv);
 	batadv_mcast_init(bat_priv);
@@ -186,8 +196,18 @@ int batadv_mesh_init(struct net_device *soft_iface)
 
 	return 0;
 
-err:
-	batadv_mesh_free(soft_iface);
+err_nc:
+	batadv_dat_free(bat_priv);
+err_dat:
+	batadv_bla_free(bat_priv);
+err_bla:
+	batadv_tt_free(bat_priv);
+err_tt:
+	batadv_originator_free(bat_priv);
+err_orig:
+	batadv_purge_outstanding_packets(bat_priv, NULL);
+	atomic_set(&bat_priv->mesh_state, BATADV_MESH_INACTIVE);
+
 	return ret;
 }
 
diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index 91de807a8f03..9317d872b9c0 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -159,8 +159,10 @@ int batadv_nc_mesh_init(struct batadv_priv *bat_priv)
 				   &batadv_nc_coding_hash_lock_class_key);
 
 	bat_priv->nc.decoding_hash = batadv_hash_new(128);
-	if (!bat_priv->nc.decoding_hash)
+	if (!bat_priv->nc.decoding_hash) {
+		batadv_hash_destroy(bat_priv->nc.coding_hash);
 		goto err;
+	}
 
 	batadv_hash_set_lock_class(bat_priv->nc.decoding_hash,
 				   &batadv_nc_decoding_hash_lock_class_key);
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 5f976485e8c6..1ad90267064d 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3833,8 +3833,10 @@ int batadv_tt_init(struct batadv_priv *bat_priv)
 		return ret;
 
 	ret = batadv_tt_global_init(bat_priv);
-	if (ret < 0)
+	if (ret < 0) {
+		batadv_tt_local_table_free(bat_priv);
 		return ret;
+	}
 
 	batadv_tvlv_handler_register(bat_priv, batadv_tt_tvlv_ogm_handler_v1,
 				     batadv_tt_tvlv_unicast_handler_v1,
-- 
2.30.2

