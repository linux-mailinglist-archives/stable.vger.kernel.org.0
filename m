Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E55167456
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732219AbgBUIU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732212AbgBUIU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:20:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 433E024696;
        Fri, 21 Feb 2020 08:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273226;
        bh=u6S3yZCvhJ85JEu9QpP7tqvyuJ74zd9mfDlmQQv16MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogqJenz0UwWtYRjff1+O/Mz2MRuxKYTj3crz0GPP8fjh9BmQBmxB+FwNsP/pHSxjM
         ARJwu2jSNDYq1+wMQ7SJprGqtRIXxIDnxKrGU3fuMaY//svvO3XSinYaIpJotHIExz
         JfJFyVqWC2tOi6dmsAyW9/L9zA717M9Bu30GOIUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/191] ext4, jbd2: ensure panic when aborting with zero errno
Date:   Fri, 21 Feb 2020 08:40:17 +0100
Message-Id: <20200221072257.117975168@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

[ Upstream commit 51f57b01e4a3c7d7bdceffd84de35144e8c538e7 ]

JBD2_REC_ERR flag used to indicate the errno has been updated when jbd2
aborted, and then __ext4_abort() and ext4_handle_error() can invoke
panic if ERRORS_PANIC is specified. But if the journal has been aborted
with zero errno, jbd2_journal_abort() didn't set this flag so we can
no longer panic. Fix this by always record the proper errno in the
journal superblock.

Fixes: 4327ba52afd03 ("ext4, jbd2: ensure entering into panic after recording an error in superblock")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191204124614.45424-3-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/checkpoint.c |  2 +-
 fs/jbd2/journal.c    | 15 ++++-----------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 26f8d7e46462e..66409cbd3ed54 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -165,7 +165,7 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 				       "journal space in %s\n", __func__,
 				       journal->j_devname);
 				WARN_ON(1);
-				jbd2_journal_abort(journal, 0);
+				jbd2_journal_abort(journal, -EIO);
 			}
 			write_lock(&journal->j_state_lock);
 		} else {
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 568ca0ca0127c..1a96287f92647 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2142,12 +2142,10 @@ static void __journal_abort_soft (journal_t *journal, int errno)
 
 	__jbd2_journal_abort_hard(journal);
 
-	if (errno) {
-		jbd2_journal_update_sb_errno(journal);
-		write_lock(&journal->j_state_lock);
-		journal->j_flags |= JBD2_REC_ERR;
-		write_unlock(&journal->j_state_lock);
-	}
+	jbd2_journal_update_sb_errno(journal);
+	write_lock(&journal->j_state_lock);
+	journal->j_flags |= JBD2_REC_ERR;
+	write_unlock(&journal->j_state_lock);
 }
 
 /**
@@ -2189,11 +2187,6 @@ static void __journal_abort_soft (journal_t *journal, int errno)
  * failure to disk.  ext3_error, for example, now uses this
  * functionality.
  *
- * Errors which originate from within the journaling layer will NOT
- * supply an errno; a null errno implies that absolutely no further
- * writes are done to the journal (unless there are any already in
- * progress).
- *
  */
 
 void jbd2_journal_abort(journal_t *journal, int errno)
-- 
2.20.1



