Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7CC2010F3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393767AbgFSPbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391325AbgFSPbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 641CC206B7;
        Fri, 19 Jun 2020 15:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580658;
        bh=bHkNN74cdzXa9vVkD8gRknfG06ao0SH0hSvjcOVtP5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOgBuiXvtJMznWM9ab+A2Ebbsx302bgOuHggIE/+QV8TpBUhqPT3ZRy2R1PmzRLre
         rAgVYlJSgjeSD7Vq4C/t7zuOZtfds30ksenWJUybXSqQvTdljpsqaiQWcZQleX8F0r
         1q5iypnttrfbuLmdJZ9W/LhQEzGbXFAYjkwR4J6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.7 333/376] jbd2: avoid leaking transaction credits when unreserving handle
Date:   Fri, 19 Jun 2020 16:34:11 +0200
Message-Id: <20200619141726.093088973@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 14ff6286309e2853aed50083c9a83328423fdd8c upstream.

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
Link: https://lore.kernel.org/r/20200520133119.1383-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/transaction.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -541,17 +541,24 @@ handle_t *jbd2_journal_start(journal_t *
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
@@ -722,7 +729,8 @@ static void stop_this_handle(handle_t *h
 	atomic_sub(handle->h_total_credits,
 		   &transaction->t_outstanding_credits);
 	if (handle->h_rsv_handle)
-		__jbd2_journal_unreserve_handle(handle->h_rsv_handle);
+		__jbd2_journal_unreserve_handle(handle->h_rsv_handle,
+						transaction);
 	if (atomic_dec_and_test(&transaction->t_updates))
 		wake_up(&journal->j_wait_updates);
 


