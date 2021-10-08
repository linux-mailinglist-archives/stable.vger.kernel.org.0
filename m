Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA2D4268D6
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbhJHLbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240522AbhJHLbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:31:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C172661039;
        Fri,  8 Oct 2021 11:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692543;
        bh=27whueOksSIGYwWBQXzhOYss4ziLaN09BDh/OORgVbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3jr3SvzrHXRe9FvLFrZ0GL/JbVOvIoNJJdgPtQHUNuv42N7qPpIwvqjDBNn9iLuk
         +kCy4R0ypPMz6159GOo2drVT6XTT1Rgs1DTHuzB8zMZ+aZ3g4ufd7ugFzKct3EQK4F
         AdGz17PNVsQ688veWjVj73n4UopEzPb4HuCFCtak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 5/8] ext2: fix sleeping in atomic bugs on error
Date:   Fri,  8 Oct 2021 13:27:42 +0200
Message-Id: <20211008112714.126049100@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112713.941269121@linuxfoundation.org>
References: <20211008112713.941269121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4c40c0786e16..bd32140bdfee 100644
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



