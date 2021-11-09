Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A2644B703
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344045AbhKIWbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:31:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344422AbhKIW3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:29:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB07F61A59;
        Tue,  9 Nov 2021 22:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496437;
        bh=JXqHEpmyDYneHPyenJLoWV4u2Jk6B2/RgAVzHCFF/ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XquJcly9WmcxfUbou6DSBgBCLD2wAxcoOchVRwaYWP2C1VSEnnGhmGkbxu5/j7u2Y
         cpfKpqpQ1QZP/z5NrT2kfBLYYY5fG1ASYbb0bG18/ufsGFIaD/7aONxAzeStNT7w5B
         70YO87Sp3sPnBbHB5dWU4c6u44U5j9pzn62JlbcO9Rfe/ByZIXcCM10v/LyKuE4ZFm
         wlFqBvN1jKbGdti7Xkfnyv1pdENIxf5SeP3yG0vUQqFA6XksQrr2oKMhQZ4+QXvjvw
         1paap72dbO1YcXuaftjWrILpSAM8iVnXd3Na58DXNfRuOtexfCtAwFhcst3I+R7l9s
         t4CpdCu+pONmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, JBottomley@odin.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 58/75] scsi: scsi_debug: Fix out-of-bound read in resp_readcap16()
Date:   Tue,  9 Nov 2021 17:18:48 -0500
Message-Id: <20211109221905.1234094-58-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 4e3ace0051e7e504b55d239daab8789dd89b863c ]

The following warning was observed running syzkaller:

[ 3813.830724] sg_write: data in/out 65466/242 bytes for SCSI command 0x9e-- guessing data in;
[ 3813.830724]    program syz-executor not setting count and/or reply_len properly
[ 3813.836956] ==================================================================
[ 3813.839465] BUG: KASAN: stack-out-of-bounds in sg_copy_buffer+0x157/0x1e0
[ 3813.841773] Read of size 4096 at addr ffff8883cf80f540 by task syz-executor/1549
[ 3813.846612] Call Trace:
[ 3813.846995]  dump_stack+0x108/0x15f
[ 3813.847524]  print_address_description+0xa5/0x372
[ 3813.848243]  kasan_report.cold+0x236/0x2a8
[ 3813.849439]  check_memory_region+0x240/0x270
[ 3813.850094]  memcpy+0x30/0x80
[ 3813.850553]  sg_copy_buffer+0x157/0x1e0
[ 3813.853032]  sg_copy_from_buffer+0x13/0x20
[ 3813.853660]  fill_from_dev_buffer+0x135/0x370
[ 3813.854329]  resp_readcap16+0x1ac/0x280
[ 3813.856917]  schedule_resp+0x41f/0x1630
[ 3813.858203]  scsi_debug_queuecommand+0xb32/0x17e0
[ 3813.862699]  scsi_dispatch_cmd+0x330/0x950
[ 3813.863329]  scsi_request_fn+0xd8e/0x1710
[ 3813.863946]  __blk_run_queue+0x10b/0x230
[ 3813.864544]  blk_execute_rq_nowait+0x1d8/0x400
[ 3813.865220]  sg_common_write.isra.0+0xe61/0x2420
[ 3813.871637]  sg_write+0x6c8/0xef0
[ 3813.878853]  __vfs_write+0xe4/0x800
[ 3813.883487]  vfs_write+0x17b/0x530
[ 3813.884008]  ksys_write+0x103/0x270
[ 3813.886268]  __x64_sys_write+0x77/0xc0
[ 3813.886841]  do_syscall_64+0x106/0x360
[ 3813.887415]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

This issue can be reproduced with the following syzkaller log:

r0 = openat(0xffffffffffffff9c, &(0x7f0000000040)='./file0\x00', 0x26e1, 0x0)
r1 = syz_open_procfs(0xffffffffffffffff, &(0x7f0000000000)='fd/3\x00')
open_by_handle_at(r1, &(0x7f00000003c0)=ANY=[@ANYRESHEX], 0x602000)
r2 = syz_open_dev$sg(&(0x7f0000000000), 0x0, 0x40782)
write$binfmt_aout(r2, &(0x7f0000000340)=ANY=[@ANYBLOB="00000000deff000000000000000000000000000000000000000000000000000047f007af9e107a41ec395f1bded7be24277a1501ff6196a83366f4e6362bc0ff2b247f68a972989b094b2da4fb3607fcf611a22dd04310d28c75039d"], 0x126)

In resp_readcap16() we get "int alloc_len" value -1104926854, and then pass
the huge arr_len to fill_from_dev_buffer(), but arr is only 32 bytes. This
leads to OOB in sg_copy_buffer().

To solve this issue, define alloc_len as u32.

Link: https://lore.kernel.org/r/20211013033913.2551004-2-yebin10@huawei.com
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5b3a20a140f9e..a5125df0b7842 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1856,7 +1856,7 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 {
 	unsigned char *cmd = scp->cmnd;
 	unsigned char arr[SDEBUG_READCAP16_ARR_SZ];
-	int alloc_len;
+	u32 alloc_len;
 
 	alloc_len = get_unaligned_be32(cmd + 10);
 	/* following just in case virtual_gb changed */
@@ -1885,7 +1885,7 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 	}
 
 	return fill_from_dev_buffer(scp, arr,
-			    min_t(int, alloc_len, SDEBUG_READCAP16_ARR_SZ));
+			    min_t(u32, alloc_len, SDEBUG_READCAP16_ARR_SZ));
 }
 
 #define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
-- 
2.33.0

