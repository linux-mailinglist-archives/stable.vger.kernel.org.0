Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90FD32AF4A
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbhCCAQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350239AbhCBMOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:14:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 545AE64F6F;
        Tue,  2 Mar 2021 11:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686249;
        bh=bYXnqGtlBBbQ/TrgNTMF+Uq7rUVoZAJStA34vrdzmxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AU8iYW81rsfwzFtFvWr3XARWGi+xMhCGyijlH7z2GooiTIoT3spX+jIHtAD0KnMHu
         5Rf2Dn3vu7td4QBbn7QsSxD4Keqb85eU09tPWCEflOKkBPH5vNxEeDfwFHadKVR5mg
         bC9djjlbHgR9MMIrJmeiJ2NAy+xAC5Ih1EWvxctbxt92zYUSQ8hgznc2QSdJiyXxg5
         4TnV+6CCQceGYSMkZrSFKDh4fyez26E/VvD9ipuzsTzSTXH+NlNDghkZfANVak0eGO
         tYVNQzHEFGKaf3SJtE2ZlZjidxfJ6aEwxgVlCnJbz517WLoUnQeGXfmUddRPz1Ynnc
         m+wRVnoj2nbvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Murphy Zhou <jencce.kernel@gmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 34/47] ext4: don't try to processed freed blocks until mballoc is initialized
Date:   Tue,  2 Mar 2021 06:56:33 -0500
Message-Id: <20210302115646.62291-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 027f14f5357279655c3ebc6d14daff8368d4f53f ]

If we try to make any changes via the journal between when the journal
is initialized, but before the multi-block allocated is initialized,
we will end up deferencing a NULL pointer when the journal commit
callback function calls ext4_process_freed_data().

The proximate cause of this failure was commit 2d01ddc86606 ("ext4:
save error info to sb through journal if available") since file system
corruption problems detected before the call to ext4_mb_init() would
result in a journal commit before we aborted the mount of the file
system.... and we would then trigger the NULL pointer deref.

Link: https://lore.kernel.org/r/YAm8qH/0oo2ofSMR@mit.edu
Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea5aefa23a20..e30bf8f342c2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4876,7 +4876,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
-	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
 	sbi->s_journal->j_submit_inode_data_buffers =
 		ext4_journal_submit_inode_data_buffers;
 	sbi->s_journal->j_finish_inode_data_buffers =
@@ -4993,6 +4992,14 @@ no_journal:
 		goto failed_mount5;
 	}
 
+	/*
+	 * We can only set up the journal commit callback once
+	 * mballoc is initialized
+	 */
+	if (sbi->s_journal)
+		sbi->s_journal->j_commit_callback =
+			ext4_journal_commit_callback;
+
 	block = ext4_count_free_clusters(sb);
 	ext4_free_blocks_count_set(sbi->s_es, 
 				   EXT4_C2B(sbi, block));
-- 
2.30.1

