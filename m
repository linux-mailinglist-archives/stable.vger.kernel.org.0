Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7086A09F3
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbjBWNLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjBWNLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:11:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E9F5709E
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:11:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B875ACE1FEB
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92461C433D2;
        Thu, 23 Feb 2023 13:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157864;
        bh=qDjo2GCEzUE6bASEDIr/6h5mb0gkz90D+V1/ss1LNiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsKrqrBXPzsd980tJrYDMsitiRDQyFQVoebyoxlU+nYwbwXseLrrmGoHWpR2UY7e1
         OKjB25F/Z1dXOYOIfAEdYnWJWOWglitMtseoVYaDfOqCO209j3SiwqCfdXYkw4J7tf
         Yif9/I3i8G9W3Xz9fJTFbayQz2LI6V/t0Dsow+lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Skripkin <paskripkin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com
Subject: [PATCH 5.4 14/18] mac80211: mesh: embedd mesh_paths and mpp_paths into ieee80211_if_mesh
Date:   Thu, 23 Feb 2023 14:06:59 +0100
Message-Id: <20230223130426.215709106@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130425.680784802@linuxfoundation.org>
References: <20230223130425.680784802@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 8b5cb7e41d9d77ffca036b0239177de123394a55 upstream.

Syzbot hit NULL deref in rhashtable_free_and_destroy(). The problem was
in mesh_paths and mpp_paths being NULL.

mesh_pathtbl_init() could fail in case of memory allocation failure, but
nobody cared, since ieee80211_mesh_init_sdata() returns void. It led to
leaving 2 pointers as NULL. Syzbot has found null deref on exit path,
but it could happen anywhere else, because code assumes these pointers are
valid.

Since all ieee80211_*_setup_sdata functions are void and do not fail,
let's embedd mesh_paths and mpp_paths into parent struct to avoid
adding error handling on higher levels and follow the pattern of others
setup_sdata functions

Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
Reported-and-tested-by: syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20211230195547.23977-1-paskripkin@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[pchelkin@ispras.ru: adapt a comment spell fixing issue]
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h  |   24 ++++++++++-
 net/mac80211/mesh.h         |   22 ----------
 net/mac80211/mesh_pathtbl.c |   91 +++++++++++++++-----------------------------
 3 files changed, 55 insertions(+), 82 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -632,6 +632,26 @@ struct mesh_csa_settings {
 	struct cfg80211_csa_settings settings;
 };
 
+/**
+ * struct mesh_table
+ *
+ * @known_gates: list of known mesh gates and their mpaths by the station. The
+ * gate's mpath may or may not be resolved and active.
+ * @gates_lock: protects updates to known_gates
+ * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
+ * @walk_head: linked list containing all mesh_path objects
+ * @walk_lock: lock protecting walk_head
+ * @entries: number of entries in the table
+ */
+struct mesh_table {
+	struct hlist_head known_gates;
+	spinlock_t gates_lock;
+	struct rhashtable rhead;
+	struct hlist_head walk_head;
+	spinlock_t walk_lock;
+	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
+};
+
 struct ieee80211_if_mesh {
 	struct timer_list housekeeping_timer;
 	struct timer_list mesh_path_timer;
@@ -706,8 +726,8 @@ struct ieee80211_if_mesh {
 	/* offset from skb->data while building IE */
 	int meshconf_offset;
 
-	struct mesh_table *mesh_paths;
-	struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
+	struct mesh_table mesh_paths;
+	struct mesh_table mpp_paths; /* Store paths for MPP&MAP */
 	int mesh_paths_generation;
 	int mpp_paths_generation;
 };
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -127,26 +127,6 @@ struct mesh_path {
 	u32 path_change_count;
 };
 
-/**
- * struct mesh_table
- *
- * @known_gates: list of known mesh gates and their mpaths by the station. The
- * gate's mpath may or may not be resolved and active.
- * @gates_lock: protects updates to known_gates
- * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
- * @walk_head: linked list containging all mesh_path objects
- * @walk_lock: lock protecting walk_head
- * @entries: number of entries in the table
- */
-struct mesh_table {
-	struct hlist_head known_gates;
-	spinlock_t gates_lock;
-	struct rhashtable rhead;
-	struct hlist_head walk_head;
-	spinlock_t walk_lock;
-	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
-};
-
 /* Recent multicast cache */
 /* RMC_BUCKETS must be a power of 2, maximum 256 */
 #define RMC_BUCKETS		256
@@ -306,7 +286,7 @@ int mesh_path_error_tx(struct ieee80211_
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
-int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata);
+void mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata);
 void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata);
 int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr);
 void mesh_path_timer(struct timer_list *t);
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -47,32 +47,24 @@ static void mesh_path_rht_free(void *ptr
 	mesh_path_free_rcu(tbl, mpath);
 }
 
