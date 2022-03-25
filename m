Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BC94E7751
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376582AbiCYP1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378000AbiCYPYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EF4E29E6;
        Fri, 25 Mar 2022 08:19:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B404760AB7;
        Fri, 25 Mar 2022 15:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E3FC36AF4;
        Fri, 25 Mar 2022 15:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221572;
        bh=3ntAaR+HTeB+hv0fFYTqvXlkop8lARm5AXfhQbKVexA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+jIPmwQNTIrGFYYluPypb/kQJ+AvLZPUkT9D6bp37/gols37BP1sqk24clMrQ9nS
         APRds97ihmUIBwlasDdMHDdCLkbQrWANfjU88/7ztJE9ghNlXySh2NR2DKG9TMmoxP
         2GFoMy1t3fJnirhJyjAYsY8aisZbtrdGrWTPCHyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>,
        syzbot+afa2ca5171d93e44b348@syzkaller.appspotmail.com
Subject: [PATCH 5.17 31/39] jbd2: fix use-after-free of transaction_t race
Date:   Fri, 25 Mar 2022 16:14:46 +0100
Message-Id: <20220325150421.134448886@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
References: <20220325150420.245733653@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/transaction.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -842,27 +842,38 @@ EXPORT_SYMBOL(jbd2_journal_restart);
  */
 void jbd2_journal_wait_updates(journal_t *journal)
 {
-	transaction_t *commit_transaction = journal->j_running_transaction;
+	DEFINE_WAIT(wait);
 
-	if (!commit_transaction)
-		return;
+	while (1) {
+		/*
+		 * Note that the running transaction can get freed under us if
+		 * this transaction is getting committed in
+		 * jbd2_journal_commit_transaction() ->
+		 * jbd2_journal_free_transaction(). This can only happen when we
+		 * release j_state_lock -> schedule() -> acquire j_state_lock.
+		 * Hence we should everytime retrieve new j_running_transaction
+		 * value (after j_state_lock release acquire cycle), else it may
+		 * lead to use-after-free of old freed transaction.
+		 */
+		transaction_t *transaction = journal->j_running_transaction;
 
-	spin_lock(&commit_transaction->t_handle_lock);
-	while (atomic_read(&commit_transaction->t_updates)) {
-		DEFINE_WAIT(wait);
+		if (!transaction)
+			break;
 
+		spin_lock(&transaction->t_handle_lock);
 		prepare_to_wait(&journal->j_wait_updates, &wait,
-					TASK_UNINTERRUPTIBLE);
-		if (atomic_read(&commit_transaction->t_updates)) {
-			spin_unlock(&commit_transaction->t_handle_lock);
-			write_unlock(&journal->j_state_lock);
-			schedule();
-			write_lock(&journal->j_state_lock);
-			spin_lock(&commit_transaction->t_handle_lock);
+				TASK_UNINTERRUPTIBLE);
+		if (!atomic_read(&transaction->t_updates)) {
+			spin_unlock(&transaction->t_handle_lock);
+			finish_wait(&journal->j_wait_updates, &wait);
+			break;
 		}
+		spin_unlock(&transaction->t_handle_lock);
+		write_unlock(&journal->j_state_lock);
+		schedule();
 		finish_wait(&journal->j_wait_updates, &wait);
+		write_lock(&journal->j_state_lock);
 	}
-	spin_unlock(&commit_transaction->t_handle_lock);
 }
 
 /**
@@ -877,8 +888,6 @@ void jbd2_journal_wait_updates(journal_t
  */
 void jbd2_journal_lock_updates(journal_t *journal)
 {
-	DEFINE_WAIT(wait);
-
 	jbd2_might_wait_for_commit(journal);
 
 	write_lock(&journal->j_state_lock);


