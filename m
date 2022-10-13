Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311045FE2C6
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiJMTgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJMTgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:36:17 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84868170DF7
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 12:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DRXxp4KgDCpNTbhEm2P0MvuTU2PREQvmj1tzel54zss=; b=rq+IHG/3c0WR4FdCML0bUNLQ+u
        VV1Gt3sGtNrOI0q9P2+XX8ltQoMVP34QXocAtgnTQTpgFHQ9fyF+G2FSrpdT1m1C4uHOF51goLHkG
        Pn5/ZypYx9hK+de5c3gvZT1z6Dst1fc4UICU5NlcpoGT+asjxEz0Gnpl6UA9v87J7biY=;
Received: from p200300daa7301d0028e1e1004b08c350.dip0.t-ipconnect.de ([2003:da:a730:1d00:28e1:e100:4b08:c350] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oj2kU-00CXRx-5y; Thu, 13 Oct 2022 20:16:02 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     stable@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 5.15 1/6] mac80211: mesh: clean up rx_bcn_presp API
Date:   Thu, 13 Oct 2022 20:15:56 +0200
Message-Id: <20221013181601.5712-1-nbd@nbd.name>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit a5b983c6073140b624f64e79fea6d33c3e4315a0 upstream.

We currently pass the entire elements to the rx_bcn_presp()
method, but only need mesh_config. Additionally, we use the
length of the elements to calculate back the entire frame's
length, but that's confusing - just pass the length of the
frame instead.

Link: https://lore.kernel.org/r/20210920154009.a18ed3d2da6c.I1824b773a0fbae4453e1433c184678ca14e8df45@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  7 +++----
 net/mac80211/mesh.c        |  4 ++--
 net/mac80211/mesh_sync.c   | 26 ++++++++++++--------------
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f7bea4af2ddb..4bd55af184b2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -631,10 +631,9 @@ struct ieee80211_if_ocb {
  */
 struct ieee802_11_elems;
 struct ieee80211_mesh_sync_ops {
-	void (*rx_bcn_presp)(struct ieee80211_sub_if_data *sdata,
-			     u16 stype,
-			     struct ieee80211_mgmt *mgmt,
-			     struct ieee802_11_elems *elems,
+	void (*rx_bcn_presp)(struct ieee80211_sub_if_data *sdata, u16 stype,
+			     struct ieee80211_mgmt *mgmt, unsigned int len,
+			     const struct ieee80211_meshconf_ie *mesh_cfg,
 			     struct ieee80211_rx_status *rx_status);
 
 	/* should be called with beacon_data under RCU read lock */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 42bd81a30310..9f6414a68d71 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1354,8 +1354,8 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (ifmsh->sync_ops)
-		ifmsh->sync_ops->rx_bcn_presp(sdata,
-			stype, mgmt, &elems, rx_status);
+		ifmsh->sync_ops->rx_bcn_presp(sdata, stype, mgmt, len,
+					      elems.mesh_config, rx_status);
 }
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index fde93de2b80a..9e342cc2504c 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -3,6 +3,7 @@
  * Copyright 2011-2012, Pavel Zubarev <pavel.zubarev@gmail.com>
  * Copyright 2011-2012, Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
  * Copyright 2011-2012, cozybit Inc.
+ * Copyright (C) 2021 Intel Corporation
  */
 
 #include "ieee80211_i.h"
@@ -35,12 +36,12 @@ struct sync_method {
 /**
  * mesh_peer_tbtt_adjusting - check if an mp is currently adjusting its TBTT
  *
- * @ie: information elements of a management frame from the mesh peer
+ * @cfg: mesh config element from the mesh peer (or %NULL)
  */
-static bool mesh_peer_tbtt_adjusting(struct ieee802_11_elems *ie)
+static bool mesh_peer_tbtt_adjusting(const struct ieee80211_meshconf_ie *cfg)
 {
-	return (ie->mesh_config->meshconf_cap &
-			IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING) != 0;
+	return cfg &&
+	       (cfg->meshconf_cap & IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING);
 }
 
 void mesh_sync_adjust_tsf(struct ieee80211_sub_if_data *sdata)
@@ -76,11 +77,11 @@ void mesh_sync_adjust_tsf(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
-				   u16 stype,
-				   struct ieee80211_mgmt *mgmt,
-				   struct ieee802_11_elems *elems,
-				   struct ieee80211_rx_status *rx_status)
+static void
+mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata, u16 stype,
+			      struct ieee80211_mgmt *mgmt, unsigned int len,
+			      const struct ieee80211_meshconf_ie *mesh_cfg,
+			      struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
@@ -101,10 +102,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (ieee80211_have_rx_timestamp(rx_status))
 		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
-						       24 + 12 +
-						       elems->total_len +
-						       FCS_LEN,
-						       24);
+						       len + FCS_LEN, 24);
 	else
 		t_r = drv_get_tsf(local, sdata);
 
@@ -119,7 +117,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	 * dot11MeshNbrOffsetMaxNeighbor non-peer non-MBSS neighbors
 	 */
 
-	if (elems->mesh_config && mesh_peer_tbtt_adjusting(elems)) {
+	if (mesh_peer_tbtt_adjusting(mesh_cfg)) {
 		msync_dbg(sdata, "STA %pM : is adjusting TBTT\n",
 			  sta->sta.addr);
 		goto no_sync;
-- 
2.36.1

