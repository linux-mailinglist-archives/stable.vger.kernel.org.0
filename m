Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D069C111EFD
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbfLCWtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729510AbfLCWtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B47B20684;
        Tue,  3 Dec 2019 22:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413341;
        bh=eyU1uN6m4e8tsqe9BadBCFEWGiABRBv7Mkj8eycyImE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TAYLwY89V48WHWk4TgVP3mcVNTBnY+IfWnWEaM65sj8kY+N1p7UMbV4bRbIg99cK
         spjrkoWVcINHtwXAFIavGWlJ6nT6ztN6MkbGmcLU4E9JYIeVafqy7UhP59gMK7xVIP
         gKA7pmpRaz1fbHWpctyAh4zbiQv4iAqBi5wK6FQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/321] scsi: qla2xxx: Fix NPIV handling for FC-NVMe
Date:   Tue,  3 Dec 2019 23:32:30 +0100
Message-Id: <20191203223431.527072152@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3e892e013658d..183bfda8f5d11 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3538,6 +3538,8 @@ qla2x00_delete_all_vps(struct qla_hw_data *ha, scsi_qla_host_t *base_vha)
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 		mutex_unlock(&ha->vport_lock);
 
+		qla_nvme_delete(vha);
+
 		fc_vport_terminate(vha->fc_vport);
 		scsi_host_put(vha->host);
 
-- 
2.20.1



