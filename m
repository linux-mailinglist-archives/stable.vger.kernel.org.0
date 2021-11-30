Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CB246374C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242528AbhK3Owq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:52:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45714 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242530AbhK3OwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E826EB81A22;
        Tue, 30 Nov 2021 14:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D44C53FC7;
        Tue, 30 Nov 2021 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283722;
        bh=bColCuQBc0Z8JIaGoT+MBseiZgP9lOeHt+TkV7TJKXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3SdZ5M6pk9KNl3LRzjFXSWUAwASG1/7C9bwMp+nL9VpVjmyGOlxjn3xWpdTSwVmg
         P6y6VkdbdrBE294gJtysQsoEPrGXW+Yu959wUJrVFCbJ0GJhsVgqNzXCZArdbKfAmL
         uPvE+HCUpKxj6XfQCp8Q6LjerhggnRvJn2igZqWVA2dqkjntmJHG7oAHIjty8PEcPw
         5+Ypco1d3ogKbFdE2sb4/FAGJ1zEO37NvzdNu7TmOa+v8TxpmMEuSmBZrTn+ssPGjY
         /jqn2eNtrlteQ3fvVtAB207w5V/UYqOguXRGig8c9s5dP6XwoRrfFHHnFYyvXFh+QG
         vcmnjbe1Nh+gw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Kennedy <george.kennedy@oracle.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 33/68] scsi: scsi_debug: Sanity check block descriptor length in resp_mode_select()
Date:   Tue, 30 Nov 2021 09:46:29 -0500
Message-Id: <20211130144707.944580-33-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit e0a2c28da11e2c2b963fc01d50acbf03045ac732 ]

In resp_mode_select() sanity check the block descriptor len to avoid UAF.

BUG: KASAN: use-after-free in resp_mode_select+0xa4c/0xb40 drivers/scsi/scsi_debug.c:2509
Read of size 1 at addr ffff888026670f50 by task scsicmd/15032

CPU: 1 PID: 15032 Comm: scsicmd Not tainted 5.15.0-01d0625 #15
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Call Trace:
 <TASK>
 dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:107
 print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:257
 kasan_report.cold.14+0x7d/0x117 mm/kasan/report.c:443
 __asan_report_load1_noabort+0x14/0x20 mm/kasan/report_generic.c:306
 resp_mode_select+0xa4c/0xb40 drivers/scsi/scsi_debug.c:2509
 schedule_resp+0x4af/0x1a10 drivers/scsi/scsi_debug.c:5483
 scsi_debug_queuecommand+0x8c9/0x1e70 drivers/scsi/scsi_debug.c:7537
 scsi_queue_rq+0x16b4/0x2d10 drivers/scsi/scsi_lib.c:1521
 blk_mq_dispatch_rq_list+0xb9b/0x2700 block/blk-mq.c:1640
 __blk_mq_sched_dispatch_requests+0x28f/0x590 block/blk-mq-sched.c:325
 blk_mq_sched_dispatch_requests+0x105/0x190 block/blk-mq-sched.c:358
 __blk_mq_run_hw_queue+0xe5/0x150 block/blk-mq.c:1762
 __blk_mq_delay_run_hw_queue+0x4f8/0x5c0 block/blk-mq.c:1839
 blk_mq_run_hw_queue+0x18d/0x350 block/blk-mq.c:1891
 blk_mq_sched_insert_request+0x3db/0x4e0 block/blk-mq-sched.c:474
 blk_execute_rq_nowait+0x16b/0x1c0 block/blk-exec.c:63
 sg_common_write.isra.18+0xeb3/0x2000 drivers/scsi/sg.c:837
 sg_new_write.isra.19+0x570/0x8c0 drivers/scsi/sg.c:775
 sg_ioctl_common+0x14d6/0x2710 drivers/scsi/sg.c:941
 sg_ioctl+0xa2/0x180 drivers/scsi/sg.c:1166
 __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:52
 do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:50
 entry_SYSCALL_64_after_hwframe+0x44/0xae arch/x86/entry/entry_64.S:113

Link: https://lore.kernel.org/r/1637262208-28850-1-git-send-email-george.kennedy@oracle.com
Reported-by: syzkaller <syzkaller@googlegroups.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 871b5e1e5b8f1..4541a080e7a4d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2502,11 +2502,11 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 			    __func__, param_len, res);
 	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
 	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
-	if (md_len > 2) {
+	off = bd_len + (mselect6 ? 4 : 8);
+	if (md_len > 2 || off >= res) {
 		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
 		return check_condition_result;
 	}
-	off = bd_len + (mselect6 ? 4 : 8);
 	mpage = arr[off] & 0x3f;
 	ps = !!(arr[off] & 0x80);
 	if (ps) {
-- 
2.33.0

