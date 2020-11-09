Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0B72ABD8B
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbgKINqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729989AbgKIM5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:57:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B83DC20867;
        Mon,  9 Nov 2020 12:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926643;
        bh=BaKm0cq3+6cIzUhdgiMl7dDyelZN4ru3ztbPfpT531w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nabaBzuLMNI/ITC9EvuiGzCOJcPzeZrcWGPntGOFOBTsVJXdIyRBGc7iRS9VgOPxl
         RcH9ifsz019PbapgCh7m3Je8Qt/jvb2Cpm0rNXu6tqRl6zqK4JGmmwgogcGbVkI/8C
         SO6cu8IJd+YGhy0NtNbA2lmerwHLx+TToJyC/1gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3698081bcf0bb2d12174@syzkaller.appspotmail.com,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/86] f2fs: fix to check segment boundary during SIT page readahead
Date:   Mon,  9 Nov 2020 13:54:20 +0100
Message-Id: <20201109125021.495536002@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 6a257471fa42c8c9c04a875cd3a2a22db148e0f0 ]

As syzbot reported:

kernel BUG at fs/f2fs/segment.h:657!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 16220 Comm: syz-executor.0 Not tainted 5.9.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:f2fs_ra_meta_pages+0xa51/0xdc0 fs/f2fs/segment.h:657
Call Trace:
 build_sit_entries fs/f2fs/segment.c:4195 [inline]
 f2fs_build_segment_manager+0x4b8a/0xa3c0 fs/f2fs/segment.c:4779
 f2fs_fill_super+0x377d/0x6b80 fs/f2fs/super.c:3633
 mount_bdev+0x32e/0x3f0 fs/super.c:1417
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2875 [inline]
 path_mount+0x1387/0x2070 fs/namespace.c:3192
 do_mount fs/namespace.c:3205 [inline]
 __do_sys_mount fs/namespace.c:3413 [inline]
 __se_sys_mount fs/namespace.c:3390 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3390
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

@blkno in f2fs_ra_meta_pages could exceed max segment count, causing panic
in following sanity check in current_sit_addr(), add check condition to
avoid this issue.

Reported-by: syzbot+3698081bcf0bb2d12174@syzkaller.appspotmail.com
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 4b2f609f376d3..047da0f105278 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -188,6 +188,8 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages,
 					blkno * NAT_ENTRY_PER_BLOCK);
 			break;
 		case META_SIT:
+			if (unlikely(blkno >= TOTAL_SEGS(sbi)))
+				goto out;
 			/* get sit block addr */
 			fio.blk_addr = current_sit_addr(sbi,
 					blkno * SIT_ENTRY_PER_BLOCK);
-- 
2.27.0



