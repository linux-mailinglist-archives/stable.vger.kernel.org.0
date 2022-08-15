Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F97594C35
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344241AbiHPAsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349372AbiHPAqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:46:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4996FB5E6B;
        Mon, 15 Aug 2022 13:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C90CB80EB1;
        Mon, 15 Aug 2022 20:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11E8C433D6;
        Mon, 15 Aug 2022 20:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596312;
        bh=rBDcUaW6y7qrMZnKzZg6t/2s8g0030ERifBQbxVCGxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oi2Ad80h9+Rm15rgTSKLZeUrMulW0k7Z2MYWtEMFDU5QFAtbVtaahhQiAYlj/5K3N
         +0zYU1NSzdzwrDh4g8uZIAtblMtc7kODFfmeTvPEC0YFE5fXt3bpH3Jj0mp404X8uf
         AYic8+GuF5JZ7e3bQjNS5+GiImjaRQrUTT3mtXvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.19 1038/1157] scsi: qla2xxx: Fix crash due to stale SRB access around I/O timeouts
Date:   Mon, 15 Aug 2022 20:06:34 +0200
Message-Id: <20220815180521.511042881@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Arun Easi <aeasi@marvell.com>

commit c39587bc0abaf16593f7abcdf8aeec3c038c7d52 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |   43 ++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1337,21 +1337,20 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
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
@@ -1378,12 +1377,32 @@ qla2x00_eh_wait_for_pending_commands(scs
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
 
@@ -1420,7 +1439,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 		return err;
 
 	if (fcport->deleted)
-		return SUCCESS;
+		return FAILED;
 
 	ql_log(ql_log_info, vha, 0x8009,
 	    "DEVICE RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", vha->host_no,
@@ -1488,7 +1507,7 @@ qla2xxx_eh_target_reset(struct scsi_cmnd
 		return err;
 
 	if (fcport->deleted)
-		return SUCCESS;
+		return FAILED;
 
 	ql_log(ql_log_info, vha, 0x8009,
 	    "TARGET RESET ISSUED nexus=%ld:%d cmd=%p.\n", vha->host_no,


