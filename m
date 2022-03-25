Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF19E4E7626
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359685AbiCYPLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359822AbiCYPKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:10:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA47FBF62;
        Fri, 25 Mar 2022 08:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0604B82903;
        Fri, 25 Mar 2022 15:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59959C340E9;
        Fri, 25 Mar 2022 15:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220879;
        bh=0DVtZ/d5Z/wh7tEXj8EY6V3o0QzssdJPeoX1I9EiFy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOfvh34N3N4vz2PUWNVD4VwQRO3VKWfJptNeYUYuyclioWSYj304u6y73JHqAt3tQ
         3MFhIHGbK4ZgrTvnGLfeyzQPegP21j5AUHVex0l8c2lpscYCcInwyl2mUfvpgYg9wx
         ngSu5fB0HGhS9iVgx7Tip+gfkdOzF+uVAswb9pXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Khazhy Kumykov <khazhy@google.com>
Subject: [PATCH 5.4 02/29] nfsd: Containerise filecache laundrette
Date:   Fri, 25 Mar 2022 16:04:42 +0100
Message-Id: <20220325150418.657862336@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
References: <20220325150418.585286754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 9542e6a643fc69d528dfb3303f145719c61d3050 upstream.

Ensure that if the filecache laundrette gets stuck, it only affects
the knfsd instances of one container.

The notifier callbacks can be called from various contexts so avoid
using synchonous filesystem operations that might deadlock.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Cc: Khazhy Kumykov <khazhy@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |  238 +++++++++++++++++++++++++++++++++++++++++++---------
 fs/nfsd/filecache.h |    2 
 fs/nfsd/nfssvc.c    |    9 +
 3 files changed, 207 insertions(+), 42 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -44,6 +44,17 @@ struct nfsd_fcache_bucket {
 
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 
+struct nfsd_fcache_disposal {
+	struct list_head list;
+	struct work_struct work;
+	struct net *net;
+	spinlock_t lock;
+	struct list_head freeme;
+	struct rcu_head rcu;
+};
+
+struct workqueue_struct *nfsd_filecache_wq __read_mostly;
+
 static struct kmem_cache		*nfsd_file_slab;
 static struct kmem_cache		*nfsd_file_mark_slab;
 static struct nfsd_fcache_bucket	*nfsd_file_hashtbl;
@@ -52,32 +63,21 @@ static long				nfsd_file_lru_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
 static atomic_long_t			nfsd_filecache_count;
 static struct delayed_work		nfsd_filecache_laundrette;
+static DEFINE_SPINLOCK(laundrette_lock);
+static LIST_HEAD(laundrettes);
 
-enum nfsd_file_laundrette_ctl {
-	NFSD_FILE_LAUNDRETTE_NOFLUSH = 0,
-	NFSD_FILE_LAUNDRETTE_MAY_FLUSH
-};
+static void nfsd_file_gc(void);
 
 static void
-nfsd_file_schedule_laundrette(enum nfsd_file_laundrette_ctl ctl)
+nfsd_file_schedule_laundrette(void)
 {
 	long count = atomic_long_read(&nfsd_filecache_count);
 
 	if (count == 0 || test_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags))
 		return;
 
-	/* Be more aggressive about scanning if over the threshold */
-	if (count > NFSD_FILE_LRU_THRESHOLD)
-		mod_delayed_work(system_wq, &nfsd_filecache_laundrette, 0);
-	else
-		schedule_delayed_work(&nfsd_filecache_laundrette, NFSD_LAUNDRETTE_DELAY);
-
-	if (ctl == NFSD_FILE_LAUNDRETTE_NOFLUSH)
-		return;
-
-	/* ...and don't delay flushing if we're out of control */
-	if (count >= NFSD_FILE_LRU_LIMIT)
-		flush_delayed_work(&nfsd_filecache_laundrette);
+	queue_delayed_work(system_wq, &nfsd_filecache_laundrette,
+			NFSD_LAUNDRETTE_DELAY);
 }
 
 static void
