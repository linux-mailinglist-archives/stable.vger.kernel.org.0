Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12924F39CE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378758AbiDELih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353976AbiDEKKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A989CC55AF;
        Tue,  5 Apr 2022 02:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 295E861676;
        Tue,  5 Apr 2022 09:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4D7C385A1;
        Tue,  5 Apr 2022 09:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152572;
        bh=t+YXwxVQiruok3nvS8KiwY6su7UP+gSuSvw7d35/h0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqQzLZN4tQ0Zf/ZVn5Al+6Zz8ME1fpho8dJ68/BLq+6fzqkYKk6mucHdqBKegm/3k
         XUPqomSraVT32Bnp0pqy4rqwDUnQStJHvaKo/RTr6gx3PA9waKs6SHGyPULYe3IN1T
         7krnJ046CRJxQpCcSRxpeZ5i6cddBD1PCKd+ieq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 787/913] scsi: qla2xxx: Refactor asynchronous command initialization
Date:   Tue,  5 Apr 2022 09:30:49 +0200
Message-Id: <20220405070403.424934477@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Daniel Wagner <dwagner@suse.de>

commit d4523bd6fd5d3afa9f08a86038a8a92176089f5b upstream.

Move common open-coded asynchronous command initializing code such as
setting up the timer and the done callback into one function. This is a
preparation step and allows us later on to change the low level error flow
handling at a central place.

Link: https://lore.kernel.org/r/20220110050218.3958-2-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h    |    3 -
 drivers/scsi/qla2xxx/qla_gs.c     |   70 ++++++++++------------------------
 drivers/scsi/qla2xxx/qla_init.c   |   77 ++++++++++++--------------------------
 drivers/scsi/qla2xxx/qla_iocb.c   |   29 +++++++-------
 drivers/scsi/qla2xxx/qla_mbx.c    |   11 +----
 drivers/scsi/qla2xxx/qla_mid.c    |    5 --
 drivers/scsi/qla2xxx/qla_mr.c     |    7 +--
 drivers/scsi/qla2xxx/qla_target.c |    6 --
 8 files changed, 76 insertions(+), 132 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -316,7 +316,8 @@ extern int qla2x00_start_sp(srb_t *);
 extern int qla24xx_dif_start_scsi(srb_t *);
 extern int qla2x00_start_bidir(srb_t *, struct scsi_qla_host *, uint32_t);
 extern int qla2xxx_dif_start_scsi_mq(srb_t *);
