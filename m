Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB9B59420C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347083AbiHOVZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344515AbiHOVXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:23:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53724E68C3;
        Mon, 15 Aug 2022 12:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A75CAB81109;
        Mon, 15 Aug 2022 19:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD345C433C1;
        Mon, 15 Aug 2022 19:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591337;
        bh=BKIxRizxJYC3fDwWJHTwZ9YRG2rgV2o83TGACtjwAlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=how/FFPkvFvRSeLjc97CwdY57FSYVsIEBFhGXrDvQTRQUqLqp/NHMCLqhBUxz9ntS
         ZHF4LiP2vkVcdeugEqu20o+YPs+AemyFIl816qu32ycvC5rhOEqBpDs2p3flM8d0b8
         x7MSEscMM6GHOsHgMO3NqIaDTBqxvJrd/hijyOGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0548/1095] scsi: qla2xxx: edif: bsg refactor
Date:   Mon, 15 Aug 2022 19:59:07 +0200
Message-Id: <20220815180452.215450188@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 7a7b0b4865d3490f62d6ef1a3aa39fa2b47859a4 ]

 - Add version field to edif bsg for future enhancement.

 - Add version edif bsg version check

 - Remove unused interfaces and fields.

Link: https://lore.kernel.org/r/20220607044627.19563-3-njavali@marvell.com
Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c     | 32 +++++++---
 drivers/scsi/qla2xxx/qla_edif_bsg.h | 90 ++++++++++++++++++-----------
 2 files changed, 79 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 30ca56f8e4c8..0978551f85f5 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -280,14 +280,19 @@ qla_edif_app_check(scsi_qla_host_t *vha, struct app_id appid)
 {
 	/* check that the app is allow/known to the driver */
 
-	if (appid.app_vid == EDIF_APP_ID) {
-		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x911d, "%s app id ok\n", __func__);
-		return true;
+	if (appid.app_vid != EDIF_APP_ID) {
+		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app id not ok (%x)",
+		    __func__, appid.app_vid);
+		return false;
+	}
+
+	if (appid.version != EDIF_VERSION1) {
+		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app version is not ok (%x)",
+		    __func__, appid.version);
+		return false;
 	}
-	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app id not ok (%x)",
-	    __func__, appid.app_vid);
 
-	return false;
+	return true;
 }
 
 static void
@@ -555,6 +560,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	appreply.host_support_edif = vha->hw->flags.edif_enabled;
 	appreply.edif_enode_active = vha->pur_cinfo.enode_flags;
 	appreply.edif_edb_active = vha->e_dbell.db_flags;
+	appreply.version = EDIF_VERSION1;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 
@@ -685,6 +691,7 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	portid.b.area   = appplogiok.u.d_id.b.area;
 	portid.b.al_pa  = appplogiok.u.d_id.b.al_pa;
 
