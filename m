Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E3D4A8DA8
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354621AbiBCUcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354309AbiBCUbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B344BC0613E7;
        Thu,  3 Feb 2022 12:31:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7013FB835A8;
        Thu,  3 Feb 2022 20:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17916C340EF;
        Thu,  3 Feb 2022 20:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920264;
        bh=zzMJxbPBiRG2Y2ZlNqrD/+LQlA64/tzHiQCZyC7me9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyipsooJFXjATfxh3Z31O1uXxuz/j91JDm2ZWA49jbiKLOcNbe/yK3HIE1uF3Xpp4
         GT2PiiBhPa9fmAspjDJNSbN3wR0rlz7PpdFvKaHrR5gVYjgR72YoRaAYc/eo8HC0gi
         sM/1szJXu60DRuli/pWU947Fj9GuqEX3LriXhOyk/Zu70O0dnkGhmi0QiYpav0cT9k
         /42RtZ096EPTQlKEVinEr/fm9nNtF0smSbCraiH1AFeHnXr/HbxRl+wfFvAMmiPOoi
         6Q8BsNBBRm8mRe8Y1JFLlafRTowmSH5Miobr5Zu+l3SrOND0I+8anOp3jSo0xFiiUv
         XA5WMf6eXDc0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 29/52] scsi: qedf: Fix refcount issue when LOGO is received during TMF
Date:   Thu,  3 Feb 2022 15:29:23 -0500
Message-Id: <20220203202947.2304-29-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 5239ab63f17cee643bd4bf6addfedebaa7d4f41e ]

Hung task call trace was seen during LOGO processing.

[  974.309060] [0000:00:00.0]:[qedf_eh_device_reset:868]: 1:0:2:0: LUN RESET Issued...
[  974.309065] [0000:00:00.0]:[qedf_initiate_tmf:2422]: tm_flags 0x10 sc_cmd 00000000c16b930f op = 0x2a target_id = 0x2 lun=0
[  974.309178] [0000:00:00.0]:[qedf_initiate_tmf:2431]: portid=016900 tm_flags =LUN RESET
[  974.309222] [0000:00:00.0]:[qedf_initiate_tmf:2438]: orig io_req = 00000000ec78df8f xid = 0x180 ref_cnt = 1.
[  974.309625] host1: rport 016900: Received LOGO request while in state Ready
[  974.309627] host1: rport 016900: Delete port
[  974.309642] host1: rport 016900: work event 3
[  974.309644] host1: rport 016900: lld callback ev 3
[  974.313243] [0000:61:00.2]:[qedf_execute_tmf:2383]:1: fcport is uploading, not executing flush.
[  974.313295] [0000:61:00.2]:[qedf_execute_tmf:2400]:1: task mgmt command success...
[  984.031088] INFO: task jbd2/dm-15-8:7645 blocked for more than 120 seconds.
[  984.031136]       Not tainted 4.18.0-305.el8.x86_64 #1

[  984.031166] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  984.031209] jbd2/dm-15-8    D    0  7645      2 0x80004080
[  984.031212] Call Trace:
[  984.031222]  __schedule+0x2c4/0x700
[  984.031230]  ? unfreeze_partials.isra.83+0x16e/0x1a0
[  984.031233]  ? bit_wait_timeout+0x90/0x90
[  984.031235]  schedule+0x38/0xa0
[  984.031238]  io_schedule+0x12/0x40
[  984.031240]  bit_wait_io+0xd/0x50
[  984.031243]  __wait_on_bit+0x6c/0x80
[  984.031248]  ? free_buffer_head+0x21/0x50
[  984.031251]  out_of_line_wait_on_bit+0x91/0xb0
[  984.031257]  ? init_wait_var_entry+0x50/0x50
[  984.031268]  jbd2_journal_commit_transaction+0x112e/0x19f0 [jbd2]
[  984.031280]  kjournald2+0xbd/0x270 [jbd2]
[  984.031284]  ? finish_wait+0x80/0x80
[  984.031291]  ? commit_timeout+0x10/0x10 [jbd2]
[  984.031294]  kthread+0x116/0x130
[  984.031300]  ? kthread_flush_work_fn+0x10/0x10
[  984.031305]  ret_from_fork+0x1f/0x40

There was a ref count issue when LOGO is received during TMF. This leads to
one of the I/Os hanging with the driver. Fix the ref count.

Link: https://lore.kernel.org/r/20220117135311.6256-3-njavali@marvell.com
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 99a56ca1fb163..fab43dabe5b31 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2250,6 +2250,7 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 	    io_req->tm_flags == FCP_TMF_TGT_RESET) {
 		clear_bit(QEDF_CMD_OUTSTANDING, &io_req->flags);
 		io_req->sc_cmd = NULL;
+		kref_put(&io_req->refcount, qedf_release_cmd);
 		complete(&io_req->tm_done);
 	}
 
-- 
2.34.1

