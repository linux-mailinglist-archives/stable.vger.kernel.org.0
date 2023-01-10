Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC6F6649DD
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjAJS03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239383AbjAJSZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:25:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53173974BE
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:22:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E337461868
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01416C433EF;
        Tue, 10 Jan 2023 18:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374939;
        bh=zp9hBJ4Hep3iwBhTIDpziJKNFI9Nbe8EI9NLNmjLiFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1X/TAmtDaIi4EtfjcBzIBus628NxhNqkRQh0I00GoWrEhqGAy86QARkIVRxUp90QK
         OfU+9/EZB8DOYjsq3HVbb+ngsZchUp3z5Y/dKy97WxriezZrcYeEbv45bpLHPb0V3E
         VXoEVcM0D8nDw6RElHF0prdLzIPJF+ceWEnpAduY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hawkins Jiawei <yin31149@gmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+8d6fbb27a6aded64b25b@syzkaller.appspotmail.com
Subject: [PATCH 5.15 024/290] fs/ntfs3: Fix slab-out-of-bounds read in run_unpack
Date:   Tue, 10 Jan 2023 19:01:56 +0100
Message-Id: <20230110180032.426794781@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
index 66afa3db753a..00fd368e7b4a 100644
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