@@ -316,7 +316,9 @@ nfsd_file_put(struct nfsd_file *nf)
 
 	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
 	if (nfsd_file_put_noref(nf) == 1 && is_hashed && unused)
-		nfsd_file_schedule_laundrette(NFSD_FILE_LAUNDRETTE_MAY_FLUSH);
+		nfsd_file_schedule_laundrette();
+	if (atomic_long_read(&nfsd_filecache_count) >= NFSD_FILE_LRU_LIMIT)
+		nfsd_file_gc();
 }
 
 struct nfsd_file *
@@ -357,6 +359,58 @@ nfsd_file_dispose_list_sync(struct list_
 		flush_delayed_fput();
 }
 
+static void
+nfsd_file_list_remove_disposal(struct list_head *dst,
+		struct nfsd_fcache_disposal *l)
+{
+	spin_lock(&l->lock);
+	list_splice_init(&l->freeme, dst);
+	spin_unlock(&l->lock);
+}
+
+static void
+nfsd_file_list_add_disposal(struct list_head *files, struct net *net)
+{
+	struct nfsd_fcache_disposal *l;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(l, &laundrettes, list) {
+		if (l->net == net) {
+			spin_lock(&l->lock);
+			list_splice_tail_init(files, &l->freeme);
+			spin_unlock(&l->lock);
+			queue_work(nfsd_filecache_wq, &l->work);
+			break;
+		}
+	}
+	rcu_read_unlock();
+}
+
+static void
+nfsd_file_list_add_pernet(struct list_head *dst, struct list_head *src,
+		struct net *net)
+{
+	struct nfsd_file *nf, *tmp;
+
+	list_for_each_entry_safe(nf, tmp, src, nf_lru) {
+		if (nf->nf_net == net)
+			list_move_tail(&nf->nf_lru, dst);
+	}
+}
+
+static void
+nfsd_file_dispose_list_delayed(struct list_head *dispose)
+{
+	LIST_HEAD(list);
+	struct nfsd_file *nf;
+
+	while(!list_empty(dispose)) {
+		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
+		nfsd_file_list_add_pernet(&list, dispose, nf->nf_net);
+		nfsd_file_list_add_disposal(&list, nf->nf_net);
+	}
+}
+
 /*
  * Note this can deadlock with nfsd_file_cache_purge.
  */
@@ -403,17 +457,40 @@ out_skip:
 	return LRU_SKIP;
 }
 
-static void
-nfsd_file_lru_dispose(struct list_head *head)
+static unsigned long
+nfsd_file_lru_walk_list(struct shrink_control *sc)
 {
+	LIST_HEAD(head);
 	struct nfsd_file *nf;
+	unsigned long ret;
 
-	list_for_each_entry(nf, head, nf_lru) {
+	if (sc)
+		ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
+				nfsd_file_lru_cb, &head);
+	else
+		ret = list_lru_walk(&nfsd_file_lru,
+				nfsd_file_lru_cb,
+				&head, LONG_MAX);
+	list_for_each_entry(nf, &head, nf_lru) {
 		spin_lock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
 		nfsd_file_do_unhash(nf);
 		spin_unlock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
 	}
-	nfsd_file_dispose_list(head);
+	nfsd_file_dispose_list_delayed(&head);
+	return ret;
+}
+
+static void
+nfsd_file_gc(void)
+{
+	nfsd_file_lru_walk_list(NULL);
+}
+
+static void
+nfsd_file_gc_worker(struct work_struct *work)
+{
+	nfsd_file_gc();
+	nfsd_file_schedule_laundrette();
 }
 
 static unsigned long
