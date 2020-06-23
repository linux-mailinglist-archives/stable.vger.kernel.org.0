Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFC52063A1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391098AbgFWU37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391018AbgFWU36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:29:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C39C206C3;
        Tue, 23 Jun 2020 20:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944197;
        bh=ORfF6Bzj+Z8WXDK9odvDAwMJ+1DOYC+iTP0CO6oW+bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ki0YN5m9twKdgTqvRBjM/j7JkusxK2nXcxmDKDmmaL1CKbx9mtzsH69hp96AmvtzA
         s48XgGqej+Qsy5XT24fevULCHhOIj1V1Do0qd+btzFW4HNKtZ//+CLI0euDM7N3wzp
         7zfetGcuxr2NO5mETyMBu2g+xfnL7GzuRkc50QtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 211/314] nfsd4: make drc_slab global, not per-net
Date:   Tue, 23 Jun 2020 21:56:46 +0200
Message-Id: <20200623195348.981760480@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 027690c75e8fd91b60a634d31c4891a6e39d45bd ]

I made every global per-network-namespace instead.  But perhaps doing
that to this slab was a step too far.

The kmem_cache_create call in our net init method also seems to be
responsible for this lockdep warning:

[   45.163710] Unable to find swap-space signature
[   45.375718] trinity-c1 (855): attempted to duplicate a private mapping with mremap.  This is not supported.
[   46.055744] futex_wake_op: trinity-c1 tries to shift op by -209; fix this program
[   51.011723]
[   51.013378] ======================================================
[   51.013875] WARNING: possible circular locking dependency detected
[   51.014378] 5.2.0-rc2 #1 Not tainted
[   51.014672] ------------------------------------------------------
[   51.015182] trinity-c2/886 is trying to acquire lock:
[   51.015593] 000000005405f099 (slab_mutex){+.+.}, at: slab_attr_store+0xa2/0x130
[   51.016190]
[   51.016190] but task is already holding lock:
[   51.016652] 00000000ac662005 (kn->count#43){++++}, at: kernfs_fop_write+0x286/0x500
[   51.017266]
[   51.017266] which lock already depends on the new lock.
[   51.017266]
[   51.017909]
[   51.017909] the existing dependency chain (in reverse order) is:
[   51.018497]
[   51.018497] -> #1 (kn->count#43){++++}:
[   51.018956]        __lock_acquire+0x7cf/0x1a20
[   51.019317]        lock_acquire+0x17d/0x390
[   51.019658]        __kernfs_remove+0x892/0xae0
[   51.020020]        kernfs_remove_by_name_ns+0x78/0x110
[   51.020435]        sysfs_remove_link+0x55/0xb0
[   51.020832]        sysfs_slab_add+0xc1/0x3e0
[   51.021332]        __kmem_cache_create+0x155/0x200
[   51.021720]        create_cache+0xf5/0x320
[   51.022054]        kmem_cache_create_usercopy+0x179/0x320
[   51.022486]        kmem_cache_create+0x1a/0x30
[   51.022867]        nfsd_reply_cache_init+0x278/0x560
[   51.023266]        nfsd_init_net+0x20f/0x5e0
[   51.023623]        ops_init+0xcb/0x4b0
[   51.023928]        setup_net+0x2fe/0x670
[   51.024315]        copy_net_ns+0x30a/0x3f0
[   51.024653]        create_new_namespaces+0x3c5/0x820
[   51.025257]        unshare_nsproxy_namespaces+0xd1/0x240
[   51.025881]        ksys_unshare+0x506/0x9c0
[   51.026381]        __x64_sys_unshare+0x3a/0x50
[   51.026937]        do_syscall_64+0x110/0x10b0
[   51.027509]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   51.028175]
[   51.028175] -> #0 (slab_mutex){+.+.}:
[   51.028817]        validate_chain+0x1c51/0x2cc0
[   51.029422]        __lock_acquire+0x7cf/0x1a20
[   51.029947]        lock_acquire+0x17d/0x390
[   51.030438]        __mutex_lock+0x100/0xfa0
[   51.030995]        mutex_lock_nested+0x27/0x30
[   51.031516]        slab_attr_store+0xa2/0x130
[   51.032020]        sysfs_kf_write+0x11d/0x180
[   51.032529]        kernfs_fop_write+0x32a/0x500
[   51.033056]        do_loop_readv_writev+0x21d/0x310
[   51.033627]        do_iter_write+0x2e5/0x380
[   51.034148]        vfs_writev+0x170/0x310
[   51.034616]        do_pwritev+0x13e/0x160
[   51.035100]        __x64_sys_pwritev+0xa3/0x110
[   51.035633]        do_syscall_64+0x110/0x10b0
[   51.036200]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   51.036924]
[   51.036924] other info that might help us debug this:
[   51.036924]
[   51.037876]  Possible unsafe locking scenario:
[   51.037876]
[   51.038556]        CPU0                    CPU1
[   51.039130]        ----                    ----
[   51.039676]   lock(kn->count#43);
[   51.040084]                                lock(slab_mutex);
[   51.040597]                                lock(kn->count#43);
[   51.041062]   lock(slab_mutex);
[   51.041320]
[   51.041320]  *** DEADLOCK ***
[   51.041320]
[   51.041793] 3 locks held by trinity-c2/886:
[   51.042128]  #0: 000000001f55e152 (sb_writers#5){.+.+}, at: vfs_writev+0x2b9/0x310
[   51.042739]  #1: 00000000c7d6c034 (&of->mutex){+.+.}, at: kernfs_fop_write+0x25b/0x500
[   51.043400]  #2: 00000000ac662005 (kn->count#43){++++}, at: kernfs_fop_write+0x286/0x500

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 3ba75830ce17 "drc containerization"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/cache.h    |  2 ++
 fs/nfsd/netns.h    |  1 -
 fs/nfsd/nfscache.c | 29 +++++++++++++++++------------
 fs/nfsd/nfsctl.c   |  6 ++++++
 4 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/cache.h b/fs/nfsd/cache.h
index 10ec5ecdf1178..65c331f75e9c7 100644
--- a/fs/nfsd/cache.h
+++ b/fs/nfsd/cache.h
@@ -78,6 +78,8 @@ enum {
 /* Checksum this amount of the request */
 #define RC_CSUMLEN		(256U)
 
+int	nfsd_drc_slab_create(void);
+void	nfsd_drc_slab_free(void);
 int	nfsd_reply_cache_init(struct nfsd_net *);
 void	nfsd_reply_cache_shutdown(struct nfsd_net *);
 int	nfsd_cache_lookup(struct svc_rqst *);
diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 9a4ef815fb8c1..ed53e206a2996 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -139,7 +139,6 @@ struct nfsd_net {
 	 * Duplicate reply cache
 	 */
 	struct nfsd_drc_bucket   *drc_hashtbl;
-	struct kmem_cache        *drc_slab;
 
 	/* max number of entries allowed in the cache */
 	unsigned int             max_drc_entries;
diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 96352ab7bd810..0c10bfea039eb 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -36,6 +36,8 @@ struct nfsd_drc_bucket {
 	spinlock_t cache_lock;
 };
 
+static struct kmem_cache	*drc_slab;
+
 static int	nfsd_cache_append(struct svc_rqst *rqstp, struct kvec *vec);
 static unsigned long nfsd_reply_cache_count(struct shrinker *shrink,
 					    struct shrink_control *sc);
@@ -95,7 +97,7 @@ nfsd_reply_cache_alloc(struct svc_rqst *rqstp, __wsum csum,
 {
 	struct svc_cacherep	*rp;
 
-	rp = kmem_cache_alloc(nn->drc_slab, GFP_KERNEL);
+	rp = kmem_cache_alloc(drc_slab, GFP_KERNEL);
 	if (rp) {
 		rp->c_state = RC_UNUSED;
 		rp->c_type = RC_NOCACHE;
@@ -129,7 +131,7 @@ nfsd_reply_cache_free_locked(struct nfsd_drc_bucket *b, struct svc_cacherep *rp,
 		atomic_dec(&nn->num_drc_entries);
 		nn->drc_mem_usage -= sizeof(*rp);
 	}
-	kmem_cache_free(nn->drc_slab, rp);
+	kmem_cache_free(drc_slab, rp);
 }
 
 static void
@@ -141,6 +143,18 @@ nfsd_reply_cache_free(struct nfsd_drc_bucket *b, struct svc_cacherep *rp,
 	spin_unlock(&b->cache_lock);
 }
 
+int nfsd_drc_slab_create(void)
+{
+	drc_slab = kmem_cache_create("nfsd_drc",
+				sizeof(struct svc_cacherep), 0, 0, NULL);
+	return drc_slab ? 0: -ENOMEM;
+}
+
+void nfsd_drc_slab_free(void)
+{
+	kmem_cache_destroy(drc_slab);
+}
+
 int nfsd_reply_cache_init(struct nfsd_net *nn)
 {
 	unsigned int hashsize;
@@ -159,18 +173,13 @@ int nfsd_reply_cache_init(struct nfsd_net *nn)
 	if (status)
 		goto out_nomem;
 
-	nn->drc_slab = kmem_cache_create("nfsd_drc",
-				sizeof(struct svc_cacherep), 0, 0, NULL);
-	if (!nn->drc_slab)
-		goto out_shrinker;
-
 	nn->drc_hashtbl = kcalloc(hashsize,
 				sizeof(*nn->drc_hashtbl), GFP_KERNEL);
 	if (!nn->drc_hashtbl) {
 		nn->drc_hashtbl = vzalloc(array_size(hashsize,
 						 sizeof(*nn->drc_hashtbl)));
 		if (!nn->drc_hashtbl)
-			goto out_slab;
+			goto out_shrinker;
 	}
 
 	for (i = 0; i < hashsize; i++) {
@@ -180,8 +189,6 @@ int nfsd_reply_cache_init(struct nfsd_net *nn)
 	nn->drc_hashsize = hashsize;
 
 	return 0;
-out_slab:
-	kmem_cache_destroy(nn->drc_slab);
 out_shrinker:
 	unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
 out_nomem:
@@ -209,8 +216,6 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
 	nn->drc_hashtbl = NULL;
 	nn->drc_hashsize = 0;
 
-	kmem_cache_destroy(nn->drc_slab);
-	nn->drc_slab = NULL;
 }
 
 /*
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index d77c5261c03cb..159feae6af8ba 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1534,6 +1534,9 @@ static int __init init_nfsd(void)
 		goto out_free_slabs;
 	nfsd_fault_inject_init(); /* nfsd fault injection controls */
 	nfsd_stat_init();	/* Statistics */
+	retval = nfsd_drc_slab_create();
+	if (retval)
+		goto out_free_stat;
 	nfsd_lockd_init();	/* lockd->nfsd callbacks */
 	retval = create_proc_exports_entry();
 	if (retval)
@@ -1547,6 +1550,8 @@ out_free_all:
 	remove_proc_entry("fs/nfs", NULL);
 out_free_lockd:
 	nfsd_lockd_shutdown();
+	nfsd_drc_slab_free();
+out_free_stat:
 	nfsd_stat_shutdown();
 	nfsd_fault_inject_cleanup();
 	nfsd4_exit_pnfs();
@@ -1561,6 +1566,7 @@ out_unregister_pernet:
 
 static void __exit exit_nfsd(void)
 {
+	nfsd_drc_slab_free();
 	remove_proc_entry("fs/nfs/exports", NULL);
 	remove_proc_entry("fs/nfs", NULL);
 	nfsd_stat_shutdown();
-- 
2.25.1



