Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E060593BBE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343538AbiHOTnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345227AbiHOTmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:42:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878C86BD41;
        Mon, 15 Aug 2022 11:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CE6B611DD;
        Mon, 15 Aug 2022 18:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1FCC433D7;
        Mon, 15 Aug 2022 18:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589294;
        bh=0Q3PGTofDbqa7zbcMoFIWnJsfFMcWuzA/R+S9+DVup4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9ShFKEBleUqkD9eCHKziyJkWdKRhJXxDp1ePj/wHtiW4gWGoIZB1zpP6SQSmD4Gv
         f9jSwOGjZ9qSZROCArce7XYs9NySfb784DWmihlaFlLyEYtvh7z6X5Gg+4zDvHmro3
         3iXNiKO4Am0my6eKtcX+t9m25jzaUM5FmRQyUa2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 674/779] scsi: qla2xxx: Fix crash due to stale SRB access around I/O timeouts
Date:   Mon, 15 Aug 2022 20:05:18 +0200
Message-Id: <20220815180406.149098487@linuxfoundation.org>
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
@@ -1333,21 +1333,20 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
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
@@ -1374,12 +1373,32 @@ qla2x00_eh_wait_for_pending_commands(scs
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
 
@@ -1416,7 +1435,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 		return err;
 
 	if (fcport->deleted)
-		return SUCCESS;
+		return FAILED;
 
 	ql_log(ql_log_info, vha, 0x8009,
 	    "DEVICE RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", vha->host_no,
@@ -1484,7 +1503,7 @@ qla2xxx_eh_target_reset(struct scsi_cmnd
 		return err;
 
 	if (fcport->deleted)
-		return SUCCESS;
+		return FAILED;
 
 	ql_log(ql_log_info, vha, 0x8009,
 	    "TARGET RESET ISSUED nexus=%ld:%d cmd=%p.\n", vha->host_no,


