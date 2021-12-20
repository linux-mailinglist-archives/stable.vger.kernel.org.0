Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AE747AFC8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbhLTPS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238903AbhLTPRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:17:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B4DC08ECB3;
        Mon, 20 Dec 2021 06:58:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 221A1B80ED3;
        Mon, 20 Dec 2021 14:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C385C36AE8;
        Mon, 20 Dec 2021 14:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012332;
        bh=HZz7Ufy9w+FmEwEB5olaESeqAdIkF5ExNbMRJg/VkJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xz5TZboPIGPn57a577vqEFfdCLpi6HWQJJwfTjk0EKAgGr3rkwrL3KLpTDw24HVQ6
         maOYV1o5gr0u6WFkWWPKUqoHAnuYJRz5C3+m9/IhQtTHf+F8XlGV54bgnlPt3YPhng
         YhlW2ps8dR4vHAPNlEBxOcxwzjWRRm1vLcNAOM2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        George Kennedy <george.kennedy@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 163/177] scsi: scsi_debug: Dont call kcalloc() if size arg is zero
Date:   Mon, 20 Dec 2021 15:35:13 +0100
Message-Id: <20211220143045.561947555@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

commit 3344b58b53a76199dae48faa396e9fc37bf86992 upstream.

If the size arg to kcalloc() is zero, it returns ZERO_SIZE_PTR.  Because of
that, for a following NULL pointer check to work on the returned pointer,
kcalloc() must not be called with the size arg equal to zero. Return early
without error before the kcalloc() call if size arg is zero.

BUG: KASAN: null-ptr-deref in memcpy include/linux/fortify-string.h:191 [inline]
BUG: KASAN: null-ptr-deref in sg_copy_buffer+0x138/0x240 lib/scatterlist.c:974
Write of size 4 at addr 0000000000000010 by task syz-executor.1/22789

CPU: 1 PID: 22789 Comm: syz-executor.1 Not tainted 5.15.0-syzk #1
Hardware name: Red Hat KVM, BIOS 1.13.0-2
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
 __kasan_report mm/kasan/report.c:446 [inline]
 kasan_report.cold.14+0x112/0x117 mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x1a3/0x210 mm/kasan/generic.c:189
 memcpy+0x3b/0x60 mm/kasan/shadow.c:66
 memcpy include/linux/fortify-string.h:191 [inline]
 sg_copy_buffer+0x138/0x240 lib/scatterlist.c:974
 do_dout_fetch drivers/scsi/scsi_debug.c:2954 [inline]
 do_dout_fetch drivers/scsi/scsi_debug.c:2946 [inline]
 resp_verify+0x49e/0x930 drivers/scsi/scsi_debug.c:4276
 schedule_resp+0x4d8/0x1a70 drivers/scsi/scsi_debug.c:5478
 scsi_debug_queuecommand+0x8c9/0x1ec0 drivers/scsi/scsi_debug.c:7533
 scsi_dispatch_cmd drivers/scsi/scsi_lib.c:1520 [inline]
 scsi_queue_rq+0x16b0/0x2d40 drivers/scsi/scsi_lib.c:1699
 blk_mq_dispatch_rq_list+0xb9b/0x2700 block/blk-mq.c:1639
 __blk_mq_sched_dispatch_requests+0x28f/0x590 block/blk-mq-sched.c:325
 blk_mq_sched_dispatch_requests+0x105/0x190 block/blk-mq-sched.c:358
 __blk_mq_run_hw_queue+0xe5/0x150 block/blk-mq.c:1761
 __blk_mq_delay_run_hw_queue+0x4f8/0x5c0 block/blk-mq.c:1838
 blk_mq_run_hw_queue+0x18d/0x350 block/blk-mq.c:1891
 blk_mq_sched_insert_request+0x3db/0x4e0 block/blk-mq-sched.c:474
 blk_execute_rq_nowait+0x16b/0x1c0 block/blk-exec.c:62
 blk_execute_rq+0xdb/0x360 block/blk-exec.c:102
 sg_scsi_ioctl drivers/scsi/scsi_ioctl.c:621 [inline]
 scsi_ioctl+0x8bb/0x15c0 drivers/scsi/scsi_ioctl.c:930
 sg_ioctl_common+0x172d/0x2710 drivers/scsi/sg.c:1112
 sg_ioctl+0xa2/0x180 drivers/scsi/sg.c:1165
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Link: https://lore.kernel.org/r/1636056397-13151-1-git-send-email-george.kennedy@oracle.com
Reported-by: syzkaller <syzkaller@googlegroups.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_debug.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4259,6 +4259,8 @@ static int resp_verify(struct scsi_cmnd
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
+	if (vnum == 0)
+		return 0;	/* not an error */
 	a_num = is_bytchk3 ? 1 : vnum;
 	/* Treat following check like one for read (i.e. no write) access */
 	ret = check_device_access_params(scp, lba, a_num, false);
@@ -4322,6 +4324,8 @@ static int resp_report_zones(struct scsi
 	}
 	zs_lba = get_unaligned_be64(cmd + 2);
 	alloc_len = get_unaligned_be32(cmd + 10);
+	if (alloc_len == 0)
+		return 0;	/* not an error */
 	rep_opts = cmd[14] & 0x3f;
 	partial = cmd[14] & 0x80;
 