+	appplogireply.version = EDIF_VERSION1;
 	switch (appplogiok.type) {
 	case PL_TYPE_WWPN:
 		fcport = qla2x00_find_fcport_by_wwpn(vha,
@@ -877,6 +884,8 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	} else {
 		struct fc_port	*fcport = NULL, *tf;
 
+		app_reply->version = EDIF_VERSION1;
+
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			if (!(fcport->flags & FCF_FCSP_DEVICE))
 				continue;
@@ -893,9 +902,6 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
 				continue;
 
-			app_reply->ports[pcnt].rekey_count =
-				fcport->edif.rekey_cnt;
-
 			if (fcport->scan_state != QLA_FCPORT_FOUND)
 				continue;
 
@@ -910,6 +916,7 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 			rval = 0;
 
+			app_reply->ports[pcnt].version = EDIF_VERSION1;
 			app_reply->ports[pcnt].remote_type =
 				VND_CMD_RTYPE_UNKNOWN;
 			if (fcport->port_type & (FCT_NVME_TARGET | FCT_TARGET))
@@ -1006,6 +1013,8 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	} else {
 		struct fc_port	*fcport = NULL, *tf;
 
+		app_reply->version = EDIF_VERSION1;
+
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			if (fcport->edif.enable) {
 				if (pcnt > app_req.num_ports)
@@ -2037,6 +2046,7 @@ qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype,
 		edbnode->u.sa_aen.port_id = fcport->d_id;
 		edbnode->u.sa_aen.status =  data;
 		edbnode->u.sa_aen.key_type =  data2;
+		edbnode->u.sa_aen.version = EDIF_VERSION1;
 		break;
 	default:
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
@@ -3380,6 +3390,10 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	port_id_t d_id;
 	struct qla_bsg_auth_els_request *p =
 	    (struct qla_bsg_auth_els_request *)bsg_job->request;
+	struct qla_bsg_auth_els_reply *rpl =
+	    (struct qla_bsg_auth_els_reply *)bsg_job->reply;
+
+	rpl->version = EDIF_VERSION1;
 
 	d_id.b.al_pa = bsg_request->rqst_data.h_els.port_id[2];
 	d_id.b.area = bsg_request->rqst_data.h_els.port_id[1];
diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 5a26c77157da..301523e4f483 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -7,13 +7,15 @@
 #ifndef __QLA_EDIF_BSG_H
 #define __QLA_EDIF_BSG_H
 
+#define EDIF_VERSION1 1
+
 /* BSG Vendor specific commands */
 #define	ELS_MAX_PAYLOAD		2112
 #ifndef	WWN_SIZE
 #define WWN_SIZE		8
 #endif
-#define	VND_CMD_APP_RESERVED_SIZE	32
-
+#define VND_CMD_APP_RESERVED_SIZE	28
+#define VND_CMD_PAD_SIZE                3
 enum auth_els_sub_cmd {
 	SEND_ELS = 0,
 	SEND_ELS_REPLY,
@@ -28,7 +30,9 @@ struct extra_auth_els {
 #define BSG_CTL_FLAG_LS_ACC     1
 #define BSG_CTL_FLAG_LS_RJT     2
 #define BSG_CTL_FLAG_TRM        3
-	uint8_t         extra_rsvd[3];
+	uint8_t		version;
+	uint8_t		pad[2];
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
 struct qla_bsg_auth_els_request {
@@ -39,51 +43,46 @@ struct qla_bsg_auth_els_request {
 struct qla_bsg_auth_els_reply {
 	struct fc_bsg_reply r;
 	uint32_t rx_xchg_address;
+	uint8_t version;
+	uint8_t pad[VND_CMD_PAD_SIZE];
+	uint8_t reserved[VND_CMD_APP_RESERVED_SIZE];
 };
 
 struct app_id {
 	int		app_vid;
-	uint8_t		app_key[32];
+	uint8_t		version;
+	uint8_t		pad[VND_CMD_PAD_SIZE];
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
 struct app_start_reply {
 	uint32_t	host_support_edif;
 	uint32_t	edif_enode_active;
 	uint32_t	edif_edb_active;
-	uint32_t	reserved[VND_CMD_APP_RESERVED_SIZE];
+	uint8_t		version;
+	uint8_t		pad[VND_CMD_PAD_SIZE];
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
 struct app_start {
 	struct app_id	app_info;
-	uint32_t	prli_to;
-	uint32_t	key_shred;
 	uint8_t         app_start_flags;
-	uint8_t         reserved[VND_CMD_APP_RESERVED_SIZE - 1];
+	uint8_t		version;
+	uint8_t		pad[2];
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
 struct app_stop {
 	struct app_id	app_info;
-	char		buf[16];
+	uint8_t		version;
+	uint8_t		pad[VND_CMD_PAD_SIZE];
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
 struct app_plogi_reply {
 	uint32_t	prli_status;
-	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
-} __packed;
-
-#define	RECFG_TIME	1
-#define	RECFG_BYTES	2
-
-struct app_rekey_cfg {
-	struct app_id app_info;
-	uint8_t	 rekey_mode;
-	port_id_t d_id;
-	uint8_t	 force;
-	union {
-		int64_t bytes;
-		int64_t time;
-	} rky_units;
-
+	uint8_t		version;
+	uint8_t		pad[VND_CMD_PAD_SIZE];
 	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
@@ -91,7 +90,9 @@ struct app_pinfo_req {
 	struct app_id app_info;
 	uint8_t	 num_ports;
 	port_id_t remote_pid;
-	uint8_t	 reserved[VND_CMD_APP_RESERVED_SIZE];
+	uint8_t		version;
+	uint8_t		pad[VND_CMD_PAD_SIZE];
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
 struct app_pinfo {
@@ -103,11 +104,8 @@ struct app_pinfo {
 #define	VND_CMD_RTYPE_INITIATOR		2
 	uint8_t	remote_state;
 	uint8_t	auth_state;
-	uint8_t	rekey_mode;
-	int64_t	rekey_count;
-	int64_t	rekey_config_value;
-	int64_t	rekey_consumed_value;
-
+	uint8_t	version;
+	uint8_t	pad[VND_CMD_PAD_SIZE];
 	uint8_t	reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
@@ -120,6 +118,8 @@ struct app_pinfo {
 
 struct app_pinfo_reply {
 	uint8_t		port_count;
+	uint8_t		version;
+	uint8_t		pad[VND_CMD_PAD_SIZE];
 	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
 	struct app_pinfo ports[];
 } __packed;
@@ -127,6 +127,8 @@ struct app_pinfo_reply {
 struct app_sinfo_req {
 	struct app_id	app_info;
 	uint8_t		num_ports;
+	uint8_t		version;
+	uint8_t		pad[VND_CMD_PAD_SIZE];
 	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
@@ -140,6 +142,9 @@ struct app_sinfo {
 
 struct app_stats_reply {
 	uint8_t		elem_count;
+	uint8_t		version;
+	uint8_t		pad[VND_CMD_PAD_SIZE];
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
 	struct app_sinfo elem[];
 } __packed;
 
@@ -163,9 +168,11 @@ struct qla_sa_update_frame {
 	uint8_t		node_name[WWN_SIZE];
 	uint8_t		port_name[WWN_SIZE];
 	port_id_t	port_id;
+	uint8_t		version;
+	uint8_t		pad[VND_CMD_PAD_SIZE];
+	uint8_t		reserved2[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
-// used for edif mgmt bsg interface
 #define	QL_VND_SC_UNDEF		0
 #define	QL_VND_SC_SA_UPDATE	1
 #define	QL_VND_SC_APP_START	2
@@ -175,6 +182,8 @@ struct qla_sa_update_frame {
 #define	QL_VND_SC_REKEY_CONFIG	6
 #define	QL_VND_SC_GET_FCINFO	7
 #define	QL_VND_SC_GET_STATS	8
+#define QL_VND_SC_AEN_COMPLETE  9
+
 
 /* Application interface data structure for rtn data */
 #define	EXT_DEF_EVENT_DATA_SIZE	64
@@ -191,7 +200,9 @@ struct edif_sa_update_aen {
 	port_id_t port_id;
 	uint32_t key_type;	/* Tx (1) or RX (2) */
 	uint32_t status;	/* 0 succes,  1 failed, 2 timeout , 3 error */
-	uint8_t		reserved[16];
+	uint8_t	version;
+	uint8_t	pad[VND_CMD_PAD_SIZE];
+	uint8_t	reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
 #define	QL_VND_SA_STAT_SUCCESS	0
@@ -212,7 +223,18 @@ struct auth_complete_cmd {
 		uint8_t  wwpn[WWN_SIZE];
 		port_id_t d_id;
 	} u;
-	uint32_t reserved[VND_CMD_APP_RESERVED_SIZE];
+	uint8_t	version;
+	uint8_t	pad[VND_CMD_PAD_SIZE];
+	uint8_t	reserved[VND_CMD_APP_RESERVED_SIZE];
+} __packed;
+
+struct aen_complete_cmd {
+	struct app_id app_info;
+	port_id_t   port_id;
+	uint32_t    event_code;
+	uint8_t     version;
+	uint8_t     pad[VND_CMD_PAD_SIZE];
+	uint8_t     reserved[VND_CMD_APP_RESERVED_SIZE];
 } __packed;
 
 #define RX_DELAY_DELETE_TIMEOUT 20
-- 
2.35.1



