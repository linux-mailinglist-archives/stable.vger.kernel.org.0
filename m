Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB635591F77
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 12:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbiHNKNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 06:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiHNKNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 06:13:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C1A201BE
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 03:13:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C36DB6100C
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 10:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE952C433D6;
        Sun, 14 Aug 2022 10:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660472028;
        bh=kTn4tSnnqVKGmOucpNzdmTHBhXf0J2qGExquXQJCkow=;
        h=Subject:To:Cc:From:Date:From;
        b=Yltj6CzbWZenOzsQLnC0f3o/UH7N3+cNUfWjHo0zwaLavvh89s6G47bW8Xcs9u1ZQ
         7cuWU8uf8efoDiUZg9qP82WvRypwkqiZq+zS/clablrc1A1s4i+PGubon78eOomNJw
         /MYkWWw8UgnHK5XrbDCK/yKQ3on5TaLx4JdsqYUc=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix crash due to stale SRB access around I/O" failed to apply to 5.4-stable tree
To:     aeasi@marvell.com, martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Aug 2022 12:13:35 +0200
Message-ID: <166047201562213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c39587bc0abaf16593f7abcdf8aeec3c038c7d52 Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Wed, 15 Jun 2022 22:35:02 -0700
Subject: [PATCH] scsi: qla2xxx: Fix crash due to stale SRB access around I/O
 timeouts

Ensure SRB is returned during I/O timeout error escalation. If that is not
possible fail the escalation path.

Following crash stack was seen:

BUG: unable to handle kernel paging request at 0000002f56aa90f8
IP: qla_chk_edif_rx_sa_delete_pending+0x14/0x30 [qla2xxx]
Call Trace:
 ? qla2x00_status_entry+0x19f/0x1c50 [qla2xxx]
 ? qla2x00_start_sp+0x116/0x1170 [qla2xxx]
 ? dma_pool_alloc+0x1d6/0x210
 ? mempool_alloc+0x54/0x130
 ? qla24xx_process_response_queue+0x548/0x12b0 [qla2xxx]
 ? qla_do_work+0x2d/0x40 [qla2xxx]
 ? process_one_work+0x14c/0x390

Link: https://lore.kernel.org/r/20220616053508.27186-6-njavali@marvell.com
Fixes: d74595278f4a ("scsi: qla2xxx: Add multiple queue pair functionality.")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 210fb5c52421..1c7fb6484db2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1342,21 +1342,20 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 /*
  * Returns: QLA_SUCCESS or QLA_FUNCTION_FAILED.
  */
-int
-qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
-	uint64_t l, enum nexus_wait_type type)
+static int
+__qla2x00_eh_wait_for_pending_commands(struct qla_qpair *qpair, unsigned int t,
+				       uint64_t l, enum nexus_wait_type type)
 {
 	int cnt, match, status;
 	unsigned long flags;
-	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req;
+	scsi_qla_host_t *vha = qpair->vha;
+	struct req_que *req = qpair->req;
 	srb_t *sp;
 	struct scsi_cmnd *cmd;
 
 	status = QLA_SUCCESS;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	req = vha->req;
+	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	for (cnt = 1; status == QLA_SUCCESS &&
 		cnt < req->num_outstanding_cmds; cnt++) {
 		sp = req->outstanding_cmds[cnt];
@@ -1383,12 +1382,32 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 		if (!match)
 			continue;
 
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 		status = qla2x00_eh_wait_on_command(cmd);
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+	return status;
+}
+
+int
+qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
+				     uint64_t l, enum nexus_wait_type type)
+{
+	struct qla_qpair *qpair;
+	struct qla_hw_data *ha = vha->hw;
+	int i, status = QLA_SUCCESS;
 
+	status = __qla2x00_eh_wait_for_pending_commands(ha->base_qpair, t, l,
+							type);
+	for (i = 0; status == QLA_SUCCESS && i < ha->max_qpairs; i++) {
+		qpair = ha->queue_pair_map[i];
+		if (!qpair)
+			continue;
+		status = __qla2x00_eh_wait_for_pending_commands(qpair, t, l,
+								type);
+	}
 	return status;
 }
 
@@ -1425,7 +1444,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		return err;
 
 	if (fcport->deleted)
-		return SUCCESS;
+		return FAILED;
 
 	ql_log(ql_log_info, vha, 0x8009,
 	    "DEVICE RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", vha->host_no,
@@ -1493,7 +1512,7 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 		return err;
 
 	if (fcport->deleted)
-		return SUCCESS;
+		return FAILED;
 
 	ql_log(ql_log_info, vha, 0x8009,
 	    "TARGET RESET ISSUED nexus=%ld:%d cmd=%p.\n", vha->host_no,

