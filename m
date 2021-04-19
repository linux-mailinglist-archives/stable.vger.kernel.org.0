Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39197364430
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241130AbhDSNZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241426AbhDSNXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B6AE6140B;
        Mon, 19 Apr 2021 13:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838333;
        bh=8R2+UhaQMojDngFKiLagrUv+1uoDbTwuoNNSzuZjSks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7FBnjEbi09dEuuzIduVd442CWwTFSsGP8Vz/vwqkTAPQfTJtQ1yS11kzCKYzqMfV
         pIxpIbARozN3BAkk0Kw59I4uhDluFLyYH+2qB+UGJLKdvzg3Hj9vK2oY4/pfYini8s
         4K7dISsWVXmLAKvyNMUeAejTlwGomwhHvaP973us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Hernandez <mhernandez@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/73] scsi: qla2xxx: Dual FCP-NVMe target port support
Date:   Mon, 19 Apr 2021 15:05:54 +0200
Message-Id: <20210419130523.916754135@linuxfoundation.org>
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

From: Michael Hernandez <mhernandez@marvell.com>

[ Upstream commit 84ed362ac40ca44dbbbebf767301463aa72bc797 ]

Some storage arrays advertise FCP LUNs and NVMe namespaces behind the same
WWN.  The driver now offers a user option by way of NVRAM parameter to
allow users to choose, on a per port basis, the kind of FC-4 type they
would like to prioritize for login.

Link: https://lore.kernel.org/r/20190912180918.6436-9-hmadhani@marvell.com
Signed-off-by: Michael Hernandez <mhernandez@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h    | 26 ++++++++++++-
 drivers/scsi/qla2xxx/qla_fw.h     |  2 +
 drivers/scsi/qla2xxx/qla_gs.c     | 42 ++++++++++++--------
 drivers/scsi/qla2xxx/qla_init.c   | 64 ++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_inline.h | 12 ++++++
 drivers/scsi/qla2xxx/qla_mbx.c    | 11 +++---
 drivers/scsi/qla2xxx/qla_os.c     | 17 ++++----
 7 files changed, 114 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1eb3fe281cc3..894c2716b7ce 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2281,7 +2281,7 @@ typedef struct {
 	uint8_t fabric_port_name[WWN_SIZE];
 	uint16_t fp_speed;
 	uint8_t fc4_type;
-	uint8_t fc4f_nvme;	/* nvme fc4 feature bits */
+	uint8_t fc4_features;
 } sw_info_t;
 
 /* FCP-4 types */
