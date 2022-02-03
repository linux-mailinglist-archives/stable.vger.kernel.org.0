Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580C94A8E9A
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbiBCUiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:38:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42230 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbiBCUgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:36:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D092360AE0;
        Thu,  3 Feb 2022 20:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368F6C340EB;
        Thu,  3 Feb 2022 20:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920564;
        bh=+XLm7thfyAJVlyr8gpH4/JadVRLwjIRmSvXfhKOStXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLk1h7X0BgP450VfGFMcv9e7YpwINDKKyG3GkTVCmom+16UQMrNWSa9Zdj/KN+Q4N
         972ihKYcvrIEAHoB1+79rRQkVQiysD4MBOzgMZo+frl9A5qkhs/mzX/G9J5itvrT2F
         ijPLfiG2JsHoMCjKpZTF0fpJdJY9x1wjpW32bjYGbUlzfu4VdsR1ll1S0vcCfx7dZ8
         Eepick2rZY0Jc0UaAvlzwu/gxjOKNGsyQ9ppMH80XOKoF7v7S5f4sNImWFZeax6pcs
         bMpUIstxxMC9joIKKCChJrrOLnoVwh/BWsMdOU3NE7ONwTCdbAMsXimFJtUVdAL4BH
         Zhizh8Omzugrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/15] scsi: qedf: Fix refcount issue when LOGO is received during TMF
Date:   Thu,  3 Feb 2022 15:35:40 -0500
Message-Id: <20220203203545.3879-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203545.3879-1-sashal@kernel.org>
References: <20220203203545.3879-1-sashal@kernel.org>
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
index 4e8a284e606c0..d02d1ef0d0116 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2253,6 +2253,7 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 	    io_req->tm_flags == FCP_TMF_TGT_RESET) {
 		clear_bit(QEDF_CMD_OUTSTANDING, &io_req->flags);
 		io_req->sc_cmd = NULL;
+		kref_put(&io_req->refcount, qedf_release_cmd);
 		complete(&io_req->tm_done);
 	}
 
-- 
2.34.1

