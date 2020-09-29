Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA9827C4D7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgI2LRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729591AbgI2LQl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:16:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C66B21D7D;
        Tue, 29 Sep 2020 11:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378199;
        bh=zkaAA91lUk1zoVhUHdn8mM9FXUn61fVqzjB0/5Gz9Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIreGQf8LUVC15qDlxzmRkT5BAy/UqItyQdgz93Aicx4F1KWd2j+QX70pAyiq3t2T
         rSjtD9X3p+S7DgdaxLmQ0vePoKD10DboISFG5W0rH1NVqW8+jZogNM11IG612yQ09+
         azTQN/Tg40zKIe4CD2LYnoLfHMEheuSY3f7FyOf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/166] NFS: Fix races nfs_page_group_destroy() vs nfs_destroy_unlinked_subrequests()
Date:   Tue, 29 Sep 2020 13:00:09 +0200
Message-Id: <20200929105940.060513511@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 08ca8b21f760c0ed5034a5c122092eec22ccf8f4 ]

When a subrequest is being detached from the subgroup, we want to
ensure that it is not holding the group lock, or in the process
of waiting for the group lock.

Fixes: 5b2b5187fa85 ("NFS: Fix nfs_page_group_destroy() and nfs_lock_and_join_requests() race cases")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pagelist.c        | 67 +++++++++++++++++++++++++++-------------
 fs/nfs/write.c           | 10 ++++--
 include/linux/nfs_page.h |  2 ++
 3 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 7c01936be7c70..37358dba3b033 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -132,47 +132,70 @@ nfs_async_iocounter_wait(struct rpc_task *task, struct nfs_lock_context *l_ctx)
 EXPORT_SYMBOL_GPL(nfs_async_iocounter_wait);
 
 /*
- * nfs_page_group_lock - lock the head of the page group
- * @req - request in group that is to be locked
+ * nfs_page_set_headlock - set the request PG_HEADLOCK
+ * @req: request that is to be locked
  *
- * this lock must be held when traversing or modifying the page
- * group list
+ * this lock must be held when modifying req->wb_head
  *
  * return 0 on success, < 0 on error
  */
 int
-nfs_page_group_lock(struct nfs_page *req)
+nfs_page_set_headlock(struct nfs_page *req)
 {
-	struct nfs_page *head = req->wb_head;
-
-	WARN_ON_ONCE(head != head->wb_head);
-
-	if (!test_and_set_bit(PG_HEADLOCK, &head->wb_flags))
+	if (!test_and_set_bit(PG_HEADLOCK, &req->wb_flags))
 		return 0;
 
-	set_bit(PG_CONTENDED1, &head->wb_flags);
+	set_bit(PG_CONTENDED1, &req->wb_flags);
 	smp_mb__after_atomic();
-	return wait_on_bit_lock(&head->wb_flags, PG_HEADLOCK,
+	return wait_on_bit_lock(&req->wb_flags, PG_HEADLOCK,
 				TASK_UNINTERRUPTIBLE);
 }
 
 /*
- * nfs_page_group_unlock - unlock the head of the page group
- * @req - request in group that is to be unlocked
+ * nfs_page_clear_headlock - clear the request PG_HEADLOCK
+ * @req: request that is to be locked
  */
 void
-nfs_page_group_unlock(struct nfs_page *req)
+nfs_page_clear_headlock(struct nfs_page *req)
 {
-	struct nfs_page *head = req->wb_head;
-
-	WARN_ON_ONCE(head != head->wb_head);
-
 	smp_mb__before_atomic();
-	clear_bit(PG_HEADLOCK, &head->wb_flags);
+	clear_bit(PG_HEADLOCK, &req->wb_flags);
 	smp_mb__after_atomic();
-	if (!test_bit(PG_CONTENDED1, &head->wb_flags))
+	if (!test_bit(PG_CONTENDED1, &req->wb_flags))
 		return;
-	wake_up_bit(&head->wb_flags, PG_HEADLOCK);
+	wake_up_bit(&req->wb_flags, PG_HEADLOCK);
+}
+
+/*
+ * nfs_page_group_lock - lock the head of the page group
+ * @req: request in group that is to be locked
+ *
+ * this lock must be held when traversing or modifying the page
+ * group list
+ *
+ * return 0 on success, < 0 on error
+ */
+int
+nfs_page_group_lock(struct nfs_page *req)
+{
+	int ret;
+
+	ret = nfs_page_set_headlock(req);
+	if (ret || req->wb_head == req)
+		return ret;
+	return nfs_page_set_headlock(req->wb_head);
+}
+
+/*
+ * nfs_page_group_unlock - unlock the head of the page group
+ * @req: request in group that is to be unlocked
+ */
+void
+nfs_page_group_unlock(struct nfs_page *req)
+{
+	if (req != req->wb_head)
+		nfs_page_clear_headlock(req->wb_head);
+	nfs_page_clear_headlock(req);
 }
 
 /*
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 7b6bda68aa86a..767e46c09074b 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -406,22 +406,28 @@ nfs_destroy_unlinked_subrequests(struct nfs_page *destroy_list,
 		destroy_list = (subreq->wb_this_page == old_head) ?
 				   NULL : subreq->wb_this_page;
 
+		/* Note: lock subreq in order to change subreq->wb_head */
+		nfs_page_set_headlock(subreq);
 		WARN_ON_ONCE(old_head != subreq->wb_head);
 
 		/* make sure old group is not used */
 		subreq->wb_this_page = subreq;
+		subreq->wb_head = subreq;
 
 		clear_bit(PG_REMOVE, &subreq->wb_flags);
 
 		/* Note: races with nfs_page_group_destroy() */
 		if (!kref_read(&subreq->wb_kref)) {
 			/* Check if we raced with nfs_page_group_destroy() */
-			if (test_and_clear_bit(PG_TEARDOWN, &subreq->wb_flags))
+			if (test_and_clear_bit(PG_TEARDOWN, &subreq->wb_flags)) {
+				nfs_page_clear_headlock(subreq);
 				nfs_free_request(subreq);
+			} else
+				nfs_page_clear_headlock(subreq);
 			continue;
 		}
+		nfs_page_clear_headlock(subreq);
 
-		subreq->wb_head = subreq;
 		nfs_release_request(old_head);
 
 		if (test_and_clear_bit(PG_INODE_REF, &subreq->wb_flags)) {
diff --git a/include/linux/nfs_page.h b/include/linux/nfs_page.h
index ad69430fd0eb5..5162fc1533c2f 100644
--- a/include/linux/nfs_page.h
+++ b/include/linux/nfs_page.h
@@ -142,6 +142,8 @@ extern	void nfs_unlock_and_release_request(struct nfs_page *);
 extern int nfs_page_group_lock(struct nfs_page *);
 extern void nfs_page_group_unlock(struct nfs_page *);
 extern bool nfs_page_group_sync_on_bit(struct nfs_page *, unsigned int);
+extern	int nfs_page_set_headlock(struct nfs_page *req);
+extern void nfs_page_clear_headlock(struct nfs_page *req);
 extern bool nfs_async_iocounter_wait(struct rpc_task *, struct nfs_lock_context *);
 
 /*
-- 
2.25.1



