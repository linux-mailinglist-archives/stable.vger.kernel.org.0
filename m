Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD3B417446
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345686AbhIXNEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345541AbhIXNCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:02:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A187C61352;
        Fri, 24 Sep 2021 12:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488074;
        bh=aw21F+vjyy1SDTiIDq7VKyW9+Nry6XCrgij3JaFPgjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQUzTUSxyuftAn2tQP+lfIUKu+E/Ydb5f5nvOLc5plNMskqxAD2PTza6BTCC9KKgq
         3nCV4r2WZICbu94TNzwcPf07AGFqfJpayDw6g3A/2em0rs3odpkPZ4MJGTV5QbuNRn
         FsDJG6Tykyy/We/eiVAH09IKDxGUFdKItSip+lBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Koba Ko <koba.ko@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 042/100] drm/amdgpu: Disable PCIE_DPM on Intel RKL Platform
Date:   Fri, 24 Sep 2021 14:43:51 +0200
Message-Id: <20210924124342.864270479@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koba Ko <koba.ko@canonical.com>

[ Upstream commit b3dc549986eb7b38eba4a144e979dc93f386751f ]

Due to high latency in PCIE clock switching on RKL platforms,
switching the PCIE clock dynamically at runtime can lead to HDMI/DP
audio problems. On newer asics this is handled in the SMU firmware.
For SMU7-based asics, disable PCIE clock switching to avoid the issue.

AMD provide a parameter to disable PICE_DPM.

modprobe amdgpu ppfeaturemask=0xfff7bffb

It's better to contorl PCIE_DPM in amd gpu driver,
switch PCI_DPM by determining intel RKL platform for SMU7-based asics.

Fixes: 1a31474cdb48 ("drm/amd/pm: workaround for audio noise issue")
Ref: https://lists.freedesktop.org/archives/amd-gfx/2021-August/067413.html
Signed-off-by: Koba Ko <koba.ko@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index 0541bfc81c1b..1d76cf7cd85d 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -27,6 +27,9 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <asm/div64.h>
+#if IS_ENABLED(CONFIG_X86_64)
+#include <asm/intel-family.h>
+#endif
 #include <drm/amdgpu_drm.h>
 #include "ppatomctrl.h"
 #include "atombios.h"
@@ -1733,6 +1736,17 @@ static int smu7_disable_dpm_tasks(struct pp_hwmgr *hwmgr)
 	return result;
 }
 
+static bool intel_core_rkl_chk(void)
+{
+#if IS_ENABLED(CONFIG_X86_64)
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	return (c->x86 == 6 && c->x86_model == INTEL_FAM6_ROCKETLAKE);
+#else
+	return false;
+#endif
+}
+
 static void smu7_init_dpm_defaults(struct pp_hwmgr *hwmgr)
 {
 	struct smu7_hwmgr *data = (struct smu7_hwmgr *)(hwmgr->backend);
@@ -1758,7 +1772,8 @@ static void smu7_init_dpm_defaults(struct pp_hwmgr *hwmgr)
 
 	data->mclk_dpm_key_disabled = hwmgr->feature_mask & PP_MCLK_DPM_MASK ? false : true;
 	data->sclk_dpm_key_disabled = hwmgr->feature_mask & PP_SCLK_DPM_MASK ? false : true;
-	data->pcie_dpm_key_disabled = hwmgr->feature_mask & PP_PCIE_DPM_MASK ? false : true;
+	data->pcie_dpm_key_disabled =
+		intel_core_rkl_chk() || !(hwmgr->feature_mask & PP_PCIE_DPM_MASK);
 	/* need to set voltage control types before EVV patching */
 	data->voltage_control = SMU7_VOLTAGE_CONTROL_NONE;
 	data->vddci_control = SMU7_VOLTAGE_CONTROL_NONE;
-- 
2.33.0



