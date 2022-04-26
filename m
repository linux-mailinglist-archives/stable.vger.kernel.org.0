Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AFC5106DF
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 20:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243202AbiDZSal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 14:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbiDZSak (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 14:30:40 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1266B6E4B
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 11:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1650997653; x=1682533653;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=aIU47jeLIt+1qH3+LzO/YLTUCOlkX6h6kuzevJ6c5KE=;
  b=pFifpPYNjxtm9LKu1ZgXXN5UKkVhbqz//An+BU6mPDnFrD2IOX0WguDq
   Ya4qw9nq62k8gDifSBPaxyJ68MmisUFS4c8vviYMPjW5RDL2cWfmlhvUJ
   vgjo8sisBltyL0AENQKcnVmymOOFmjcJ4QnYNNttiQndbc5LKGCWS20bB
   M=;
X-IronPort-AV: E=Sophos;i="5.90,291,1643673600"; 
   d="scan'208";a="214124673"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6435a935.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 26 Apr 2022 18:27:32 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6435a935.us-west-2.amazon.com (Postfix) with ESMTPS id 0771041B00
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 18:27:32 +0000 (UTC)
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 26 Apr 2022 18:27:31 +0000
Received: from u46989501580c5c.ant.amazon.com (10.43.160.180) by
 EX13d01UWA002.ant.amazon.com (10.43.160.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 26 Apr 2022 18:27:31 +0000
From:   Samuel Mendoza-Jonas <samjonas@amazon.com>
To:     <stable@vger.kernel.org>
Subject: [PATCH 5.4-5.16] jbd2: fix use-after-free of transaction_t race
Date:   Tue, 26 Apr 2022 11:27:02 -0700
Message-ID: <20220426182702.716304-2-samjonas@amazon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220426182702.716304-1-samjonas@amazon.com>
References: <20220426182702.716304-1-samjonas@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D29UWC001.ant.amazon.com (10.43.162.143) To
 EX13d01UWA002.ant.amazon.com (10.43.160.74)
X-Spam-Status: No, score=-15.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit cc16eecae687912238ee6efbff71ad31e2bc414e upstream.

jbd2_journal_wait_updates() is called with j_state_lock held. But if
there is a commit in progress, then this transaction might get committed
and freed via jbd2_journal_commit_transaction() ->
jbd2_journal_free_transaction(), when we release j_state_lock.
So check for journal->j_running_transaction everytime we release and
acquire j_state_lock to avoid use-after-free issue.

Link: https://lore.kernel.org/r/948c2fed518ae739db6a8f7f83f1d58b504f87d0.1644497105.git.ritesh.list@gmail.com
Fixes: 4f98186848707f53 ("jbd2: refactor wait logic for transaction updates into a common function")
Cc: stable@kernel.org
Reported-and-tested-by: syzbot+afa2ca5171d93e44b348@syzkaller.appspotmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[backport to 5.4-5.16 in original jbd2_journal_commit_transaction()
 location before the refactor in
 4f9818684870 "jbd2: refactor wait logic for transaction updates into a
 common function"]
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Fixes: 1da177e4c3f41524
Cc: stable@kernel.org # 5.4.x - 5.16.x
---
While marked for 5.17 stable, it looks like this fix also applies to the
original location in jbd2_journal_commit_transaction() before it was
refactored to use jbd2_journal_wait_updates(). This applies the same
change there.

 fs/jbd2/commit.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index d188fa913a07..e9ed8a71ff25 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -408,6 +408,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	int csum_size = 0;
 	LIST_HEAD(io_bufs);
 	LIST_HEAD(log_bufs);
+	DEFINE_WAIT(wait);
 
 	if (jbd2_journal_has_csum_v2or3(journal))
 		csum_size = sizeof(struct jbd2_journal_block_tail);
@@ -484,22 +485,25 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	stats.run.rs_running = jbd2_time_diff(commit_transaction->t_start,
 					      stats.run.rs_locked);
 
-	spin_lock(&commit_transaction->t_handle_lock);
-	while (atomic_read(&commit_transaction->t_updates)) {
-		DEFINE_WAIT(wait);
+	while (1) {
+		commit_transaction = journal->j_running_transaction;
+		if (!commit_transaction)
+			break;
 
+		spin_lock(&commit_transaction->t_handle_lock);
 		prepare_to_wait(&journal->j_wait_updates, &wait,
 					TASK_UNINTERRUPTIBLE);
-		if (atomic_read(&commit_transaction->t_updates)) {
+		if (!atomic_read(&commit_transaction->t_updates)) {
 			spin_unlock(&commit_transaction->t_handle_lock);
-			write_unlock(&journal->j_state_lock);
-			schedule();
-			write_lock(&journal->j_state_lock);
-			spin_lock(&commit_transaction->t_handle_lock);
+			finish_wait(&journal->j_wait_updates, &wait);
+			break;
 		}
+		spin_unlock(&commit_transaction->t_handle_lock);
+		write_unlock(&journal->j_state_lock);
+		schedule();
 		finish_wait(&journal->j_wait_updates, &wait);
+		write_lock(&journal->j_state_lock);
 	}
-	spin_unlock(&commit_transaction->t_handle_lock);
 	commit_transaction->t_state = T_SWITCH;
 	write_unlock(&journal->j_state_lock);
 
-- 
2.25.1