@@ -2450,7 +2450,7 @@ typedef struct fc_port {
 	u32 supported_classes;
 
 	uint8_t fc4_type;
-	uint8_t	fc4f_nvme;
+	uint8_t fc4_features;
 	uint8_t scan_state;
 
 	unsigned long last_queue_full;
@@ -2481,6 +2481,9 @@ typedef struct fc_port {
 	u16 n2n_chip_reset;
 } fc_port_t;
 
+#define FC4_PRIORITY_NVME	0
+#define FC4_PRIORITY_FCP	1
+
 #define QLA_FCPORT_SCAN		1
 #define QLA_FCPORT_FOUND	2
 
@@ -4296,6 +4299,8 @@ struct qla_hw_data {
 	atomic_t        nvme_active_aen_cnt;
 	uint16_t        nvme_last_rptd_aen;             /* Last recorded aen count */
 
+	uint8_t fc4_type_priority;
+
 	atomic_t zio_threshold;
 	uint16_t last_zio_threshold;
 
@@ -4821,6 +4826,23 @@ struct sff_8247_a0 {
 	 ha->current_topology == ISP_CFG_N || \
 	 !ha->current_topology)
 
+#define NVME_TYPE(fcport) \
+	(fcport->fc4_type & FS_FC4TYPE_NVME) \
+
+#define FCP_TYPE(fcport) \
+	(fcport->fc4_type & FS_FC4TYPE_FCP) \
+
+#define NVME_ONLY_TARGET(fcport) \
+	(NVME_TYPE(fcport) && !FCP_TYPE(fcport))  \
+
+#define NVME_FCP_TARGET(fcport) \
+	(FCP_TYPE(fcport) && NVME_TYPE(fcport)) \
+
+#define NVME_TARGET(ha, fcport) \
+	((NVME_FCP_TARGET(fcport) && \
+	(ha->fc4_type_priority == FC4_PRIORITY_NVME)) || \
+	NVME_ONLY_TARGET(fcport)) \
+
 #include "qla_target.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index dc2366a29665..9dc09c117416 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -2105,4 +2105,6 @@ struct qla_fcp_prio_cfg {
 #define FA_FLASH_LAYOUT_ADDR_83	(0x3F1000/4)
 #define FA_FLASH_LAYOUT_ADDR_28	(0x11000/4)
 
+#define NVRAM_DUAL_FCP_NVME_FLAG_OFFSET	0x196
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index fc6e12fb7d77..ae13aabf280b 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -248,7 +248,7 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    WWN_SIZE);
 
 		fcport->fc4_type = (ct_rsp->rsp.ga_nxt.fc4_types[2] & BIT_0) ?
-		    FC4_TYPE_FCP_SCSI : FC4_TYPE_OTHER;
+		    FS_FC4TYPE_FCP : FC4_TYPE_OTHER;
 
 		if (ct_rsp->rsp.ga_nxt.port_type != NS_N_PORT_TYPE &&
 		    ct_rsp->rsp.ga_nxt.port_type != NS_NL_PORT_TYPE)
@@ -2887,7 +2887,7 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 	struct qla_hw_data *ha = vha->hw;
-	uint8_t fcp_scsi_features = 0;
+	uint8_t fcp_scsi_features = 0, nvme_features = 0;
 	struct ct_arg arg;
 
 	for (i = 0; i < ha->max_fibre_devices; i++) {
@@ -2933,14 +2933,19 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
 			   ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
 			fcp_scsi_features &= 0x0f;
 
-			if (fcp_scsi_features)
-				list[i].fc4_type = FC4_TYPE_FCP_SCSI;
-			else
-				list[i].fc4_type = FC4_TYPE_OTHER;
+			if (fcp_scsi_features) {
+				list[i].fc4_type = FS_FC4TYPE_FCP;
+				list[i].fc4_features = fcp_scsi_features;
+			}
 
-			list[i].fc4f_nvme =
+			nvme_features =
 			    ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
-			list[i].fc4f_nvme &= 0xf;
+			nvme_features &= 0xf;
+
+			if (nvme_features) {
+				list[i].fc4_type |= FS_FC4TYPE_NVME;
+				list[i].fc4_features = nvme_features;
+			}
 		}
 
 		/* Last device exit. */
@@ -3435,6 +3440,8 @@ void qla24xx_async_gffid_sp_done(srb_t *sp, int res)
 	fc_port_t *fcport = sp->fcport;
 	struct ct_sns_rsp *ct_rsp;
 	struct event_arg ea;
+	uint8_t fc4_scsi_feat;
+	uint8_t fc4_nvme_feat;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2133,
 	       "Async done-%s res %x ID %x. %8phC\n",
@@ -3442,24 +3449,25 @@ void qla24xx_async_gffid_sp_done(srb_t *sp, int res)
 
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	ct_rsp = &fcport->ct_desc.ct_sns->p.rsp;
+	fc4_scsi_feat = ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
+	fc4_nvme_feat = ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
+
 	/*
 	 * FC-GS-7, 5.2.3.12 FC-4 Features - format
 	 * The format of the FC-4 Features object, as defined by the FC-4,
 	 * Shall be an array of 4-bit values, one for each type code value
 	 */
 	if (!res) {
-		if (ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET] & 0xf) {
+		if (fc4_scsi_feat & 0xf) {
 			/* w1 b00:03 */
-			fcport->fc4_type =
-			    ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
-			fcport->fc4_type &= 0xf;
-	       }
+			fcport->fc4_type = FS_FC4TYPE_FCP;
+			fcport->fc4_features = fc4_scsi_feat & 0xf;
+		}
 
-		if (ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET] & 0xf) {
+		if (fc4_nvme_feat & 0xf) {
 			/* w5 [00:03]/28h */
-			fcport->fc4f_nvme =
-			    ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
-			fcport->fc4f_nvme &= 0xf;
+			fcport->fc4_type |= FS_FC4TYPE_NVME;
+			fcport->fc4_features = fc4_nvme_feat & 0xf;
 		}
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5305c914b0a4..bc7460da394f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -356,7 +356,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	else
 		lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
 
-	if (fcport->fc4f_nvme)
+	if (NVME_TARGET(vha->hw, fcport))
 		lio->u.logio.flags |= SRB_LOGIN_SKIP_PRLI;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2072,
@@ -755,19 +755,17 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
 		loop_id = le16_to_cpu(e->nport_handle);
 		loop_id = (loop_id & 0x7fff);
-		if  (fcport->fc4f_nvme)
+		if (NVME_TARGET(vha->hw, fcport))
 			current_login_state = e->current_login_state >> 4;
 		else
 			current_login_state = e->current_login_state & 0xf;
 
-
 		ql_dbg(ql_dbg_disc, vha, 0x20e2,
-		    "%s found %8phC CLS [%x|%x] nvme %d ID[%02x%02x%02x|%02x%02x%02x] lid[%d|%d]\n",
+		    "%s found %8phC CLS [%x|%x] fc4_type %d ID[%06x|%06x] lid[%d|%d]\n",
 		    __func__, fcport->port_name,
 		    e->current_login_state, fcport->fw_login_state,
-		    fcport->fc4f_nvme, id.b.domain, id.b.area, id.b.al_pa,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa, loop_id, fcport->loop_id);
+		    fcport->fc4_type, id.b24, fcport->d_id.b24,
+		    loop_id, fcport->loop_id);
 
 		switch (fcport->disc_state) {
 		case DSC_DELETE_PEND:
@@ -1263,13 +1261,13 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 	sp->done = qla2x00_async_prli_sp_done;
 	lio->u.logio.flags = 0;
 
-	if  (fcport->fc4f_nvme)
+	if (NVME_TARGET(vha->hw, fcport))
 		lio->u.logio.flags |= SRB_LOGIN_NVME_PRLI;
 
 	ql_dbg(ql_dbg_disc, vha, 0x211b,
 	    "Async-prli - %8phC hdl=%x, loopid=%x portid=%06x retries=%d %s.\n",
 	    fcport->port_name, sp->handle, fcport->loop_id, fcport->d_id.b24,
-	    fcport->login_retry, fcport->fc4f_nvme ? "nvme" : "fc");
+	    fcport->login_retry, NVME_TARGET(vha->hw, fcport) ? "nvme" : "fc");
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
@@ -1420,14 +1418,14 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	fcport->flags &= ~FCF_ASYNC_SENT;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d2,
-	    "%s %8phC DS %d LS %d nvme %x rc %d\n", __func__, fcport->port_name,
-	    fcport->disc_state, pd->current_login_state, fcport->fc4f_nvme,
-	    ea->rc);
+	    "%s %8phC DS %d LS %d fc4_type %x rc %d\n", __func__,
+	    fcport->port_name, fcport->disc_state, pd->current_login_state,
+	    fcport->fc4_type, ea->rc);
 
 	if (fcport->disc_state == DSC_DELETE_PEND)
 		return;
 
