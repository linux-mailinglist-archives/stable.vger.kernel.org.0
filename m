Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530B862405
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390804AbfGHPjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732065AbfGHP3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:29:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 334D4204EC;
        Mon,  8 Jul 2019 15:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599757;
        bh=GggVCx1Hlzk+MVuJdPjICVgcV5W9PyPoL0nOFalkwYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzEKKnz1ndbgMD8QtdqkWxXYXvbLY4as5M8wtHDQkRnUgBFvsqBPOEF2XdBqX/xRd
         rRIB0D+8EGmzFt/jviy/6j19yM6Zinj5hEdqo5IlvZrvtTUd3niyc/w2zTdFteuwur
         T+Zau/XNOYv/zH6aTAImL4sIWUG+7MwdvoHikpEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 68/90] f2fs: dont access node/meta inode mapping after iput
Date:   Mon,  8 Jul 2019 17:13:35 +0200
Message-Id: <20190708150525.790996587@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7c77bf7de1574ac7a31a2b76f4927404307d13e7 ]

This fixes wrong access of address spaces of node and meta inodes after iput.

Fixes: 60aa4d5536ab ("f2fs: fix use-after-free issue when accessing sbi->stat_info")
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/debug.c | 19 ++++++++++++-------
 fs/f2fs/super.c |  5 +++++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index ebe649d9793c..bbe155465ca0 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -94,8 +94,10 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 	si->free_secs = free_sections(sbi);
 	si->prefree_count = prefree_segments(sbi);
 	si->dirty_count = dirty_segments(sbi);
-	si->node_pages = NODE_MAPPING(sbi)->nrpages;
-	si->meta_pages = META_MAPPING(sbi)->nrpages;
+	if (sbi->node_inode)
+		si->node_pages = NODE_MAPPING(sbi)->nrpages;
+	if (sbi->meta_inode)
+		si->meta_pages = META_MAPPING(sbi)->nrpages;
 	si->nats = NM_I(sbi)->nat_cnt;
 	si->dirty_nats = NM_I(sbi)->dirty_nat_cnt;
 	si->sits = MAIN_SEGS(sbi);
@@ -168,7 +170,6 @@ static void update_sit_info(struct f2fs_sb_info *sbi)
 static void update_mem_info(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_stat_info *si = F2FS_STAT(sbi);
-	unsigned npages;
 	int i;
 
 	if (si->base_mem)
@@ -251,10 +252,14 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 						sizeof(struct extent_node);
 
 	si->page_mem = 0;
-	npages = NODE_MAPPING(sbi)->nrpages;
-	si->page_mem += (unsigned long long)npages << PAGE_SHIFT;
-	npages = META_MAPPING(sbi)->nrpages;
-	si->page_mem += (unsigned long long)npages << PAGE_SHIFT;
+	if (sbi->node_inode) {
+		unsigned npages = NODE_MAPPING(sbi)->nrpages;
+		si->page_mem += (unsigned long long)npages << PAGE_SHIFT;
+	}
+	if (sbi->meta_inode) {
+		unsigned npages = META_MAPPING(sbi)->nrpages;
+		si->page_mem += (unsigned long long)npages << PAGE_SHIFT;
+	}
 }
 
 static int stat_show(struct seq_file *s, void *v)
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 2264f27fd26d..1871031e2d5e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1050,7 +1050,10 @@ static void f2fs_put_super(struct super_block *sb)
 	f2fs_bug_on(sbi, sbi->fsync_node_num);
 
 	iput(sbi->node_inode);
+	sbi->node_inode = NULL;
+
 	iput(sbi->meta_inode);
+	sbi->meta_inode = NULL;
 
 	/*
 	 * iput() can update stat information, if f2fs_write_checkpoint()
@@ -3166,6 +3169,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	f2fs_release_ino_entry(sbi, true);
 	truncate_inode_pages_final(NODE_MAPPING(sbi));
 	iput(sbi->node_inode);
+	sbi->node_inode = NULL;
 free_stats:
 	f2fs_destroy_stats(sbi);
 free_nm:
@@ -3178,6 +3182,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 free_meta_inode:
 	make_bad_inode(sbi->meta_inode);
 	iput(sbi->meta_inode);
+	sbi->meta_inode = NULL;
 free_io_dummy:
 	mempool_destroy(sbi->write_io_dummy);
 free_percpu:
-- 
2.20.1



