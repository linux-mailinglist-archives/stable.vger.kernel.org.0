Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8C89E22B
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfH0HwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbfH0HwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:52:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB01206BF;
        Tue, 27 Aug 2019 07:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892336;
        bh=fuOx11uhh5YsawfBTSpk8nyaT/KVIG6B6mSohKzmDWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M//sCqi+KL/hxIStLWZnWdEZDWWANytAPAKz0tiq1yA/1Hesb5vvfWDvK1QNpGWWL
         mKKDGVfxGn258qIT6ltW/6Oct97OvhAMmUgD2t7cjad9bWfDF3PYOrXRKrourwigIr
         wcPPrji4tS7UABpFo76fXDjUjB8uaNF4H1bv0B8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/62] NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()
Date:   Tue, 27 Aug 2019 09:50:26 +0200
Message-Id: <20190827072701.584786664@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c77e22834ae9a11891cb613bd9a551be1b94f2bc ]

John Hubbard reports seeing the following stack trace:

nfs4_do_reclaim
   rcu_read_lock /* we are now in_atomic() and must not sleep */
       nfs4_purge_state_owners
           nfs4_free_state_owner
               nfs4_destroy_seqid_counter
                   rpc_destroy_wait_queue
                       cancel_delayed_work_sync
                           __cancel_work_timer
                               __flush_work
                                   start_flush_work
                                       might_sleep:
                                        (kernel/workqueue.c:2975: BUG)

The solution is to separate out the freeing of the state owners
from nfs4_purge_state_owners(), and perform that outside the atomic
context.

Reported-by: John Hubbard <jhubbard@nvidia.com>
Fixes: 0aaaf5c424c7f ("NFS: Cache state owners after files are closed")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4_fs.h    |  3 ++-
 fs/nfs/nfs4client.c |  5 ++++-
 fs/nfs/nfs4state.c  | 27 ++++++++++++++++++++++-----
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index a73144b3cb8c8..22cff39cca29a 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -433,7 +433,8 @@ static inline void nfs4_schedule_session_recovery(struct nfs4_session *session,
 
 extern struct nfs4_state_owner *nfs4_get_state_owner(struct nfs_server *, struct rpc_cred *, gfp_t);
 extern void nfs4_put_state_owner(struct nfs4_state_owner *);
-extern void nfs4_purge_state_owners(struct nfs_server *);
+extern void nfs4_purge_state_owners(struct nfs_server *, struct list_head *);
+extern void nfs4_free_state_owners(struct list_head *head);
 extern struct nfs4_state * nfs4_get_open_state(struct inode *, struct nfs4_state_owner *);
 extern void nfs4_put_open_state(struct nfs4_state *);
 extern void nfs4_close_state(struct nfs4_state *, fmode_t);
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 8f96f6548dc82..0924b68b56574 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -739,9 +739,12 @@ out:
 
 static void nfs4_destroy_server(struct nfs_server *server)
 {
+	LIST_HEAD(freeme);
+
 	nfs_server_return_all_delegations(server);
 	unset_pnfs_layoutdriver(server);
-	nfs4_purge_state_owners(server);
+	nfs4_purge_state_owners(server, &freeme);
+	nfs4_free_state_owners(&freeme);
 }
 
 /*
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 85ec07e4aa91b..f92bfc787c5fe 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -614,24 +614,39 @@ void nfs4_put_state_owner(struct nfs4_state_owner *sp)
 /**
  * nfs4_purge_state_owners - Release all cached state owners
  * @server: nfs_server with cached state owners to release
+ * @head: resulting list of state owners
  *
  * Called at umount time.  Remaining state owners will be on
  * the LRU with ref count of zero.
+ * Note that the state owners are not freed, but are added
+ * to the list @head, which can later be used as an argument
+ * to nfs4_free_state_owners.
  */
-void nfs4_purge_state_owners(struct nfs_server *server)
+void nfs4_purge_state_owners(struct nfs_server *server, struct list_head *head)
 {
 	struct nfs_client *clp = server->nfs_client;
 	struct nfs4_state_owner *sp, *tmp;
-	LIST_HEAD(doomed);
 
 	spin_lock(&clp->cl_lock);
 	list_for_each_entry_safe(sp, tmp, &server->state_owners_lru, so_lru) {
-		list_move(&sp->so_lru, &doomed);
+		list_move(&sp->so_lru, head);
 		nfs4_remove_state_owner_locked(sp);
 	}
 	spin_unlock(&clp->cl_lock);
+}
 
-	list_for_each_entry_safe(sp, tmp, &doomed, so_lru) {
+/**
+ * nfs4_purge_state_owners - Release all cached state owners
+ * @head: resulting list of state owners
+ *
+ * Frees a list of state owners that was generated by
+ * nfs4_purge_state_owners
+ */
+void nfs4_free_state_owners(struct list_head *head)
+{
+	struct nfs4_state_owner *sp, *tmp;
+
+	list_for_each_entry_safe(sp, tmp, head, so_lru) {
 		list_del(&sp->so_lru);
 		nfs4_free_state_owner(sp);
 	}
@@ -1782,12 +1797,13 @@ static int nfs4_do_reclaim(struct nfs_client *clp, const struct nfs4_state_recov
 	struct nfs4_state_owner *sp;
 	struct nfs_server *server;
 	struct rb_node *pos;
+	LIST_HEAD(freeme);
 	int status = 0;
 
 restart:
 	rcu_read_lock();
 	list_for_each_entry_rcu(server, &clp->cl_superblocks, client_link) {
-		nfs4_purge_state_owners(server);
+		nfs4_purge_state_owners(server, &freeme);
 		spin_lock(&clp->cl_lock);
 		for (pos = rb_first(&server->state_owners);
 		     pos != NULL;
@@ -1816,6 +1832,7 @@ restart:
 		spin_unlock(&clp->cl_lock);
 	}
 	rcu_read_unlock();
+	nfs4_free_state_owners(&freeme);
 	return 0;
 }
 
-- 
2.20.1



