Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C86415E456
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393566AbgBNQf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:35:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405969AbgBNQYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:24:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDC4E2479B;
        Fri, 14 Feb 2020 16:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697485;
        bh=FicK43LbrSAH49U3UV7o1NsyGHzAUMpaTjKHDcjzups=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKhmFbVqgDPUg3P/vhEgrVY6CXZh2Gx8MMIxBbAZExKh74XpYYtw+8WHL5I1Bd6gU
         OdybwebqNaYLJ1EwaDNTL9leawsvXg+QoqMcRW6dWQn3cGpQiTv9+Nt1R6Dn6oIkFJ
         Ybys8+9JDXP8rYE3JtKVb/cu8ksHXlD+Sgw57mXk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 016/100] ext4, jbd2: ensure panic when aborting with zero errno
Date:   Fri, 14 Feb 2020 11:23:00 -0500
Message-Id: <20200214162425.21071-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "zhangyi (F)" <yi.zhang@huawei.com>

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
index 4d5a5a4cc017c..addb0784dd1c4 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -168,7 +168,7 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 				       "journal space in %s\n", __func__,
 				       journal->j_devname);
 				WARN_ON(1);
-				jbd2_journal_abort(journal, 0);
+				jbd2_journal_abort(journal, -EIO);
 			}
 			write_lock(&journal->j_state_lock);
 		} else {
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index deb3300299709..d62435897d0d0 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2086,12 +2086,10 @@ static void __journal_abort_soft (journal_t *journal, int errno)
 
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
@@ -2133,11 +2131,6 @@ static void __journal_abort_soft (journal_t *journal, int errno)
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

