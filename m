Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C967451EE5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343886AbhKPAhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344684AbhKOTZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B918636AC;
        Mon, 15 Nov 2021 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002932;
        bh=P4W9AgWWiVYk1csbTzAj0LQ2lQGFUlPtSi6yMupF2tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQbO8lYe0ppWLW+Tpdnpw3MDgkxtenM9S4B6Rb406spE9+7Mn83whaNWWDiLm/EJu
         XpnDLQ1OO31NLFtqUTE0GkzhfHRB4mzjwfoGvhi0t9DQgXI7WxPEJKQLVK2jba2Ffl
         BdeXdXy/BwqS7N2K6zPevul99oM9J4IqBkFrxlHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 750/917] scsi: qla2xxx: edif: Fix app start fail
Date:   Mon, 15 Nov 2021 18:04:05 +0100
Message-Id: <20211115165454.346463663@linuxfoundation.org>
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

[ Upstream commit 8e6d5df3cb32dddf558a52414d29febecb660396 ]

On app start, all sessions need to be reset to see if secure connection can
be made. Fix the broken check which prevents that process.

Link: https://lore.kernel.org/r/20211026115412.27691-5-njavali@marvell.com
Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 52 ++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index ad746c62f0d44..615596becb7a1 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -529,7 +529,8 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	struct app_start_reply	appreply;
 	struct fc_port  *fcport, *tf;
 
-	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app start\n", __func__);
+	ql_log(ql_log_info, vha, 0x1313,
+	       "EDIF application registration with driver, FC device connections will be re-established.\n");
 
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, &appstart,
@@ -554,37 +555,36 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		qla2xxx_wake_dpc(vha);
 	} else {
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
+			ql_dbg(ql_dbg_edif, vha, 0x2058,
+			       "FCSP - nn %8phN pn %8phN portid=%06x.\n",
+			       fcport->node_name, fcport->port_name,
+			       fcport->d_id.b24);
 			ql_dbg(ql_dbg_edif, vha, 0xf084,
-			       "%s: sess %p %8phC lid %#04x s_id %06x logout %d\n",
-			       __func__, fcport, fcport->port_name,
-			       fcport->loop_id, fcport->d_id.b24,
-			       fcport->logout_on_delete);
-
-			ql_dbg(ql_dbg_edif, vha, 0xf084,
-			       "keep %d els_logo %d disc state %d auth state %d stop state %d\n",
-			       fcport->keep_nport_handle,
-			       fcport->send_els_logo, fcport->disc_state,
-			       fcport->edif.auth_state, fcport->edif.app_stop);
+			       "%s: se_sess %p / sess %p from port %8phC "
+			       "loop_id %#04x s_id %06x logout %d "
+			       "keep %d els_logo %d disc state %d auth state %d"
+			       "stop state %d\n",
+			       __func__, fcport->se_sess, fcport,
+			       fcport->port_name, fcport->loop_id,
+			       fcport->d_id.b24, fcport->logout_on_delete,
+			       fcport->keep_nport_handle, fcport->send_els_logo,
+			       fcport->disc_state, fcport->edif.auth_state,
+			       fcport->edif.app_stop);
 
 			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
 				break;
-			if (!(fcport->flags & FCF_FCSP_DEVICE))
-				continue;
 
 			fcport->edif.app_started = 1;
-			if (fcport->edif.app_stop ||
-			    (fcport->disc_state != DSC_LOGIN_COMPLETE &&
-			     fcport->disc_state != DSC_LOGIN_PEND &&
-			     fcport->disc_state != DSC_DELETED)) {
-				/* no activity */
-				fcport->edif.app_stop = 0;
-
-				ql_dbg(ql_dbg_edif, vha, 0x911e,
-				       "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
-				       __func__, fcport->port_name);
-				fcport->edif.app_sess_online = 1;
-				qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
-			}
+			fcport->login_retry = vha->hw->login_retry_count;
+
+			/* no activity */
+			fcport->edif.app_stop = 0;
+
+			ql_dbg(ql_dbg_edif, vha, 0x911e,
+			       "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
+			       __func__, fcport->port_name);
+			fcport->edif.app_sess_online = 1;
+			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
 			qla_edif_sa_ctl_init(vha, fcport);
 		}
 	}
-- 
2.33.0



