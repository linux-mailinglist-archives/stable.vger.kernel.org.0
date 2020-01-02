Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5963C12EDD3
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgABWcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:32:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730377AbgABWcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:32:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8615222C3;
        Thu,  2 Jan 2020 22:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004335;
        bh=cjjj8HUL2ccSlahCzMTsUIhhclgLz0kTzARVr0PFoYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TUjJ/qFtFkbAuDFnfmDXg/x9GaI3KIogECE/7mzdTL6om5SeLWi7ozz+7diMYw0k
         HrUvBXFM3aonxcrvUscUCVyHV8Q0sYAdTiia8QR5AHXWZ1nioTgRsqdGw6T3fNF7BP
         TGBYDnpyCSPdSQSUZGLU1DFc+Su+WmidHyFHgFpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 136/171] scsi: atari_scsi: sun3_scsi: Set sg_tablesize to 1 instead of SG_NONE
Date:   Thu,  2 Jan 2020 23:07:47 +0100
Message-Id: <20200102220605.968395892@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 79172ab20bfd8437b277254028efdb68484e2c21 ]

Since the scsi subsystem adopted the blk-mq API, a host with zero
sg_tablesize crashes with a NULL pointer dereference.

blk_queue_max_segments: set to minimum 1
scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    2.5+ PQ: 0 ANSI: 5
scsi target0:0:0: Beginning Domain Validation
scsi target0:0:0: Domain Validation skipping write tests
scsi target0:0:0: Ending Domain Validation
blk_queue_max_segments: set to minimum 1
scsi 0:0:1:0: Direct-Access     QEMU     QEMU HARDDISK    2.5+ PQ: 0 ANSI: 5
scsi target0:0:1: Beginning Domain Validation
scsi target0:0:1: Domain Validation skipping write tests
scsi target0:0:1: Ending Domain Validation
blk_queue_max_segments: set to minimum 1
scsi 0:0:2:0: CD-ROM            QEMU     QEMU CD-ROM      2.5+ PQ: 0 ANSI: 5
scsi target0:0:2: Beginning Domain Validation
scsi target0:0:2: Domain Validation skipping write tests
scsi target0:0:2: Ending Domain Validation
blk_queue_max_segments: set to minimum 1
blk_queue_max_segments: set to minimum 1
blk_queue_max_segments: set to minimum 1
blk_queue_max_segments: set to minimum 1
sr 0:0:2:0: Power-on or device reset occurred
sd 0:0:0:0: Power-on or device reset occurred
sd 0:0:1:0: Power-on or device reset occurred
sd 0:0:0:0: [sda] 10485762 512-byte logical blocks: (5.37 GB/5.00 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Unable to handle kernel NULL pointer dereference at virtual address (ptrval)
Oops: 00000000
Modules linked in:
PC: [<001cd874>] blk_mq_free_request+0x66/0xe2
SR: 2004  SP: (ptrval)  a2: 00874520
d0: 00000000    d1: 00000000    d2: 009ba800    d3: 00000000
d4: 00000000    d5: 08000002    a0: 0087be68    a1: 009a81e0
Process kworker/u2:2 (pid: 15, task=(ptrval))
Frame format=7 eff addr=0000007a ssw=0505 faddr=0000007a
wb 1 stat/addr/data: 0000 00000000 00000000
wb 2 stat/addr/data: 0000 00000000 00000000
wb 3 stat/addr/data: 0000 0000007a 00000000
push data: 00000000 00000000 00000000 00000000
Stack from 0087bd98:
        00000002 00000000 0087be72 009a7820 0087bdb4 001c4f6c 009a7820 0087bdd4
        0024d200 009a7820 0024d0dc 0087be72 009baa00 0087be68 009a5000 0087be7c
        00265d10 009a5000 0087be72 00000003 00000000 00000000 00000000 0087be68
        00000bb8 00000005 00000000 00000000 00000000 00000000 00265c56 00000000
        009ba60c 0036ddf4 00000002 ffffffff 009baa00 009ba600 009a50d6 0087be74
        00227ba0 009baa08 00000001 009baa08 009ba60c 0036ddf4 00000000 00000000
Call Trace: [<001c4f6c>] blk_put_request+0xe/0x14
 [<0024d200>] __scsi_execute+0x124/0x174
 [<0024d0dc>] __scsi_execute+0x0/0x174
 [<00265d10>] sd_revalidate_disk+0xba/0x1f02
 [<00265c56>] sd_revalidate_disk+0x0/0x1f02
 [<0036ddf4>] strlen+0x0/0x22
 [<00227ba0>] device_add+0x3da/0x604
 [<0036ddf4>] strlen+0x0/0x22
 [<00267e64>] sd_probe+0x30c/0x4b4
 [<0002da44>] process_one_work+0x0/0x402
 [<0022b978>] really_probe+0x226/0x354
 [<0022bc34>] driver_probe_device+0xa4/0xf0
 [<0002da44>] process_one_work+0x0/0x402
 [<0022bcd0>] __driver_attach_async_helper+0x50/0x70
 [<00035dae>] async_run_entry_fn+0x36/0x130
 [<0002db88>] process_one_work+0x144/0x402
 [<0002e1aa>] worker_thread+0x0/0x570
 [<0002e29a>] worker_thread+0xf0/0x570
 [<0002e1aa>] worker_thread+0x0/0x570
 [<003768d8>] schedule+0x0/0xb8
 [<0003f58c>] __init_waitqueue_head+0x0/0x12
 [<00033e92>] kthread+0xc2/0xf6
 [<000331e8>] kthread_parkme+0x0/0x4e
 [<003768d8>] schedule+0x0/0xb8
 [<00033dd0>] kthread+0x0/0xf6
 [<00002c10>] ret_from_kernel_thread+0xc/0x14
Code: 0280 0006 0800 56c0 4400 0280 0000 00ff <52b4> 0c3a 082b 0006 0013 6706 2042 53a8 00c4 4ab9 0047 3374 6640 202d 000c 670c
Disabling lock debugging due to kernel taint

Avoid this by setting sg_tablesize = 1.

Link: https://lore.kernel.org/r/4567bcae94523b47d6f3b77450ba305823bca479.1572656814.git.fthain@telegraphics.com.au
Reported-and-tested-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/atari_scsi.c | 6 +++---
 drivers/scsi/mac_scsi.c   | 2 +-
 drivers/scsi/sun3_scsi.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index a59ad94ea52b..9dc4b689f94b 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -753,7 +753,7 @@ static int __init atari_scsi_probe(struct platform_device *pdev)
 		atari_scsi_template.sg_tablesize = SG_ALL;
 	} else {
 		atari_scsi_template.can_queue    = 1;
-		atari_scsi_template.sg_tablesize = SG_NONE;
+		atari_scsi_template.sg_tablesize = 1;
 	}
 
 	if (setup_can_queue > 0)