-static struct mesh_table *mesh_table_alloc(void)
+static void mesh_table_init(struct mesh_table *tbl)
 {
-	struct mesh_table *newtbl;
-
-	newtbl = kmalloc(sizeof(struct mesh_table), GFP_ATOMIC);
-	if (!newtbl)
-		return NULL;
-
-	INIT_HLIST_HEAD(&newtbl->known_gates);
-	INIT_HLIST_HEAD(&newtbl->walk_head);
-	atomic_set(&newtbl->entries,  0);
-	spin_lock_init(&newtbl->gates_lock);
-	spin_lock_init(&newtbl->walk_lock);
-	if (rhashtable_init(&newtbl->rhead, &mesh_rht_params)) {
-		kfree(newtbl);
-		return NULL;
-	}
-
-	return newtbl;
+	INIT_HLIST_HEAD(&tbl->known_gates);
+	INIT_HLIST_HEAD(&tbl->walk_head);
+	atomic_set(&tbl->entries,  0);
+	spin_lock_init(&tbl->gates_lock);
+	spin_lock_init(&tbl->walk_lock);
+
+	/* rhashtable_init() may fail only in case of wrong
+	 * mesh_rht_params
+	 */
+	WARN_ON(rhashtable_init(&tbl->rhead, &mesh_rht_params));
 }
 
 static void mesh_table_free(struct mesh_table *tbl)
 {
 	rhashtable_free_and_destroy(&tbl->rhead,
 				    mesh_path_rht_free, tbl);
-	kfree(tbl);
 }
 
 /**
@@ -240,13 +232,13 @@ static struct mesh_path *mpath_lookup(st
 struct mesh_path *
 mesh_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
-	return mpath_lookup(sdata->u.mesh.mesh_paths, dst, sdata);
+	return mpath_lookup(&sdata->u.mesh.mesh_paths, dst, sdata);
 }
 
 struct mesh_path *
 mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
-	return mpath_lookup(sdata->u.mesh.mpp_paths, dst, sdata);
+	return mpath_lookup(&sdata->u.mesh.mpp_paths, dst, sdata);
 }
 
 static struct mesh_path *
@@ -283,7 +275,7 @@ __mesh_path_lookup_by_idx(struct mesh_ta
 struct mesh_path *
 mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	return __mesh_path_lookup_by_idx(sdata->u.mesh.mesh_paths, idx);
+	return __mesh_path_lookup_by_idx(&sdata->u.mesh.mesh_paths, idx);
 }
 
 /**
@@ -298,7 +290,7 @@ mesh_path_lookup_by_idx(struct ieee80211
 struct mesh_path *
 mpp_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	return __mesh_path_lookup_by_idx(sdata->u.mesh.mpp_paths, idx);
+	return __mesh_path_lookup_by_idx(&sdata->u.mesh.mpp_paths, idx);
 }
 
 /**
@@ -311,7 +303,7 @@ int mesh_path_add_gate(struct mesh_path
 	int err;
 
 	rcu_read_lock();
-	tbl = mpath->sdata->u.mesh.mesh_paths;
+	tbl = &mpath->sdata->u.mesh.mesh_paths;
 
 	spin_lock_bh(&mpath->state_lock);
 	if (mpath->is_gate) {
@@ -420,7 +412,7 @@ struct mesh_path *mesh_path_add(struct i
 	if (!new_mpath)
 		return ERR_PTR(-ENOMEM);
 
-	tbl = sdata->u.mesh.mesh_paths;
+	tbl = &sdata->u.mesh.mesh_paths;
 	spin_lock_bh(&tbl->walk_lock);
 	mpath = rhashtable_lookup_get_insert_fast(&tbl->rhead,
 						  &new_mpath->rhash,
@@ -462,7 +454,7 @@ int mpp_path_add(struct ieee80211_sub_if
 		return -ENOMEM;
 
 	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
-	tbl = sdata->u.mesh.mpp_paths;
+	tbl = &sdata->u.mesh.mpp_paths;
 
 	spin_lock_bh(&tbl->walk_lock);
 	ret = rhashtable_lookup_insert_fast(&tbl->rhead,
@@ -491,7 +483,7 @@ int mpp_path_add(struct ieee80211_sub_if
 void mesh_plink_broken(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mesh_paths;
 	static const u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct mesh_path *mpath;
 
@@ -550,7 +542,7 @@ static void __mesh_path_del(struct mesh_
 void mesh_path_flush_by_nexthop(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mesh_paths;
 	struct mesh_path *mpath;
 	struct hlist_node *n;
 
@@ -565,7 +557,7 @@ void mesh_path_flush_by_nexthop(struct s
 static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
 			       const u8 *proxy)
 {
-	struct mesh_table *tbl = sdata->u.mesh.mpp_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mpp_paths;
 	struct mesh_path *mpath;
 	struct hlist_node *n;
 
@@ -599,8 +591,8 @@ static void table_flush_by_iface(struct
  */
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 {
-	table_flush_by_iface(sdata->u.mesh.mesh_paths);
-	table_flush_by_iface(sdata->u.mesh.mpp_paths);
+	table_flush_by_iface(&sdata->u.mesh.mesh_paths);
+	table_flush_by_iface(&sdata->u.mesh.mpp_paths);
 }
 
 /**
@@ -646,7 +638,7 @@ int mesh_path_del(struct ieee80211_sub_i
 	/* flush relevant mpp entries first */
 	mpp_flush_by_proxy(sdata, addr);
 
