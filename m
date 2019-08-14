Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DCB8C7EA
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfHNC1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730300AbfHNC0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:26:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 973DC208C2;
        Wed, 14 Aug 2019 02:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749583;
        bh=rvGvV5611w8c4pUuxjDfYdGpdtKIqZg8xBa9evfeSk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Td51MDRpBV3clQXcO0dFLOo/dzUnt6PhXqcPDr3SikrZYQHJdQbNRm8L0d99s/yub
         ngBXHm2siQ3fb8CKjtBwri7UfI+HIFZT7Nq91/D99Pw5/us8TnUx41JoYViYI60Gud
         sWbKqnurYd1ydC0xEQxuCdg7qtWku1V0iqFizDDI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 18/28] NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()
Date:   Tue, 13 Aug 2019 22:25:40 -0400
Message-Id: <20190814022550.17463-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022550.17463-1-sashal@kernel.org>
References: <20190814022550.17463-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

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
index 4afdee420d253..9f15696f55b9f 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -416,7 +416,8 @@ static inline void nfs4_schedule_session_recovery(struct nfs4_session *session,
 
 extern struct nfs4_state_owner *nfs4_get_state_owner(struct nfs_server *, struct rpc_cred *, gfp_t);
 extern void nfs4_put_state_owner(struct nfs4_state_owner *);
-extern void nfs4_purge_state_owners(struct nfs_server *);
+extern void nfs4_purge_state_owners(struct nfs_server *, struct list_head *);
+extern void nfs4_free_state_owners(struct list_head *head);
 extern struct nfs4_state * nfs4_get_open_state(struct inode *, struct nfs4_state_owner *);
 extern void nfs4_put_open_state(struct nfs4_state *);
 extern void nfs4_close_state(struct nfs4_state *, fmode_t);
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index ae91d1e450be7..dac20f31f01f8 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -685,9 +685,12 @@ int nfs41_walk_client_list(struct nfs_client *new,
 
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
index 5be61affeefd8..ef3ed2b1fd278 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -611,24 +611,39 @@ void nfs4_put_state_owner(struct nfs4_state_owner *sp)
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
@@ -1724,12 +1739,13 @@ static int nfs4_do_reclaim(struct nfs_client *clp, const struct nfs4_state_recov
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
@@ -1758,6 +1774,7 @@ static int nfs4_do_reclaim(struct nfs_client *clp, const struct nfs4_state_recov
 		spin_unlock(&clp->cl_lock);
 	}
 	rcu_read_unlock();
+	nfs4_free_state_owners(&freeme);
 	return 0;
 }
 
-- 
2.20.1

