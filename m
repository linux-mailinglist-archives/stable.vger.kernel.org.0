Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C625152641C
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357833AbiEMO1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380942AbiEMO0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:26:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B385F8E2;
        Fri, 13 May 2022 07:25:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9B77B8306F;
        Fri, 13 May 2022 14:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E01DC34100;
        Fri, 13 May 2022 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451951;
        bh=3ZAQoHJRAorjhE63N9J2GNWT/DBzxa637Mj9/BzDMmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OYEq3/QdjkmG/2dCQbjMUeid3PUAGUqPfPzllHHeRGsG34HaQLb95evAKkMBYbRA
         l0aJm3leAmUAD5rSUaw/9cxSudi50uCsFM2KFwPe7pujExcFJMQE0XJ6EtC5P1HNsG
         /5ETxIG67ZNgjTrChv7dXY0vkiKjzcNRLUesKveQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        ChenXiaoSong <chenxiaosong2@huawei.com>
Subject: [PATCH 4.19 15/15] VFS: Fix memory leak caused by concurrently mounting fs with subtype
Date:   Fri, 13 May 2022 16:23:37 +0200
Message-Id: <20220513142228.347780404@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142227.897535454@linuxfoundation.org>
References: <20220513142227.897535454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChenXiaoSong <chenxiaosong2@huawei.com>

If two processes mount same superblock, memory leak occurs:

CPU0               |  CPU1
do_new_mount       |  do_new_mount
  fs_set_subtype   |    fs_set_subtype
    kstrdup        |
                   |      kstrdup
    memrory leak   |

The following reproducer triggers the problem:

1. shell command: mount -t ntfs /dev/sda1 /mnt &
2. c program: mount("/dev/sda1", "/mnt", "fuseblk", 0, "...")

with kmemleak report being along the lines of

unreferenced object 0xffff888235f1a5c0 (size 8):
  comm "mount.ntfs", pid 2860, jiffies 4295757824 (age 43.423s)
  hex dump (first 8 bytes):
    00 a5 f1 35 82 88 ff ff                          ...5....
  backtrace:
    [<00000000656e30cc>] __kmalloc_track_caller+0x16e/0x430
    [<000000008e591727>] kstrdup+0x3e/0x90
    [<000000008430d12b>] do_mount.cold+0x7b/0xd9
    [<0000000078d639cd>] ksys_mount+0xb2/0x150
    [<000000006015988d>] __x64_sys_mount+0x29/0x40
    [<00000000e0a7c118>] do_syscall_64+0xc1/0x1d0
    [<00000000bcea7df5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<00000000803a4067>] 0xffffffffffffffff

Linus's tree already have refactoring patchset [1], one of them can fix this bug:
        c30da2e981a7 ("fuse: convert to use the new mount API")
After refactoring, init super_block->s_subtype in fuse_fill_super.

Since we did not merge the refactoring patchset in this branch, I create this patch.
This patch fix this by adding a write lock while calling fs_set_subtype.

[1] https://patchwork.kernel.org/project/linux-fsdevel/patch/20190903113640.7984-3-mszeredi@redhat.com/

Fixes: 79c0b2df79eb ("add filesystem subtype support")
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v1: Can not mount sshfs ([PATCH linux-4.19.y] VFS: Fix fuseblk memory leak caused by mount concurrency)
v2: Use write lock while writing superblock ([PATCH 4.19,v2] VFS: Fix fuseblk memory leak caused by mount concurrency)
v3: Update commit message

 fs/namespace.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2490,9 +2490,12 @@ static int do_new_mount(struct path *pat
 		return -ENODEV;
 
 	mnt = vfs_kern_mount(type, sb_flags, name, data);
-	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
-	    !mnt->mnt_sb->s_subtype)
-		mnt = fs_set_subtype(mnt, fstype);
+	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE)) {
+		down_write(&mnt->mnt_sb->s_umount);
+		if (!mnt->mnt_sb->s_subtype)
+			mnt = fs_set_subtype(mnt, fstype);
+		up_write(&mnt->mnt_sb->s_umount);
+	}
 
 	put_filesystem(type);
 	if (IS_ERR(mnt))


