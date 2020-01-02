Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A4112F0F4
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgABWR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbgABWR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D76C21582;
        Thu,  2 Jan 2020 22:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003445;
        bh=TUF6l8qqFHFTpbCmAeUfedIvNbaM8HwzC82v6RJxrsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oh8GEUcrWfYnZPNWCVWRiHyugSxk2I56/jXZ2/R9J6Go+7dy9zS4OfbEHbhxmxNeN
         5LVyh/p2GqdBVdkdlYE68Cxysnb1taayhsAk0x3cAlLddju8NS0yuTGuX/7lKjUJ3l
         iTHY8HyY9PI+I7PBhwt9X2HfxRv9pHM6v7QKsUQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 163/191] bnxt_en: Fix the logic that creates the health reporters.
Date:   Thu,  2 Jan 2020 23:07:25 +0100
Message-Id: <20200102215846.854474500@linuxfoundation.org>
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

[ Upstream commit 937f188c1f4f89b3fa93ba31fc8587dc1fb14a22 ]

Fix the logic to properly check the fw capabilities and create the
devlink health reporters only when needed.  The current code creates
the reporters unconditionally as long as bp->fw_health is valid, and
that's not correct.

Call bnxt_dl_fw_reporters_create() directly from the init and reset
code path instead of from bnxt_dl_register().  This allows the
reporters to be adjusted when capabilities change.  The same
applies to bnxt_dl_fw_reporters_destroy().

Fixes: 6763c779c2d8 ("bnxt_en: Add new FW devlink_health_reporter")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   11 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |   64 +++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |    2 
 3 files changed, 56 insertions(+), 21 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10563,6 +10563,12 @@ static int bnxt_fw_init_one(struct bnxt
 	rc = bnxt_approve_mac(bp, bp->dev->dev_addr, false);
 	if (rc)
 		return rc;
+
+	/* In case fw capabilities have changed, destroy the unneeded
+	 * reporters and create newly capable ones.
+	 */
+	bnxt_dl_fw_reporters_destroy(bp, false);
+	bnxt_dl_fw_reporters_create(bp);
 	bnxt_fw_init_one_p3(bp);
 	return 0;
 }
@@ -11339,6 +11345,7 @@ static void bnxt_remove_one(struct pci_d
 
 	if (BNXT_PF(bp)) {
 		bnxt_sriov_disable(bp);
+		bnxt_dl_fw_reporters_destroy(bp, true);
 		bnxt_dl_unregister(bp);
 	}
 
@@ -11837,8 +11844,10 @@ static int bnxt_init_one(struct pci_dev
 	if (rc)
 		goto init_err_cleanup_tc;
 
-	if (BNXT_PF(bp))
+	if (BNXT_PF(bp)) {
 		bnxt_dl_register(bp);
+		bnxt_dl_fw_reporters_create(bp);
+	}
 
 	netdev_info(dev, "%s found at mem %lx, node addr %pM\n",
 		    board_info[ent->driver_data].name,
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -102,21 +102,15 @@ struct devlink_health_reporter_ops bnxt_
 	.recover = bnxt_fw_fatal_recover,
 };
 
-static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
+void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
 
-	if (!health)
+	if (!bp->dl || !health)
 		return;
 
-	health->fw_reporter =
-		devlink_health_reporter_create(bp->dl, &bnxt_dl_fw_reporter_ops,
-					       0, false, bp);
-	if (IS_ERR(health->fw_reporter)) {
-		netdev_warn(bp->dev, "Failed to create FW health reporter, rc = %ld\n",
-			    PTR_ERR(health->fw_reporter));
-		health->fw_reporter = NULL;
-	}
+	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) || health->fw_reset_reporter)
+		goto err_recovery;
 
 	health->fw_reset_reporter =
 		devlink_health_reporter_create(bp->dl,
@@ -126,8 +120,30 @@ static void bnxt_dl_fw_reporters_create(
 		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
 			    PTR_ERR(health->fw_reset_reporter));
 		health->fw_reset_reporter = NULL;
+		bp->fw_cap &= ~BNXT_FW_CAP_HOT_RESET;
 	}
 
+err_recovery:
+	if (!(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
+		return;
+
+	if (!health->fw_reporter) {
+		health->fw_reporter =
+			devlink_health_reporter_create(bp->dl,
+						       &bnxt_dl_fw_reporter_ops,
+						       0, false, bp);
+		if (IS_ERR(health->fw_reporter)) {
+			netdev_warn(bp->dev, "Failed to create FW health reporter, rc = %ld\n",
+				    PTR_ERR(health->fw_reporter));
+			health->fw_reporter = NULL;
+			bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
+			return;
+		}
+	}
+
+	if (health->fw_fatal_reporter)
+		return;
+
 	health->fw_fatal_reporter =
 		devlink_health_reporter_create(bp->dl,
 					       &bnxt_dl_fw_fatal_reporter_ops,
@@ -136,24 +152,35 @@ static void bnxt_dl_fw_reporters_create(
 		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
 			    PTR_ERR(health->fw_fatal_reporter));
 		health->fw_fatal_reporter = NULL;
+		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
 	}
 }
 
-static void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
+void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
 
-	if (!health)
+	if (!bp->dl || !health)
 		return;
 
-	if (health->fw_reporter)
-		devlink_health_reporter_destroy(health->fw_reporter);
-
-	if (health->fw_reset_reporter)
+	if ((all || !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) &&
+	    health->fw_reset_reporter) {
 		devlink_health_reporter_destroy(health->fw_reset_reporter);
+		health->fw_reset_reporter = NULL;
+	}
 
-	if (health->fw_fatal_reporter)
+	if ((bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY) && !all)
+		return;
+
+	if (health->fw_reporter) {
+		devlink_health_reporter_destroy(health->fw_reporter);
+		health->fw_reporter = NULL;
+	}
+
+	if (health->fw_fatal_reporter) {
 		devlink_health_reporter_destroy(health->fw_fatal_reporter);
+		health->fw_fatal_reporter = NULL;
+	}
 }
 
 void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event)
@@ -458,8 +485,6 @@ int bnxt_dl_register(struct bnxt *bp)
 
 	devlink_params_publish(dl);
 
-	bnxt_dl_fw_reporters_create(bp);
-
 	return 0;
 
 err_dl_port_unreg:
@@ -482,7 +507,6 @@ void bnxt_dl_unregister(struct bnxt *bp)
 	if (!dl)
 		return;
 
-	bnxt_dl_fw_reporters_destroy(bp);
 	devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
 				       ARRAY_SIZE(bnxt_dl_port_params));
 	devlink_port_unregister(&bp->dl_port);
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -57,6 +57,8 @@ struct bnxt_dl_nvm_param {
 };
 
 void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event);
+void bnxt_dl_fw_reporters_create(struct bnxt *bp);
+void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all);
 int bnxt_dl_register(struct bnxt *bp);
 void bnxt_dl_unregister(struct bnxt *bp);
 


