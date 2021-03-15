Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A6133B937
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhCOOFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233158AbhCOOAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46DB564F12;
        Mon, 15 Mar 2021 14:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816831;
        bh=b13n/JM383bPTPMveV85jOVeUCq/BvkKO7g6EFlCcMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyGcinZsLFGmU46escI3n2Q1zds/KZcqa+jBfui2cQDNeJTbLfx5rFRdZzKU6HQQS
         Diwh+XjilxdmYeIr4sDM3YfQXW71eS/o0xXvUL3Z2soi8De8BI8I5lLuAL8maVw35R
         z8ePe3aefaPN+Wk90nZz1bO8M0h2pt8OkEGQtx38=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 151/306] ext4: dont try to processed freed blocks until mballoc is initialized
Date:   Mon, 15 Mar 2021 14:53:34 +0100
Message-Id: <20210315135512.744888708@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -4987,6 +4986,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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



