Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D641612F0F9
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgABW5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:57:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbgABWRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5BCE21582;
        Thu,  2 Jan 2020 22:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003440;
        bh=cTA2eAYld73xYFoSNXCACbowDDFywcmMTcA6QE+outE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgX6OQUzmwniEpqWxlxJsnAtX4VvW8i4SZX/DoSgSMuc6z0WEqKLm18ga6YvBJQ+D
         zqHx9fTShRlSAnRmrr0CY1QtcrOze/QEl8aLT1YK2CG2PvIMudRxy65N7pbnPVlEEH
         JbbBfnVzTSFbJ06kGnPXgGdJs3vmHQIKmOwO+QSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 161/191] bnxt_en: Fix bp->fw_health allocation and free logic.
Date:   Thu,  2 Jan 2020 23:07:23 +0100
Message-Id: <20200102215846.635578505@linuxfoundation.org>
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

[ Upstream commit 8280b38e01f71e0f89389ccad3fa43b79e57c604 ]

bp->fw_health needs to be allocated for either the firmware initiated
reset feature or the driver initiated error recovery feature.  The
current code is not allocating bp->fw_health for all the necessary cases.
This patch corrects the logic to allocate bp->fw_health correctly when
needed.  If allocation fails, we clear the feature flags.

We also add the the missing kfree(bp->fw_health) when the driver is
unloaded.  If we get an async reset message from the firmware, we also
need to make sure that we have a valid bp->fw_health before proceeding.

Fixes: 07f83d72d238 ("bnxt_en: Discover firmware error recovery capabilities.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   36 +++++++++++++++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |    1 
 2 files changed, 27 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1995,6 +1995,9 @@ static int bnxt_async_event_process(stru
 	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY: {
 		u32 data1 = le32_to_cpu(cmpl->event_data1);
 
+		if (!bp->fw_health)
+			goto async_event_process_exit;
+
 		bp->fw_reset_timestamp = jiffies;
 		bp->fw_reset_min_dsecs = cmpl->timestamp_lo;
 		if (!bp->fw_reset_min_dsecs)
@@ -4438,8 +4441,9 @@ static int bnxt_hwrm_func_drv_rgtr(struc
 			    FUNC_DRV_RGTR_REQ_ENABLES_VER);
 
 	req.os_type = cpu_to_le16(FUNC_DRV_RGTR_REQ_OS_TYPE_LINUX);
-	flags = FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE |
-		FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT;
+	flags = FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE;
+	if (bp->fw_cap & BNXT_FW_CAP_HOT_RESET)
+		flags |= FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT;
 	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
 		flags |= FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT;
 	req.flags = cpu_to_le32(flags);
@@ -7096,14 +7100,6 @@ static int bnxt_hwrm_error_recovery_qcfg
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc)
 		goto err_recovery_out;
-	if (!fw_health) {
-		fw_health = kzalloc(sizeof(*fw_health), GFP_KERNEL);
-		bp->fw_health = fw_health;
-		if (!fw_health) {
-			rc = -ENOMEM;
-			goto err_recovery_out;
-		}
-	}
 	fw_health->flags = le32_to_cpu(resp->flags);
 	if ((fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_CO_CPU) &&
 	    !(bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL)) {
@@ -10419,6 +10415,23 @@ static void bnxt_init_dflt_coal(struct b
 	bp->stats_coal_ticks = BNXT_DEF_STATS_COAL_TICKS;
 }
 
+static void bnxt_alloc_fw_health(struct bnxt *bp)
+{
+	if (bp->fw_health)
+		return;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) &&
+	    !(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
+		return;
+
+	bp->fw_health = kzalloc(sizeof(*bp->fw_health), GFP_KERNEL);
+	if (!bp->fw_health) {
+		netdev_warn(bp->dev, "Failed to allocate fw_health\n");
+		bp->fw_cap &= ~BNXT_FW_CAP_HOT_RESET;
+		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
+	}
+}
+
 static int bnxt_fw_init_one_p1(struct bnxt *bp)
 {
 	int rc;
@@ -10465,6 +10478,7 @@ static int bnxt_fw_init_one_p2(struct bn
 		netdev_warn(bp->dev, "hwrm query adv flow mgnt failure rc: %d\n",
 			    rc);
 
+	bnxt_alloc_fw_health(bp);
 	rc = bnxt_hwrm_error_recovery_qcfg(bp);
 	if (rc)
 		netdev_warn(bp->dev, "hwrm query error recovery failure rc: %d\n",
@@ -11344,6 +11358,8 @@ static void bnxt_remove_one(struct pci_d
 	bnxt_dcb_free(bp);
 	kfree(bp->edev);
 	bp->edev = NULL;
+	kfree(bp->fw_health);
+	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1658,6 +1658,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	0x00020000
 	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
+	#define BNXT_FW_CAP_HOT_RESET			0x00200000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;


