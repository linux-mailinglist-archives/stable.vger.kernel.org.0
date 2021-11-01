Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A200D441795
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbhKAJhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232031AbhKAJfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B32AC61359;
        Mon,  1 Nov 2021 09:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758763;
        bh=Uws+q5ofjW2c1ycVXZLSNqJ2tMDAMEdFcdbOvzDuDmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFKjotomuJZVpScw922oH2aXd6PuO4RQeML9QjLYT9plwvR0QUGUjwr+WbmhtQmPD
         WjQc2FIL6ySTFHQWxXL+iF51hD6EYprQYn0oXdgRtegjBKqueWiPXsMeRqCOf2Ic1t
         e1YigB+LgotqCbICnb/NeUtSAtvUirCc9gYNaZTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com
Subject: [PATCH 5.10 49/77] net: batman-adv: fix error handling
Date:   Mon,  1 Nov 2021 10:17:37 +0100
Message-Id: <20211101082522.088764191@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Acked-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    8 +++-
 net/batman-adv/main.c                  |   56 +++++++++++++++++++++++----------
 net/batman-adv/network-coding.c        |    4 +-
 net/batman-adv/translation-table.c     |    4 +-
 4 files changed, 52 insertions(+), 20 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1561,10 +1561,14 @@ int batadv_bla_init(struct batadv_priv *
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
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -196,29 +196,41 @@ int batadv_mesh_init(struct net_device *
 
 	bat_priv->gw.generation = 0;
 
-	ret = batadv_v_mesh_init(bat_priv);
-	if (ret < 0)
-		goto err;
-
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
+
+	ret = batadv_v_mesh_init(bat_priv);
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_v;
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
@@ -228,8 +240,20 @@ int batadv_mesh_init(struct net_device *
 
 	return 0;
 
-err:
-	batadv_mesh_free(soft_iface);
+err_nc:
+	batadv_dat_free(bat_priv);
+err_dat:
+	batadv_bla_free(bat_priv);
+err_bla:
+	batadv_v_mesh_free(bat_priv);
+err_v:
+	batadv_tt_free(bat_priv);
+err_tt:
+	batadv_originator_free(bat_priv);
+err_orig:
+	batadv_purge_outstanding_packets(bat_priv, NULL);
+	atomic_set(&bat_priv->mesh_state, BATADV_MESH_INACTIVE);
+
 	return ret;
 }
 
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -155,8 +155,10 @@ int batadv_nc_mesh_init(struct batadv_pr
 				   &batadv_nc_coding_hash_lock_class_key);
 
 	bat_priv->nc.decoding_hash = batadv_hash_new(128);
-	if (!bat_priv->nc.decoding_hash)
+	if (!bat_priv->nc.decoding_hash) {
+		batadv_hash_destroy(bat_priv->nc.coding_hash);
 		goto err;
+	}
 
 	batadv_hash_set_lock_class(bat_priv->nc.decoding_hash,
 				   &batadv_nc_decoding_hash_lock_class_key);
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -4405,8 +4405,10 @@ int batadv_tt_init(struct batadv_priv *b
 		return ret;
 
 	ret = batadv_tt_global_init(bat_priv);
-	if (ret < 0)
+	if (ret < 0) {
+		batadv_tt_local_table_free(bat_priv);
 		return ret;
+	}
 
 	batadv_tvlv_handler_register(bat_priv, batadv_tt_tvlv_ogm_handler_v1,
 				     batadv_tt_tvlv_unicast_handler_v1,


