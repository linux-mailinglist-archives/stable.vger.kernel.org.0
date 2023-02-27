Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321106A3749
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjB0CIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjB0CH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:07:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424891ADC9;
        Sun, 26 Feb 2023 18:06:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9227260CA3;
        Mon, 27 Feb 2023 02:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B18C4339C;
        Mon, 27 Feb 2023 02:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463551;
        bh=mxqtPc31wVf13akapwPkx7fnH6psPC0aqeJoaIzSHJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moEaA2jkvCgrpyrWFLcbmsed7YoofEGG6nepWVv96eAhiV7c4RkKwGpWoy6eFdC7c
         CfIl06NW3wyOf4/2H0Mk0sG7jtAHOTMeaSE2uHEWoszOYlYIvq4XZi/rBq/J3u9IjL
         hWF0hhn1Tf0qW7sjJAvwtEsxlbzCejkNErkBs7r/ay1/mj83A+cRp96OWXXuo8nvaR
         GJcc8WpWRtiv/iJoh9ZIVe2Yt4C+OrFjvs0CrSkxM8LXN+Vc5X4A7FAt2LvFFoQgDn
         +gg5jKElPEnw2+fPS43A82e6ycZtSk+hk6I90JNVpAL6KHdVCMQG8swjqoP3Qe29tx
         4D7ho1HHTNh7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 13/58] scsi: lpfc: Fix use-after-free KFENCE violation during sysfs firmware write
Date:   Sun, 26 Feb 2023 21:04:11 -0500
Message-Id: <20230227020457.1048737-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 21681b81b9ae548c5dae7ae00d931197a27f480c ]

During the sysfs firmware write process, a use-after-free read warning is
logged from the lpfc_wr_object() routine:

  BUG: KFENCE: use-after-free read in lpfc_wr_object+0x235/0x310 [lpfc]
  Use-after-free read at 0x0000000000cf164d (in kfence-#111):
  lpfc_wr_object+0x235/0x310 [lpfc]
  lpfc_write_firmware.cold+0x206/0x30d [lpfc]
  lpfc_sli4_request_firmware_update+0xa6/0x100 [lpfc]
  lpfc_request_firmware_upgrade_store+0x66/0xb0 [lpfc]
  kernfs_fop_write_iter+0x121/0x1b0
  new_sync_write+0x11c/0x1b0
  vfs_write+0x1ef/0x280
  ksys_write+0x5f/0xe0
  do_syscall_64+0x59/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

The driver accessed wr_object pointer data, which was initialized into
mailbox payload memory, after the mailbox object was released back to the
mailbox pool.

Fix by moving the mailbox free calls to the end of the routine ensuring
that we don't reference internal mailbox memory after release.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 21c52154626f1..b93c948c4fcc4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20802,6 +20802,7 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 	struct lpfc_mbx_wr_object *wr_object;
 	LPFC_MBOXQ_t *mbox;
 	int rc = 0, i = 0;
+	int mbox_status = 0;
 	uint32_t shdr_status, shdr_add_status, shdr_add_status_2;
 	uint32_t shdr_change_status = 0, shdr_csf = 0;
 	uint32_t mbox_tmo;
@@ -20847,11 +20848,15 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 	wr_object->u.request.bde_count = i;
 	bf_set(lpfc_wr_object_write_length, &wr_object->u.request, written);
 	if (!phba->sli4_hba.intr_enable)
-		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+		mbox_status = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
 		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
-		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+		mbox_status = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
+
+	/* The mbox status needs to be maintained to detect MBOX_TIMEOUT. */
+	rc = mbox_status;
+
 	/* The IOCTL status is embedded in the mailbox subheader. */
 	shdr_status = bf_get(lpfc_mbox_hdr_status,
 			     &wr_object->header.cfg_shdr.response);
@@ -20866,10 +20871,6 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 				  &wr_object->u.response);
 	}
 
-	if (!phba->sli4_hba.intr_enable)
-		mempool_free(mbox, phba->mbox_mem_pool);
-	else if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
 	if (shdr_status || shdr_add_status || shdr_add_status_2 || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3025 Write Object mailbox failed with "
@@ -20887,6 +20888,12 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 		lpfc_log_fw_write_cmpl(phba, shdr_status, shdr_add_status,
 				       shdr_add_status_2, shdr_change_status,
 				       shdr_csf);
+
+	if (!phba->sli4_hba.intr_enable)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	else if (mbox_status != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+
 	return rc;
 }
 
-- 
2.39.0

