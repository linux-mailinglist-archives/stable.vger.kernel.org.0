Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AB9657F72
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbiL1QFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiL1QE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:04:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7DE193C0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:04:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CECA0B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49192C433D2;
        Wed, 28 Dec 2022 16:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243493;
        bh=VJogmBw8B5TDJSm1Dx40EjiDykgr1JCGBYsI90FICZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtTLsq+LoHAJacG0z3v7dCIscMCf8q+zTNvmIyM5n02Sj+EcXbKD885NKE/0f4Ihn
         iC/6JahxTP2PVZML4fuQAZKUdw/CTnI8JYrkvkbyTEhA8aeAknnlEquU2EcAxf1T32
         VhohvMng+Rvn8bz+3JqRzGZGa2QBpTkzQxmLAE5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marco Patalano <mpatalan@redhat.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 727/731] scsi: qla2xxx: Fix crash when I/O abort times out
Date:   Wed, 28 Dec 2022 15:43:54 +0100
Message-Id: <20221228144317.516204159@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Arun Easi <aeasi@marvell.com>

commit 68ad83188d782b2ecef2e41ac245d27e0710fe8e upstream.

While performing CPU hotplug, a crash with the following stack was seen:

Call Trace:
     qla24xx_process_response_queue+0x42a/0x970 [qla2xxx]
     qla2x00_start_nvme_mq+0x3a2/0x4b0 [qla2xxx]
     qla_nvme_post_cmd+0x166/0x240 [qla2xxx]
     nvme_fc_start_fcp_op.part.0+0x119/0x2e0 [nvme_fc]
     blk_mq_dispatch_rq_list+0x17b/0x610
     __blk_mq_sched_dispatch_requests+0xb0/0x140
     blk_mq_sched_dispatch_requests+0x30/0x60
     __blk_mq_run_hw_queue+0x35/0x90
     __blk_mq_delay_run_hw_queue+0x161/0x180
     blk_execute_rq+0xbe/0x160
     __nvme_submit_sync_cmd+0x16f/0x220 [nvme_core]
     nvmf_connect_admin_queue+0x11a/0x170 [nvme_fabrics]
     nvme_fc_create_association.cold+0x50/0x3dc [nvme_fc]
     nvme_fc_connect_ctrl_work+0x19/0x30 [nvme_fc]
     process_one_work+0x1e8/0x3c0

On abort timeout, completion was called without checking if the I/O was
already completed.

Verify that I/O and abort request are indeed outstanding before attempting
completion.

Fixes: 71c80b75ce8f ("scsi: qla2xxx: Do command completion on abort timeout")
Reported-by: Marco Patalano <mpatalan@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20221129092634.15347-1-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -110,6 +110,7 @@ static void qla24xx_abort_iocb_timeout(v
 	struct qla_qpair *qpair = sp->qpair;
 	u32 handle;
 	unsigned long flags;
+	int sp_found = 0, cmdsp_found = 0;
 
 	if (sp->cmd_sp)
 		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
@@ -124,18 +125,21 @@ static void qla24xx_abort_iocb_timeout(v
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	for (handle = 1; handle < qpair->req->num_outstanding_cmds; handle++) {
 		if (sp->cmd_sp && (qpair->req->outstanding_cmds[handle] ==
-		    sp->cmd_sp))
+		    sp->cmd_sp)) {
 			qpair->req->outstanding_cmds[handle] = NULL;
+			cmdsp_found = 1;
+		}
 
 		/* removing the abort */
 		if (qpair->req->outstanding_cmds[handle] == sp) {
 			qpair->req->outstanding_cmds[handle] = NULL;
+			sp_found = 1;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-	if (sp->cmd_sp) {
+	if (cmdsp_found && sp->cmd_sp) {
 		/*
 		 * This done function should take care of
 		 * original command ref: INIT
@@ -143,8 +147,10 @@ static void qla24xx_abort_iocb_timeout(v
 		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
 	}
 
-	abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
-	sp->done(sp, QLA_OS_TIMER_EXPIRED);
+	if (sp_found) {
+		abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
+		sp->done(sp, QLA_OS_TIMER_EXPIRED);
+	}
 }
 
 static void qla24xx_abort_sp_done(srb_t *sp, int res)


