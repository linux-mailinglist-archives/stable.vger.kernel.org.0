Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C5826EB9E
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgIRCGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgIRCGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BCFD23770;
        Fri, 18 Sep 2020 02:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394795;
        bh=ffDT/WKFTgV67vs+6P5VHGIfYyVvsSViiPmyQrIFwe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbY0crE8KOFG/32kJXkzQyL1R8WNS+Q/niwTxJpKAxaWGHJ5gDm1fLNSdOfsrm+2u
         pH/wmDPj5/sEQGd5PqMYwIAhXLxLx9nxzUHOUl0YFIZCsZnDq0tucZdiifFd9Pc1un
         xC82E5N/MT29JsVD1V6G7hGLr3dEdeuCuhRPuNAQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 265/330] drm/amd/powerplay: try to do a graceful shutdown on SW CTF
Date:   Thu, 17 Sep 2020 22:00:05 -0400
Message-Id: <20200918020110.2063155-265-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 9495220577416632675959caf122e968469ffd16 ]

Normally this(SW CTF) should not happen. And by doing graceful
shutdown we can prevent further damage.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/powerplay/hwmgr/smu_helper.c  | 21 +++++++++++++++----
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c     |  7 +++++++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
index d09690fca4520..414added3d02c 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/reboot.h>
 
 #include "hwmgr.h"
 #include "pp_debug.h"
@@ -593,12 +594,18 @@ int phm_irq_process(struct amdgpu_device *adev,
 	uint32_t src_id = entry->src_id;
 
 	if (client_id == AMDGPU_IRQ_CLIENTID_LEGACY) {
-		if (src_id == VISLANDS30_IV_SRCID_CG_TSS_THERMAL_LOW_TO_HIGH)
+		if (src_id == VISLANDS30_IV_SRCID_CG_TSS_THERMAL_LOW_TO_HIGH) {
 			pr_warn("GPU over temperature range detected on PCIe %d:%d.%d!\n",
 						PCI_BUS_NUM(adev->pdev->devfn),
 						PCI_SLOT(adev->pdev->devfn),
 						PCI_FUNC(adev->pdev->devfn));
-		else if (src_id == VISLANDS30_IV_SRCID_CG_TSS_THERMAL_HIGH_TO_LOW)
+			/*
+			 * SW CTF just occurred.
+			 * Try to do a graceful shutdown to prevent further damage.
+			 */
+			dev_emerg(adev->dev, "System is going to shutdown due to SW CTF!\n");
+			orderly_poweroff(true);
+		} else if (src_id == VISLANDS30_IV_SRCID_CG_TSS_THERMAL_HIGH_TO_LOW)
 			pr_warn("GPU under temperature range detected on PCIe %d:%d.%d!\n",
 					PCI_BUS_NUM(adev->pdev->devfn),
 					PCI_SLOT(adev->pdev->devfn),
@@ -609,12 +616,18 @@ int phm_irq_process(struct amdgpu_device *adev,
 					PCI_SLOT(adev->pdev->devfn),
 					PCI_FUNC(adev->pdev->devfn));
 	} else if (client_id == SOC15_IH_CLIENTID_THM) {
-		if (src_id == 0)
+		if (src_id == 0) {
 			pr_warn("GPU over temperature range detected on PCIe %d:%d.%d!\n",
 						PCI_BUS_NUM(adev->pdev->devfn),
 						PCI_SLOT(adev->pdev->devfn),
 						PCI_FUNC(adev->pdev->devfn));
-		else
+			/*
+			 * SW CTF just occurred.
+			 * Try to do a graceful shutdown to prevent further damage.
+			 */
+			dev_emerg(adev->dev, "System is going to shutdown due to SW CTF!\n");
+			orderly_poweroff(true);
+		} else
 			pr_warn("GPU under temperature range detected on PCIe %d:%d.%d!\n",
 					PCI_BUS_NUM(adev->pdev->devfn),
 					PCI_SLOT(adev->pdev->devfn),
diff --git a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c b/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
index c4d8c52c6b9ca..6c4405622c9bb 100644
--- a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
@@ -23,6 +23,7 @@
 #include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/reboot.h>
 
 #include "pp_debug.h"
 #include "amdgpu.h"
@@ -1538,6 +1539,12 @@ static int smu_v11_0_irq_process(struct amdgpu_device *adev,
 				PCI_BUS_NUM(adev->pdev->devfn),
 				PCI_SLOT(adev->pdev->devfn),
 				PCI_FUNC(adev->pdev->devfn));
+			/*
+			 * SW CTF just occurred.
+			 * Try to do a graceful shutdown to prevent further damage.
+			 */
+			dev_emerg(adev->dev, "System is going to shutdown due to SW CTF!\n");
+			orderly_poweroff(true);
 		break;
 		case THM_11_0__SRCID__THM_DIG_THERM_H2L:
 			pr_warn("GPU under temperature range detected on PCIe %d:%d.%d!\n",
-- 
2.25.1

