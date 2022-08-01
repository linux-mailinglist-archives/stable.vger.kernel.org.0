Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EC5587120
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbiHATHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiHATHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:07:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0225045050;
        Mon,  1 Aug 2022 12:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E241F61229;
        Mon,  1 Aug 2022 19:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D74C433D6;
        Mon,  1 Aug 2022 19:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380642;
        bh=TPytx1N/dr1O0qa21LUkcsV1zrJah+fC1FTAhW/ruV0=;
        h=From:To:Cc:Subject:Date:From;
        b=HOI58JpAkcXduwf97ILp/V9v/8BNiNvqvVJE6RIdbUPdlumIDv2PZKzIgV/vOtYE8
         NmbHpu77TlKach/rK/3RhoFOaDnhlQClGvey08geQPLjw48U0w+yL1qmvTwdVXfbKl
         RGLo7/n59GGA1R3AxL4XWfqLimLcgDAN3hd1H2Axl9q+j/86//dbKIGzf0hqRcv16i
         t5rICRnp/0y8iUYw/bu4sX40HlNMrg9ilvP+ORPMPZ2ECqYoO2bV1mdUmUbg94drsM
         5f6yMT6GM84rPFvRCDDcEUCMEzSCWM2YqHT/y+28cl3/hO5aEaw4yE2eKO5vaa2tiA
         r960zIG7qmqYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ChenXiaoSong <chenxiaosong2@huawei.com>,
        Hawkins Jiawei <yin31149@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Yongqiang Liu <liuyongqiang13@huawei.com>,
        Zhang Yi <yi.zhang@huawei.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 1/3] ntfs: fix use-after-free in ntfs_ucsncmp()
Date:   Mon,  1 Aug 2022 15:03:56 -0400
Message-Id: <20220801190359.3820214-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit 38c9c22a85aeed28d0831f230136e9cf6fa2ed44 ]

Syzkaller reported use-after-free bug as follows:

==================================================================
BUG: KASAN: use-after-free in ntfs_ucsncmp+0x123/0x130
Read of size 2 at addr ffff8880751acee8 by task a.out/879

CPU: 7 PID: 879 Comm: a.out Not tainted 5.19.0-rc4-next-20220630-00001-gcc5218c8bd2c-dirty #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x1c0/0x2b0
 print_address_description.constprop.0.cold+0xd4/0x484
 print_report.cold+0x55/0x232
 kasan_report+0xbf/0xf0
 ntfs_ucsncmp+0x123/0x130
 ntfs_are_names_equal.cold+0x2b/0x41
 ntfs_attr_find+0x43b/0xb90
 ntfs_attr_lookup+0x16d/0x1e0
 ntfs_read_locked_attr_inode+0x4aa/0x2360
 ntfs_attr_iget+0x1af/0x220
 ntfs_read_locked_inode+0x246c/0x5120
 ntfs_iget+0x132/0x180
 load_system_files+0x1cc6/0x3480
 ntfs_fill_super+0xa66/0x1cf0
 mount_bdev+0x38d/0x460
 legacy_get_tree+0x10d/0x220
 vfs_get_tree+0x93/0x300
 do_new_mount+0x2da/0x6d0
 path_mount+0x496/0x19d0
 __x64_sys_mount+0x284/0x300
 do_syscall_64+0x3b/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f3f2118d9ea
Code: 48 8b 0d a9 f4 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 76 f4 0b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffc269deac8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3f2118d9ea
RDX: 0000000020000000 RSI: 0000000020000100 RDI: 00007ffc269dec00
RBP: 00007ffc269dec80 R08: 00007ffc269deb00 R09: 00007ffc269dec44
R10: 0000000000000000 R11: 0000000000000202 R12: 000055f81ab1d220
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

The buggy address belongs to the physical page:
page:0000000085430378 refcount:1 mapcount:1 mapping:0000000000000000 index:0x555c6a81d pfn:0x751ac
memcg:ffff888101f7e180
anon flags: 0xfffffc00a0014(uptodate|lru|mappedtodisk|swapbacked|node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc00a0014 ffffea0001bf2988 ffffea0001de2448 ffff88801712e201
raw: 0000000555c6a81d 0000000000000000 0000000100000000 ffff888101f7e180
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880751acd80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880751ace00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880751ace80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                                                          ^
 ffff8880751acf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880751acf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

The reason is that struct ATTR_RECORD->name_offset is 6485, end address of
name string is out of bounds.

Fix this by adding sanity check on end address of attribute name string.

[akpm@linux-foundation.org: coding-style cleanups]
[chenxiaosong2@huawei.com: cleanup suggested by Hawkins Jiawei]
  Link: https://lkml.kernel.org/r/20220709064511.3304299-1-chenxiaosong2@huawei.com
Link: https://lkml.kernel.org/r/20220707105329.4020708-1-chenxiaosong2@huawei.com
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: ChenXiaoSong <chenxiaosong2@huawei.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 44a39a099b54..62b49197e5f6 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -606,8 +606,12 @@ static int ntfs_attr_find(const ATTR_TYPE type, const ntfschar *name,
 		a = (ATTR_RECORD*)((u8*)ctx->attr +
 				le32_to_cpu(ctx->attr->length));
 	for (;;	a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))) {
-		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > (u8*)ctx->mrec +
-				le32_to_cpu(ctx->mrec->bytes_allocated))
+		u8 *mrec_end = (u8 *)ctx->mrec +
+		               le32_to_cpu(ctx->mrec->bytes_allocated);
+		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
+			       a->name_length * sizeof(ntfschar);
+		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
+		    name_end > mrec_end)
 			break;
 		ctx->attr = a;
 		if (unlikely(le32_to_cpu(a->type) > le32_to_cpu(type) ||
-- 
2.35.1

