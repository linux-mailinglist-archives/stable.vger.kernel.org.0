Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE8F205CDA
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388030AbgFWUGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388428AbgFWUGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E13E2064B;
        Tue, 23 Jun 2020 20:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942762;
        bh=cURi996Y/4EFOeLRBNaN9bVB5fpanWqms+W9KOwEDgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sbf+q5PBnxf0Fcb3bocIqj8fnvn+xXXuCgydWam1ktXNA+L/PAeKQDx57dMzxx6t/
         zSDpcAypQOfwd90JM8UMDVVdJ1g2IrwDd8y45uMgu8JrNHUjx8YqE/W9LWQstnV4Sj
         DgQ7aK0vPpUhlOQttbB8lz75GsUPsL3ZZrQQgNk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chad Dupuis <cdupuis@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 125/477] scsi: qedf: Fix crash when MFW calls for protocol stats while function is still probing
Date:   Tue, 23 Jun 2020 21:52:02 +0200
Message-Id: <20200623195413.517678603@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f3f399fe10c86..0da4e16fb23a6 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -355,6 +355,7 @@ struct qedf_ctx {
 #define QEDF_GRCDUMP_CAPTURE		4
 #define QEDF_IN_RECOVERY		5
 #define QEDF_DBG_STOP_IO		6
+#define QEDF_PROBING			8
 	unsigned long flags; /* Miscellaneous state flags */
 	int fipvlan_retries;
 	u8 num_queues;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 5b19f5175c5cd..3a7d034729228 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3153,7 +3153,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 {
 	int rc = -EINVAL;
 	struct fc_lport *lport;
-	struct qedf_ctx *qedf;
+	struct qedf_ctx *qedf = NULL;
 	struct Scsi_Host *host;
 	bool is_vf = false;
 	struct qed_ll2_params params;
@@ -3183,6 +3183,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 
 		/* Initialize qedf_ctx */
 		qedf = lport_priv(lport);
+		set_bit(QEDF_PROBING, &qedf->flags);
 		qedf->lport = lport;
 		qedf->ctlr.lp = lport;
 		qedf->pdev = pdev;
@@ -3206,9 +3207,12 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
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
@@ -3513,6 +3517,10 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	else
 		fc_fabric_login(lport);
 
+	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC, "Probe done.\n");
+
+	clear_bit(QEDF_PROBING, &qedf->flags);
+
 	/* All good */
 	return 0;
 
@@ -3538,6 +3546,11 @@ err2:
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
 
@@ -3687,11 +3700,25 @@ void qedf_get_protocol_tlv_data(void *dev, void *data)
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



