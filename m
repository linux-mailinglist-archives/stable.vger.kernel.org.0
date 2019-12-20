Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B535F127D76
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfLTOe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbfLTOa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 614AD222C2;
        Fri, 20 Dec 2019 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852227;
        bh=6sWzmQDeg1/vZEhrwOu0mgaGDs5oEm0Uqe+Gk8JOxxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMs8R3G0m9I4AGC+DovIa6zo3VmOvwuhAeEtWkKLtOLxS6cqLc+hJAb5fC6lUJgGd
         b4H5FbZ+1I7yqMft9/hboXqvXcaHvaFURNUoP3tmKVfrSzcfZS7I5zG2hSmTZZ/1M3
         umGKYZI99mppqAucOJf/wxHLTyKSbA8u+sK/xs2k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>, Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/52] scsi: qla2xxx: Use explicit LOGO in target mode
Date:   Fri, 20 Dec 2019 09:29:26 -0500
Message-Id: <20191220142954.9500-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d5386edddaf64..1eb3fe281cc3c 100644
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
index 518eb954cf42c..44dc97cebb06b 100644
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
index a06e56224a559..29729efac51f2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1104,6 +1104,7 @@ void qlt_free_session_done(struct work_struct *work)
 		}
 	}
 
+	sess->explicit_logout = 0;
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	sess->free_pending = 0;
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 042a24314edcf..589cd22198bb0 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -348,6 +348,7 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	target_sess_cmd_list_set_waiting(se_sess);
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
+	sess->explicit_logout = 1;
 	tcm_qla2xxx_put_sess(sess);
 }
 
-- 
2.20.1

