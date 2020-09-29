Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA0427CA05
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732243AbgI2MPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729682AbgI2LhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802EB23EAF;
        Tue, 29 Sep 2020 11:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379132;
        bh=GuydHO9q3hqS4cSCp53Kx8Gu+F5DGVHOJVgrJoPuwi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2is+gEBYSIprRg74mXD5FM6uTB751gMKlV3GNp/qESuoFOG+ATTl1tDEYNdGybs1V
         vhTBcmC7WMPfHJ5lr+qToEidg8s1n50XPNUiae+QVGweB5p3nawb4ViXbcg1/I2NIm
         MKKPBmP4zvLehphB+qU2ckY1+4pM03T+hJt0gMl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/388] scsi: qla2xxx: Add error handling for PLOGI ELS passthrough
Date:   Tue, 29 Sep 2020 12:55:40 +0200
Message-Id: <20200929110010.933632579@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit c76ae845ea836d6128982dcbd41ac35c81e2de63 ]

Add error handling logic to ELS Passthrough relating to NVME devices.
Current code does not parse error code to take proper recovery action,
instead it re-logins with the same login parameters that encountered the
error. Ex: nport handle collision.

Link: https://lore.kernel.org/r/20190912180918.6436-10-hmadhani@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 95 +++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index bdf1994251b9b..2e272fc858ed1 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2749,6 +2749,10 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 	struct scsi_qla_host *vha = sp->vha;
 	struct event_arg ea;
 	struct qla_work_evt *e;
+	struct fc_port *conflict_fcport;
+	port_id_t cid;	/* conflict Nport id */
+	u32 *fw_status = sp->u.iocb_cmd.u.els_plogi.fw_status;
+	u16 lid;
 
 	ql_dbg(ql_dbg_disc, vha, 0x3072,
 	    "%s ELS done rc %d hdl=%x, portid=%06x %8phC\n",
@@ -2760,14 +2764,99 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
 		complete(&lio->u.els_plogi.comp);
 	else {
-		if (res) {
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		} else {
+		switch (fw_status[0]) {
+		case CS_DATA_UNDERRUN:
+		case CS_COMPLETE:
 			memset(&ea, 0, sizeof(ea));
 			ea.fcport = fcport;
 			ea.data[0] = MBS_COMMAND_COMPLETE;
 			ea.sp = sp;
 			qla24xx_handle_plogi_done_event(vha, &ea);
+			break;
+		case CS_IOCB_ERROR:
+			switch (fw_status[1]) {
+			case LSC_SCODE_PORTID_USED:
+				lid = fw_status[2] & 0xffff;
+				qlt_find_sess_invalidate_other(vha,
+				    wwn_to_u64(fcport->port_name),
+				    fcport->d_id, lid, &conflict_fcport);
+				if (conflict_fcport) {
+					/*
+					 * Another fcport shares the same
+					 * loop_id & nport id; conflict
+					 * fcport needs to finish cleanup
+					 * before this fcport can proceed
+					 * to login.
+					 */
+					conflict_fcport->conflict = fcport;
+					fcport->login_pause = 1;
+					ql_dbg(ql_dbg_disc, vha, 0x20ed,
+					    "%s %d %8phC pid %06x inuse with lid %#x post gidpn\n",
+					    __func__, __LINE__,
+					    fcport->port_name,
+					    fcport->d_id.b24, lid);
+				} else {
+					ql_dbg(ql_dbg_disc, vha, 0x20ed,
+					    "%s %d %8phC pid %06x inuse with lid %#x sched del\n",
+					    __func__, __LINE__,
+					    fcport->port_name,
+					    fcport->d_id.b24, lid);
+					qla2x00_clear_loop_id(fcport);
+					set_bit(lid, vha->hw->loop_id_map);
+					fcport->loop_id = lid;
+					fcport->keep_nport_handle = 0;
+					qlt_schedule_sess_for_deletion(fcport);
+				}
+				break;
+
+			case LSC_SCODE_NPORT_USED:
+				cid.b.domain = (fw_status[2] >> 16) & 0xff;
+				cid.b.area   = (fw_status[2] >>  8) & 0xff;
+				cid.b.al_pa  = fw_status[2] & 0xff;
+				cid.b.rsvd_1 = 0;
+
+				ql_dbg(ql_dbg_disc, vha, 0x20ec,
+				    "%s %d %8phC lid %#x in use with pid %06x post gnl\n",
+				    __func__, __LINE__, fcport->port_name,
+				    fcport->loop_id, cid.b24);
+				set_bit(fcport->loop_id,
+				    vha->hw->loop_id_map);
+				fcport->loop_id = FC_NO_LOOP_ID;
+				qla24xx_post_gnl_work(vha, fcport);
+				break;
+
+			case LSC_SCODE_NOXCB:
+				vha->hw->exch_starvation++;
+				if (vha->hw->exch_starvation > 5) {
+					ql_log(ql_log_warn, vha, 0xd046,
+					    "Exchange starvation. Resetting RISC\n");
+					vha->hw->exch_starvation = 0;
+					set_bit(ISP_ABORT_NEEDED,
+					    &vha->dpc_flags);
+					qla2xxx_wake_dpc(vha);
+				}
+				/* fall through */
+			default:
+				ql_dbg(ql_dbg_disc, vha, 0x20eb,
+				    "%s %8phC cmd error fw_status 0x%x 0x%x 0x%x\n",
+				    __func__, sp->fcport->port_name,
+				    fw_status[0], fw_status[1], fw_status[2]);
+
+				fcport->flags &= ~FCF_ASYNC_SENT;
+				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+				break;
+			}
+			break;
+
+		default:
+			ql_dbg(ql_dbg_disc, vha, 0x20eb,
+			    "%s %8phC cmd error 2 fw_status 0x%x 0x%x 0x%x\n",
+			    __func__, sp->fcport->port_name,
+			    fw_status[0], fw_status[1], fw_status[2]);
+
+			sp->fcport->flags &= ~FCF_ASYNC_SENT;
+			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			break;
 		}
 
 		e = qla2x00_alloc_work(vha, QLA_EVT_UNMAP);
-- 
2.25.1



