Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D876C177B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjCTPOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbjCTPN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:13:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8051FDE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:08:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 799AD614CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C379C433D2;
        Mon, 20 Mar 2023 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324933;
        bh=ZoihgBCB7rET4pBCs/jDiS3kdfArkE05Mmc1Tn/m0Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyBYDuzcQXvh37f1k2dlPevfA32LLYJUkogrA6YGlqPNmKdTu4NIe703bY/7GuqWs
         brhwrzmDxK/SNdw0R9XXGaqzeu4lxThFUdF9DMH1Uiam5wF3e4tRGOLCLY++ze+RQ2
         lCxj633qFjSofaNl3LOXzV78f4FtOTjWjAaKzoEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/198] scsi: mpi3mr: ioctl timeout when disabling/enabling interrupt
Date:   Mon, 20 Mar 2023 15:52:40 +0100
Message-Id: <20230320145508.424877368@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 02ca7da2919ada525fb424640205110e24646b50 ]

As part of Task Management handling, the driver will disable and enable the
MSIx index zero which belongs to the Admin reply queue. During this
transition the driver loses some interrupts and this leads to Admin request
and ioctl timeouts.

After enabling the interrupts, poll the Admin reply queue to avoid
timeouts.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230228140835.4075-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ce756daa36e1 ("scsi: mpi3mr: Fix expander node leak in mpi3mr_remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 12 ++++++++++--
 drivers/scsi/mpi3mr/mpi3mr_os.c |  1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8a438f248a820..68f29ffb05b82 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -903,6 +903,7 @@ struct scmd_priv {
  * @admin_reply_ephase:Admin reply queue expected phase
  * @admin_reply_base: Admin reply queue base virtual address
  * @admin_reply_dma: Admin reply queue base dma address
+ * @admin_reply_q_in_use: Queue is handled by poll/ISR
  * @ready_timeout: Controller ready timeout
  * @intr_info: Interrupt cookie pointer
  * @intr_info_count: Number of interrupt cookies
@@ -1056,6 +1057,7 @@ struct mpi3mr_ioc {
 	u8 admin_reply_ephase;
 	void *admin_reply_base;
 	dma_addr_t admin_reply_dma;
+	atomic_t admin_reply_q_in_use;
 
 	u32 ready_timeout;
 
@@ -1391,4 +1393,5 @@ void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_cmds_for_unrecovered_controller(struct mpi3mr_ioc *mrioc);
 void mpi3mr_free_enclosure_list(struct mpi3mr_ioc *mrioc);
+int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1a404d71b88cf..74fa7f90399e3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -415,7 +415,7 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 		    le64_to_cpu(scsi_reply->sense_data_buffer_address));
 }
 
-static int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
+int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 {
 	u32 exp_phase = mrioc->admin_reply_ephase;
 	u32 admin_reply_ci = mrioc->admin_reply_ci;
@@ -423,12 +423,17 @@ static int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 	u64 reply_dma = 0;
 	struct mpi3_default_reply_descriptor *reply_desc;
 
+	if (!atomic_add_unless(&mrioc->admin_reply_q_in_use, 1, 1))
+		return 0;
+
 	reply_desc = (struct mpi3_default_reply_descriptor *)mrioc->admin_reply_base +
 	    admin_reply_ci;
 
 	if ((le16_to_cpu(reply_desc->reply_flags) &
-	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
+	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase) {
+		atomic_dec(&mrioc->admin_reply_q_in_use);
 		return 0;
+	}
 
 	do {
 		if (mrioc->unrecoverable)
@@ -454,6 +459,7 @@ static int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 	writel(admin_reply_ci, &mrioc->sysif_regs->admin_reply_queue_ci);
 	mrioc->admin_reply_ci = admin_reply_ci;
 	mrioc->admin_reply_ephase = exp_phase;
+	atomic_dec(&mrioc->admin_reply_q_in_use);
 
 	return num_admin_replies;
 }
@@ -2605,6 +2611,7 @@ static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc)
 	mrioc->admin_reply_ci = 0;
 	mrioc->admin_reply_ephase = 1;
 	mrioc->admin_reply_base = NULL;
+	atomic_set(&mrioc->admin_reply_q_in_use, 0);
 
 	if (!mrioc->admin_req_base) {
 		mrioc->admin_req_base = dma_alloc_coherent(&mrioc->pdev->dev,
@@ -4168,6 +4175,7 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		memset(mrioc->admin_req_base, 0, mrioc->admin_req_q_sz);
 	if (mrioc->admin_reply_base)
 		memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
+	atomic_set(&mrioc->admin_reply_q_in_use, 0);
 
 	if (mrioc->init_cmds.reply) {
 		memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5698e7b90f852..2e546c80d98ce 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3720,6 +3720,7 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 		mpi3mr_poll_pend_io_completions(mrioc);
 		mpi3mr_ioc_enable_intr(mrioc);
 		mpi3mr_poll_pend_io_completions(mrioc);
+		mpi3mr_process_admin_reply_q(mrioc);
 	}
 	switch (tm_type) {
 	case MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
-- 
2.39.2



