Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE0DBCE9F
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410024AbfIXQpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410020AbfIXQpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:45:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8215321906;
        Tue, 24 Sep 2019 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343543;
        bh=es2vIaM7f5xW4Dh/JCsV+tGaGa4oEA9m7N0liZ52Yc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osj07c0IXhuLTG04IobP44rH9U4B/NQgdNQ2utQT1GyBYX76NbjTUgUfMmcq2ReZl
         1lJY96dOpJ4aO88uzAVp6k9GgG6D0yk+C8//NzO5quf0enAzewJQQDa8Cx9TTRgumN
         r4eHEAsX25ElzUrrQyCkf5T9IkEQ/TuOtTSkxmD8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.3 86/87] f2fs: fix to drop meta/node pages during umount
Date:   Tue, 24 Sep 2019 12:41:42 -0400
Message-Id: <20190924164144.25591-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit a8933b6b68f775b5774e7b075447fae13f4d01fe ]

As reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=204193

A null pointer dereference bug is triggered in f2fs under kernel-5.1.3.

 kasan_report.cold+0x5/0x32
 f2fs_write_end_io+0x215/0x650
 bio_endio+0x26e/0x320
 blk_update_request+0x209/0x5d0
 blk_mq_end_request+0x2e/0x230
 lo_complete_rq+0x12c/0x190
 blk_done_softirq+0x14a/0x1a0
 __do_softirq+0x119/0x3e5
 irq_exit+0x94/0xe0
 call_function_single_interrupt+0xf/0x20

During umount, we will access NULL sbi->node_inode pointer in
f2fs_write_end_io():

	f2fs_bug_on(sbi, page->mapping == NODE_MAPPING(sbi) &&
				page->index != nid_of_node(page));

The reason is if disable_checkpoint mount option is on, meta dirty
pages can remain during umount, and then be flushed by iput() of
meta_inode, however node_inode has been iput()ed before
meta_inode's iput().

Since checkpoint is disabled, all meta/node datas are useless and
should be dropped in next mount, so in umount, let's adjust
drop_inode() to give a hint to iput_final() to drop all those dirty
datas correctly.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 78a1b873e48ad..aa3178f1b145d 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -873,7 +873,21 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 
 static int f2fs_drop_inode(struct inode *inode)
 {
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int ret;
+
+	/*
+	 * during filesystem shutdown, if checkpoint is disabled,
+	 * drop useless meta/node dirty pages.
+	 */
+	if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED))) {
+		if (inode->i_ino == F2FS_NODE_INO(sbi) ||
+			inode->i_ino == F2FS_META_INO(sbi)) {
+			trace_f2fs_drop_inode(inode, 1);
+			return 1;
+		}
+	}
+
 	/*
 	 * This is to avoid a deadlock condition like below.
 	 * writeback_single_inode(inode)
-- 
2.20.1

