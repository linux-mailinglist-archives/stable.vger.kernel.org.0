Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569EF12DC46
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 00:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLaXMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 18:12:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfLaXMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Dec 2019 18:12:13 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C75DB206E6;
        Tue, 31 Dec 2019 23:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577833932;
        bh=ReC4x1Vx8Cza8Q4fzJOULr5bhukfy8HMhYdP5X/QZ+0=;
        h=Date:From:To:Subject:From;
        b=iMc6D/+NnJqb4ko2z8DfCSjRa6QCbd3CSeGR8Ax2jIfIPz7Nmsgvwmc2IoiacEvfC
         YLOwVj/ks/ecvSZG5a7a7JHoU4XryHVarwBJ74WEzHAhXVGhN5uzZAlprqRBpKaCGz
         vk0m6Dp6ewB5E9mJ7aPjI8ySTUaItq2/I5KVrY2Y=
Date:   Tue, 31 Dec 2019 15:12:11 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org
Subject:  +
 ocfs2-fix-the-crash-due-to-call-ocfs2_get_dlm_debug-once-less.patch added
 to -mm tree
Message-ID: <20191231231211.YyO60FfaH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix the crash due to call ocfs2_get_dlm_debug once less
has been added to the -mm tree.  Its filename is
     ocfs2-fix-the-crash-due-to-call-ocfs2_get_dlm_debug-once-less.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-the-crash-due-to-call-ocfs2_get_dlm_debug-once-less.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-the-crash-due-to-call-ocfs2_get_dlm_debug-once-less.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <GHe@suse.com>
Subject: ocfs2: fix the crash due to call ocfs2_get_dlm_debug once less

Because ocfs2_get_dlm_debug() function is called once less here, ocfs2
file system will trigger the system crash, usually after ocfs2 file system
is unmounted.

This system crash is caused by a generic memory corruption, these crash
backtraces are not always the same, for exapmle,

[ 4106.597432] ocfs2: Unmounting device (253,16) on (node 172167785)
[ 4116.230719] general protection fault: 0000 [#1] SMP PTI
[ 4116.230731] CPU: 3 PID: 14107 Comm: fence_legacy Kdump:
[ 4116.230737] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
[ 4116.230772] RIP: 0010:__kmalloc+0xa5/0x2a0
[ 4116.230778] Code: 00 00 4d 8b 07 65 4d 8b
[ 4116.230785] RSP: 0018:ffffaa1fc094bbe8 EFLAGS: 00010286
[ 4116.230790] RAX: 0000000000000000 RBX: d310a8800d7a3faf RCX: 0000000000000000
[ 4116.230794] RDX: 0000000000000000 RSI: 0000000000000dc0 RDI: ffff96e68fc036c0
[ 4116.230798] RBP: d310a8800d7a3faf R08: ffff96e6ffdb10a0 R09: 00000000752e7079
[ 4116.230802] R10: 000000000001c513 R11: 0000000004091041 R12: 0000000000000dc0
[ 4116.230806] R13: 0000000000000039 R14: ffff96e68fc036c0 R15: ffff96e68fc036c0
[ 4116.230811] FS:  00007f699dfba540(0000) GS:ffff96e6ffd80000(0000) knlGS:00000
[ 4116.230815] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4116.230819] CR2: 000055f3a9d9b768 CR3: 000000002cd1c000 CR4: 00000000000006e0
[ 4116.230833] Call Trace:
[ 4116.230898]  ? ext4_htree_store_dirent+0x35/0x100 [ext4]
[ 4116.230924]  ext4_htree_store_dirent+0x35/0x100 [ext4]
[ 4116.230957]  htree_dirblock_to_tree+0xea/0x290 [ext4]
[ 4116.230989]  ext4_htree_fill_tree+0x1c1/0x2d0 [ext4]
[ 4116.231027]  ext4_readdir+0x67c/0x9d0 [ext4]
[ 4116.231040]  iterate_dir+0x8d/0x1a0
[ 4116.231056]  __x64_sys_getdents+0xab/0x130
[ 4116.231063]  ? iterate_dir+0x1a0/0x1a0
[ 4116.231076]  ? do_syscall_64+0x60/0x1f0
[ 4116.231080]  ? __ia32_sys_getdents+0x130/0x130
[ 4116.231086]  do_syscall_64+0x60/0x1f0
[ 4116.231151]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 4116.231168] RIP: 0033:0x7f699d33a9fb

This regression problem was introduced by commit e581595ea29c ("ocfs: no
need to check return value of debugfs_create functions").

Link: http://lkml.kernel.org/r/20191225061501.13587-1-ghe@suse.com
Fixes: e581595ea29c ("ocfs: no need to check return value of debugfs_create functions")
Signed-off-by: Gang He <ghe@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>	[5.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/dlmglue.c~ocfs2-fix-the-crash-due-to-call-ocfs2_get_dlm_debug-once-less
+++ a/fs/ocfs2/dlmglue.c
@@ -3282,6 +3282,7 @@ static void ocfs2_dlm_init_debug(struct
 
 	debugfs_create_u32("locking_filter", 0600, osb->osb_debug_root,
 			   &dlm_debug->d_filter_secs);
+	ocfs2_get_dlm_debug(dlm_debug);
 }
 
 static void ocfs2_dlm_shutdown_debug(struct ocfs2_super *osb)
_

Patches currently in -mm which might be from GHe@suse.com are

ocfs2-fix-the-crash-due-to-call-ocfs2_get_dlm_debug-once-less.patch

