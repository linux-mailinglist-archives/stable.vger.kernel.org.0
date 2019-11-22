Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E588510608C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfKVFtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbfKVFtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E297D2082F;
        Fri, 22 Nov 2019 05:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401790;
        bh=9Vyqt3zmn8NcG/gtQP2AQNm8fvqB9tSopBcJdG0d62E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ghl2ECi+jPhGhAD142ensyFs9fMnVkOtXn9tsh3EkhuubaIj8nIoLvmlPWAon4cak
         DGOMxGjaAMP2WgogDLjna6W+xepuyXMDSPJtyvobdX93TTAUQgTcQiG9+F+6N4XMR6
         Dc7CWYqHXJN9hVQw2JL5egvxG2WDtp2tFmsQ8V8Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 038/219] scsi: qla2xxx: Fix NPIV handling for FC-NVMe
Date:   Fri, 22 Nov 2019 00:46:10 -0500
Message-Id: <20191122054911.1750-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Himanshu Madhani <hmadhani@marvell.com>

[ Upstream commit 5e6803b409ba3c18434de6693062d98a470bcb1e ]

This patch fixes issues with NPIV port with FC-NVMe. Clean up code for
remoteport delete and also call nvme_delete when deleting VPs.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 16 +++-------------
 drivers/scsi/qla2xxx/qla_os.c   |  2 ++
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index e6545cb9a2c19..5590d6e8b5762 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -474,21 +474,10 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	int rval = -ENODEV;
 	srb_t *sp;
 	struct qla_qpair *qpair = hw_queue_handle;
-	struct nvme_private *priv;
+	struct nvme_private *priv = fd->private;
 	struct qla_nvme_rport *qla_rport = rport->private;
 
-	if (!fd || !qpair) {
-		ql_log(ql_log_warn, NULL, 0x2134,
-		    "NO NVMe request or Queue Handle\n");
-		return rval;
-	}
-
-	priv = fd->private;
 	fcport = qla_rport->fcport;
-	if (!fcport) {
-		ql_log(ql_log_warn, NULL, 0x210e, "No fcport ptr\n");
-		return rval;
-	}
 
 	vha = fcport->vha;
 
@@ -517,6 +506,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	sp->name = "nvme_cmd";
 	sp->done = qla_nvme_sp_done;
 	sp->qpair = qpair;
+	sp->vha = vha;
 	nvme = &sp->u.iocb_cmd;
 	nvme->u.nvme.desc = fd;
 
@@ -564,7 +554,7 @@ static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 		schedule_work(&fcport->free_work);
 	}
 
-	fcport->nvme_flag &= ~(NVME_FLAG_REGISTERED | NVME_FLAG_DELETING);
+	fcport->nvme_flag &= ~NVME_FLAG_DELETING;
 	ql_log(ql_log_info, fcport->vha, 0x2110,
 	    "remoteport_delete of %p completed.\n", fcport);
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 18ee614fe07f5..fb6b5de098f58 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3537,6 +3537,8 @@ qla2x00_delete_all_vps(struct qla_hw_data *ha, scsi_qla_host_t *base_vha)
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 		mutex_unlock(&ha->vport_lock);
 
+		qla_nvme_delete(vha);
+
 		fc_vport_terminate(vha->fc_vport);
 		scsi_host_put(vha->host);
 
-- 
2.20.1

