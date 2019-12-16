Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919F71214A7
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbfLPSNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:13:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731087AbfLPSNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:13:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3236321582;
        Mon, 16 Dec 2019 18:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519998;
        bh=sInmNJgXILs0cHVozaxxnQ7mHNlApnUnRvJc+jszUY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGw8D9y2S6ujXK4kd5W2sZTjrqyid8qUQG4wAttMGbilm0jIT9QPOv6zPDtHWfGSh
         HP4jjnuuDDmazOQjcn61n/+c/LRZio5+VeaxbLXOsHF0E/CRxSBuv8i3VEhw8+eXoN
         z+oLRpc1GhA9c2BmKODL4Du/2wqVGBvLmGTOY+GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 154/180] scsi: qla2xxx: Fix stuck login session
Date:   Mon, 16 Dec 2019 18:49:54 +0100
Message-Id: <20191216174844.558699420@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit ce0ba496dccfc15d3a8866b845864585b5d316ff ]

Login session was stucked on cable pull. When FW is in the middle PRLI
PENDING + driver is in Initiator mode, driver fails to check back with FW to
see if the PRLI has completed. This patch would re-check with FW again to
make sure PRLI would complete before pushing forward with relogin.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Link: https://lore.kernel.org/r/20190830222402.23688-5-hmadhani@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index fb9095179fc59..d4e381f81997b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -842,6 +842,15 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 			fcport->fw_login_state = current_login_state;
 			fcport->d_id = id;
 			switch (current_login_state) {
+			case DSC_LS_PRLI_PEND:
+				/*
+				 * In the middle of PRLI. Let it finish.
+				 * Allow relogin code to recheck state again
+				 * with GNL. Push disc_state back to DELETED
+				 * so GNL can go out again
+				 */
+				fcport->disc_state = DSC_DELETED;
+				break;
 			case DSC_LS_PRLI_COMP:
 				if ((e->prli_svc_param_word_3[0] & BIT_4) == 0)
 					fcport->port_type = FCT_INITIATOR;
@@ -1517,7 +1526,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	u64 wwn;
 	u16 sec;
 
-	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x20d8,
+	ql_dbg(ql_dbg_disc, vha, 0x20d8,
 	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d lid %d scan %d\n",
 	    __func__, fcport->port_name, fcport->disc_state,
 	    fcport->fw_login_state, fcport->login_pause, fcport->flags,
@@ -1528,6 +1537,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		return 0;
 
 	if ((fcport->loop_id != FC_NO_LOOP_ID) &&
+	    qla_dual_mode_enabled(vha) &&
 	    ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
 	     (fcport->fw_login_state == DSC_LS_PRLI_PEND)))
 		return 0;
@@ -1697,17 +1707,6 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 	    fcport->last_login_gen, fcport->login_gen,
 	    fcport->flags);
 
-	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
-	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
-		return;
-
-	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
-		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline)) {
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-			return;
-		}
-	}
-
 	if (fcport->last_rscn_gen != fcport->rscn_gen) {
 		ql_dbg(ql_dbg_disc, vha, 0x20e9, "%s %d %8phC post gnl\n",
 		    __func__, __LINE__, fcport->port_name);
-- 
2.20.1



