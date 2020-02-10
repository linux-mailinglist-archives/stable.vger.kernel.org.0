Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46D51579AF
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgBJNRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:17:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbgBJMiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:03 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1C002168B;
        Mon, 10 Feb 2020 12:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338282;
        bh=/1tLgSXLr2zGncF4c5Qo6ckyM58TYsaf1w+b+Ouk6c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1kGb1w8kglsJFHuetlnB4iv/aqbs9HpVuc2RogjNlhUNPFojQpOf8BM8Qp6JztBH
         DyfE95lD7BGONkSQkfutWLK/wZiapwG3FzY7I1xh8qqal4ztkeJGgPfGga6myhJJRj
         l9SZYfq6m0CdKQLes0TbueNc2MkUMKfud0txXqjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/309] scsi: qla2xxx: Fix stuck login session using prli_pend_timer
Date:   Mon, 10 Feb 2020 04:31:30 -0800
Message-Id: <20200210122419.227863408@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index 1eb3fe281cc3c..c57b95a206888 100644
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
@@ -4821,6 +4823,9 @@ struct sff_8247_a0 {
 	 ha->current_topology == ISP_CFG_N || \
 	 !ha->current_topology)
 
+#define PRLI_PHASE(_cls) \
+	((_cls == DSC_LS_PRLI_PEND) || (_cls == DSC_LS_PRLI_COMP))
+
 #include "qla_target.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9ffaa920fc8f8..ac4c47fc5f4c1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -686,7 +686,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 	port_id_t id;
 	u64 wwn;
 	u16 data[2];
-	u8 current_login_state;
+	u8 current_login_state, nvme_cls;
 
 	fcport = ea->fcport;
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
@@ -745,10 +745,17 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
 		loop_id = le16_to_cpu(e->nport_handle);
 		loop_id = (loop_id & 0x7fff);
-		if  (fcport->fc4f_nvme)
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
@@ -1219,12 +1226,19 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
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
@@ -1602,6 +1616,10 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
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
index 74a378a91b71e..cb8a892e2d393 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1257,6 +1257,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
+	sess->prli_pend_timer = 0;
 	sess->disc_state = DSC_DELETE_PEND;
 
 	qla24xx_chk_fcp_state(sess);
-- 
2.20.1



