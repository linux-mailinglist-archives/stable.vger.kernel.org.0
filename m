Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFCE29B1E7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760675AbgJ0Ofv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760663AbgJ0Ofr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:35:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 105D122202;
        Tue, 27 Oct 2020 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809346;
        bh=GmjrIIIpHuM7SDFnusNHtLXhpaAs1F6AyxchG7BZlZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFpe+4YJqw5AHaMXXaZUh7GgQJgPRIjTIqLNJ/ueoPFOmN0hogl6Na8WXfOdWNi+N
         lkLdHz3rJEdxtDAK2VM04AVdGRzoJzmqhqM6CPhN4Nc3hMqTYjUS9LaBBij5BchChO
         CTNRUKA9+4Euzhlwh3z5rRfk9mE9uaLpIBo12Umc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jan Kara <jack@suse.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/408] quota: clear padding in v2r1_mem2diskdqb()
Date:   Tue, 27 Oct 2020 14:51:42 +0100
Message-Id: <20201027135502.708997639@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3d3dc274ce736227e3197868ff749cff2f175f63 ]

Freshly allocated memory contains garbage, better make sure
to init all struct v2r1_disk_dqblk fields to avoid KMSAN report:

BUG: KMSAN: uninit-value in qtree_entry_unused+0x137/0x1b0 fs/quota/quota_tree.c:218
CPU: 0 PID: 23373 Comm: syz-executor.1 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:122
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:219
 qtree_entry_unused+0x137/0x1b0 fs/quota/quota_tree.c:218
 v2r1_mem2diskdqb+0x43d/0x710 fs/quota/quota_v2.c:285
 qtree_write_dquot+0x226/0x870 fs/quota/quota_tree.c:394
 v2_write_dquot+0x1ad/0x280 fs/quota/quota_v2.c:333
 dquot_commit+0x4af/0x600 fs/quota/dquot.c:482
 ext4_write_dquot fs/ext4/super.c:5934 [inline]
 ext4_mark_dquot_dirty+0x4d8/0x6a0 fs/ext4/super.c:5985
 mark_dquot_dirty fs/quota/dquot.c:347 [inline]
 mark_all_dquot_dirty fs/quota/dquot.c:385 [inline]
 dquot_alloc_inode+0xc05/0x12b0 fs/quota/dquot.c:1755
 __ext4_new_inode+0x8204/0x9d70 fs/ext4/ialloc.c:1155
 ext4_tmpfile+0x41a/0x850 fs/ext4/namei.c:2686
 vfs_tmpfile+0x2a2/0x570 fs/namei.c:3283
 do_tmpfile fs/namei.c:3316 [inline]
 path_openat+0x4035/0x6a90 fs/namei.c:3359
 do_filp_open+0x2b8/0x710 fs/namei.c:3395
 do_sys_openat2+0xa88/0x1140 fs/open.c:1168
 do_sys_open fs/open.c:1184 [inline]
 __do_compat_sys_openat fs/open.c:1242 [inline]
 __se_compat_sys_openat+0x2a4/0x310 fs/open.c:1240
 __ia32_compat_sys_openat+0x56/0x70 fs/open.c:1240
 do_syscall_32_irqs_on arch/x86/entry/common.c:80 [inline]
 __do_fast_syscall_32+0x129/0x180 arch/x86/entry/common.c:139
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:162
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:205
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7ff4549
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f55cd0cc EFLAGS: 00000296 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000020000000
RDX: 0000000000410481 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:143 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:126
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2907 [inline]
 slab_alloc mm/slub.c:2916 [inline]
 __kmalloc+0x2bb/0x4b0 mm/slub.c:3982
 kmalloc include/linux/slab.h:559 [inline]
 getdqbuf+0x56/0x150 fs/quota/quota_tree.c:52
 qtree_write_dquot+0xf2/0x870 fs/quota/quota_tree.c:378
 v2_write_dquot+0x1ad/0x280 fs/quota/quota_v2.c:333
 dquot_commit+0x4af/0x600 fs/quota/dquot.c:482
 ext4_write_dquot fs/ext4/super.c:5934 [inline]
 ext4_mark_dquot_dirty+0x4d8/0x6a0 fs/ext4/super.c:5985
 mark_dquot_dirty fs/quota/dquot.c:347 [inline]
 mark_all_dquot_dirty fs/quota/dquot.c:385 [inline]
 dquot_alloc_inode+0xc05/0x12b0 fs/quota/dquot.c:1755
 __ext4_new_inode+0x8204/0x9d70 fs/ext4/ialloc.c:1155
 ext4_tmpfile+0x41a/0x850 fs/ext4/namei.c:2686
 vfs_tmpfile+0x2a2/0x570 fs/namei.c:3283
 do_tmpfile fs/namei.c:3316 [inline]
 path_openat+0x4035/0x6a90 fs/namei.c:3359
 do_filp_open+0x2b8/0x710 fs/namei.c:3395
 do_sys_openat2+0xa88/0x1140 fs/open.c:1168
 do_sys_open fs/open.c:1184 [inline]
 __do_compat_sys_openat fs/open.c:1242 [inline]
 __se_compat_sys_openat+0x2a4/0x310 fs/open.c:1240
 __ia32_compat_sys_openat+0x56/0x70 fs/open.c:1240
 do_syscall_32_irqs_on arch/x86/entry/common.c:80 [inline]
 __do_fast_syscall_32+0x129/0x180 arch/x86/entry/common.c:139
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:162
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:205
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Fixes: 498c60153ebb ("quota: Implement quota format with 64-bit space and inode limits")
Link: https://lore.kernel.org/r/20200924183619.4176790-1-edumazet@google.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jan Kara <jack@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/quota_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
index 53429c29c7842..276c27fb99280 100644
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -284,6 +284,7 @@ static void v2r1_mem2diskdqb(void *dp, struct dquot *dquot)
 	d->dqb_curspace = cpu_to_le64(m->dqb_curspace);
 	d->dqb_btime = cpu_to_le64(m->dqb_btime);
 	d->dqb_id = cpu_to_le32(from_kqid(&init_user_ns, dquot->dq_id));
+	d->dqb_pad = 0;
 	if (qtree_entry_unused(info, dp))
 		d->dqb_itime = cpu_to_le64(1);
 }
-- 
2.25.1



