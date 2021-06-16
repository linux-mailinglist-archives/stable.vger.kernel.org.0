Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339343A9F3C
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbhFPPgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234723AbhFPPgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:36:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FEF161166;
        Wed, 16 Jun 2021 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857666;
        bh=zBX5+t7P22/SsUebnlFcvH3bWaWPytRVLdfKBGxjOWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwc9bShyi0tGYcprc2sdnhR/2G3hbpV3QEpvqt9jYGl9qu7L9jhHYQnp25Te3LymM
         nXZPuaGXklswivdAMAlnEpZRsgYPbTbym8LN98patzLURSC8IntURNpqUO62rRj4oS
         xBexx4BnrJy0KvJf07KamAZcTJfOetO7SJTDKSAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Javed Hasan <jhasan@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/28] scsi: qedf: Do not put host in qedf_vport_create() unconditionally
Date:   Wed, 16 Jun 2021 17:33:28 +0200
Message-Id: <20210616152834.706199336@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
References: <20210616152834.149064097@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



