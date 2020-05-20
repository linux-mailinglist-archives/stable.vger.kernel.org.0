Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AB01DB50E
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 15:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgETNbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 09:31:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:42314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgETNbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 09:31:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6EDE0B196;
        Wed, 20 May 2020 13:31:25 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3289F1E1272; Wed, 20 May 2020 15:31:22 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] jbd2: Avoid leaking transaction credits when unreserving handle
Date:   Wed, 20 May 2020 15:31:19 +0200
Message-Id: <20200520133119.1383-3-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200520133119.1383-1-jack@suse.cz>
References: <20200520133119.1383-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When reserved transaction handle is unused, we subtract its reserved
credits in __jbd2_journal_unreserve_handle() called from
jbd2_journal_stop(). However this function forgets to remove reserved
credits from transaction->t_outstanding_credits and thus the transaction
space that was reserved remains effectively leaked. The leaked
transaction space can be quite significant in some cases and leads to
unnecessarily small transactions and thus reducing throughput of the
journalling machinery. E.g. fsmark workload creating lots of 4k files
was observed to have about 20% lower throughput due to this when ext4 is
mounted with dioread_nolock mount option.

Subtract reserved credits from t_outstanding_credits as well.

CC: stable@vger.kernel.org
Fixes: 8f7d89f36829 ("jbd2: transaction reservation support")
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 3dccc23cf010..e91aad3637a2 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -541,17 +541,24 @@ handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
 }
 EXPORT_SYMBOL(jbd2_journal_start);
 
-static void __jbd2_journal_unreserve_handle(handle_t *handle)
+static void __jbd2_journal_unreserve_handle(handle_t *handle, transaction_t *t)
 {
 	journal_t *journal = handle->h_journal;
 
 	WARN_ON(!handle->h_reserved);
 	sub_reserved_credits(journal, handle->h_total_credits);
+	if (t)
+		atomic_sub(handle->h_total_credits, &t->t_outstanding_credits);
 }
 
 void jbd2_journal_free_reserved(handle_t *handle)
 {
-	__jbd2_journal_unreserve_handle(handle);
+	journal_t *journal = handle->h_journal;
+
+	/* Get j_state_lock to pin running transaction if it exists */
+	read_lock(&journal->j_state_lock);
+	__jbd2_journal_unreserve_handle(handle, journal->j_running_transaction);
+	read_unlock(&journal->j_state_lock);
 	jbd2_free_handle(handle);
 }
 EXPORT_SYMBOL(jbd2_journal_free_reserved);
@@ -722,7 +729,8 @@ static void stop_this_handle(handle_t *handle)
 	atomic_sub(handle->h_total_credits,
 		   &transaction->t_outstanding_credits);
 	if (handle->h_rsv_handle)
-		__jbd2_journal_unreserve_handle(handle->h_rsv_handle);
+		__jbd2_journal_unreserve_handle(handle->h_rsv_handle,
+						transaction);
 	if (atomic_dec_and_test(&transaction->t_updates))
 		wake_up(&journal->j_wait_updates);
 
-- 
2.16.4

