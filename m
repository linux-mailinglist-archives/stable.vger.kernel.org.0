Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF42110664E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfKVFtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbfKVFtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 016ED2070B;
        Fri, 22 Nov 2019 05:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401791;
        bh=TaYwXSiTikoqgLkJZ6M91+16bQLBH8S4qlW21fgTZZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOmZ9Xc1woCqMa2GCumyrf6mBhOkq8Z7tUBEC80PG0qVRz1vCFFsiUf/6D1M5XrVk
         flnoDnG7cnhsnqxwgZH2TLt38PiTaLrnObujpnZBxLIB59VwrZDUP3SzNESriDr+gi
         KnvGRTwus0jOQpb5uxMS4Do0YrbL0kYErODrvitI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giridhar Malavali <gmalavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 039/219] scsi: qla2xxx: Fix for FC-NVMe discovery for NPIV port
Date:   Fri, 22 Nov 2019 00:46:11 -0500
Message-Id: <20191122054911.1750-32-sashal@kernel.org>
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

From: Giridhar Malavali <gmalavali@marvell.com>

[ Upstream commit 835aa4f2691e4ed4ed16de81f3cabf17a87a164f ]

This patch fixes NVMe discovery by setting SKIP_PRLI flag, so that PRLI is
driven by driver and is retried when the NPIV port is detected to have NVMe
capability.

Signed-off-by: Giridhar Malavali <gmalavali@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |  2 ++
 drivers/scsi/qla2xxx/qla_init.c | 10 ++++------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 15d493f30810f..3e9c49b3184f1 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2161,6 +2161,8 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
 		msleep(1000);
 
+	qla_nvme_delete(vha);
+
 	qla24xx_disable_vp(vha);
 	qla2x00_wait_for_sess_deletion(vha);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bee9cfb291529..1ae6bb6e70415 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -242,15 +242,13 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	sp->done = qla2x00_async_login_sp_done;
-	if (N2N_TOPO(fcport->vha->hw) && fcport_is_bigger(fcport)) {
+	if (N2N_TOPO(fcport->vha->hw) && fcport_is_bigger(fcport))
 		lio->u.logio.flags |= SRB_LOGIN_PRLI_ONLY;
-	} else {
+	else
 		lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
 
-		if (fcport->fc4f_nvme)
-			lio->u.logio.flags |= SRB_LOGIN_SKIP_PRLI;
-
-	}
+	if (fcport->fc4f_nvme)
+		lio->u.logio.flags |= SRB_LOGIN_SKIP_PRLI;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2072,
 	    "Async-login - %8phC hdl=%x, loopid=%x portid=%02x%02x%02x "
-- 
2.20.1

