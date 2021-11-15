Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CEF451485
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348352AbhKOUJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:09:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344698AbhKOTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CB6B636B1;
        Mon, 15 Nov 2021 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002944;
        bh=B/Wxskf8W9UHbvX02Sp4vwyE7u0dNaDrWzcLkVUVRdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6tuJwqucW3uI+CBPHdZeWd6SjfaOlEKODoVtlnqmDWC8e3NoNxmGanWVqyo+6j5J
         xe8doOsdT/TblyyG69TZith0jjcRinzn9V/ctQFKEnz22ziglGp2/1s6M3KhOEInSm
         XbMnhzVmCSnDuI31Y51qlb4Z1c+0vBLl4zhXLPeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 754/917] scsi: qla2xxx: edif: Fix EDIF bsg
Date:   Mon, 15 Nov 2021 18:04:09 +0100
Message-Id: <20211115165454.478282175@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 9fd26c633e8ab5a291c0241533efff161bbe5570 ]

Various EDIF bsgs did not properly fill out the reply_payload_rcv_len
field. This causes app to parse empty data in the return payload.

Link: https://lore.kernel.org/r/20211026115412.27691-13-njavali@marvell.com
Fixes: 7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 49 ++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 98235df803aef..9240e788b011d 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -544,14 +544,14 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	appreply.edif_enode_active = vha->pur_cinfo.enode_flags;
 	appreply.edif_edb_active = vha->e_dbell.db_flags;
 
-	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
-	    sizeof(struct app_start_reply);
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 
 	SET_DID_STATUS(bsg_reply->result, DID_OK);
 
-	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, &appreply,
-	    sizeof(struct app_start_reply));
+	bsg_reply->reply_payload_rcv_len = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+							       bsg_job->reply_payload.sg_cnt,
+							       &appreply,
+							       sizeof(struct app_start_reply));
 
 	ql_dbg(ql_dbg_edif, vha, 0x911d,
 	    "%s app start completed with 0x%x\n",
@@ -748,9 +748,10 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 errstate_exit:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, &appplogireply,
-	    sizeof(struct app_plogi_reply));
+	bsg_reply->reply_payload_rcv_len = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+							       bsg_job->reply_payload.sg_cnt,
+							       &appplogireply,
+							       sizeof(struct app_plogi_reply));
 
 	return rval;
 }
@@ -833,7 +834,7 @@ static int
 qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 {
 	int32_t			rval = 0;
-	int32_t			num_cnt;
+	int32_t			pcnt = 0;
 	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
 	struct app_pinfo_req	app_req;
 	struct app_pinfo_reply	*app_reply;
@@ -845,16 +846,14 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	    bsg_job->request_payload.sg_cnt, &app_req,
 	    sizeof(struct app_pinfo_req));
 
-	num_cnt = app_req.num_ports;	/* num of ports alloc'd by app */
-
 	app_reply = kzalloc((sizeof(struct app_pinfo_reply) +
-	    sizeof(struct app_pinfo) * num_cnt), GFP_KERNEL);
+	    sizeof(struct app_pinfo) * app_req.num_ports), GFP_KERNEL);
+
 	if (!app_reply) {
 		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
 		rval = -1;
 	} else {
 		struct fc_port	*fcport = NULL, *tf;
-		uint32_t	pcnt = 0;
 
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			if (!(fcport->flags & FCF_FCSP_DEVICE))
@@ -923,9 +922,11 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		SET_DID_STATUS(bsg_reply->result, DID_OK);
 	}
 
-	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, app_reply,
-	    sizeof(struct app_pinfo_reply) + sizeof(struct app_pinfo) * num_cnt);
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	bsg_reply->reply_payload_rcv_len = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+							       bsg_job->reply_payload.sg_cnt,
+							       app_reply,
+							       sizeof(struct app_pinfo_reply) + sizeof(struct app_pinfo) * pcnt);
 
 	kfree(app_reply);
 
@@ -942,10 +943,11 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 {
 	int32_t			rval = 0;
 	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
-	uint32_t ret_size, size;
+	uint32_t size;
 
 	struct app_sinfo_req	app_req;
 	struct app_stats_reply	*app_reply;
+	uint32_t pcnt = 0;
 
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, &app_req,
@@ -961,18 +963,12 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	size = sizeof(struct app_stats_reply) +
 	    (sizeof(struct app_sinfo) * app_req.num_ports);
 
-	if (size > bsg_job->reply_payload.payload_len)
-		ret_size = bsg_job->reply_payload.payload_len;
-	else
-		ret_size = size;
-
 	app_reply = kzalloc(size, GFP_KERNEL);
 	if (!app_reply) {
 		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
 		rval = -1;
 	} else {
 		struct fc_port	*fcport = NULL, *tf;
-		uint32_t	pcnt = 0;
 
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			if (fcport->edif.enable) {
@@ -996,9 +992,11 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		SET_DID_STATUS(bsg_reply->result, DID_OK);
 	}
 
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len =
 	    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-	       bsg_job->reply_payload.sg_cnt, app_reply, ret_size);
+	       bsg_job->reply_payload.sg_cnt, app_reply,
+	       sizeof(struct app_stats_reply) + (sizeof(struct app_sinfo) * pcnt));
 
 	kfree(app_reply);
 
@@ -1072,8 +1070,7 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 		    __func__,
 		    bsg_request->rqst_data.h_vendor.vendor_cmd[1]);
 		rval = EXT_STATUS_INVALID_PARAM;
-		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		done = false;
 		break;
 	}
 
-- 
2.33.0



