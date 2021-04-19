Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEDC364417
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242155AbhDSNZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241632AbhDSNXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:23:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B513613D3;
        Mon, 19 Apr 2021 13:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838324;
        bh=Y+u+XCrMWQUJssvyXqMlQNpd+8mjkvd+AUa8jEAgta4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywF5kCifhj5DPlzcwIad4QpNGMVwqlwY81f/UfRhDAc/Jlfk2XySAFdJV4vGySlgb
         xvo07nAsiobelogw9i+PA7gBJuXp5g6j5SNnOzCACrQHKXayMpcJ7TaVzd9GmSodlp
         XoN1mzqkmKouCsIWFWAHqA8m3w5z3d+KKLxBjbDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/73] Revert "scsi: qla2xxx: Fix stuck login session using prli_pend_timer"
Date:   Mon, 19 Apr 2021 15:05:53 +0200
Message-Id: <20210419130523.886015724@linuxfoundation.org>
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

This reverts commit 0b84591fdd5ea3ca0d93aaea489353f0381832c0.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h    |  5 -----
 drivers/scsi/qla2xxx/qla_init.c   | 34 ++++++++-----------------------
 drivers/scsi/qla2xxx/qla_target.c |  1 -
 3 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c57b95a20688..1eb3fe281cc3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2402,7 +2402,6 @@ typedef struct fc_port {
 	unsigned int scan_needed:1;
 	unsigned int n2n_flag:1;
 	unsigned int explicit_logout:1;
-	unsigned int prli_pend_timer:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
@@ -2429,7 +2428,6 @@ typedef struct fc_port {
 	struct work_struct free_work;
 	struct work_struct reg_work;
 	uint64_t jiffies_at_registration;
-	unsigned long prli_expired;
 	struct qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
 
 	uint16_t tgt_id;
@@ -4823,9 +4821,6 @@ struct sff_8247_a0 {
 	 ha->current_topology == ISP_CFG_N || \
 	 !ha->current_topology)
 
-#define PRLI_PHASE(_cls) \
-	((_cls == DSC_LS_PRLI_PEND) || (_cls == DSC_LS_PRLI_COMP))
-
 #include "qla_target.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 05a22fb17e52..5305c914b0a4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -696,7 +696,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 	port_id_t id;
 	u64 wwn;
 	u16 data[2];
-	u8 current_login_state, nvme_cls;
+	u8 current_login_state;
 
 	fcport = ea->fcport;
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
@@ -755,17 +755,10 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
 		loop_id = le16_to_cpu(e->nport_handle);
 		loop_id = (loop_id & 0x7fff);
-		nvme_cls = e->current_login_state >> 4;
-		current_login_state = e->current_login_state & 0xf;
-
-		if (PRLI_PHASE(nvme_cls)) {
-			current_login_state = nvme_cls;
-			fcport->fc4_type &= ~FS_FC4TYPE_FCP;
-			fcport->fc4_type |= FS_FC4TYPE_NVME;
-		} else if (PRLI_PHASE(current_login_state)) {
-			fcport->fc4_type |= FS_FC4TYPE_FCP;
-			fcport->fc4_type &= ~FS_FC4TYPE_NVME;
-		}
+		if  (fcport->fc4f_nvme)
+			current_login_state = e->current_login_state >> 4;
+		else
+			current_login_state = e->current_login_state & 0xf;
 
 
 		ql_dbg(ql_dbg_disc, vha, 0x20e2,
@@ -1246,19 +1239,12 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 	struct srb_iocb *lio;
 	int rval = QLA_FUNCTION_FAILED;
 
-	if (!vha->flags.online) {
-		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %d %8phC exit\n",
-		    __func__, __LINE__, fcport->port_name);
+	if (!vha->flags.online)
 		return rval;
-	}
 
-	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND ||
-	    fcport->fw_login_state == DSC_LS_PRLI_PEND) &&
-	    qla_dual_mode_enabled(vha)) {
-		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s %d %8phC exit\n",
-		    __func__, __LINE__, fcport->port_name);
+	if (fcport->fw_login_state == DSC_LS_PLOGI_PEND ||
+	    fcport->fw_login_state == DSC_LS_PRLI_PEND)
 		return rval;
-	}
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
@@ -1636,10 +1622,6 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 			break;
 		default:
 			if (fcport->login_pause) {
-				ql_dbg(ql_dbg_disc, vha, 0x20d8,
-				    "%s %d %8phC exit\n",
-				    __func__, __LINE__,
-				    fcport->port_name);
 				fcport->last_rscn_gen = fcport->rscn_gen;
 				fcport->last_login_gen = fcport->login_gen;
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8fd0a568303b..5dbdae1f65af 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1267,7 +1267,6 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
-	sess->prli_pend_timer = 0;
 	sess->disc_state = DSC_DELETE_PEND;
 
 	qla24xx_chk_fcp_state(sess);
-- 
2.30.2



