Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04FC635664
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbiKWJ3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237779AbiKWJ3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:29:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611B210E1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:27:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09FA1B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F30C433D6;
        Wed, 23 Nov 2022 09:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195658;
        bh=GzoWNf11BJbxgQ5dp8GhRgeAFnuO0L89kf0hVz/N4PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGmKde8RLp1sjNYS6n9FhlNbON7QeuzncNl1Wfc2uriYp02RIVtokszxtPHVUCv9H
         EFbTGGZlmP1DgCY8c8YapXB1ijkbYH/7qVSmFDPJOeiYAMxF41wFXXaZ730ea/2RYa
         Z4+3m73Ctg7MIeEQy3R9icHrvgyrrp4BWR4YKod4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hawkins Jiawei <yin31149@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        ChenXiaoSong <chenxiaosong2@huawei.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 147/149] ntfs: fix use-after-free in ntfs_attr_find()
Date:   Wed, 23 Nov 2022 09:52:10 +0100
Message-Id: <20221123084603.183766481@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

commit d85a1bec8e8d552ab13163ca1874dcd82f3d1550 upstream.

Patch series "ntfs: fix bugs about Attribute", v2.

This patchset fixes three bugs relative to Attribute in record:

Patch 1 adds a sanity check to ensure that, attrs_offset field in first
mft record loading from disk is within bounds.

Patch 2 moves the ATTR_RECORD's bounds checking earlier, to avoid
dereferencing ATTR_RECORD before checking this ATTR_RECORD is within
bounds.

Patch 3 adds an overflow checking to avoid possible forever loop in
ntfs_attr_find().

Without patch 1 and patch 2, the kernel triggersa KASAN use-after-free
detection as reported by Syzkaller.

Although one of patch 1 or patch 2 can fix this, we still need both of
them.  Because patch 1 fixes the root cause, and patch 2 not only fixes
the direct cause, but also fixes the potential out-of-bounds bug.


This patch (of 3):

Syzkaller reported use-after-free read as follows:
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

Kernel will loads $MFT/$DATA's first mft record in
ntfs_read_inode_mount().

Yet the problem is that after loading, kernel doesn't check whether
attrs_offset field is a valid value.

To be more specific, if attrs_offset field is larger than bytes_allocated
field, then it may trigger the out-of-bounds read bug(reported as
use-after-free bug) in ntfs_attr_find(), when kernel tries to access the
corresponding mft record's attribute.

This patch solves it by adding the sanity check between attrs_offset field
and bytes_allocated field, after loading the first mft record.

Link: https://lkml.kernel.org/r/20220831160935.3409-1-yin31149@gmail.com
Link: https://lkml.kernel.org/r/20220831160935.3409-2-yin31149@gmail.com
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: ChenXiaoSong <chenxiaosong2@huawei.com>
Cc: syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1829,6 +1829,13 @@ int ntfs_read_inode_mount(struct inode *
 		goto err_out;
 	}
 
+	/* Sanity check offset to the first attribute */
+	if (le16_to_cpu(m->attrs_offset) >= le32_to_cpu(m->bytes_allocated)) {
+		ntfs_error(sb, "Incorrect mft offset to the first attribute %u in superblock.",
+			       le16_to_cpu(m->attrs_offset));
+		goto err_out;
+	}
+
 	/* Need this to sanity check attribute list references to $MFT. */
 	vi->i_generation = ni->seq_no = le16_to_cpu(m->sequence_number);
 


