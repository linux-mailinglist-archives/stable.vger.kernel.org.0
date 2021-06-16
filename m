Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7AF3AA01D
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbhFPPoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234733AbhFPPmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56C0C61001;
        Wed, 16 Jun 2021 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857885;
        bh=a4TIiWANEKxTnYf+JVI7YM6TQKyxchagbhSFNk43bco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLcn2DWmxgQVTG0db4j4OKfEh5AirQV1lk92lTa9lq0cpRFlzTPsZfKfZievW0llw
         bN85pWrxXAVmTqqsyzeFLYyjGiqwbd6/B7jswqeFsciKwtgioeefex5aT6/4JBzK0b
         5e8zs1sIsHCsCHTIEh/p9ySvGOJeXqaJ6Iw981OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Javed Hasan <jhasan@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 32/48] scsi: qedf: Do not put host in qedf_vport_create() unconditionally
Date:   Wed, 16 Jun 2021 17:33:42 +0200
Message-Id: <20210616152837.662912901@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
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
index e5076f09d5ed..16a0470aedfc 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1827,22 +1827,20 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
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
@@ -1866,7 +1864,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	if (rc) {
 		QEDF_ERR(&(base_qedf->dbg_ctx), "Could not allocate memory "
 		    "for lport stats.\n");
-		goto err2;
+		goto err;
 	}
 
 	fc_set_wwnn(vn_port, vport->node_name);
@@ -1884,7 +1882,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	if (rc) {
 		QEDF_WARN(&base_qedf->dbg_ctx,
 			  "Error adding Scsi_Host rc=0x%x.\n", rc);
-		goto err2;
+		goto err;
 	}
 
 	/* Set default dev_loss_tmo based on module parameter */
@@ -1925,9 +1923,10 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
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
 
@@ -1968,8 +1967,7 @@ static int qedf_vport_destroy(struct fc_vport *vport)
 	fc_lport_free_stats(vn_port);
 
 	/* Release Scsi_Host */
-	if (vn_port->host)
-		scsi_host_put(vn_port->host);
+	scsi_host_put(vn_port->host);
 
 out:
 	return 0;
-- 
2.30.2



