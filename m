Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE593A2387
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbfH2SQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728236AbfH2SQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:16:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6228F23404;
        Thu, 29 Aug 2019 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102570;
        bh=YaV+f0950vjRD5TeumxAXpgg2lCSSecBsPFAdte19FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQPmj9J474XRAC57GsCmWTPer88hbCdzU0vS0+HGGCulwmEOUUsNwjsMvq5tcPfmF
         hnNxwt2yQt5y2QVS2PvmLEmjIR6R6dr9TwKF5KIBo0bEZKGVBFb6TVvxVIVjyg2p7e
         LELgrXkkyRX+8uMt0ffdhBjlUczJtYRMniD8vA2g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bill Kuzeja <William.Kuzeja@stratus.com>,
        Bill Kuzeja <william.kuzeja@stratus.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/45] scsi: qla2xxx: Fix gnl.l memory leak on adapter init failure
Date:   Thu, 29 Aug 2019 14:15:16 -0400
Message-Id: <20190829181547.8280-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181547.8280-1-sashal@kernel.org>
References: <20190829181547.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bill Kuzeja <William.Kuzeja@stratus.com>

[ Upstream commit 26fa656e9a0cbccddf7db132ea020d2169dbe46e ]

If HBA initialization fails unexpectedly (exiting via probe_failed:), we
may fail to free vha->gnl.l. So that we don't attempt to double free, set
this pointer to NULL after a free and check for NULL at probe_failed: so we
know whether or not to call dma_free_coherent.

Signed-off-by: Bill Kuzeja <william.kuzeja@stratus.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |  2 ++
 drivers/scsi/qla2xxx/qla_os.c   | 11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index f8f4d3ea67f3f..15d493f30810f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2191,6 +2191,8 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	dma_free_coherent(&ha->pdev->dev, vha->gnl.size, vha->gnl.l,
 	    vha->gnl.ldma);
 
+	vha->gnl.l = NULL;
+
 	vfree(vha->scan.l);
 
 	if (vha->qpair && vha->qpair->vp_idx == vha->vp_idx) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 42b8f0d3e580d..02fa81f122c22 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3395,6 +3395,12 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 probe_failed:
+	if (base_vha->gnl.l) {
+		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
+				base_vha->gnl.l, base_vha->gnl.ldma);
+		base_vha->gnl.l = NULL;
+	}
+
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
 	base_vha->flags.online = 0;
@@ -3624,7 +3630,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	if (!atomic_read(&pdev->enable_cnt)) {
 		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
 		    base_vha->gnl.l, base_vha->gnl.ldma);
-
+		base_vha->gnl.l = NULL;
 		scsi_host_put(base_vha->host);
 		kfree(ha);
 		pci_set_drvdata(pdev, NULL);
@@ -3663,6 +3669,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	dma_free_coherent(&ha->pdev->dev,
 		base_vha->gnl.size, base_vha->gnl.l, base_vha->gnl.ldma);
 
+	base_vha->gnl.l = NULL;
+
 	vfree(base_vha->scan.l);
 
 	if (IS_QLAFX00(ha))
@@ -4602,6 +4610,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 		    "Alloc failed for scan database.\n");
 		dma_free_coherent(&ha->pdev->dev, vha->gnl.size,
 		    vha->gnl.l, vha->gnl.ldma);
+		vha->gnl.l = NULL;
 		scsi_remove_host(vha->host);
 		return NULL;
 	}
-- 
2.20.1

