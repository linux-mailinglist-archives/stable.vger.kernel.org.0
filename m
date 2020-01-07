Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128BB133103
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgAGU4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727327AbgAGU4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:56:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC28E214D8;
        Tue,  7 Jan 2020 20:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430611;
        bh=Ty7u6J8Kzec+n1PJ72hiMKYldBjCKxUfAvKTbCJa9vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LshJQAg9vl010CSO1emsz7AhRDZ2k8pFIvpQY/mpM+zsIrPzQ2vwrLCBDS32E1Dyz
         Do803T+MtyShstBMyay4M+9eLXPlPG8QQTiLvSYCEYuKidINbqOLNKQmQDEemxKplu
         KuLEfUlK5E7MbqNx6LlFmyrUdF3aws5zTPkMdyyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/191] scsi: qla2xxx: Use explicit LOGO in target mode
Date:   Tue,  7 Jan 2020 21:52:24 +0100
Message-Id: <20200107205334.296043641@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 86196a8fa8a84af1395a28ea0548f2ce6ae9bc22 ]

Target makes implicit LOGO on session teardown. LOGO ELS is not send on the
wire and initiator is not aware that target no longer wants talking to
it. Initiator keeps sending I/O requests, target responds with BA_RJT, they
time out and then initiator sends ABORT TASK (ABTS-LS).

Current behaviour incurs unneeded I/O timeout and can be fixed for some
initiators by making explicit LOGO on session deletion.

Link: https://lore.kernel.org/r/20191125165702.1013-3-r.bolshakov@yadro.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h     |  1 +
 drivers/scsi/qla2xxx/qla_iocb.c    | 16 ++++++++++++----
 drivers/scsi/qla2xxx/qla_target.c  |  1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  1 +
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d5386edddaf6..1eb3fe281cc3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2401,6 +2401,7 @@ typedef struct fc_port {
 	unsigned int id_changed:1;
 	unsigned int scan_needed:1;
 	unsigned int n2n_flag:1;
+	unsigned int explicit_logout:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 518eb954cf42..44dc97cebb06 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2405,11 +2405,19 @@ qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
 static void
 qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 {
+	u16 control_flags = LCF_COMMAND_LOGO;
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
-	logio->control_flags =
-	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
-	if (!sp->fcport->keep_nport_handle)
-		logio->control_flags |= cpu_to_le16(LCF_FREE_NPORT);
+
+	if (sp->fcport->explicit_logout) {
+		control_flags |= LCF_EXPL_LOGO|LCF_FREE_NPORT;
+	} else {
+		control_flags |= LCF_IMPL_LOGO;
+
+		if (!sp->fcport->keep_nport_handle)
+			control_flags |= LCF_FREE_NPORT;
+	}
+
+	logio->control_flags = cpu_to_le16(control_flags);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a9bd0f513316..950764ed4ab2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1104,6 +1104,7 @@ void qlt_free_session_done(struct work_struct *work)
 		}
 	}
 
+	sess->explicit_logout = 0;
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	sess->free_pending = 0;
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index bab2073c1f72..abe7f79bb789 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -350,6 +350,7 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	target_sess_cmd_list_set_waiting(se_sess);
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
+	sess->explicit_logout = 1;
 	tcm_qla2xxx_put_sess(sess);
 }
 
-- 
2.20.1



