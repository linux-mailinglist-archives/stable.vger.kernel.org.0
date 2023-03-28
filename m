Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AB56CC511
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjC1PMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjC1PML (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:12:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1D8F74D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1CDC7CE1DAE
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBB8C433D2;
        Tue, 28 Mar 2023 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015858;
        bh=sAchlvPwB8NkyoCQI74UIIVYbbID+V8y0O57zBdkGRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGLT/i+wJ71ebKeVCHAz12QBQNgGGJqMmOP8l25LXOv7eBZWYZkHVEhMpqe9ztq7O
         tNuBs84CvGHvrQr8Z4JbTQxOlgouJEu5pjaS7eKLthelKVL8n/zeTfxlitW8NsrfI+
         nNCjvIDvwPpk7qfsu9UF0OtWT4ROeSG4GLTFDdB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 201/224] drm/amdgpu/nv: Apply ASPM quirk on Intel ADL + AMD Navi
Date:   Tue, 28 Mar 2023 16:43:17 +0200
Message-Id: <20230328142625.759173401@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 2b072442f4962231a8516485012bb2d2551ef2fe upstream.

S2idle resume freeze can be observed on Intel ADL + AMD WX5500. This is
caused by commit 0064b0ce85bb ("drm/amd/pm: enable ASPM by default").

The root cause is still not clear for now.

So extend and apply the ASPM quirk from commit e02fe3bc7aba
("drm/amdgpu: vi: disable ASPM on Intel Alder Lake based systems"), to
workaround the issue on Navi cards too.

Fixes: 0064b0ce85bb ("drm/amd/pm: enable ASPM by default")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2458
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   15 +++++++++++++++
 drivers/gpu/drm/amd/amdgpu/nv.c            |    2 +-
 drivers/gpu/drm/amd/amdgpu/vi.c            |   17 +----------------
 4 files changed, 18 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1263,6 +1263,7 @@ void amdgpu_device_pci_config_reset(stru
 int amdgpu_device_pci_reset(struct amdgpu_device *adev);
 bool amdgpu_device_need_post(struct amdgpu_device *adev);
 bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev);
+bool amdgpu_device_aspm_support_quirk(void);
 
 void amdgpu_cs_report_moved_bytes(struct amdgpu_device *adev, u64 num_bytes,
 				  u64 num_vis_bytes);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -78,6 +78,10 @@
 
 #include <drm/drm_drv.h>
 
+#if IS_ENABLED(CONFIG_X86)
+#include <asm/intel-family.h>
+#endif
+
 MODULE_FIRMWARE("amdgpu/vega10_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/vega12_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/raven_gpu_info.bin");
@@ -1353,6 +1357,17 @@ bool amdgpu_device_should_use_aspm(struc
 	return pcie_aspm_enabled(adev->pdev);
 }
 
+bool amdgpu_device_aspm_support_quirk(void)
+{
+#if IS_ENABLED(CONFIG_X86)
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	return !(c->x86 == 6 && c->x86_model == INTEL_FAM6_ALDERLAKE);
+#else
+	return true;
+#endif
+}
+
 /* if we get transitioned to only one device, take VGA back */
 /**
  * amdgpu_device_vga_set_decode - enable/disable vga decode
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -527,7 +527,7 @@ static void nv_pcie_gen3_enable(struct a
 
 static void nv_program_aspm(struct amdgpu_device *adev)
 {
-	if (!amdgpu_device_should_use_aspm(adev))
+	if (!amdgpu_device_should_use_aspm(adev) || !amdgpu_device_aspm_support_quirk())
 		return;
 
 	if (!(adev->flags & AMD_IS_APU) &&
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -81,10 +81,6 @@
 #include "mxgpu_vi.h"
 #include "amdgpu_dm.h"
 
-#if IS_ENABLED(CONFIG_X86)
-#include <asm/intel-family.h>
-#endif
-
 #define ixPCIE_LC_L1_PM_SUBSTATE	0x100100C6
 #define PCIE_LC_L1_PM_SUBSTATE__LC_L1_SUBSTATES_OVERRIDE_EN_MASK	0x00000001L
 #define PCIE_LC_L1_PM_SUBSTATE__LC_PCI_PM_L1_2_OVERRIDE_MASK	0x00000002L
@@ -1138,24 +1134,13 @@ static void vi_enable_aspm(struct amdgpu
 		WREG32_PCIE(ixPCIE_LC_CNTL, data);
 }
 
-static bool aspm_support_quirk_check(void)
-{
-#if IS_ENABLED(CONFIG_X86)
-	struct cpuinfo_x86 *c = &cpu_data(0);
-
-	return !(c->x86 == 6 && c->x86_model == INTEL_FAM6_ALDERLAKE);
-#else
-	return true;
-#endif
-}
-
 static void vi_program_aspm(struct amdgpu_device *adev)
 {
 	u32 data, data1, orig;
 	bool bL1SS = false;
 	bool bClkReqSupport = true;
 
-	if (!amdgpu_device_should_use_aspm(adev) || !aspm_support_quirk_check())
+	if (!amdgpu_device_should_use_aspm(adev) || !amdgpu_device_aspm_support_quirk())
 		return;
 
 	if (adev->flags & AMD_IS_APU ||


