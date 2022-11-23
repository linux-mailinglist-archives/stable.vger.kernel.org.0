Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA70C635440
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbiKWJDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236998AbiKWJDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:03:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D392B58BF6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:03:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7246561B4A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4461EC433C1;
        Wed, 23 Nov 2022 09:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194180;
        bh=2OLNWatJJrSTJi1lrfP1du4PfQg8OKWnA/Yn+SZDzbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obGqO+FeDq3ItLcB0Kg4drpJlSwjZUigi3gXGvXh2274Q2ikfo4MsoqgIIzn2InCY
         MoUov69NhZ3gZsamCJU+s5yb67eP42/E113isMKNEGfAqpibhKdMUl2IQSy6J0lPgP
         X5s26BfuyhWR50QaOQJUOG3H3mcBE84AQzmQstbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "chenxiaosong (A)" <chenxiaosong2@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hawkins Jiawei <yin31149@gmail.com>,
        syzbot+5f8dcabe4a3b2c51c607@syzkaller.appspotmail.com,
        Anton Altaparmakov <anton@tuxera.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 87/88] ntfs: fix out-of-bounds read in ntfs_attr_find()
Date:   Wed, 23 Nov 2022 09:51:24 +0100
Message-Id: <20221123084551.711543734@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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

From: Hawkins Jiawei <yin31149@gmail.com>

commit 36a4d82dddbbd421d2b8e79e1cab68c8126d5075 upstream.

Kernel iterates over ATTR_RECORDs in mft record in ntfs_attr_find().  To
ensure access on these ATTR_RECORDs are within bounds, kernel will do some
checking during iteration.

The problem is that during checking whether ATTR_RECORD's name is within
bounds, kernel will dereferences the ATTR_RECORD name_offset field, before
checking this ATTR_RECORD strcture is within bounds.  This problem may
result out-of-bounds read in ntfs_attr_find(), reported by Syzkaller:

==================================================================
BUG: KASAN: use-after-free in ntfs_attr_find+0xc02/0xce0 fs/ntfs/attrib.c:597
Read of size 2 at addr ffff88807e352009 by task syz-executor153/3607

[...]
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
 kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
 ntfs_attr_find+0xc02/0xce0 fs/ntfs/attrib.c:597
 ntfs_attr_lookup+0x1056/0x2070 fs/ntfs/attrib.c:1193
 ntfs_read_inode_mount+0x89a/0x2580 fs/ntfs/inode.c:1845
 ntfs_fill_super+0x1799/0x9320 fs/ntfs/super.c:2854
 mount_bdev+0x34d/0x410 fs/super.c:1400
 legacy_get_tree+0x105/0x220 fs/fs_context.c:610
 vfs_get_tree+0x89/0x2f0 fs/super.c:1530
 do_new_mount fs/namespace.c:3040 [inline]
 path_mount+0x1326/0x1e20 fs/namespace.c:3370
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 [...]
 </TASK>

The buggy address belongs to the physical page:
page:ffffea0001f8d400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7e350
head:ffffea0001f8d400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888011842140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff88807e351f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807e351f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807e352000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88807e352080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807e352100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

This patch solves it by moving the ATTR_RECORD strcture's bounds checking
earlier, then checking whether ATTR_RECORD's name is within bounds.
What's more, this patch also add some comments to improve its
maintainability.

Link: https://lkml.kernel.org/r/20220831160935.3409-3-yin31149@gmail.com
Link: https://lore.kernel.org/all/1636796c-c85e-7f47-e96f-e074fee3c7d3@huawei.com/
Link: https://groups.google.com/g/syzkaller-bugs/c/t_XdeKPGTR4/m/LECAuIGcBgAJ
Signed-off-by: chenxiaosong (A) <chenxiaosong2@huawei.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Reported-by: syzbot+5f8dcabe4a3b2c51c607@syzkaller.appspotmail.com
Tested-by: syzbot+5f8dcabe4a3b2c51c607@syzkaller.appspotmail.com
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -608,11 +608,23 @@ static int ntfs_attr_find(const ATTR_TYP
 	for (;;	a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))) {
 		u8 *mrec_end = (u8 *)ctx->mrec +
 		               le32_to_cpu(ctx->mrec->bytes_allocated);
-		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
-			       a->name_length * sizeof(ntfschar);
-		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
-		    name_end > mrec_end)
+		u8 *name_end;
+
+		/* check whether ATTR_RECORD wrap */
+		if ((u8 *)a < (u8 *)ctx->mrec)
 			break;
+
+		/* check whether Attribute Record Header is within bounds */
+		if ((u8 *)a > mrec_end ||
+		    (u8 *)a + sizeof(ATTR_RECORD) > mrec_end)
+			break;
+
+		/* check whether ATTR_RECORD's name is within bounds */
+		name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
+			   a->name_length * sizeof(ntfschar);
+		if (name_end > mrec_end)
+			break;
+
 		ctx->attr = a;
 		if (unlikely(le32_to_cpu(a->type) > le32_to_cpu(type) ||
 				a->type == AT_END))


