Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774175937C3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343549AbiHOTJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343528AbiHOTIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:08:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E274927B04;
        Mon, 15 Aug 2022 11:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CF86B80F99;
        Mon, 15 Aug 2022 18:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928F3C433D6;
        Mon, 15 Aug 2022 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588541;
        bh=wsvOfBT7zwazJEVPwXKfVdFmoSLEK5mtwrZNp4XqzgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RM+J5ofAxnr1UzQ+ZHJW0WPQuqnT+yaYFK8bg4h8+9tkyOvqsgpJkxtNbAIRIzpvJ
         su5Jdr8mB1Rt2rVqQTvuIGn7dFIh7PjTdxqM+f8tONIWACBS96RWPGIUkLzfxJrCFV
         /mpapbBVe/wuhjaJ0yCbJ+EgLiS+n2joI+wHlSTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/779] scsi: iscsi: Fix session removal on shutdown
Date:   Mon, 15 Aug 2022 20:01:21 +0200
Message-Id: <20220815180355.959434818@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 31500e902759322ba3c64b60dabae2704e738df8 ]

When the system is shutting down, iscsid is not running so we will not get
a response to the ISCSI_ERR_INVALID_HOST error event. The system shutdown
will then hang waiting on userspace to remove the session.

This has libiscsi force the destruction of the session from the kernel when
iscsi_host_remove() is called from a driver's shutdown callout.

This fixes a regression added in qedi boot with commit d1f2ce77638d ("scsi:
qedi: Fix host removal with running sessions") which made qedi use the
common session removal function that waits on userspace instead of rolling
its own kernel based removal.

Link: https://lore.kernel.org/r/20220616222738.5722-7-michael.christie@oracle.com
Fixes: d1f2ce77638d ("scsi: qedi: Fix host removal with running sessions")
Tested-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 4 ++--
 drivers/scsi/be2iscsi/be_main.c          | 2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         | 2 +-
 drivers/scsi/cxgbi/libcxgbi.c            | 2 +-
 drivers/scsi/iscsi_tcp.c                 | 4 ++--
 drivers/scsi/libiscsi.c                  | 9 +++++++--
 drivers/scsi/qedi/qedi_main.c            | 9 ++++++---
 include/scsi/libiscsi.h                  | 2 +-
 8 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 776e46ee95da..ef2d165d15a8 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -584,7 +584,7 @@ iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 
 	iscsi_session_teardown(cls_session);
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 	iscsi_host_free(shost);
 }
 
@@ -702,7 +702,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	return cls_session;
 
 remove_host:
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 free_host:
 	iscsi_host_free(shost);
 	return NULL;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e70f69f791db..7974c1326d46 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5741,7 +5741,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	cancel_work_sync(&phba->sess_work);
 
 	beiscsi_iface_destroy_default(phba);
-	iscsi_host_remove(phba->shost);
+	iscsi_host_remove(phba->shost, false);
 	beiscsi_disable_port(phba, 1);
 
 	/* after cancelling boot_work */
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 2e5241d12dc3..85b5aca4b497 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -909,7 +909,7 @@ void bnx2i_free_hba(struct bnx2i_hba *hba)
 {
 	struct Scsi_Host *shost = hba->shost;
 
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 	INIT_LIST_HEAD(&hba->ep_ofld_list);
 	INIT_LIST_HEAD(&hba->ep_active_list);
 	INIT_LIST_HEAD(&hba->ep_destroy_list);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 4365d52c6430..32abdf0fa9aa 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -328,7 +328,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 		chba = cdev->hbas[i];
 		if (chba) {
 			cdev->hbas[i] = NULL;
-			iscsi_host_remove(chba->shost);
+			iscsi_host_remove(chba->shost, false);
 			pci_dev_put(cdev->pdev);
 			iscsi_host_free(chba->shost);
 		}
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 1bc37593c88f..0e52c6499eaf 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -898,7 +898,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 remove_session:
 	iscsi_session_teardown(cls_session);
 remove_host:
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 free_host:
 	iscsi_host_free(shost);
 	return NULL;
@@ -915,7 +915,7 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	iscsi_tcp_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
 
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 	iscsi_host_free(shost);
 }
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0f2c7098f9d6..78de36250b31 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2830,11 +2830,12 @@ static void iscsi_notify_host_removed(struct iscsi_cls_session *cls_session)
 /**
  * iscsi_host_remove - remove host and sessions
  * @shost: scsi host
+ * @is_shutdown: true if called from a driver shutdown callout
  *
  * If there are any sessions left, this will initiate the removal and wait
  * for the completion.
  */
-void iscsi_host_remove(struct Scsi_Host *shost)
+void iscsi_host_remove(struct Scsi_Host *shost, bool is_shutdown)
 {
 	struct iscsi_host *ihost = shost_priv(shost);
 	unsigned long flags;
@@ -2843,7 +2844,11 @@ void iscsi_host_remove(struct Scsi_Host *shost)
 	ihost->state = ISCSI_HOST_REMOVED;
 	spin_unlock_irqrestore(&ihost->lock, flags);
 
-	iscsi_host_for_each_session(shost, iscsi_notify_host_removed);
+	if (!is_shutdown)
+		iscsi_host_for_each_session(shost, iscsi_notify_host_removed);
+	else
+		iscsi_host_for_each_session(shost, iscsi_force_destroy_session);
+
 	wait_event_interruptible(ihost->session_removal_wq,
 				 ihost->num_sessions == 0);
 	if (signal_pending(current))
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index e6dc0b495a82..a117d11f2b07 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2417,9 +2417,12 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	int rval;
 	u16 retry = 10;
 
-	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
-		iscsi_host_remove(qedi->shost);
+	if (mode == QEDI_MODE_NORMAL)
+		iscsi_host_remove(qedi->shost, false);
+	else if (mode == QEDI_MODE_SHUTDOWN)
+		iscsi_host_remove(qedi->shost, true);
 
+	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
 		if (qedi->tmf_thread) {
 			flush_workqueue(qedi->tmf_thread);
 			destroy_workqueue(qedi->tmf_thread);
@@ -2796,7 +2799,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 #ifdef CONFIG_DEBUG_FS
 	qedi_dbg_host_exit(&qedi->dbg_ctx);
 #endif
-	iscsi_host_remove(qedi->shost);
+	iscsi_host_remove(qedi->shost, false);
 stop_iscsi_func:
 	qedi_ops->stop(qedi->cdev);
 stop_slowpath:
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 6ad01d7de480..a071f6ffd7fa 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -400,7 +400,7 @@ extern int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev);
 extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 					  int dd_data_size,
 					  bool xmit_can_sleep);
-extern void iscsi_host_remove(struct Scsi_Host *shost);
+extern void iscsi_host_remove(struct Scsi_Host *shost, bool is_shutdown);
 extern void iscsi_host_free(struct Scsi_Host *shost);
 extern int iscsi_target_alloc(struct scsi_target *starget);
 extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
-- 
2.35.1



