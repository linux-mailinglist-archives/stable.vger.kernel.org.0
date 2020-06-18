Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14941FE2A3
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgFRBXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731013AbgFRBXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:23:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C3C320776;
        Thu, 18 Jun 2020 01:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443416;
        bh=f2xq+IdYHdu0JPb5RaqyEwHmdxOYR7J9ACK2wF0bpps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fz6SqARcI7SeHGtTaBqhS/139SVq5SE0GCSxfNmLpndO/ApkoxlwlQZOI2iHve3+v
         ztX1RgIzElmUIqC3hafEaK51lEcCG+5KHobYuMORrHGWr7jZqbPg9m1mCz+AjAPE0f
         7bn/FnBfTjXlp136dmLQTAbb7O4xIm1YgsgtO5d8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chad Dupuis <cdupuis@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 058/172] scsi: qedf: Fix crash when MFW calls for protocol stats while function is still probing
Date:   Wed, 17 Jun 2020 21:20:24 -0400
Message-Id: <20200618012218.607130-58-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chad Dupuis <cdupuis@marvell.com>

[ Upstream commit ad40f5256095c68dc17c991eb976261d5ea2daaa ]

The MFW may make a call to qed and then to qedf for protocol statistics
while the function is still probing.  If this happens it's possible that
some members of the struct qedf_ctx may not be fully initialized which can
result in a NULL pointer dereference or general protection fault.

To prevent this, add a new flag call QEDF_PROBING and set it when the
__qedf_probe() function is active. Then in the qedf_get_protocol_tlv_data()
function we can check if the function is still probing and return
immediantely before any uninitialized structures can be touched.

Link: https://lore.kernel.org/r/20200416084314.18851-9-skashyap@marvell.com
Signed-off-by: Chad Dupuis <cdupuis@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf.h      |  1 +
 drivers/scsi/qedf/qedf_main.c | 35 +++++++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 2c78d8fb9122..fc06be4fd10c 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -335,6 +335,7 @@ struct qedf_ctx {
 #define QEDF_GRCDUMP_CAPTURE		4
 #define QEDF_IN_RECOVERY		5
 #define QEDF_DBG_STOP_IO		6
+#define QEDF_PROBING			8
 	unsigned long flags; /* Miscellaneous state flags */
 	int fipvlan_retries;
 	u8 num_queues;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index cd61905ca2f5..b253523217b8 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2961,7 +2961,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 {
 	int rc = -EINVAL;
 	struct fc_lport *lport;
-	struct qedf_ctx *qedf;
+	struct qedf_ctx *qedf = NULL;
 	struct Scsi_Host *host;
 	bool is_vf = false;
 	struct qed_ll2_params params;
@@ -2989,6 +2989,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 
 		/* Initialize qedf_ctx */
 		qedf = lport_priv(lport);
+		set_bit(QEDF_PROBING, &qedf->flags);
 		qedf->lport = lport;
 		qedf->ctlr.lp = lport;
 		qedf->pdev = pdev;
@@ -3011,9 +3012,12 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	} else {
 		/* Init pointers during recovery */
 		qedf = pci_get_drvdata(pdev);
+		set_bit(QEDF_PROBING, &qedf->flags);
 		lport = qedf->lport;
 	}
 
+	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC, "Probe started.\n");
+
 	host = lport->host;
 
 	/* Allocate mempool for qedf_io_work structs */
@@ -3312,6 +3316,10 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	else
 		fc_fabric_login(lport);
 
+	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC, "Probe done.\n");
+
+	clear_bit(QEDF_PROBING, &qedf->flags);
+
 	/* All good */
 	return 0;
 
@@ -3337,6 +3345,11 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 err1:
 	scsi_host_put(lport->host);
 err0:
+	if (qedf) {
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC, "Probe done.\n");
+
+		clear_bit(QEDF_PROBING, &qedf->flags);
+	}
 	return rc;
 }
 
@@ -3484,11 +3497,25 @@ void qedf_get_protocol_tlv_data(void *dev, void *data)
 {
 	struct qedf_ctx *qedf = dev;
 	struct qed_mfw_tlv_fcoe *fcoe = data;
-	struct fc_lport *lport = qedf->lport;
-	struct Scsi_Host *host = lport->host;
-	struct fc_host_attrs *fc_host = shost_to_fc_host(host);
+	struct fc_lport *lport;
+	struct Scsi_Host *host;
+	struct fc_host_attrs *fc_host;
 	struct fc_host_statistics *hst;
 
+	if (!qedf) {
+		QEDF_ERR(NULL, "qedf is null.\n");
+		return;
+	}
+
+	if (test_bit(QEDF_PROBING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Function is still probing.\n");
+		return;
+	}
+
+	lport = qedf->lport;
+	host = lport->host;
+	fc_host = shost_to_fc_host(host);
+
 	/* Force a refresh of the fc_host stats including offload stats */
 	hst = qedf_fc_get_host_stats(host);
 
-- 
2.25.1

