Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E071F5F2B2A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiJCHuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbiJCHt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:49:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30455AC66;
        Mon,  3 Oct 2022 00:28:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D30660FAC;
        Mon,  3 Oct 2022 07:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AAEC433C1;
        Mon,  3 Oct 2022 07:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781432;
        bh=kXF99wYI2vw+gjdXMYA9FTirKzz+ImYzxc+lgH9a35I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7UM9rVFLkSs3dG12NmpgfTFiAFcm5TI+drXEQXxDJyfYwG139wHFtRCmKmuUVEbT
         lMTox7T1SDJMBqqtD8cQyuUIlvrIsXSg0e//3Rg1M2XER0OBH9krU+KfMBKg90C0GH
         goYt090p4R/nGf6xrx/p86FxTbdRV2tO/Q07PZbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChenXiaoSong <chenxiaosong2@huawei.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 18/83] ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()
Date:   Mon,  3 Oct 2022 09:10:43 +0200
Message-Id: <20221003070722.440859023@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChenXiaoSong <chenxiaosong2@huawei.com>

commit 1b513f613731e2afc05550e8070d79fac80c661e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
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


