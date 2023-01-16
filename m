Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7555D66C95D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbjAPQt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbjAPQs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:48:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79862A155
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:35:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67EEEB81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8021C433EF;
        Mon, 16 Jan 2023 16:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886945;
        bh=oTfFiWOuLAUCJTsQhKZfXAbrQzLjFJLMwn3Ou6mKLHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/ZJv4V2/G+syU8ZFG/ghqTDeL17dnx++/u3zrX035/LzuWwZAisGj6utBeOIXlMp
         jrExoQfQsKyVC2++MqA2usqM2B54Ph+SBRo8zADKulWABlmfXubzwhiHCKir92Qbxx
         c9dOEJvLRyzEPB2G4kfQUcIiHLhMsHP+se6iRO5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 622/658] jbd2: Factor out common parts of stopping and restarting a handle
Date:   Mon, 16 Jan 2023 16:51:50 +0100
Message-Id: <20230116154937.955221888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit ec8b6f600e49dc87a8564807fec4193bf93ee2b5 ]

jbd2__journal_restart() has quite some code that is common with
jbd2_journal_stop(). Factor this functionality into stop_this_handle()
helper and use it from both functions. Note that this also drops
t_handle_lock protection from jbd2__journal_restart() as
jbd2_journal_stop() does the same thing without it.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191105164437.32602-17-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d87a7b4c77a9 ("jbd2: use the correct print format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/transaction.c | 98 ++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 52 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 6d78648392f0..ee9a778c8fbe 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -514,12 +514,17 @@ handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
 }
 EXPORT_SYMBOL(jbd2_journal_start);
 
-void jbd2_journal_free_reserved(handle_t *handle)
+static void __jbd2_journal_unreserve_handle(handle_t *handle)
 {
 	journal_t *journal = handle->h_journal;
 
 	WARN_ON(!handle->h_reserved);
 	sub_reserved_credits(journal, handle->h_buffer_credits);
+}
+
+void jbd2_journal_free_reserved(handle_t *handle)
+{
+	__jbd2_journal_unreserve_handle(handle);
 	jbd2_free_handle(handle);
 }
 EXPORT_SYMBOL(jbd2_journal_free_reserved);
@@ -657,6 +662,28 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
 	return result;
 }
 
+static void stop_this_handle(handle_t *handle)
+{
+	transaction_t *transaction = handle->h_transaction;
+	journal_t *journal = transaction->t_journal;
+
+	J_ASSERT(journal_current_handle() == handle);
+	J_ASSERT(atomic_read(&transaction->t_updates) > 0);
+	current->journal_info = NULL;
+	atomic_sub(handle->h_buffer_credits,
+		   &transaction->t_outstanding_credits);
+	if (handle->h_rsv_handle)
+		__jbd2_journal_unreserve_handle(handle->h_rsv_handle);
+	if (atomic_dec_and_test(&transaction->t_updates))
+		wake_up(&journal->j_wait_updates);
+
+	rwsem_release(&journal->j_trans_commit_map, 1, _THIS_IP_);
+	/*
+	 * Scope of the GFP_NOFS context is over here and so we can restore the
+	 * original alloc context.
+	 */
+	memalloc_nofs_restore(handle->saved_alloc_context);
+}
 
 /**
  * int jbd2_journal_restart() - restart a handle .
@@ -679,52 +706,34 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal;
 	tid_t		tid;
-	int		need_to_start, ret;
+	int		need_to_start;
 
 	/* If we've had an abort of any type, don't even think about
 	 * actually doing the restart! */
 	if (is_handle_aborted(handle))
 		return 0;
 	journal = transaction->t_journal;
+	tid = transaction->t_tid;
 
 	/*
 	 * First unlink the handle from its current transaction, and start the
 	 * commit on that.
 	 */
