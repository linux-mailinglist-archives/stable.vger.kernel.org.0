Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 473131672B1
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731716AbgBUIFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731883AbgBUIFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:05:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B080120801;
        Fri, 21 Feb 2020 08:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272352;
        bh=HPTBNIgufBhtrErdc5gIbRW4g4btuC/j0cH6+rg11NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDP8bYufzl+bkoak0WDkhp/jFaUgbzE8EvqNj2Emxg+k0BXM6cSFcr5ckUE0pgDX3
         BdXFECrrSjEm69kU5tv/qYltAoZYTmFB5a88DcbdANDVBYEK0wRyVo0dWzZ9SUX68H
         V4lLHMpBZ7soHxHl1bF0DRbkagT9/YyS63Vzj6Vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Li <li.kai4@h3c.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/344] jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal
Date:   Fri, 21 Feb 2020 08:37:43 +0100
Message-Id: <20200221072354.832846800@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ef485f892d1b0..389c9be4e7919 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1682,6 +1682,11 @@ int jbd2_journal_load(journal_t *journal)
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
@@ -1689,7 +1694,6 @@ int jbd2_journal_load(journal_t *journal)
 	if (journal_reset(journal))
 		goto recovery_error;
 
-	journal->j_flags &= ~JBD2_ABORT;
 	journal->j_flags |= JBD2_LOADED;
 	return 0;
 
-- 
2.20.1



