Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06E31553F5
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 09:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgBGItW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 03:49:22 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47673 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgBGItV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 03:49:21 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 645C321B81;
        Fri,  7 Feb 2020 03:49:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 03:49:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YVnQta
        HkF7HjFRrIUC/3pM24fsfdFyoh2Y1sVg5KrD8=; b=sT2S/uVMCpahDg8ECoGq6r
        Nwhdbj9UaaiHVYsMZNGPx//PTSGzxuYsVnMqsOax3uTCfw5Yvmy45uHzDyoVM9JY
        6bIolPit9il1GonFd0RRPJI2u0xEqOU8dPao5RbKaq8MDbbkM1vBW6EsuliZGNyC
        nucVlgjffQd4adF9EugzHlFx3mLqLIwI8TUYtR73JgvBk2sPfnFRDNyF4C/7P+jr
        dheBcAoStr5tioerJ+6zcCLTkC8EdVcJVanTrFVKvauLHs2oXJW0Cni2pIk7xWXq
        vkKLouGGEv09kqpaOKIZrm6ZDOgMekBJdbmHwVTsZ5IqI5mansOSh58dnmEGXPeA
        ==
X-ME-Sender: <xms:kCQ9XpV-m5HQjXFijSFlQYxFHxPdj3E3ZAs0KaIdJnUCsl9vMp_l-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheeggdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kCQ9XjSm13dlbrmtlpWUdYFano7WFpFIu0IfgfydunagNm1PGyMRBQ>
    <xmx:kCQ9Xku9dRWNJE1h3N5BZ0_f50NhISHK7CA8mEUqZHu01OK4uA42bw>
    <xmx:kCQ9XkYZWIb77z4Jyr8-zCc_p5DET9gKDSiC_j-72RhZABZ1FGGSnA>
    <xmx:kCQ9Xl81bburk6f4u0papCbZcPLhDBTjcakyAI1u_awuCvHj0XjQ2Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC05930606E9;
        Fri,  7 Feb 2020 03:49:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix stuck login session using prli_pend_timer" failed to apply to 5.4-stable tree
To:     qutran@marvell.com, hmadhani@marvell.com,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Feb 2020 09:49:15 +0100
Message-ID: <158106535523929@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 8aaac2d7da873aebeba92c666f82c00bbd74aaf9 Mon Sep 17 00:00:00 2001
From: Quinn Tran <qutran@marvell.com>
Date: Tue, 17 Dec 2019 14:06:11 -0800
Subject: [PATCH] scsi: qla2xxx: Fix stuck login session using prli_pend_timer

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

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3b9ecdeecc8e..90dae8f2d080 100644
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
@@ -4858,6 +4860,9 @@ struct sff_8247_a0 {
 	(ha->fc4_type_priority == FC4_PRIORITY_NVME)) || \
 	NVME_ONLY_TARGET(fcport)) \
 
+#define PRLI_PHASE(_cls) \
+	((_cls == DSC_LS_PRLI_PEND) || (_cls == DSC_LS_PRLI_COMP))
+
 #include "qla_target.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 67f7c21edb4c..37aad8da7934 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -675,7 +675,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 	port_id_t id;
 	u64 wwn;
 	u16 data[2];
-	u8 current_login_state;
+	u8 current_login_state, nvme_cls;
 
 	fcport = ea->fcport;
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
@@ -734,10 +734,17 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
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
@@ -1207,12 +1214,19 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
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
@@ -1591,6 +1605,10 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
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
index fecc2b2aabf9..0ef76743a26d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1258,6 +1258,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
+	sess->prli_pend_timer = 0;
 	qla2x00_set_fcport_disc_state(sess, DSC_DELETE_PEND);
 
 	qla24xx_chk_fcp_state(sess);