-	J_ASSERT(atomic_read(&transaction->t_updates) > 0);
-	J_ASSERT(journal_current_handle() == handle);
-
-	read_lock(&journal->j_state_lock);
-	spin_lock(&transaction->t_handle_lock);
-	atomic_sub(handle->h_buffer_credits,
-		   &transaction->t_outstanding_credits);
-	if (handle->h_rsv_handle) {
-		sub_reserved_credits(journal,
-				     handle->h_rsv_handle->h_buffer_credits);
-	}
-	if (atomic_dec_and_test(&transaction->t_updates))
-		wake_up(&journal->j_wait_updates);
-	tid = transaction->t_tid;
-	spin_unlock(&transaction->t_handle_lock);
+	jbd_debug(2, "restarting handle %p\n", handle);
+	stop_this_handle(handle);
 	handle->h_transaction = NULL;
-	current->journal_info = NULL;
 
-	jbd_debug(2, "restarting handle %p\n", handle);
+	/*
+	 * TODO: If we use READ_ONCE / WRITE_ONCE for j_commit_request we can
+ 	 * get rid of pointless j_state_lock traffic like this.
+	 */
+	read_lock(&journal->j_state_lock);
 	need_to_start = !tid_geq(journal->j_commit_request, tid);
 	read_unlock(&journal->j_state_lock);
 	if (need_to_start)
 		jbd2_log_start_commit(journal, tid);
-
-	rwsem_release(&journal->j_trans_commit_map, 1, _THIS_IP_);
 	handle->h_buffer_credits = nblocks;
-	/*
-	 * Restore the original nofs context because the journal restart
-	 * is basically the same thing as journal stop and start.
-	 * start_this_handle will start a new nofs context.
-	 */
-	memalloc_nofs_restore(handle->saved_alloc_context);
-	ret = start_this_handle(journal, handle, gfp_mask);
-	return ret;
+	return start_this_handle(journal, handle, gfp_mask);
 }
 EXPORT_SYMBOL(jbd2__journal_restart);
 
@@ -1734,16 +1743,12 @@ int jbd2_journal_stop(handle_t *handle)
 		 * Handle is already detached from the transaction so there is
 		 * nothing to do other than free the handle.
 		 */
-		if (handle->h_rsv_handle)
-			jbd2_free_handle(handle->h_rsv_handle);
+		memalloc_nofs_restore(handle->saved_alloc_context);
 		goto free_and_exit;
 	}
 	journal = transaction->t_journal;
 	tid = transaction->t_tid;
 
-	J_ASSERT(journal_current_handle() == handle);
-	J_ASSERT(atomic_read(&transaction->t_updates) > 0);
-
 	if (is_handle_aborted(handle))
 		err = -EIO;
 
@@ -1813,9 +1818,6 @@ int jbd2_journal_stop(handle_t *handle)
 
 	if (handle->h_sync)
 		transaction->t_synchronous_commit = 1;
-	current->journal_info = NULL;
-	atomic_sub(handle->h_buffer_credits,
-		   &transaction->t_outstanding_credits);
 
 	/*
 	 * If the handle is marked SYNC, we need to set another commit
@@ -1845,27 +1847,19 @@ int jbd2_journal_stop(handle_t *handle)
 	}
 
 	/*
-	 * Once we drop t_updates, if it goes to zero the transaction
-	 * could start committing on us and eventually disappear.  So
-	 * once we do this, we must not dereference transaction
-	 * pointer again.
+	 * Once stop_this_handle() drops t_updates, the transaction could start
+	 * committing on us and eventually disappear.  So we must not
+	 * dereference transaction pointer again after calling
+	 * stop_this_handle().
 	 */
-	if (atomic_dec_and_test(&transaction->t_updates))
-		wake_up(&journal->j_wait_updates);
-
-	rwsem_release(&journal->j_trans_commit_map, 1, _THIS_IP_);
+	stop_this_handle(handle);
 
 	if (wait_for_commit)
 		err = jbd2_log_wait_commit(journal, tid);
 
-	if (handle->h_rsv_handle)
-		jbd2_journal_free_reserved(handle->h_rsv_handle);
 free_and_exit:
-	/*
-	 * Scope of the GFP_NOFS context is over here and so we can restore the
-	 * original alloc context.
-	 */
-	memalloc_nofs_restore(handle->saved_alloc_context);
+	if (handle->h_rsv_handle)
+		jbd2_free_handle(handle->h_rsv_handle);
 	jbd2_free_handle(handle);
 	return err;
 }
-- 
2.35.1



