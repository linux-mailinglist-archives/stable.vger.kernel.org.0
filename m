Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A703E36441E
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242192AbhDSNZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241684AbhDSNYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:24:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E3B7613DD;
        Mon, 19 Apr 2021 13:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838345;
        bh=wtg99C/Y/UDkSbwlG7I2HotjaCHwJrIAVF8gCrBkW74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiMC0oOmwieLGK3SQZgnXFBRYmhf0XZO3mjFd7LrvTkQtJD3se138xcotItM4bQdz
         QS6AHK+GuEUdZ4wrjABGUC8j/LnTbL+0UeRHqYMeodfnbIfuTe+7tK+Ubl6KKPNNoG
         cbbD/dsFjhxfAXFb2jGM3lFuzbBjLPwHEnfWs47w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/73] scsi: qla2xxx: Fix stuck login session using prli_pend_timer
Date:   Mon, 19 Apr 2021 15:05:58 +0200
Message-Id: <20210419130524.051048140@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 8aaac2d7da873aebeba92c666f82c00bbd74aaf9 ]

Session is stuck if driver sees FW has received a PRLI. Driver allows FW to
finish with processing of PRLI by checking back with FW at a later time to
see if the PRLI has finished. Instead, driver failed to push forward after
re-checking PRLI completion.

Fixes: ce0ba496dccf ("scsi: qla2xxx: Fix stuck login session")
Cc: stable@vger.kernel.org # 5.3
Link: https://lore.kernel.org/r/20191217220617.28084-9-hmadhani@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h    |  5 +++++
 drivers/scsi/qla2xxx/qla_init.c   | 34 +++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_target.c |  1 +
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5e940543eaa1..7c22f8eea3ea 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2402,6 +2402,7 @@ typedef struct fc_port {
 	unsigned int scan_needed:1;
 	unsigned int n2n_flag:1;
 	unsigned int explicit_logout:1;
+	unsigned int prli_pend_timer:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
@@ -2428,6 +2429,7 @@ typedef struct fc_port {
 	struct work_struct free_work;
 	struct work_struct reg_work;
 	uint64_t jiffies_at_registration;
+	unsigned long prli_expired;
 	struct qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
 
 	uint16_t tgt_id;
@@ -4857,6 +4859,9 @@ struct sff_8247_a0 {
 	(ha->fc4_type_priority == FC4_PRIORITY_NVME)) || \
 	NVME_ONLY_TARGET(fcport)) \
 
+#define PRLI_PHASE(_cls) \
+	((_cls == DSC_LS_PRLI_PEND) || (_cls == DSC_LS_PRLI_COMP))
+
 #include "qla_target.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0aac1eb1e013..b4f0c2c8414e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -696,7 +696,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 	port_id_t id;
 	u64 wwn;
 	u16 data[2];
-	u8 current_login_state;
+	u8 current_login_state, nvme_cls;
 
 	fcport = ea->fcport;
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
@@ -755,10 +755,17 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
 		loop_id = le16_to_cpu(e->nport_handle);
 		loop_id = (loop_id & 0x7fff);
-		if (NVME_TARGET(vha->hw, fcport))
-			current_login_state = e->current_login_state >> 4;
-		else
-			current_login_state = e->current_login_state & 0xf;
+		nvme_cls = e->current_login_state >> 4;
+		current_login_state = e->current_login_state & 0xf;
+
+		if (PRLI_PHASE(nvme_cls)) {
+			current_login_state = nvme_cls;
+			fcport->fc4_type &= ~FS_FC4TYPE_FCP;
+			fcport->fc4_type |= FS_FC4TYPE_NVME;
+		} else if (PRLI_PHASE(current_login_state)) {
+			fcport->fc4_type |= FS_FC4TYPE_FCP;
+			fcport->fc4_type &= ~FS_FC4TYPE_NVME;
+		}
 
 		ql_dbg(ql_dbg_disc, vha, 0x20e2,
 		    "%s found %8phC CLS [%x|%x] fc4_type %d ID[%06x|%06x] lid[%d|%d]\n",
@@ -1238,12 +1245,19 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 	struct srb_iocb *lio;
 	int rval = QLA_FUNCTION_FAILED;
 
-	if (!vha->flags.online)
+	if (!vha->flags.online) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %d %8phC exit\n",
+		    __func__, __LINE__, fcport->port_name);
 		return rval;
+	}
 
-	if (fcport->fw_login_state == DSC_LS_PLOGI_PEND ||
-	    fcport->fw_login_state == DSC_LS_PRLI_PEND)
+	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND ||
+	    fcport->fw_login_state == DSC_LS_PRLI_PEND) &&
+	    qla_dual_mode_enabled(vha)) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %d %8phC exit\n",
+		    __func__, __LINE__, fcport->port_name);
 		return rval;
+	}
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
@@ -1622,6 +1636,10 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 			break;
 		default:
 			if (fcport->login_pause) {
+				ql_dbg(ql_dbg_disc, vha, 0x20d8,
+				    "%s %d %8phC exit\n",
+				    __func__, __LINE__,
+				    fcport->port_name);
 				fcport->last_rscn_gen = fcport->rscn_gen;
 				fcport->last_login_gen = fcport->login_gen;
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 594dfbeee376..509539ec58e9 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1268,6 +1268,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
+	sess->prli_pend_timer = 0;
 	qla2x00_set_fcport_disc_state(sess, DSC_DELETE_PEND);
 
 	qla24xx_chk_fcp_state(sess);
-- 
2.30.2



