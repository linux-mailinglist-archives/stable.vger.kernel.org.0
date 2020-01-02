Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623B112F0F5
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgABW5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:57:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgABWR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E83DD21582;
        Thu,  2 Jan 2020 22:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003447;
        bh=slQbVtF+GXopB5WGJzRj5aJidD4gfzmVZdsJhf0mx5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0ti6p/eT353ZMm6/p4QRDSL5ksY2pJu0xeZjQSorK4DbLd9Jj+F6sNZpVkXhgEh+
         Fzo+DOSLJLGdZTHrkPP0ZHSVDKvmEAWiVg87EF5L0qLU9i94Fds4LmUYAL044bdZyP
         OoanVHYYOzsSneupRos3yRFn/wt0/sV5gakHzwbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 164/191] bnxt_en: Add missing devlink health reporters for VFs.
Date:   Thu,  2 Jan 2020 23:07:26 +0100
Message-Id: <20200102215846.940065716@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 7e334fc8003c7a38372cc98e7be6082670a47d29 ]

The VF driver also needs to create the health reporters since
VFs are also involved in firmware reset and recovery.  Modify
bnxt_dl_register() and bnxt_dl_unregister() so that they can
be called by the VFs to register/unregister devlink.  Only the PF
will register the devlink parameters.  With devlink registered,
we can now create the health reporters on the VFs.

Fixes: 6763c779c2d8 ("bnxt_en: Add new FW devlink_health_reporter")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   13 ++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |   23 ++++++++++++++++------
 2 files changed, 22 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11343,12 +11343,11 @@ static void bnxt_remove_one(struct pci_d
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(dev);
 
-	if (BNXT_PF(bp)) {
+	if (BNXT_PF(bp))
 		bnxt_sriov_disable(bp);
-		bnxt_dl_fw_reporters_destroy(bp, true);
-		bnxt_dl_unregister(bp);
-	}
 
+	bnxt_dl_fw_reporters_destroy(bp, true);
+	bnxt_dl_unregister(bp);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
 	bnxt_shutdown_tc(bp);
@@ -11844,10 +11843,8 @@ static int bnxt_init_one(struct pci_dev
 	if (rc)
 		goto init_err_cleanup_tc;
 
-	if (BNXT_PF(bp)) {
-		bnxt_dl_register(bp);
-		bnxt_dl_fw_reporters_create(bp);
-	}
+	bnxt_dl_register(bp);
+	bnxt_dl_fw_reporters_create(bp);
 
 	netdev_info(dev, "%s found at mem %lx, node addr %pM\n",
 		    board_info[ent->driver_data].name,
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -226,6 +226,8 @@ static const struct devlink_ops bnxt_dl_
 #endif /* CONFIG_BNXT_SRIOV */
 };
 
+static const struct devlink_ops bnxt_vf_dl_ops;
+
 enum bnxt_dl_param_id {
 	BNXT_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK,
@@ -439,7 +441,10 @@ int bnxt_dl_register(struct bnxt *bp)
 		return -ENOTSUPP;
 	}
 
-	dl = devlink_alloc(&bnxt_dl_ops, sizeof(struct bnxt_dl));
+	if (BNXT_PF(bp))
+		dl = devlink_alloc(&bnxt_dl_ops, sizeof(struct bnxt_dl));
+	else
+		dl = devlink_alloc(&bnxt_vf_dl_ops, sizeof(struct bnxt_dl));
 	if (!dl) {
 		netdev_warn(bp->dev, "devlink_alloc failed");
 		return -ENOMEM;
@@ -458,6 +463,9 @@ int bnxt_dl_register(struct bnxt *bp)
 		goto err_dl_free;
 	}
 
+	if (!BNXT_PF(bp))
+		return 0;
+
 	rc = devlink_params_register(dl, bnxt_dl_params,
 				     ARRAY_SIZE(bnxt_dl_params));
 	if (rc) {
@@ -507,11 +515,14 @@ void bnxt_dl_unregister(struct bnxt *bp)
 	if (!dl)
 		return;
 
-	devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
-				       ARRAY_SIZE(bnxt_dl_port_params));
-	devlink_port_unregister(&bp->dl_port);
-	devlink_params_unregister(dl, bnxt_dl_params,
-				  ARRAY_SIZE(bnxt_dl_params));
+	if (BNXT_PF(bp)) {
+		devlink_port_params_unregister(&bp->dl_port,
+					       bnxt_dl_port_params,
+					       ARRAY_SIZE(bnxt_dl_port_params));
+		devlink_port_unregister(&bp->dl_port);
+		devlink_params_unregister(dl, bnxt_dl_params,
+					  ARRAY_SIZE(bnxt_dl_params));
+	}
 	devlink_unregister(dl);
 	devlink_free(dl);
 }


