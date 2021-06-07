Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF2439E30F
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhFGQUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232441AbhFGQSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0696161613;
        Mon,  7 Jun 2021 16:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082473;
        bh=zBX5+t7P22/SsUebnlFcvH3bWaWPytRVLdfKBGxjOWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMQjZFzigDMkciisweLjGG+TXReg86KaUAfaT3Mh0OpRtWqcMnljjOXt/f2fDQjQ2
         7aR5IvwF2IwHfaAO8JO4ieAlp7B3EQ3wFLxcMn4H+qW5j376FgivfACuZpqMV6iIfN
         JPXqewxZDw5/ApLDbpsh8Awv1VV/AfKMsPuCO9sUra9bil3fRkZj6jSqskJnAXdSGY
         FfEhvaH0iCd8D/SZza6aCGBDE66kqLCU4mKoAUQ2QwP4RY4cmESgX06J+iWiOERZzG
         DopOPSpmNgRPJ/VWjdQ+TTCLst8SR6Nnz8DAUPXlWYJidBpLm4KRl8On9iBdbCqcn0
         V6B7W5JHymTjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>, Javed Hasan <jhasan@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/29] scsi: qedf: Do not put host in qedf_vport_create() unconditionally
Date:   Mon,  7 Jun 2021 12:13:59 -0400
Message-Id: <20210607161410.3584036-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 79c932cd6af9829432888c4a0001d01793a09f12 ]

Do not drop reference count on vn_port->host in qedf_vport_create()
unconditionally. Instead drop the reference count in qedf_vport_destroy().

Link: https://lore.kernel.org/r/20210521143440.84816-1-dwagner@suse.de
Reported-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 9c0955c334e3..7a6306f8483e 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1729,22 +1729,20 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 		fcoe_wwn_to_str(vport->port_name, buf, sizeof(buf));
 		QEDF_WARN(&(base_qedf->dbg_ctx), "Failed to create vport, "
 			   "WWPN (0x%s) already exists.\n", buf);
-		goto err1;
+		return rc;
 	}
 
 	if (atomic_read(&base_qedf->link_state) != QEDF_LINK_UP) {
 		QEDF_WARN(&(base_qedf->dbg_ctx), "Cannot create vport "
 			   "because link is not up.\n");
-		rc = -EIO;
-		goto err1;
+		return -EIO;
 	}
 
 	vn_port = libfc_vport_create(vport, sizeof(struct qedf_ctx));
 	if (!vn_port) {
 		QEDF_WARN(&(base_qedf->dbg_ctx), "Could not create lport "
 			   "for vport.\n");
-		rc = -ENOMEM;
-		goto err1;
+		return -ENOMEM;
 	}
 
 	fcoe_wwn_to_str(vport->port_name, buf, sizeof(buf));
@@ -1768,7 +1766,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	if (rc) {
 		QEDF_ERR(&(base_qedf->dbg_ctx), "Could not allocate memory "
 		    "for lport stats.\n");
-		goto err2;
+		goto err;
 	}
 
 	fc_set_wwnn(vn_port, vport->node_name);
@@ -1786,7 +1784,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	if (rc) {
 		QEDF_WARN(&base_qedf->dbg_ctx,
 			  "Error adding Scsi_Host rc=0x%x.\n", rc);
-		goto err2;
+		goto err;
 	}
 
 	/* Set default dev_loss_tmo based on module parameter */
@@ -1827,9 +1825,10 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	vport_qedf->dbg_ctx.host_no = vn_port->host->host_no;
 	vport_qedf->dbg_ctx.pdev = base_qedf->pdev;
 
-err2:
+	return 0;
+
+err:
 	scsi_host_put(vn_port->host);
-err1:
 	return rc;
 }
 
@@ -1870,8 +1869,7 @@ static int qedf_vport_destroy(struct fc_vport *vport)
 	fc_lport_free_stats(vn_port);
 
 	/* Release Scsi_Host */
-	if (vn_port->host)
-		scsi_host_put(vn_port->host);
+	scsi_host_put(vn_port->host);
 
 out:
 	return 0;
-- 
2.30.2

