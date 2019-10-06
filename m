Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4BECD702
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfJFRib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730630AbfJFRib (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:38:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 543BE2080F;
        Sun,  6 Oct 2019 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383510;
        bh=VQvzdB4+euS16B1nRt9g7D9Y0DJawliTTWFFI4GaiJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nc5gYqH0oNZSiuhUTdzvLO4m+EZ74K2nhoGZ3L6oGIv/NDrLd9wA6DVWCuRpmWimE
         eRR+E73XVLXHbgKtlV/zVG2AI4Wn01ZZj2NIPIyVhsv4V0WvTdCU/t9BkebTtM7thZ
         XTh/aXJoN7JFaqBm7Xu89Z+dewofYX3a5gNHEH4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 088/137] f2fs: fix to drop meta/node pages during umount
Date:   Sun,  6 Oct 2019 19:21:12 +0200
Message-Id: <20191006171216.158393309@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 973f1e8187706..01038aff5d8e0 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -894,7 +894,21 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 
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



