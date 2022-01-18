Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38924491554
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245719AbiARC1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245699AbiARCZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:25:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE0FC0613AE;
        Mon, 17 Jan 2022 18:24:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E1F66110F;
        Tue, 18 Jan 2022 02:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6AAC36AF5;
        Tue, 18 Jan 2022 02:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472667;
        bh=ebvfpE83+PqI3ZaZWF3SrL2qIONeao6SDSIY8ligs8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEyCgYoBwZ2qcB63M8Rdbdt0p7TsSmkc0SjyDbIxyajnA3SZRt19r02CTO+izKNdI
         Qj76cD7m27WYCDWcd0j5Cy5t5DC47nyDXj4C57+vd21xTsVhYOuIuj/7O0+UKsie+T
         Bu41MRk+aqP/zSwFWr3DlT1crYXSg8iPJzWlxcb22xJmkRFAoZpBLOouLyZjGgJssz
         /8sRI1RJlSqVp+qYn+z1G1xuxhpsk1NV091dYaCgAc5k1JgcQEl5xI4GQ1RtojwFIN
         uEtftfdfFQZux1uPBnra/o8uaxB8+eWICilp83F1P+0a594zQCe2yDmg+ptkin9yZq
         wsJcKZANTmC2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiongwei Song <sxwjean@gmail.com>,
        syzbot+23a02c7df2cf2bc93fa2@syzkaller.appspotmail.com,
        Denis Efremov <efremov@linux.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 093/217] floppy: Add max size check for user space request
Date:   Mon, 17 Jan 2022 21:17:36 -0500
Message-Id: <20220118021940.1942199-93-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongwei Song <sxwjean@gmail.com>

[ Upstream commit 545a32498c536ee152331cd2e7d2416aa0f20e01 ]

We need to check the max request size that is from user space before
allocating pages. If the request size exceeds the limit, return -EINVAL.
This check can avoid the warning below from page allocator.

WARNING: CPU: 3 PID: 16525 at mm/page_alloc.c:5344 current_gfp_context include/linux/sched/mm.h:195 [inline]
WARNING: CPU: 3 PID: 16525 at mm/page_alloc.c:5344 __alloc_pages+0x45d/0x500 mm/page_alloc.c:5356
Modules linked in:
CPU: 3 PID: 16525 Comm: syz-executor.3 Not tainted 5.15.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:__alloc_pages+0x45d/0x500 mm/page_alloc.c:5344
Code: be c9 00 00 00 48 c7 c7 20 4a 97 89 c6 05 62 32 a7 0b 01 e8 74 9a 42 07 e9 6a ff ff ff 0f 0b e9 a0 fd ff ff 40 80 e5 3f eb 88 <0f> 0b e9 18 ff ff ff 4c 89 ef 44 89 e6 45 31 ed e8 1e 76 ff ff e9
RSP: 0018:ffffc90023b87850 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff92004770f0b RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000033 RDI: 0000000000010cc1
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff81bb4686 R11: 0000000000000001 R12: ffffffff902c1960
R13: 0000000000000033 R14: 0000000000000000 R15: ffff88804cf64a30
FS:  0000000000000000(0000) GS:ffff88802cd00000(0063) knlGS:00000000f44b4b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000000002c921000 CR3: 000000004f507000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2191
 __get_free_pages+0x8/0x40 mm/page_alloc.c:5418
 raw_cmd_copyin drivers/block/floppy.c:3113 [inline]
 raw_cmd_ioctl drivers/block/floppy.c:3160 [inline]
 fd_locked_ioctl+0x12e5/0x2820 drivers/block/floppy.c:3528
 fd_ioctl drivers/block/floppy.c:3555 [inline]
 fd_compat_ioctl+0x891/0x1b60 drivers/block/floppy.c:3869
 compat_blkdev_ioctl+0x3b8/0x810 block/ioctl.c:662
 __do_compat_sys_ioctl+0x1c7/0x290 fs/ioctl.c:972
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:203
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Reported-by: syzbot+23a02c7df2cf2bc93fa2@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20211116131033.27685-1-sxwjean@me.com
Signed-off-by: Xiongwei Song <sxwjean@gmail.com>
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index c4267da716fe6..52112ed59dd02 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3081,6 +3081,8 @@ static void raw_cmd_free(struct floppy_raw_cmd **ptr)
 	}
 }
 
+#define MAX_LEN (1UL << MAX_ORDER << PAGE_SHIFT)
+
 static int raw_cmd_copyin(int cmd, void __user *param,
 				 struct floppy_raw_cmd **rcmd)
 {
@@ -3108,7 +3110,7 @@ static int raw_cmd_copyin(int cmd, void __user *param,
 	ptr->resultcode = 0;
 
 	if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
-		if (ptr->length <= 0)
+		if (ptr->length <= 0 || ptr->length >= MAX_LEN)
 			return -EINVAL;
 		ptr->kernel_data = (char *)fd_dma_mem_alloc(ptr->length);
 		fallback_on_nodma_alloc(&ptr->kernel_data, ptr->length);
-- 
2.34.1

