Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CB1656EF2
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiL0UgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiL0Uee (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:34:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F352765E8;
        Tue, 27 Dec 2022 12:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABC1AB811F8;
        Tue, 27 Dec 2022 20:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29ACC433EF;
        Tue, 27 Dec 2022 20:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173235;
        bh=oYFblYElf6bdtAmIsXilFDyuYzUUNSGZjgSvoPieQZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVuaqBA4c4gwp6/Oeot/b4HczsjThwqcUXDGFYplrLw+tXAkwiFwns8E5C9yCSS8q
         QHBJNnqUwrFK2sYeMFZVRAwou1QihFj0kFc+bd0uuCeiObUTF/2xOLoUarpJLaS7QM
         HbMyOJMED1B9qCd/RUZhqr/bYpTLmfmVPGNGfgoAFlHXDZ9BTRcZbG3+Z43X8gF2/w
         pWA4mV2klVJHNVXr2CbHOpBLOGv+KxD3l0A1Ac+eAyihJFEvT+m568kG1AwngzFGHM
         FRDUQbl65QqvP2KQl/2Ky4chN6MJFF1HzQu8HtungltMQO95AiG5sgtKuIEpkzb1QJ
         OHX5wDR5MNDMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hawkins Jiawei <yin31149@gmail.com>,
        syzbot+8d6fbb27a6aded64b25b@syzkaller.appspotmail.com,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 10/27] fs/ntfs3: Fix slab-out-of-bounds read in run_unpack
Date:   Tue, 27 Dec 2022 15:33:25 -0500
Message-Id: <20221227203342.1213918-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203342.1213918-1-sashal@kernel.org>
References: <20221227203342.1213918-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 887bfc546097fbe8071dac13b2fef73b77920899 ]

Syzkaller reports slab-out-of-bounds bug as follows:
==================================================================
BUG: KASAN: slab-out-of-bounds in run_unpack+0x8b7/0x970 fs/ntfs3/run.c:944
Read of size 1 at addr ffff88801bbdff02 by task syz-executor131/3611

[...]
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
 kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
 run_unpack+0x8b7/0x970 fs/ntfs3/run.c:944
 run_unpack_ex+0xb0/0x7c0 fs/ntfs3/run.c:1057
 ntfs_read_mft fs/ntfs3/inode.c:368 [inline]
 ntfs_iget5+0xc20/0x3280 fs/ntfs3/inode.c:501
 ntfs_loadlog_and_replay+0x124/0x5d0 fs/ntfs3/fsntfs.c:272
 ntfs_fill_super+0x1eff/0x37f0 fs/ntfs3/super.c:1018
 get_tree_bdev+0x440/0x760 fs/super.c:1323
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
page:ffffea00006ef600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1bbd8
head:ffffea00006ef600 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801bbdfe00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801bbdfe80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801bbdff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff88801bbdff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801bbe0000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Kernel will tries to read record and parse MFT from disk in
ntfs_read_mft().

Yet the problem is that during enumerating attributes in record,
kernel doesn't check whether run_off field loading from the disk
is a valid value.

To be more specific, if attr->nres.run_off is larger than attr->size,
kernel will passes an invalid argument run_buf_size in
run_unpack_ex(), which having an integer overflow. Then this invalid
argument will triggers the slab-out-of-bounds Read bug as above.

This patch solves it by adding the sanity check between
the offset to packed runs and attribute size.

link: https://lore.kernel.org/all/0000000000009145fc05e94bd5c3@google.com/#t
Reported-and-tested-by: syzbot+8d6fbb27a6aded64b25b@syzkaller.appspotmail.com
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 791d049a9ad7..ba2005c12ee3 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -373,6 +373,13 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 	}
 
 	t64 = le64_to_cpu(attr->nres.svcn);
+
+	/* offset to packed runs is out-of-bounds */
+	if (roff > asize) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = run_unpack_ex(run, sbi, ino, t64, le64_to_cpu(attr->nres.evcn),
 			    t64, Add2Ptr(attr, roff), asize - roff);
 	if (err < 0)
-- 
2.35.1

