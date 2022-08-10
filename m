Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC0558E4C9
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 04:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiHJCDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 22:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiHJCDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 22:03:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9941780F49;
        Tue,  9 Aug 2022 19:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23C1761283;
        Wed, 10 Aug 2022 02:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF4BC433D6;
        Wed, 10 Aug 2022 02:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660097023;
        bh=EAbo9w3jt2AJHXfRcNdU1Fyy3s3DrLAbGOG+QoG0sJw=;
        h=Date:To:From:Subject:From;
        b=bv1i+ZvssrG54AY8g+xJFTcMDHXSQbLyieI0Fs3XwYHlpoEAF3cZhMJpry5/Ep0Rf
         3g+N6TNPtCoC31aQcSHOrXIBTvbT6puDc1lQFIPBoyqn0YIf8074EdQNGQhSyL6DIK
         Dou3Vp1VOvtT+xha1asm1IBSkyQTZc10lfTO0FX8=
Date:   Tue, 09 Aug 2022 19:03:42 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        anton@tuxera.com, chenxiaosong2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs-fix-bug_on-in-ntfs_lookup_inode_by_name.patch added to mm-hotfixes-unstable branch
Message-Id: <20220810020343.6FF4BC433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ntfs-fix-bug_on-in-ntfs_lookup_inode_by_name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs-fix-bug_on-in-ntfs_lookup_inode_by_name.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: ChenXiaoSong <chenxiaosong2@huawei.com>
Subject: ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()
Date: Tue, 9 Aug 2022 14:47:30 +0800

Syzkaller reported BUG_ON as follows:

------------[ cut here ]------------
kernel BUG at fs/ntfs/dir.c:86!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 3 PID: 758 Comm: a.out Not tainted 5.19.0-next-20220808 #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
RIP: 0010:ntfs_lookup_inode_by_name+0xd11/0x2d10
Code: ff e9 b9 01 00 00 e8 1e fe d6 fe 48 8b 7d 98 49 8d 5d 07 e8 91 85 29 ff 48 c7 45 98 00 00 00 00 e9 5a fb ff ff e8 ff fd d6 fe <0f> 0b e8 f8 fd d6 fe 0f 0b e8 f1 fd d6 fe 48 8b b5 50 ff ff ff 4c
RSP: 0018:ffff888079607978 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000008000 RCX: 0000000000000000
RDX: ffff88807cf10000 RSI: ffffffff82a4a081 RDI: 0000000000000003
RBP: ffff888079607a70 R08: 0000000000000001 R09: ffff88807a6d01d7
R10: ffffed100f4da03a R11: 0000000000000000 R12: ffff88800f0fb110
R13: ffff88800f0ee000 R14: ffff88800f0fb000 R15: 0000000000000001
FS:  00007f33b63c7540(0000) GS:ffff888108580000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f33b635c090 CR3: 000000000f39e005 CR4: 0000000000770ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 load_system_files+0x1f7f/0x3620
 ntfs_fill_super+0xa01/0x1be0
 mount_bdev+0x36a/0x440
 ntfs_mount+0x3a/0x50
 legacy_get_tree+0xfb/0x210
 vfs_get_tree+0x8f/0x2f0
 do_new_mount+0x30a/0x760
 path_mount+0x4de/0x1880
 __x64_sys_mount+0x2b3/0x340
 do_syscall_64+0x38/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f33b62ff9ea
Code: 48 8b 0d a9 f4 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 76 f4 0b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffd0c471aa8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f33b62ff9ea
RDX: 0000000020000000 RSI: 0000000020000100 RDI: 00007ffd0c471be0
RBP: 00007ffd0c471c60 R08: 00007ffd0c471ae0 R09: 00007ffd0c471c24
R10: 0000000000000000 R11: 0000000000000202 R12: 000055bac5afc160
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---

Fix this by adding sanity check on extended system files' directory inode
to ensure that it is directory, just like ntfs_extend_init() when mounting
ntfs3.

Link: https://lkml.kernel.org/r/20220809064730.2316892-1-chenxiaosong2@huawei.com
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ntfs/super.c~ntfs-fix-bug_on-in-ntfs_lookup_inode_by_name
+++ a/fs/ntfs/super.c
@@ -2092,7 +2092,8 @@ get_ctx_vol_failed:
 	// TODO: Initialize security.
 	/* Get the extended system files' directory inode. */
 	vol->extend_ino = ntfs_iget(sb, FILE_Extend);
-	if (IS_ERR(vol->extend_ino) || is_bad_inode(vol->extend_ino)) {
+	if (IS_ERR(vol->extend_ino) || is_bad_inode(vol->extend_ino) ||
+	    !S_ISDIR(vol->extend_ino->i_mode)) {
 		if (!IS_ERR(vol->extend_ino))
 			iput(vol->extend_ino);
 		ntfs_error(sb, "Failed to load $Extend.");
_

Patches currently in -mm which might be from chenxiaosong2@huawei.com are

ntfs-fix-bug_on-in-ntfs_lookup_inode_by_name.patch

