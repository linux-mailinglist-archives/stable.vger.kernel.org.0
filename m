Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CEE451E37
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345111AbhKPAf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344683AbhKOTZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C4F9636AB;
        Mon, 15 Nov 2021 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002935;
        bh=PaFViRxYXC6xhGa2I6uhquoAwS32oBto5srNQd+dT1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JknHKOVb7ccV0VHMAc15L4oGgeazg2fm/Ha7fOp2MK0CGW0jQgHKQ/UBHLGRviZ/W
         GV6h6vlaCbJb928t2GTHgUk/N2qO5r7zY8cffZvSAAuVQCoFmoRe1nzLMAOXM+it+g
         BR0yfyWCHJIivAOz3IDbeYBFmD5xgoH2xXOCXNcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 751/917] scsi: qla2xxx: edif: Fix app start delay
Date:   Mon, 15 Nov 2021 18:04:06 +0100
Message-Id: <20211115165454.383059057@linuxfoundation.org>
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

[ Upstream commit b492d6a4880fddce098472dec5086d37802c68d3 ]

Current driver does unnecessary pause for each session to get to certain
state before allowing the app start call to return. In larger environment,
this introduces a long delay.  Originally the delay was meant to
synchronize app and driver. However, the with current implementation the
two sides use various events to synchronize their state.

The same is applied to the authentication failure call.

Link: https://lore.kernel.org/r/20211026115412.27691-6-njavali@marvell.com
Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 64 ++-------------------------------
 1 file changed, 3 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 615596becb7a1..cf62f26ce27d9 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -290,63 +290,6 @@ qla_edif_app_check(scsi_qla_host_t *vha, struct app_id appid)
 	return false;
 }
 
-static void qla_edif_reset_auth_wait(struct fc_port *fcport, int state,
-		int waitonly)
-{
-	int cnt, max_cnt = 200;
-	bool traced = false;
-
-	fcport->keep_nport_handle = 1;
-
-	if (!waitonly) {
-		qla2x00_set_fcport_disc_state(fcport, state);
-		qlt_schedule_sess_for_deletion(fcport);
-	} else {
-		qla2x00_set_fcport_disc_state(fcport, state);
-	}
-
-	ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
-		"%s: waiting for session, max_cnt=%u\n",
-		__func__, max_cnt);
-
-	cnt = 0;
-
-	if (waitonly) {
-		/* Marker wait min 10 msecs. */
-		msleep(50);
-		cnt += 50;
-	}
-	while (1) {
-		if (!traced) {
-			ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
-			    "%s: session sleep.\n",
-			    __func__);
-			traced = true;
-		}
-		msleep(20);
-		cnt++;
-		if (waitonly && (fcport->disc_state == state ||
-			fcport->disc_state == DSC_LOGIN_COMPLETE))
-			break;
-		if (fcport->disc_state == DSC_LOGIN_AUTH_PEND)
-			break;
-		if (cnt > max_cnt)
-			break;
-	}
-
-	if (!waitonly) {
-		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
-		    "%s: waited for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",
-		    __func__, fcport->port_name, fcport->loop_id,
-		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
-	} else {
-		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
-		    "%s: waited ONLY for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",
-		    __func__, fcport->port_name, fcport->loop_id,
-		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
-	}
-}
-
 static void
 qla_edif_free_sa_ctl(fc_port_t *fcport, struct edif_sa_ctl *sa_ctl,
 	int index)
@@ -583,8 +526,8 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			ql_dbg(ql_dbg_edif, vha, 0x911e,
 			       "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
 			       __func__, fcport->port_name);
-			fcport->edif.app_sess_online = 1;
-			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
+			fcport->edif.app_sess_online = 0;
+			qlt_schedule_sess_for_deletion(fcport);
 			qla_edif_sa_ctl_init(vha, fcport);
 		}
 	}
@@ -800,7 +743,6 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		ql_dbg(ql_dbg_edif, vha, 0x911e,
 		    "%s AUTH complete - RESUME with prli for wwpn %8phC\n",
 		    __func__, fcport->port_name);
-		qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 1);
 		qla24xx_post_prli_work(vha, fcport);
 	}
 
@@ -873,7 +815,7 @@ qla_edif_app_authfail(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 		if (qla_ini_mode_enabled(fcport->vha)) {
 			fcport->send_els_logo = 1;
-			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
+			qlt_schedule_sess_for_deletion(fcport);
 		}
 	}
 
-- 
2.33.0



