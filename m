Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C2F32AF24
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbhCCAPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383761AbhCBME1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:04:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 813D764F3C;
        Tue,  2 Mar 2021 11:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686184;
        bh=QX92ayI+w7Oykb+H1OW64lrgEm8oAdPLoxkZQitIYGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JsmLGkTWvIjPHv6C2YThl18Ge2q/+QxbylOx5mXlTDiYNqOGE6pdPr+vfvQ89Cnai
         MFs+wdEVlU1FaaJD1ct3YQbRvrwqKcrfArVFMGQxGCo23eulIESzNeMunODDHgzDvg
         8tTZz9JQTBUOfwRsHNc0wEIQAwLAC03sP7RebbpDV29haJr/rMQPPJ9zQJSpvMEIa4
         skZM/hETElfBK3bEqdPttZLMQdI2GgIUT9HM7DpAyOYTnxgF8t4fsWd8/gaLwQi8qM
         +xjSixgxp+SuiI3aJ45aT0FMgrvSClx7eDrpVY1/yB6nDDlvs5Kf2qVwSxaBGPEOvt
         c884kiFgLvVHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Murphy Zhou <jencce.kernel@gmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 38/52] ext4: don't try to processed freed blocks until mballoc is initialized
Date:   Tue,  2 Mar 2021 06:55:19 -0500
Message-Id: <20210302115534.61800-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
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
index 9a6f9875aa34..2ae0af1c88c7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4875,7 +4875,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
-	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
 	sbi->s_journal->j_submit_inode_data_buffers =
 		ext4_journal_submit_inode_data_buffers;
 	sbi->s_journal->j_finish_inode_data_buffers =
@@ -4987,6 +4986,14 @@ no_journal:
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

