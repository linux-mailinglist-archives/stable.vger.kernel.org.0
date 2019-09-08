Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1E0ACE5E
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbfIHMrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730724AbfIHMrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:47:36 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F26218AC;
        Sun,  8 Sep 2019 12:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946855;
        bh=8+B21AyeMTarJBVXGnbm/kZ6rmCIgUSHP1j6KmYnzfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9Yxu8AnArmA/rWXcFYPp/Q5O5IVtBxTsW8RWiskJCLJ+Q07KmTtrVyReGZGKujge
         jjLoiaqCo4XuZsJ2hbLjDGTEob0Sz1Ic6icK6XWG+QBgPzM+xVLoIwVS8SOr4DujUd
         bzQURXUisB0zmmcFfl76gP/Fm6s8O0y690NMmvSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/57] scsi: qla2xxx: Fix gnl.l memory leak on adapter init failure
Date:   Sun,  8 Sep 2019 13:41:49 +0100
Message-Id: <20190908121135.695973476@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -3395,6 +3395,12 @@ skip_dpc:
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



