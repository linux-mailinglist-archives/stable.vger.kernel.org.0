Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE8441A863
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbhI1GE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238929AbhI1GCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F6D7613CF;
        Tue, 28 Sep 2021 05:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808664;
        bh=DiC/iphoatt/a+XEjILF60jpiyxJAzAikHTj84ook+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8WM0iq3q4DIhDQrKVu26tuCBP32hx3wjaAaR9544LbZpX0gSYqQntLnPS7cXAFNq
         oqwuwKUpwPMRLUoyZpxnO+lHEvU7PWb8mlyMXXEdr4S7tEMYE5nQ5ukXj87ZRUq53V
         CStMuWy04LrBuO2nZNr6QPbdl6CjMLOgQLXCtvGHrgqAaivjgu9MmWYCQtiduRng+O
         t5uoePRAyowW9ghcdgtCodaGmZRqdsK3jNsK1SXp90/omLwUH4dGJO0NjTSVVcPtz4
         nMXbQ8whFw9gm+x2H9CaoUARc8wA9FM4QqVfUZwUvRjVsGfyU5+DYZvJPAeKt7+eG8
         8hnmJA00SI96g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>, jack@suse.com,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/5] ext2: fix sleeping in atomic bugs on error
Date:   Tue, 28 Sep 2021 01:57:39 -0400
Message-Id: <20210928055741.173265-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055741.173265-1-sashal@kernel.org>
References: <20210928055741.173265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 372d1f3e1bfede719864d0d1fbf3146b1e638c88 ]

The ext2_error() function syncs the filesystem so it sleeps.  The caller
is holding a spinlock so it's not allowed to sleep.

   ext2_statfs() <- disables preempt
   -> ext2_count_free_blocks()
      -> ext2_get_group_desc()

Fix this by using WARN() to print an error message and a stack trace
instead of using ext2_error().

Link: https://lore.kernel.org/r/20210921203233.GA16529@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/balloc.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 9f9992b37924..2e4747e0aaf0 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -46,10 +46,9 @@ struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
 	if (block_group >= sbi->s_groups_count) {
-		ext2_error (sb, "ext2_get_group_desc",
-			    "block_group >= groups_count - "
-			    "block_group = %d, groups_count = %lu",
-			    block_group, sbi->s_groups_count);
+		WARN(1, "block_group >= groups_count - "
+		     "block_group = %d, groups_count = %lu",
+		     block_group, sbi->s_groups_count);
 
 		return NULL;
 	}
@@ -57,10 +56,9 @@ struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 	group_desc = block_group >> EXT2_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT2_DESC_PER_BLOCK(sb) - 1);
 	if (!sbi->s_group_desc[group_desc]) {
-		ext2_error (sb, "ext2_get_group_desc",
-			    "Group descriptor not loaded - "
-			    "block_group = %d, group_desc = %lu, desc = %lu",
-			     block_group, group_desc, offset);
+		WARN(1, "Group descriptor not loaded - "
+		     "block_group = %d, group_desc = %lu, desc = %lu",
+		      block_group, group_desc, offset);
 		return NULL;
 	}
 
-- 
2.33.0