@@ -425,12 +502,7 @@ nfsd_file_lru_count(struct shrinker *s,
 static unsigned long
 nfsd_file_lru_scan(struct shrinker *s, struct shrink_control *sc)
 {
-	LIST_HEAD(head);
-	unsigned long ret;
-
-	ret = list_lru_shrink_walk(&nfsd_file_lru, sc, nfsd_file_lru_cb, &head);
-	nfsd_file_lru_dispose(&head);
-	return ret;
+	return nfsd_file_lru_walk_list(sc);
 }
 
 static struct shrinker	nfsd_file_shrinker = {
@@ -492,7 +564,7 @@ nfsd_file_close_inode(struct inode *inod
 
 	__nfsd_file_close_inode(inode, hashval, &dispose);
 	trace_nfsd_file_close_inode(inode, hashval, !list_empty(&dispose));
-	nfsd_file_dispose_list(&dispose);
+	nfsd_file_dispose_list_delayed(&dispose);
 }
 
 /**
@@ -508,16 +580,11 @@ static void
 nfsd_file_delayed_close(struct work_struct *work)
 {
 	LIST_HEAD(head);
+	struct nfsd_fcache_disposal *l = container_of(work,
+			struct nfsd_fcache_disposal, work);
 
-	list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb, &head, LONG_MAX);
-
-	if (test_and_clear_bit(NFSD_FILE_LRU_RESCAN, &nfsd_file_lru_flags))
-		nfsd_file_schedule_laundrette(NFSD_FILE_LAUNDRETTE_NOFLUSH);
-
-	if (!list_empty(&head)) {
-		nfsd_file_lru_dispose(&head);
-		flush_delayed_fput();
-	}
+	nfsd_file_list_remove_disposal(&head, l);
+	nfsd_file_dispose_list(&head);
 }
 
 static int
@@ -578,6 +645,10 @@ nfsd_file_cache_init(void)
 	if (nfsd_file_hashtbl)
 		return 0;
 
+	nfsd_filecache_wq = alloc_workqueue("nfsd_filecache", 0, 0);
+	if (!nfsd_filecache_wq)
+		goto out;
+
 	nfsd_file_hashtbl = kcalloc(NFSD_FILE_HASH_SIZE,
 				sizeof(*nfsd_file_hashtbl), GFP_KERNEL);
 	if (!nfsd_file_hashtbl) {
@@ -631,7 +702,7 @@ nfsd_file_cache_init(void)
 		spin_lock_init(&nfsd_file_hashtbl[i].nfb_lock);
 	}
 
-	INIT_DELAYED_WORK(&nfsd_filecache_laundrette, nfsd_file_delayed_close);
+	INIT_DELAYED_WORK(&nfsd_filecache_laundrette, nfsd_file_gc_worker);
 out:
 	return ret;
 out_notifier:
@@ -647,6 +718,8 @@ out_err:
 	nfsd_file_mark_slab = NULL;
 	kfree(nfsd_file_hashtbl);
 	nfsd_file_hashtbl = NULL;
+	destroy_workqueue(nfsd_filecache_wq);
+	nfsd_filecache_wq = NULL;
 	goto out;
 }
 
@@ -685,6 +758,88 @@ nfsd_file_cache_purge(struct net *net)
 	}
 }
 
+static struct nfsd_fcache_disposal *
+nfsd_alloc_fcache_disposal(struct net *net)
+{
+	struct nfsd_fcache_disposal *l;
+
+	l = kmalloc(sizeof(*l), GFP_KERNEL);
+	if (!l)
+		return NULL;
+	INIT_WORK(&l->work, nfsd_file_delayed_close);
+	l->net = net;
+	spin_lock_init(&l->lock);
+	INIT_LIST_HEAD(&l->freeme);
+	return l;
+}
+
+static void
+nfsd_free_fcache_disposal(struct nfsd_fcache_disposal *l)
+{
+	rcu_assign_pointer(l->net, NULL);
+	cancel_work_sync(&l->work);
+	nfsd_file_dispose_list(&l->freeme);
+	kfree_rcu(l, rcu);
+}
+
+static void
+nfsd_add_fcache_disposal(struct nfsd_fcache_disposal *l)
+{
+	spin_lock(&laundrette_lock);
+	list_add_tail_rcu(&l->list, &laundrettes);
+	spin_unlock(&laundrette_lock);
+}
+
+static void
+nfsd_del_fcache_disposal(struct nfsd_fcache_disposal *l)
+{
+	spin_lock(&laundrette_lock);
+	list_del_rcu(&l->list);
+	spin_unlock(&laundrette_lock);
+}
+
+static int
+nfsd_alloc_fcache_disposal_net(struct net *net)
+{
+	struct nfsd_fcache_disposal *l;
+
+	l = nfsd_alloc_fcache_disposal(net);
+	if (!l)
+		return -ENOMEM;
+	nfsd_add_fcache_disposal(l);
+	return 0;
+}
+
+static void
+nfsd_free_fcache_disposal_net(struct net *net)
+{
+	struct nfsd_fcache_disposal *l;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(l, &laundrettes, list) {
+		if (l->net != net)
+			continue;
+		nfsd_del_fcache_disposal(l);
+		rcu_read_unlock();
+		nfsd_free_fcache_disposal(l);
+		return;
+	}
+	rcu_read_unlock();
+}
+
+int
+nfsd_file_cache_start_net(struct net *net)
+{
+	return nfsd_alloc_fcache_disposal_net(net);
+}
+
+void
+nfsd_file_cache_shutdown_net(struct net *net)
+{
+	nfsd_file_cache_purge(net);
+	nfsd_free_fcache_disposal_net(net);
+}
+
 void
 nfsd_file_cache_shutdown(void)
 {
@@ -711,6 +866,8 @@ nfsd_file_cache_shutdown(void)
 	nfsd_file_mark_slab = NULL;
 	kfree(nfsd_file_hashtbl);
 	nfsd_file_hashtbl = NULL;
+	destroy_workqueue(nfsd_filecache_wq);
+	nfsd_filecache_wq = NULL;
 }
 
 static bool
@@ -880,7 +1037,8 @@ open_file:
 	nfsd_file_hashtbl[hashval].nfb_maxcount = max(nfsd_file_hashtbl[hashval].nfb_maxcount,
 			nfsd_file_hashtbl[hashval].nfb_count);
 	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
-	atomic_long_inc(&nfsd_filecache_count);
+	if (atomic_long_inc_return(&nfsd_filecache_count) >= NFSD_FILE_LRU_THRESHOLD)
+		nfsd_file_gc();
 
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
 	if (nf->nf_mark)
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -51,6 +51,8 @@ struct nfsd_file {
 int nfsd_file_cache_init(void);
 void nfsd_file_cache_purge(struct net *);
 void nfsd_file_cache_shutdown(void);
+int nfsd_file_cache_start_net(struct net *net);
+void nfsd_file_cache_shutdown_net(struct net *net);
 void nfsd_file_put(struct nfsd_file *nf);
 struct nfsd_file *nfsd_file_get(struct nfsd_file *nf);
 void nfsd_file_close_inode_sync(struct inode *inode);
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -394,13 +394,18 @@ static int nfsd_startup_net(int nrservs,
 		nn->lockd_up = 1;
 	}
 
-	ret = nfs4_state_start_net(net);
+	ret = nfsd_file_cache_start_net(net);
 	if (ret)
 		goto out_lockd;
+	ret = nfs4_state_start_net(net);
+	if (ret)
+		goto out_filecache;
 
 	nn->nfsd_net_up = true;
 	return 0;
 
+out_filecache:
+	nfsd_file_cache_shutdown_net(net);
 out_lockd:
 	if (nn->lockd_up) {
 		lockd_down(net);
@@ -415,7 +420,7 @@ static void nfsd_shutdown_net(struct net
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
-	nfsd_file_cache_purge(net);
+	nfsd_file_cache_shutdown_net(net);
 	nfs4_state_shutdown_net(net);
 	if (nn->lockd_up) {
 		lockd_down(net);