-	if (fcport->fc4f_nvme)
+	if (NVME_TARGET(vha->hw, fcport))
 		ls = pd->current_login_state >> 4;
 	else
 		ls = pd->current_login_state & 0xf;
@@ -1616,7 +1614,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 				ql_dbg(ql_dbg_disc, vha, 0x2118,
 				    "%s %d %8phC post %s PRLI\n",
 				    __func__, __LINE__, fcport->port_name,
-				    fcport->fc4f_nvme ? "NVME" : "FC");
+				    NVME_TARGET(vha->hw, fcport) ? "NVME" :
+				    "FC");
 				qla24xx_post_prli_work(vha, fcport);
 			}
 			break;
@@ -1898,13 +1897,22 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			break;
 		}
 
-		if (ea->fcport->fc4f_nvme) {
+		/*
+		 * Retry PRLI with other FC-4 type if failure occurred on dual
+		 * FCP/NVMe port
+		 */
+		if (NVME_FCP_TARGET(ea->fcport)) {
+			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
+				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
+			else
+				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
 			ql_dbg(ql_dbg_disc, vha, 0x2118,
-				"%s %d %8phC post fc4 prli\n",
-				__func__, __LINE__, ea->fcport->port_name);
-			ea->fcport->fc4f_nvme = 0;
+				"%s %d %8phC post %s prli\n",
+				__func__, __LINE__, ea->fcport->port_name,
+				(ea->fcport->fc4_type & FS_FC4TYPE_NVME) ?
+				"NVMe" : "FCP");
 			qla24xx_post_prli_work(vha, ea->fcport);
-			return;
+			break;
 		}
 
 		/* at this point both PRLI NVME & PRLI FCP failed */
