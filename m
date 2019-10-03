Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2BACA6F4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405795AbfJCQtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405098AbfJCQs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:48:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48ED620830;
        Thu,  3 Oct 2019 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121337;
        bh=LeERzmuctCeSuhuULVmF9fFXwSY41m5ogzB9ycAZJPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCuxibR0LV9Hut5zl/9tsoWXH6bQoQU7ndXrR0Vfqj8GfNf80WRjNc8N4aF0Oc12T
         AvLKVMW2safzjp1AwHNoxKNwyxZJCdK87d++MbZ/n1U2x6bWK6Zsh9WaC/HcoTahxc
         vbF+8mCc3hWDsfdlCQkMn5fHm+16OggNLnKIY4Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.3 241/344] scsi: qla2xxx: Fix Relogin to prevent modifying scan_state flag
Date:   Thu,  3 Oct 2019 17:53:26 +0200
Message-Id: <20191003154604.169402030@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit 8b5292bcfcacf15182a77a973a98d310e76fd58b upstream.

Relogin fails to move forward due to scan_state flag indicating device is
not there. Before relogin process, Session delete process accidently
modified the scan_state flag.

[mkp: typos plus corrected Fixes: sha as reported by sfr]

Fixes: 2dee5521028c ("scsi: qla2xxx: Fix login state machine freeze")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_init.c   |   25 ++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_os.c     |    1 +
 drivers/scsi/qla2xxx/qla_target.c |    1 -
 3 files changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -289,8 +289,13 @@ qla2x00_async_login(struct scsi_qla_host
 	struct srb_iocb *lio;
 	int rval = QLA_FUNCTION_FAILED;
 
-	if (!vha->flags.online)
-		goto done;
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT) ||
+	    fcport->loop_id == FC_NO_LOOP_ID) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "%s: %8phC - not sending command.\n",
+		    __func__, fcport->port_name);
+		return rval;
+	}
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
@@ -1262,8 +1267,13 @@ int qla24xx_async_gpdb(struct scsi_qla_h
 	struct port_database_24xx *pd;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT) ||
+	    fcport->loop_id == FC_NO_LOOP_ID) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "%s: %8phC - not sending command.\n",
+		    __func__, fcport->port_name);
 		return rval;
+	}
 
 	fcport->disc_state = DSC_GPDB;
 
@@ -1953,8 +1963,11 @@ qla24xx_handle_plogi_done_event(struct s
 		return;
 	}
 
-	if (fcport->disc_state == DSC_DELETE_PEND)
+	if ((fcport->disc_state == DSC_DELETE_PEND) ||
+	    (fcport->disc_state == DSC_DELETED)) {
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		return;
+	}
 
 	if (ea->sp->gen2 != fcport->login_gen) {
 		/* target side must have changed it. */
@@ -6698,8 +6711,10 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_
 	}
 
 	/* Clear all async request states across all VPs. */
-	list_for_each_entry(fcport, &vha->vp_fcports, list)
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+		fcport->scan_state = 0;
+	}
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry(vp, &ha->vp_list, list) {
 		atomic_inc(&vp->vref_count);
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5086,6 +5086,7 @@ void qla24xx_create_new_sess(struct scsi
 	if (fcport) {
 		fcport->id_changed = 1;
 		fcport->scan_state = QLA_FCPORT_FOUND;
+		fcport->chip_reset = vha->hw->base_qpair->chip_reset;
 		memcpy(fcport->node_name, e->u.new_sess.node_name, WWN_SIZE);
 
 		if (pla) {
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1209,7 +1209,6 @@ static void qla24xx_chk_fcp_state(struct
 		sess->logout_on_delete = 0;
 		sess->logo_ack_needed = 0;
 		sess->fw_login_state = DSC_LS_PORT_UNAVAIL;
-		sess->scan_state = 0;
 	}
 }
 


