Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D70244B7A8
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345203AbhKIWg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:36:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345510AbhKIWeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:34:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2C9061AD1;
        Tue,  9 Nov 2021 22:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496528;
        bh=3Vu0XxQGctumngGP0qAUb+siqu5jgLpyDhFnayMstWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSAe6Hx8R4VidMFsckGhGwdbwuhVc8Kqb7a3H9csZ3APRol3r/e1RyOUriLPgzdyN
         DDrBiosPGrjXKweu/7a69wLqdGux+RGJOnPtDYI2nEiGaObPb1P87X/MkbMo0ePJrV
         RFgUq6Zn1axeSPofICQhNj8b+FgC4AX19zIX61KnOZgQcJapKzhffVynNVPBf27uwS
         qot24AW/w3JG60U74TJRNhmKi2LsubnDttEyxrk2/asnfptT285oNjMSnfd2uZTamq
         NQNBgxSIt5klMA3L1okT2WSCrbkn9vSNEIUlYamansd9mhDQ9BwzjYGAl9BCAz3RfX
         MtjoWS2DsnXXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, JBottomley@odin.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 41/50] scsi: scsi_debug: Fix out-of-bound read in resp_report_tgtpgs()
Date:   Tue,  9 Nov 2021 17:20:54 -0500
Message-Id: <20211109222103.1234885-41-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit f347c26836c270199de1599c3cd466bb7747caa9 ]

The following issue was observed running syzkaller:

BUG: KASAN: slab-out-of-bounds in memcpy include/linux/string.h:377 [inline]
BUG: KASAN: slab-out-of-bounds in sg_copy_buffer+0x150/0x1c0 lib/scatterlist.c:831
Read of size 2132 at addr ffff8880aea95dc8 by task syz-executor.0/9815

CPU: 0 PID: 9815 Comm: syz-executor.0 Not tainted 4.19.202-00874-gfc0fe04215a9 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xe4/0x14a lib/dump_stack.c:118
 print_address_description+0x73/0x280 mm/kasan/report.c:253
 kasan_report_error mm/kasan/report.c:352 [inline]
 kasan_report+0x272/0x370 mm/kasan/report.c:410
 memcpy+0x1f/0x50 mm/kasan/kasan.c:302
 memcpy include/linux/string.h:377 [inline]
 sg_copy_buffer+0x150/0x1c0 lib/scatterlist.c:831
 fill_from_dev_buffer+0x14f/0x340 drivers/scsi/scsi_debug.c:1021
 resp_report_tgtpgs+0x5aa/0x770 drivers/scsi/scsi_debug.c:1772
 schedule_resp+0x464/0x12f0 drivers/scsi/scsi_debug.c:4429
 scsi_debug_queuecommand+0x467/0x1390 drivers/scsi/scsi_debug.c:5835
 scsi_dispatch_cmd+0x3fc/0x9b0 drivers/scsi/scsi_lib.c:1896
 scsi_request_fn+0x1042/0x1810 drivers/scsi/scsi_lib.c:2034
 __blk_run_queue_uncond block/blk-core.c:464 [inline]
 __blk_run_queue+0x1a4/0x380 block/blk-core.c:484
 blk_execute_rq_nowait+0x1c2/0x2d0 block/blk-exec.c:78
 sg_common_write.isra.19+0xd74/0x1dc0 drivers/scsi/sg.c:847
 sg_write.part.23+0x6e0/0xd00 drivers/scsi/sg.c:716
 sg_write+0x64/0xa0 drivers/scsi/sg.c:622
 __vfs_write+0xed/0x690 fs/read_write.c:485
kill_bdev:block_device:00000000e138492c
 vfs_write+0x184/0x4c0 fs/read_write.c:549
 ksys_write+0x107/0x240 fs/read_write.c:599
 do_syscall_64+0xc2/0x560 arch/x86/entry/common.c:293
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

We get 'alen' from command its type is int. If userspace passes a large
length we will get a negative 'alen'.

Switch n, alen, and rlen to u32.

Link: https://lore.kernel.org/r/20211013033913.2551004-3-yebin10@huawei.com
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 63504dc63d878..3fc7c2a31c191 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1895,8 +1895,9 @@ static int resp_report_tgtpgs(struct scsi_cmnd *scp,
 	unsigned char *cmd = scp->cmnd;
 	unsigned char *arr;
 	int host_no = devip->sdbg_host->shost->host_no;
-	int n, ret, alen, rlen;
 	int port_group_a, port_group_b, port_a, port_b;
+	u32 alen, n, rlen;
+	int ret;
 
 	alen = get_unaligned_be32(cmd + 6);
 	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_ATOMIC);
@@ -1958,9 +1959,9 @@ static int resp_report_tgtpgs(struct scsi_cmnd *scp,
 	 * - The constructed command length
 	 * - The maximum array size
 	 */
-	rlen = min_t(int, alen, n);
+	rlen = min(alen, n);
 	ret = fill_from_dev_buffer(scp, arr,
-			   min_t(int, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
+			   min_t(u32, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
 	kfree(arr);
 	return ret;
 }
-- 
2.33.0