-extern void qla2x00_init_timer(srb_t *sp, unsigned long tmo);
+extern void qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
+				  void (*done)(struct srb *, int));
 extern unsigned long qla2x00_get_async_timeout(struct scsi_qla_host *);
 
 extern void *qla2x00_alloc_iocbs(struct scsi_qla_host *, srb_t *);
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -598,7 +598,8 @@ static int qla_async_rftid(scsi_qla_host
 
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "rft_id";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_sns_sp_done);
 
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
@@ -638,8 +639,6 @@ static int qla_async_rftid(scsi_qla_host
 	sp->u.iocb_cmd.u.ctarg.req_size = RFT_ID_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RFT_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_sns_sp_done;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - hdl=%x portid %06x.\n",
@@ -694,7 +693,8 @@ static int qla_async_rffid(scsi_qla_host
 
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "rff_id";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_sns_sp_done);
 
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
@@ -732,8 +732,6 @@ static int qla_async_rffid(scsi_qla_host
 	sp->u.iocb_cmd.u.ctarg.req_size = RFF_ID_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RFF_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_sns_sp_done;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - hdl=%x portid %06x feature %x type %x.\n",
@@ -785,7 +783,8 @@ static int qla_async_rnnid(scsi_qla_host
 
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "rnid";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_sns_sp_done);
 
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
@@ -823,9 +822,6 @@ static int qla_async_rnnid(scsi_qla_host
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RNN_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_sns_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - hdl=%x portid %06x\n",
 	    sp->name, sp->handle, d_id->b24);
@@ -892,7 +888,8 @@ static int qla_async_rsnn_nn(scsi_qla_ho
 
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "rsnn_nn";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_sns_sp_done);
 
 	sp->u.iocb_cmd.u.ctarg.req = dma_alloc_coherent(&vha->hw->pdev->dev,
 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
@@ -936,9 +933,6 @@ static int qla_async_rsnn_nn(scsi_qla_ho
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RSNN_NN_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_sns_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - hdl=%x.\n",
 	    sp->name, sp->handle);
@@ -2912,8 +2906,8 @@ int qla24xx_async_gpsc(scsi_qla_host_t *
 	sp->name = "gpsc";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla24xx_async_gpsc_sp_done);
 
 	/* CT_IU preamble  */
 	ct_req = qla24xx_prep_ct_fm_req(fcport->ct_desc.ct_sns, GPSC_CMD,
@@ -2931,9 +2925,6 @@ int qla24xx_async_gpsc(scsi_qla_host_t *
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GPSC_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = vha->mgmt_svr_loop_id;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla24xx_async_gpsc_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0x205e,
 	    "Async-%s %8phC hdl=%x loopid=%x portid=%02x%02x%02x.\n",
 	    sp->name, fcport->port_name, sp->handle,
@@ -3189,7 +3180,8 @@ int qla24xx_async_gpnid(scsi_qla_host_t
 	sp->name = "gpnid";
 	sp->u.iocb_cmd.u.ctarg.id = *id;
 	sp->gen1 = 0;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_gpnid_sp_done);
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	list_for_each_entry(tsp, &vha->gpnid_list, elem) {
@@ -3237,9 +3229,6 @@ int qla24xx_async_gpnid(scsi_qla_host_t
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GPN_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	sp->done = qla2x00_async_gpnid_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0x2067,
 	    "Async-%s hdl=%x ID %3phC.\n", sp->name,
 	    sp->handle, &ct_req->req.port_id.port_id);
@@ -3347,9 +3336,8 @@ int qla24xx_async_gffid(scsi_qla_host_t
 	sp->name = "gffid";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla24xx_async_gffid_sp_done);
 
 	/* CT_IU preamble  */
 	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GFF_ID_CMD,
@@ -3367,8 +3355,6 @@ int qla24xx_async_gffid(scsi_qla_host_t
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GFF_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->done = qla24xx_async_gffid_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0x2132,
 	    "Async-%s hdl=%x  %8phC.\n", sp->name,
 	    sp->handle, fcport->port_name);
@@ -3891,9 +3877,8 @@ static int qla24xx_async_gnnft(scsi_qla_
 	sp->name = "gnnft";
 	sp->gen1 = vha->hw->base_qpair->chip_reset;
 	sp->gen2 = fc4_type;
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_gpnft_gnnft_sp_done);
 
 	memset(sp->u.iocb_cmd.u.ctarg.rsp, 0, sp->u.iocb_cmd.u.ctarg.rsp_size);
 	memset(sp->u.iocb_cmd.u.ctarg.req, 0, sp->u.iocb_cmd.u.ctarg.req_size);
@@ -3909,8 +3894,6 @@ static int qla24xx_async_gnnft(scsi_qla_
 	sp->u.iocb_cmd.u.ctarg.req_size = GNN_FT_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->done = qla2x00_async_gpnft_gnnft_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s hdl=%x FC4Type %x.\n", sp->name,
 	    sp->handle, ct_req->req.gpn_ft.port_type);
@@ -4056,9 +4039,8 @@ int qla24xx_async_gpnft(scsi_qla_host_t
 	sp->name = "gpnft";
 	sp->gen1 = vha->hw->base_qpair->chip_reset;
 	sp->gen2 = fc4_type;
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_gpnft_gnnft_sp_done);
 
 	rspsz = sp->u.iocb_cmd.u.ctarg.rsp_size;
 	memset(sp->u.iocb_cmd.u.ctarg.rsp, 0, sp->u.iocb_cmd.u.ctarg.rsp_size);
@@ -4073,8 +4055,6 @@ int qla24xx_async_gpnft(scsi_qla_host_t
 
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->done = qla2x00_async_gpnft_gnnft_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s hdl=%x FC4Type %x.\n", sp->name,
 	    sp->handle, ct_req->req.gpn_ft.port_type);
@@ -4188,9 +4168,8 @@ int qla24xx_async_gnnid(scsi_qla_host_t
 	sp->name = "gnnid";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_gnnid_sp_done);
 
 	/* CT_IU preamble  */
 	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GNN_ID_CMD,
@@ -4209,8 +4188,6 @@ int qla24xx_async_gnnid(scsi_qla_host_t
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GNN_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->done = qla2x00_async_gnnid_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - %8phC hdl=%x loopid=%x portid %06x.\n",
 	    sp->name, fcport->port_name,
@@ -4316,9 +4293,8 @@ int qla24xx_async_gfpnid(scsi_qla_host_t
 	sp->name = "gfpnid";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_gfpnid_sp_done);
 
 	/* CT_IU preamble  */
 	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GFPN_ID_CMD,
@@ -4337,8 +4313,6 @@ int qla24xx_async_gfpnid(scsi_qla_host_t
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GFPN_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->done = qla2x00_async_gfpnid_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s - %8phC hdl=%x loopid=%x portid %06x.\n",
 	    sp->name, fcport->port_name,
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -167,16 +167,14 @@ int qla24xx_async_abort_cmd(srb_t *cmd_s
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 
-	abt_iocb->timeout = qla24xx_abort_iocb_timeout;
 	init_completion(&abt_iocb->u.abt.comp);
 	/* FW can send 2 x ABTS's timeout/20s */
-	qla2x00_init_timer(sp, 42);
+	qla2x00_init_async_sp(sp, 42, qla24xx_abort_sp_done);
+	sp->u.iocb_cmd.timeout = qla24xx_abort_iocb_timeout;
 
 	abt_iocb->u.abt.cmd_hndl = cmd_sp->handle;
 	abt_iocb->u.abt.req_que_no = cpu_to_le16(cmd_sp->qpair->req->id);
 
-	sp->done = qla24xx_abort_sp_done;
-
 	ql_dbg(ql_dbg_async, vha, 0x507c,
 	       "Abort command issued - hdl=%x, type=%x\n", cmd_sp->handle,
 	       cmd_sp->type);
@@ -320,12 +318,10 @@ qla2x00_async_login(struct scsi_qla_host
 	sp->name = "login";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_login_sp_done);
 
 	lio = &sp->u.iocb_cmd;
-	lio->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
-	sp->done = qla2x00_async_login_sp_done;
 	if (N2N_TOPO(fcport->vha->hw) && fcport_is_bigger(fcport)) {
 		lio->u.logio.flags |= SRB_LOGIN_PRLI_ONLY;
 	} else {
@@ -378,7 +374,6 @@ int
 qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	srb_t *sp;
-	struct srb_iocb *lio;
 	int rval = QLA_FUNCTION_FAILED;
 
 	fcport->flags |= FCF_ASYNC_SENT;
@@ -388,12 +383,8 @@ qla2x00_async_logout(struct scsi_qla_hos
 
 	sp->type = SRB_LOGOUT_CMD;
 	sp->name = "logout";
-
-	lio = &sp->u.iocb_cmd;
-	lio->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
-	sp->done = qla2x00_async_logout_sp_done;
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_logout_sp_done),
 
 	ql_dbg(ql_dbg_disc, vha, 0x2070,
 	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC explicit %d.\n",
@@ -440,7 +431,6 @@ int
 qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	srb_t *sp;
-	struct srb_iocb *lio;
 	int rval;
 
 	rval = QLA_FUNCTION_FAILED;
@@ -450,12 +440,8 @@ qla2x00_async_prlo(struct scsi_qla_host
 
 	sp->type = SRB_PRLO_CMD;
 	sp->name = "prlo";
-
-	lio = &sp->u.iocb_cmd;
-	lio->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
-	sp->done = qla2x00_async_prlo_sp_done;
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_prlo_sp_done);
 
 	ql_dbg(ql_dbg_disc, vha, 0x2070,
 	    "Async-prlo - hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
@@ -576,16 +562,15 @@ qla2x00_async_adisc(struct scsi_qla_host
 
 	sp->type = SRB_ADISC_CMD;
 	sp->name = "adisc";
-
-	lio = &sp->u.iocb_cmd;
-	lio->timeout = qla2x00_async_iocb_timeout;
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_adisc_sp_done);
 
-	sp->done = qla2x00_async_adisc_sp_done;
-	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
+	if (data[1] & QLA_LOGIO_LOGIN_RETRIED) {
+		lio = &sp->u.iocb_cmd;
 		lio->u.logio.flags |= SRB_LOGIN_RETRIED;
+	}
 
 	ql_dbg(ql_dbg_disc, vha, 0x206f,
 	    "Async-adisc - hdl=%x loopid=%x portid=%06x %8phC.\n",
@@ -1085,7 +1070,6 @@ static void qla24xx_async_gnl_sp_done(sr
 int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	srb_t *sp;
-	struct srb_iocb *mbx;
 	int rval = QLA_FUNCTION_FAILED;
 	unsigned long flags;
 	u16 *mb;
@@ -1118,10 +1102,8 @@ int qla24xx_async_gnl(struct scsi_qla_ho
 	sp->name = "gnlist";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	mbx = &sp->u.iocb_cmd;
-	mbx->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla24xx_async_gnl_sp_done);
 
 	mb = sp->u.iocb_cmd.u.mbx.out_mb;
 	mb[0] = MBC_PORT_NODE_NAME_LIST;
@@ -1133,8 +1115,6 @@ int qla24xx_async_gnl(struct scsi_qla_ho
 	mb[8] = vha->gnl.size;
 	mb[9] = vha->vp_idx;
 
-	sp->done = qla24xx_async_gnl_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0x20da,
 	    "Async-%s - OUT WWPN %8phC hndl %x\n",
 	    sp->name, fcport->port_name, sp->handle);
@@ -1270,12 +1250,10 @@ qla24xx_async_prli(struct scsi_qla_host
 
 	sp->type = SRB_PRLI_CMD;
 	sp->name = "prli";
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_prli_sp_done);
 
 	lio = &sp->u.iocb_cmd;
-	lio->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
-	sp->done = qla2x00_async_prli_sp_done;
 	lio->u.logio.flags = 0;
 
 	if (NVME_TARGET(vha->hw, fcport))
@@ -1345,10 +1323,8 @@ int qla24xx_async_gpdb(struct scsi_qla_h
 	sp->name = "gpdb";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-
-	mbx = &sp->u.iocb_cmd;
-	mbx->timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla24xx_async_gpdb_sp_done);
 
 	pd = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
 	if (pd == NULL) {
@@ -1367,11 +1343,10 @@ int qla24xx_async_gpdb(struct scsi_qla_h
 	mb[9] = vha->vp_idx;
 	mb[10] = opt;
 
-	mbx->u.mbx.in = pd;
+	mbx = &sp->u.iocb_cmd;
+	mbx->u.mbx.in = (void *)pd;
 	mbx->u.mbx.in_dma = pd_dma;
 
-	sp->done = qla24xx_async_gpdb_sp_done;
-
 	ql_dbg(ql_dbg_disc, vha, 0x20dc,
 	    "Async-%s %8phC hndl %x opt %x\n",
 	    sp->name, fcport->port_name, sp->handle, opt);
@@ -1955,18 +1930,16 @@ qla2x00_async_tm_cmd(fc_port_t *fcport,
 	if (!sp)
 		goto done;
 
-	tm_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_TM_CMD;
 	sp->name = "tmf";
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha),
+			      qla2x00_tmf_sp_done);
+	sp->u.iocb_cmd.timeout = qla2x00_tmf_iocb_timeout;
 
-	tm_iocb->timeout = qla2x00_tmf_iocb_timeout;
+	tm_iocb = &sp->u.iocb_cmd;
 	init_completion(&tm_iocb->u.tmf.comp);
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
-
 	tm_iocb->u.tmf.flags = flags;
 	tm_iocb->u.tmf.lun = lun;
-	tm_iocb->u.tmf.data = tag;
-	sp->done = qla2x00_tmf_sp_done;
 
 	ql_dbg(ql_dbg_taskm, vha, 0x802f,
 	    "Async-tmf hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2560,11 +2560,15 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mg
 	}
 }
 
-void qla2x00_init_timer(srb_t *sp, unsigned long tmo)
+void
+qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
+		     void (*done)(struct srb *sp, int res))
 {
 	timer_setup(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout, 0);
-	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
+	sp->done = done;
 	sp->free = qla2x00_sp_free;
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
+	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
 	if (IS_QLAFX00(sp->vha->hw) && sp->type == SRB_FXIOCB_DCMD)
 		init_completion(&sp->u.iocb_cmd.u.fxiocb.fxiocb_comp);
 	sp->start_timer = 1;
@@ -2672,11 +2676,11 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
 	sp->fcport = fcport;
-	elsio->timeout = qla2x00_els_dcmd_iocb_timeout;
-	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
-	init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
-	sp->done = qla2x00_els_dcmd_sp_done;
+	qla2x00_init_async_sp(sp, ELS_DCMD_TIMEOUT,
+			      qla2x00_els_dcmd_sp_done);
 	sp->free = qla2x00_els_dcmd_sp_free;
+	sp->u.iocb_cmd.timeout = qla2x00_els_dcmd_iocb_timeout;
+	init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
 
 	elsio->u.els_logo.els_logo_pyld = dma_alloc_coherent(&ha->pdev->dev,
 			    DMA_POOL_SIZE, &elsio->u.els_logo.els_logo_pyld_dma,
@@ -2993,17 +2997,16 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *
 	ql_dbg(ql_dbg_io, vha, 0x3073,
 	       "%s Enter: PLOGI portid=%06x\n", __func__, fcport->d_id.b24);
 
-	sp->type = SRB_ELS_DCMD;
-	sp->name = "ELS_DCMD";
-	sp->fcport = fcport;
-
-	elsio->timeout = qla2x00_els_dcmd2_iocb_timeout;
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 
-	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT + 2);
+	sp->type = SRB_ELS_DCMD;
+	sp->name = "ELS_DCMD";
+	sp->fcport = fcport;
+	qla2x00_init_async_sp(sp, ELS_DCMD_TIMEOUT + 2,
+			     qla2x00_els_dcmd2_sp_done);
+	sp->u.iocb_cmd.timeout = qla2x00_els_dcmd2_iocb_timeout;
 
-	sp->done = qla2x00_els_dcmd2_sp_done;
 	elsio->u.els_plogi.tx_size = elsio->u.els_plogi.rx_size = DMA_POOL_SIZE;
 
 	ptr = elsio->u.els_plogi.els_plogi_pyld =
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6483,19 +6483,16 @@ int qla24xx_send_mb_cmd(struct scsi_qla_
 	if (!sp)
 		goto done;
 
-	sp->type = SRB_MB_IOCB;
-	sp->name = mb_to_str(mcp->mb[0]);
-
 	c = &sp->u.iocb_cmd;
-	c->timeout = qla2x00_async_iocb_timeout;
 	init_completion(&c->u.mbx.comp);
 
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	sp->type = SRB_MB_IOCB;
+	sp->name = mb_to_str(mcp->mb[0]);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_mb_sp_done);
 
 	memcpy(sp->u.iocb_cmd.u.mbx.out_mb, mcp->mb, SIZEOF_IOCB_MB_REG);
 
-	sp->done = qla2x00_async_mb_sp_done;
-
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1018,
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -972,9 +972,8 @@ int qla24xx_control_vp(scsi_qla_host_t *
 	sp->type = SRB_CTRL_VP;
 	sp->name = "ctrl_vp";
 	sp->comp = &comp;
-	sp->done = qla_ctrlvp_sp_done;
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla_ctrlvp_sp_done);
 	sp->u.iocb_cmd.u.ctrlvp.cmd = cmd;
 	sp->u.iocb_cmd.u.ctrlvp.vp_index = vp_index;
 
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1793,11 +1793,11 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc
 
 	sp->type = SRB_FXIOCB_DCMD;
 	sp->name = "fxdisc";
+	qla2x00_init_async_sp(sp, FXDISC_TIMEOUT,
+			      qla2x00_fxdisc_sp_done);
+	sp->u.iocb_cmd.timeout = qla2x00_fxdisc_iocb_timeout;
 
 	fdisc = &sp->u.iocb_cmd;
-	fdisc->timeout = qla2x00_fxdisc_iocb_timeout;
-	qla2x00_init_timer(sp, FXDISC_TIMEOUT);
-
 	switch (fx_type) {
 	case FXDISC_GET_CONFIG_INFO:
 	fdisc->u.fxiocb.flags =
@@ -1898,7 +1898,6 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc
 	}
 
 	fdisc->u.fxiocb.req_func_type = cpu_to_le16(fx_type);
-	sp->done = qla2x00_fxdisc_sp_done;
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -656,12 +656,10 @@ int qla24xx_async_notify_ack(scsi_qla_ho
 
 	sp->type = type;
 	sp->name = "nack";
-
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
+	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
+			      qla2x00_async_nack_sp_done);
 
 	sp->u.iocb_cmd.u.nack.ntfy = ntfy;
-	sp->done = qla2x00_async_nack_sp_done;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20f4,
 	    "Async-%s %8phC hndl %x %s\n",


