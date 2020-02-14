Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E99315E7DC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394076AbgBNQ42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:56:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392476AbgBNQR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273B2246F8;
        Fri, 14 Feb 2020 16:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697078;
        bh=y20f20EyVym5ZJBttPilPcZuoK1w1Z50nYChb4w15uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxQ8ZI5Dk5PtcIMOdTdg9EjTJnd9WIr5VqhUg9cQvgEeLx4w2/HO3FpZoSMNI7Hni
         SSYpsU/xVYEUafOqFwf1CAe70ZnEp56UD6b3hu1nZFyYwmmT/YbaLUk7i9QYJhSPvn
         uVQgy8E1YK7IsCJWaakJenFbC29riLDAKjSYk07k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Li <li.kai4@h3c.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 033/186] jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal
Date:   Fri, 14 Feb 2020 11:14:42 -0500
Message-Id: <20200214161715.18113-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Li <li.kai4@h3c.com>

[ Upstream commit a09decff5c32060639a685581c380f51b14e1fc2 ]

If the journal is dirty when the filesystem is mounted, jbd2 will replay
the journal but the journal superblock will not be updated by
journal_reset() because JBD2_ABORT flag is still set (it was set in
journal_init_common()). This is problematic because when a new transaction
is then committed, it will be recorded in block 1 (journal->j_tail was set
to 1 in journal_reset()). If unclean shutdown happens again before the
journal superblock is updated, the new recorded transaction will not be
replayed during the next mount (because of stale sb->s_start and
sb->s_sequence values) which can lead to filesystem corruption.

Fixes: 85e0c4e89c1b ("jbd2: if the journal is aborted then don't allow update of the log tail")
Signed-off-by: Kai Li <li.kai4@h3c.com>
Link: https://lore.kernel.org/r/20200111022542.5008-1-li.kai4@h3c.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index d3cce5c86fd90..b72be822f04f2 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1687,6 +1687,11 @@ int jbd2_journal_load(journal_t *journal)
 		       journal->j_devname);
 		return -EFSCORRUPTED;
 	}
+	/*
+	 * clear JBD2_ABORT flag initialized in journal_init_common
+	 * here to update log tail information with the newest seq.
+	 */
+	journal->j_flags &= ~JBD2_ABORT;
 
 	/* OK, we've finished with the dynamic journal bits:
 	 * reinitialise the dynamic contents of the superblock in memory
@@ -1694,7 +1699,6 @@ int jbd2_journal_load(journal_t *journal)
 	if (journal_reset(journal))
 		goto recovery_error;
 
-	journal->j_flags &= ~JBD2_ABORT;
 	journal->j_flags |= JBD2_LOADED;
 	return 0;
 
-- 
2.20.1

