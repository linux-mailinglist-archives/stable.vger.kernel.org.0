Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268B811B78B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731357AbfLKQId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731071AbfLKPMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B048208C3;
        Wed, 11 Dec 2019 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077134;
        bh=O/W07dSdGlWbNDMUsUSBXfWXUFhILzgxa65l8f5AhjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cf//cW48+l1aSKwTZOFOjoK8qE8LEFp4E9cmHVgmfChpEDwMRxc5bYWY++0apO3lE
         eRW5lL+SxnFBO967YxgtPjJBVg3PLVZRwR8+tSrdsi6VF5iSeu7QdgXUAujZ6EBkaw
         jD4BnM8mDRPaIRJxJBqeaN5siI1O215Y41/527EA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 021/134] scsi: hisi_sas: Replace in_softirq() check in hisi_sas_task_exec()
Date:   Wed, 11 Dec 2019 10:09:57 -0500
Message-Id: <20191211151150.19073-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 550c0d89d52d3bec5c299f69b4ed5d2ee6b8a9a6 ]

For IOs from upper layer, preemption may be disabled as it may be called by
function __blk_mq_delay_run_hw_queue which will call get_cpu() (it disables
preemption). So if flags HISI_SAS_REJECT_CMD_BIT is set in function
hisi_sas_task_exec(), it may disable preempt twice after down() and up()
which will cause following call trace:

BUG: scheduling while atomic: fio/60373/0x00000002
Call trace:
dump_backtrace+0x0/0x150
show_stack+0x24/0x30
dump_stack+0xa0/0xc4
__schedule_bug+0x68/0x88
__schedule+0x4b8/0x548
schedule+0x40/0xd0
schedule_timeout+0x200/0x378
__down+0x78/0xc8
down+0x54/0x70
hisi_sas_task_exec.isra.10+0x598/0x8d8 [hisi_sas_main]
hisi_sas_queue_command+0x28/0x38 [hisi_sas_main]
sas_queuecommand+0x168/0x1b0 [libsas]
scsi_queue_rq+0x2ac/0x980
blk_mq_dispatch_rq_list+0xb0/0x550
blk_mq_do_dispatch_sched+0x6c/0x110
blk_mq_sched_dispatch_requests+0x114/0x1d8
__blk_mq_run_hw_queue+0xb8/0x130
__blk_mq_delay_run_hw_queue+0x1c0/0x220
blk_mq_run_hw_queue+0xb0/0x128
blk_mq_sched_insert_requests+0xdc/0x208
blk_mq_flush_plug_list+0x1b4/0x3a0
blk_flush_plug_list+0xdc/0x110
blk_finish_plug+0x3c/0x50
blkdev_direct_IO+0x404/0x550
generic_file_read_iter+0x9c/0x848
blkdev_read_iter+0x50/0x78
aio_read+0xc8/0x170
io_submit_one+0x1fc/0x8d8
__arm64_sys_io_submit+0xdc/0x280
el0_svc_common.constprop.0+0xe0/0x1e0
el0_svc_handler+0x34/0x90
el0_svc+0x10/0x14
...

To solve the issue, check preemptible() to avoid disabling preempt multiple
when flag HISI_SAS_REJECT_CMD_BIT is set.

Link: https://lore.kernel.org/r/1571926105-74636-5-git-send-email-john.garry@huawei.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 0847e682797be..20f0cb4698b7f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -587,7 +587,13 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	dev = hisi_hba->dev;
 
 	if (unlikely(test_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags))) {
-		if (in_softirq())
+		/*
+		 * For IOs from upper layer, it may already disable preempt
+		 * in the IO path, if disable preempt again in down(),
+		 * function schedule() will report schedule_bug(), so check
+		 * preemptible() before goto down().
+		 */
+		if (!preemptible())
 			return -EINVAL;
 
 		down(&hisi_hba->sem);
-- 
2.20.1

