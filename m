Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7E46AF554
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbjCGTYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbjCGTYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:24:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065DBAF0E9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:09:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8206B8117B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3819C433EF;
        Tue,  7 Mar 2023 19:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216175;
        bh=084TwYer79m8VBMvi5NXgTPGZcMgrcdjEBrOuKMwImc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olmsacm79AhG7PEHjI76WYB3NZcRD1UF0NC28Z+At3E30hhEiDfjJVMXYg6rIwBIN
         NZ/WR6nRyQw5YfuzV4s2GmX6aCW/ugfWhaSpXfYNRrUNLZ/vMnqiAHPZAoc4JoHVaK
         LKmzWh1m3C2FpOwGo6C1JdQQQ6EMsiATWRBCX3iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        zhanchengbin <zhanchengbin1@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 498/567] jbd2: fix data missing when reusing bh which is ready to be checkpointed
Date:   Tue,  7 Mar 2023 18:03:54 +0100
Message-Id: <20230307165927.554429059@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit e6b9bd7290d334451ce054e98e752abc055e0034 upstream.

Following process will make data lost and could lead to a filesystem
corrupted problem:

1. jh(bh) is inserted into T1->t_checkpoint_list, bh is dirty, and
   jh->b_transaction = NULL
2. T1 is added into journal->j_checkpoint_transactions.
3. Get bh prepare to write while doing checkpoing:
           PA				    PB
   do_get_write_access             jbd2_log_do_checkpoint
    spin_lock(&jh->b_state_lock)
     if (buffer_dirty(bh))
      clear_buffer_dirty(bh)   // clear buffer dirty
       set_buffer_jbddirty(bh)
				    transaction =
				    journal->j_checkpoint_transactions
				    jh = transaction->t_checkpoint_list
				    if (!buffer_dirty(bh))
		                      __jbd2_journal_remove_checkpoint(jh)
				      // bh won't be flushed
		                    jbd2_cleanup_journal_tail
    __jbd2_journal_file_buffer(jh, transaction, BJ_Reserved)
4. Aborting journal/Power-cut before writing latest bh on journal area.

In this way we get a corrupted filesystem with bh's data lost.

Fix it by moving the clearing of buffer_dirty bit just before the call
to __jbd2_journal_file_buffer(), both bit clearing and jh->b_transaction
assignment are under journal->j_list_lock locked, so that
jbd2_log_do_checkpoint() will wait until jh's new transaction fininshed
even bh is currently not dirty. And journal_shrink_one_cp_list() won't
remove jh from checkpoint list if the buffer head is reused in
do_get_write_access().

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216898
Cc: <stable@kernel.org>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230110015327.1181863-1-chengzhihao1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/transaction.c |   50 +++++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1001,36 +1001,28 @@ repeat:
 	 * ie. locked but not dirty) or tune2fs (which may actually have
 	 * the buffer dirtied, ugh.)  */
 
-	if (buffer_dirty(bh)) {
+	if (buffer_dirty(bh) && jh->b_transaction) {
+		warn_dirty_buffer(bh);
 		/*
-		 * First question: is this buffer already part of the current
-		 * transaction or the existing committing transaction?
-		 */
-		if (jh->b_transaction) {
-			J_ASSERT_JH(jh,
-				jh->b_transaction == transaction ||
-				jh->b_transaction ==
-					journal->j_committing_transaction);
-			if (jh->b_next_transaction)
-				J_ASSERT_JH(jh, jh->b_next_transaction ==
-							transaction);
-			warn_dirty_buffer(bh);
-		}
-		/*
-		 * In any case we need to clean the dirty flag and we must
-		 * do it under the buffer lock to be sure we don't race
-		 * with running write-out.
+		 * We need to clean the dirty flag and we must do it under the
+		 * buffer lock to be sure we don't race with running write-out.
 		 */
 		JBUFFER_TRACE(jh, "Journalling dirty buffer");
 		clear_buffer_dirty(bh);
+		/*
+		 * The buffer is going to be added to BJ_Reserved list now and
+		 * nothing guarantees jbd2_journal_dirty_metadata() will be
+		 * ever called for it. So we need to set jbddirty bit here to
+		 * make sure the buffer is dirtied and written out when the
+		 * journaling machinery is done with it.
+		 */
 		set_buffer_jbddirty(bh);
 	}
 
-	unlock_buffer(bh);
-
 	error = -EROFS;
 	if (is_handle_aborted(handle)) {
 		spin_unlock(&jh->b_state_lock);
+		unlock_buffer(bh);
 		goto out;
 	}
 	error = 0;
@@ -1040,8 +1032,10 @@ repeat:
 	 * b_next_transaction points to it
 	 */
 	if (jh->b_transaction == transaction ||
-	    jh->b_next_transaction == transaction)
+	    jh->b_next_transaction == transaction) {
+		unlock_buffer(bh);
 		goto done;
+	}
 
 	/*
 	 * this is the first time this transaction is touching this buffer,
@@ -1065,10 +1059,24 @@ repeat:
 		 */
 		smp_wmb();
 		spin_lock(&journal->j_list_lock);
+		if (test_clear_buffer_dirty(bh)) {
+			/*
+			 * Execute buffer dirty clearing and jh->b_transaction
+			 * assignment under journal->j_list_lock locked to
+			 * prevent bh being removed from checkpoint list if
+			 * the buffer is in an intermediate state (not dirty
+			 * and jh->b_transaction is NULL).
+			 */
+			JBUFFER_TRACE(jh, "Journalling dirty buffer");
+			set_buffer_jbddirty(bh);
+		}
 		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
 		spin_unlock(&journal->j_list_lock);
+		unlock_buffer(bh);
 		goto done;
 	}
+	unlock_buffer(bh);
+
 	/*
 	 * If there is already a copy-out version of this buffer, then we don't
 	 * need to make another one