-	err = table_path_del(sdata->u.mesh.mesh_paths, sdata, addr);
+	err = table_path_del(&sdata->u.mesh.mesh_paths, sdata, addr);
 	sdata->u.mesh.mesh_paths_generation++;
 	return err;
 }
@@ -684,7 +676,7 @@ int mesh_path_send_to_gates(struct mesh_
 	struct mesh_path *gate;
 	bool copy = false;
 
-	tbl = sdata->u.mesh.mesh_paths;
+	tbl = &sdata->u.mesh.mesh_paths;
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(gate, &tbl->known_gates, gate_list) {
@@ -764,29 +756,10 @@ void mesh_path_fix_nexthop(struct mesh_p
 	mesh_path_tx_pending(mpath);
 }
 
-int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
+void mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
 {
-	struct mesh_table *tbl_path, *tbl_mpp;
-	int ret;
-
-	tbl_path = mesh_table_alloc();
-	if (!tbl_path)
-		return -ENOMEM;
-
-	tbl_mpp = mesh_table_alloc();
-	if (!tbl_mpp) {
-		ret = -ENOMEM;
-		goto free_path;
-	}
-
-	sdata->u.mesh.mesh_paths = tbl_path;
-	sdata->u.mesh.mpp_paths = tbl_mpp;
-
-	return 0;
-
-free_path:
-	mesh_table_free(tbl_path);
-	return ret;
+	mesh_table_init(&sdata->u.mesh.mesh_paths);
+	mesh_table_init(&sdata->u.mesh.mpp_paths);
 }
 
 static
@@ -808,12 +781,12 @@ void mesh_path_tbl_expire(struct ieee802
 
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 {
-	mesh_path_tbl_expire(sdata, sdata->u.mesh.mesh_paths);
-	mesh_path_tbl_expire(sdata, sdata->u.mesh.mpp_paths);
+	mesh_path_tbl_expire(sdata, &sdata->u.mesh.mesh_paths);
+	mesh_path_tbl_expire(sdata, &sdata->u.mesh.mpp_paths);
 }
 
 void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata)
 {
-	mesh_table_free(sdata->u.mesh.mesh_paths);
-	mesh_table_free(sdata->u.mesh.mpp_paths);
+	mesh_table_free(&sdata->u.mesh.mesh_paths);
+	mesh_table_free(&sdata->u.mesh.mpp_paths);
 }