@@ -1990,7 +1998,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		 * force a relogin attempt via implicit LOGO, PLOGI, and PRLI
 		 * requests.
 		 */
-		if (ea->fcport->fc4f_nvme) {
+		if (NVME_TARGET(vha->hw, ea->fcport)) {
 			ql_dbg(ql_dbg_disc, vha, 0x2117,
 				"%s %d %8phC post prli\n",
 				__func__, __LINE__, ea->fcport->port_name);
@@ -5415,7 +5423,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	qla2x00_iidma_fcport(vha, fcport);
 
-	if (fcport->fc4f_nvme) {
+	if (NVME_TARGET(vha->hw, fcport)) {
 		qla_nvme_register_remote(vha, fcport);
 		fcport->disc_state = DSC_LOGIN_COMPLETE;
 		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
@@ -5743,11 +5751,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 				new_fcport->fc4_type = swl[swl_idx].fc4_type;
 
 				new_fcport->nvme_flag = 0;
-				new_fcport->fc4f_nvme = 0;
 				if (vha->flags.nvme_enabled &&
-				    swl[swl_idx].fc4f_nvme) {
-					new_fcport->fc4f_nvme =
-					    swl[swl_idx].fc4f_nvme;
+				    swl[swl_idx].fc4_type & FS_FC4TYPE_NVME) {
 					ql_log(ql_log_info, vha, 0x2131,
 					    "FOUND: NVME port %8phC as FC Type 28h\n",
 					    new_fcport->port_name);
@@ -5803,7 +5808,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 
 		/* Bypass ports whose FCP-4 type is not FCP_SCSI */
 		if (ql2xgffidenable &&
-		    (new_fcport->fc4_type != FC4_TYPE_FCP_SCSI &&
+		    (!(new_fcport->fc4_type & FS_FC4TYPE_FCP) &&
 		    new_fcport->fc4_type != FC4_TYPE_UNKNOWN))
 			continue;
 
@@ -5872,7 +5877,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 			break;
 		}
 
-		if (fcport->fc4f_nvme) {
+		if (NVME_TARGET(vha->hw, fcport)) {
 			if (fcport->disc_state == DSC_DELETE_PEND) {
 				fcport->disc_state = DSC_GNL;
 				vha->fcport_count--;
@@ -8547,6 +8552,11 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	/* N2N: driver will initiate Login instead of FW */
 	icb->firmware_options_3 |= BIT_8;
 
+	/* Determine NVMe/FCP priority for target ports */
+	ha->fc4_type_priority = qla2xxx_get_fc4_priority(vha);
+	ql_log(ql_log_info, vha, 0xffff, "FC4 priority set to %s\n",
+	    ha->fc4_type_priority & BIT_0 ? "FCP" : "NVMe");
+
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x0076,
 		    "NVRAM configuration failed.\n");
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 6dfde42d799b..af91e567a38d 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -312,3 +312,15 @@ qla_83xx_start_iocbs(struct qla_qpair *qpair)
 
 	WRT_REG_DWORD(req->req_q_in, req->ring_index);
 }
+
+static inline int
+qla2xxx_get_fc4_priority(struct scsi_qla_host *vha)
+{
+	uint32_t data;
+
+	data =
+	    ((uint8_t *)vha->hw->nvram)[NVRAM_DUAL_FCP_NVME_FLAG_OFFSET];
+
+
+	return ((data >> 6) & BIT_0);
+}
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c1631e42d35d..098388a12feb 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1924,7 +1924,7 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		pd24 = (struct port_database_24xx *) pd;
 
 		/* Check for logged in state. */
-		if (fcport->fc4f_nvme) {
+		if (NVME_TARGET(ha, fcport)) {
 			current_login_state = pd24->current_login_state >> 4;
 			last_login_state = pd24->last_login_state >> 4;
 		} else {
@@ -3891,8 +3891,9 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				fcport->scan_state = QLA_FCPORT_FOUND;
 				fcport->n2n_flag = 1;
 				fcport->keep_nport_handle = 1;
+				fcport->fc4_type = FS_FC4TYPE_FCP;
 				if (vha->flags.nvme_enabled)
-					fcport->fc4f_nvme = 1;
+					fcport->fc4_type |= FS_FC4TYPE_NVME;
 
 				switch (fcport->disc_state) {
 				case DSC_DELETED:
@@ -6350,7 +6351,7 @@ int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
 	uint64_t zero = 0;
 	u8 current_login_state, last_login_state;
 
-	if (fcport->fc4f_nvme) {
+	if (NVME_TARGET(vha->hw, fcport)) {
 		current_login_state = pd->current_login_state >> 4;
 		last_login_state = pd->last_login_state >> 4;
 	} else {
@@ -6385,8 +6386,8 @@ int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
 	fcport->d_id.b.al_pa = pd->port_id[2];
 	fcport->d_id.b.rsvd_1 = 0;
 
-	if (fcport->fc4f_nvme) {
-		fcport->port_type = 0;
+	if (NVME_TARGET(vha->hw, fcport)) {
+		fcport->port_type = FCT_NVME;
 		if ((pd->prli_svc_param_word_3[0] & BIT_5) == 0)
 			fcport->port_type |= FCT_NVME_INITIATOR;
 		if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 67b1e74fcd1e..899dfb445710 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5055,19 +5055,17 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			fcport->d_id = e->u.new_sess.id;
 			fcport->flags |= FCF_FABRIC_DEVICE;
 			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
-			if (e->u.new_sess.fc4_type == FS_FC4TYPE_FCP)
-				fcport->fc4_type = FC4_TYPE_FCP_SCSI;
-
-			if (e->u.new_sess.fc4_type == FS_FC4TYPE_NVME) {
-				fcport->fc4_type = FC4_TYPE_OTHER;
-				fcport->fc4f_nvme = FC4_TYPE_NVME;
-			}
 
 			memcpy(fcport->port_name, e->u.new_sess.port_name,
 			    WWN_SIZE);
 
-			if (e->u.new_sess.fc4_type & FS_FCP_IS_N2N)
+			fcport->fc4_type = e->u.new_sess.fc4_type;
+			if (e->u.new_sess.fc4_type & FS_FCP_IS_N2N) {
+				fcport->fc4_type = FS_FC4TYPE_FCP;
 				fcport->n2n_flag = 1;
+				if (vha->flags.nvme_enabled)
+					fcport->fc4_type |= FS_FC4TYPE_NVME;
+			}
 
 		} else {
 			ql_dbg(ql_dbg_disc, vha, 0xffff,
@@ -5171,7 +5169,8 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 				fcport->flags &= ~FCF_FABRIC_DEVICE;
 				fcport->keep_nport_handle = 1;
 				if (vha->flags.nvme_enabled) {
-					fcport->fc4f_nvme = 1;
+					fcport->fc4_type =
+					    (FS_FC4TYPE_NVME | FS_FC4TYPE_FCP);
 					fcport->n2n_flag = 1;
 				}
 				fcport->fw_login_state = 0;
-- 
2.30.2



