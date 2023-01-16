Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB36C66C95C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbjAPQtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbjAPQsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:48:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6582D43459
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:35:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20A17B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810E3C433EF;
        Mon, 16 Jan 2023 16:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886939;
        bh=wHUaAU5fDxLnromnsNEk9BvFIIPsxifoRg80XRDHeI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIxqt5q2MMfXrCbXWzTC6T7rQWMwOqqt8s2phhamPGFBbGOHihbY5S9Us0Yv2fYIr
         pGEDrrc7ss4G7KDsrTuBEQhO/sayWyakZYu1qcYYKGGWzLDXATGU6LYXrqdk83ZbiW
         dsKeIitzQNmVr3bDZqPzKvp54H9YOU7MJm1U3YbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Theodore Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 620/658] jbd2: Reorganize jbd2_journal_stop()
Date:   Mon, 16 Jan 2023 16:51:48 +0100
Message-Id: <20230116154937.870524899@linuxfoundation.org>
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

[ Upstream commit dfaf5ffda227be3e867fee7c0f6a66749392fbd0 ]

Move code in jbd2_journal_stop() around a bit. It removes some
unnecessary code duplication and will make factoring out parts common
with jbd2__journal_restart() easier.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191105164437.32602-14-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d87a7b4c77a9 ("jbd2: use the correct print format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/transaction.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 09f4d00fece2..ce66dbbf0f90 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1722,41 +1722,34 @@ int jbd2_journal_stop(handle_t *handle)
 	tid_t tid;
 	pid_t pid;
 
+	if (--handle->h_ref > 0) {
+		jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
+						 handle->h_ref);
+		if (is_handle_aborted(handle))
+			return -EIO;
+		return 0;
+	}
 	if (!transaction) {
 		/*
-		 * Handle is already detached from the transaction so
-		 * there is nothing to do other than decrease a refcount,
-		 * or free the handle if refcount drops to zero
+		 * Handle is already detached from the transaction so there is
+		 * nothing to do other than free the handle.
 		 */
-		if (--handle->h_ref > 0) {
-			jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
-							 handle->h_ref);
-			return err;
-		} else {
-			if (handle->h_rsv_handle)
-				jbd2_free_handle(handle->h_rsv_handle);
-			goto free_and_exit;
-		}
+		if (handle->h_rsv_handle)
+			jbd2_free_handle(handle->h_rsv_handle);
+		goto free_and_exit;
 	}
 	journal = transaction->t_journal;
+	tid = transaction->t_tid;
 
 	J_ASSERT(journal_current_handle() == handle);
+	J_ASSERT(atomic_read(&transaction->t_updates) > 0);
 
 	if (is_handle_aborted(handle))
 		err = -EIO;
-	else
-		J_ASSERT(atomic_read(&transaction->t_updates) > 0);
-
-	if (--handle->h_ref > 0) {
-		jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
-			  handle->h_ref);
-		return err;
-	}
 
 	jbd_debug(4, "Handle %p going down\n", handle);
 	trace_jbd2_handle_stats(journal->j_fs_dev->bd_dev,
-				transaction->t_tid,
-				handle->h_type, handle->h_line_no,
+				tid, handle->h_type, handle->h_line_no,
 				jiffies - handle->h_start_jiffies,
 				handle->h_sync, handle->h_requested_credits,
 				(handle->h_requested_credits -
@@ -1841,7 +1834,7 @@ int jbd2_journal_stop(handle_t *handle)
 		jbd_debug(2, "transaction too old, requesting commit for "
 					"handle %p\n", handle);
 		/* This is non-blocking */
-		jbd2_log_start_commit(journal, transaction->t_tid);
+		jbd2_log_start_commit(journal, tid);
 
 		/*
 		 * Special case: JBD2_SYNC synchronous updates require us
@@ -1857,7 +1850,6 @@ int jbd2_journal_stop(handle_t *handle)
 	 * once we do this, we must not dereference transaction
 	 * pointer again.
 	 */
-	tid = transaction->t_tid;
 	if (atomic_dec_and_test(&transaction->t_updates)) {
 		wake_up(&journal->j_wait_updates);
 		if (journal->j_barrier_count)
-- 
2.35.1