@@ -762,8 +762,8 @@ static int __init atari_scsi_probe(struct platform_device *pdev)
 	if (setup_cmd_per_lun > 0)
 		atari_scsi_template.cmd_per_lun = setup_cmd_per_lun;
 
-	/* Leave sg_tablesize at 0 on a Falcon! */
-	if (ATARIHW_PRESENT(TT_SCSI) && setup_sg_tablesize >= 0)
+	/* Don't increase sg_tablesize on Falcon! */
+	if (ATARIHW_PRESENT(TT_SCSI) && setup_sg_tablesize > 0)
 		atari_scsi_template.sg_tablesize = setup_sg_tablesize;
 
 	if (setup_hostid >= 0) {
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 5648d30c7376..5aa60bbbd09a 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -378,7 +378,7 @@ static int __init mac_scsi_probe(struct platform_device *pdev)
 		mac_scsi_template.can_queue = setup_can_queue;
 	if (setup_cmd_per_lun > 0)
 		mac_scsi_template.cmd_per_lun = setup_cmd_per_lun;
-	if (setup_sg_tablesize >= 0)
+	if (setup_sg_tablesize > 0)
 		mac_scsi_template.sg_tablesize = setup_sg_tablesize;
 	if (setup_hostid >= 0)
 		mac_scsi_template.this_id = setup_hostid & 7;
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 3c4c07038948..6f75693cf7d2 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -419,7 +419,7 @@ static struct scsi_host_template sun3_scsi_template = {
 	.eh_bus_reset_handler	= sun3scsi_bus_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
-	.sg_tablesize		= SG_NONE,
+	.sg_tablesize		= 1,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
@@ -440,7 +440,7 @@ static int __init sun3_scsi_probe(struct platform_device *pdev)
 		sun3_scsi_template.can_queue = setup_can_queue;
 	if (setup_cmd_per_lun > 0)
 		sun3_scsi_template.cmd_per_lun = setup_cmd_per_lun;
-	if (setup_sg_tablesize >= 0)
+	if (setup_sg_tablesize > 0)
 		sun3_scsi_template.sg_tablesize = setup_sg_tablesize;
 	if (setup_hostid >= 0)
 		sun3_scsi_template.this_id = setup_hostid & 7;
-- 
2.20.1



