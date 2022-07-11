Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E83356FD57
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiGKJyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbiGKJx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:53:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E22D32ECF;
        Mon, 11 Jul 2022 02:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A63F6112E;
        Mon, 11 Jul 2022 09:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27106C34115;
        Mon, 11 Jul 2022 09:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531535;
        bh=XjUZrUHL7LcdbDE6IVjFy/5ilO4yxwYXYvobmuNbkv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqQqdBSyF+77WS1C6PunlTI4A5YlPyiI3ymCYcFikWSrvoPIov4rmoyRDyG7kDSI/
         L66H4xHUlXRbpDbBPC/Xq2MEnM6940zK1pEmCqCxxqBuxmLO02v24y8NPmSH/Cd/VY
         /0xsa+4uNhoWPbAQsi3EWpS4Z9GTk27dbj7TPwhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/230] drm/amd: Refactor `amdgpu_aspm` to be evaluated per device
Date:   Mon, 11 Jul 2022 11:06:37 +0200
Message-Id: <20220711090608.062900976@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 0ab5d711ec74d9e60673900974806b7688857947 ]

Evaluating `pcie_aspm_enabled` as part of driver probe has the implication
that if one PCIe bridge with an AMD GPU connected doesn't support ASPM
then none of them do.  This is an invalid assumption as the PCIe core will
configure ASPM for individual PCIe bridges.

Create a new helper function that can be called by individual dGPUs to
react to the `amdgpu_aspm` module parameter without having negative results
for other dGPUs on the PCIe bus.

Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h           |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c    | 25 +++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/cik.c              |  2 +-
 drivers/gpu/drm/amd/amdgpu/nv.c               |  2 +-
 drivers/gpu/drm/amd/amdgpu/si.c               |  2 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c            |  2 +-
 drivers/gpu/drm/amd/amdgpu/vi.c               |  2 +-
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   |  2 +-
 8 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 2eebefd26fa8..5f95d03fd46a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1285,6 +1285,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 void amdgpu_device_pci_config_reset(struct amdgpu_device *adev);
 int amdgpu_device_pci_reset(struct amdgpu_device *adev);
 bool amdgpu_device_need_post(struct amdgpu_device *adev);
+bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev);
 
 void amdgpu_cs_report_moved_bytes(struct amdgpu_device *adev, u64 num_bytes,
 				  u64 num_vis_bytes);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index a926b5ebbfdf..d1af709cc7dc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1309,6 +1309,31 @@ bool amdgpu_device_need_post(struct amdgpu_device *adev)
 	return true;
 }
 
+/**
+ * amdgpu_device_should_use_aspm - check if the device should program ASPM
+ *
+ * @adev: amdgpu_device pointer
+ *
+ * Confirm whether the module parameter and pcie bridge agree that ASPM should
+ * be set for this device.
+ *
+ * Returns true if it should be used or false if not.
+ */
+bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev)
+{
+	switch (amdgpu_aspm) {
+	case -1:
+		break;
+	case 0:
+		return false;
+	case 1:
+		return true;
+	default:
+		return false;
+	}
+	return pcie_aspm_enabled(adev->pdev);
+}
+
 /* if we get transitioned to only one device, take VGA back */
 /**
  * amdgpu_device_vga_set_decode - enable/disable vga decode
diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
index f10ce740a29c..de6d10390ab2 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1719,7 +1719,7 @@ static void cik_program_aspm(struct amdgpu_device *adev)
 	bool disable_l0s = false, disable_l1 = false, disable_plloff_in_l1 = false;
 	bool disable_clkreq = false;
 
-	if (amdgpu_aspm == 0)
+	if (!amdgpu_device_should_use_aspm(adev))
 		return;
 
 	if (pci_is_root_bus(adev->pdev->bus))
diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
index 9cbed9a8f1c0..6e277236b44f 100644
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -584,7 +584,7 @@ static void nv_pcie_gen3_enable(struct amdgpu_device *adev)
 
 static void nv_program_aspm(struct amdgpu_device *adev)
 {
-	if (!amdgpu_aspm)
+	if (!amdgpu_device_should_use_aspm(adev))
 		return;
 
 	if (!(adev->flags & AMD_IS_APU) &&
diff --git a/drivers/gpu/drm/amd/amdgpu/si.c b/drivers/gpu/drm/amd/amdgpu/si.c
index e6d2f74a7976..7f99e130acd0 100644
--- a/drivers/gpu/drm/amd/amdgpu/si.c
+++ b/drivers/gpu/drm/amd/amdgpu/si.c
@@ -2453,7 +2453,7 @@ static void si_program_aspm(struct amdgpu_device *adev)
 	bool disable_l0s = false, disable_l1 = false, disable_plloff_in_l1 = false;
 	bool disable_clkreq = false;
 
-	if (amdgpu_aspm == 0)
+	if (!amdgpu_device_should_use_aspm(adev))
 		return;
 
 	if (adev->flags & AMD_IS_APU)
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 6439d5c3d8d8..bdb47ae96ce6 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -689,7 +689,7 @@ static void soc15_pcie_gen3_enable(struct amdgpu_device *adev)
 
 static void soc15_program_aspm(struct amdgpu_device *adev)
 {
-	if (!amdgpu_aspm)
+	if (!amdgpu_device_should_use_aspm(adev))
 		return;
 
 	if (!(adev->flags & AMD_IS_APU) &&
diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index 6645ebbd2696..039b90cdc3bc 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1140,7 +1140,7 @@ static void vi_program_aspm(struct amdgpu_device *adev)
 	bool bL1SS = false;
 	bool bClkReqSupport = true;
 
-	if (!amdgpu_aspm)
+	if (!amdgpu_device_should_use_aspm(adev))
 		return;
 
 	if (adev->flags & AMD_IS_APU ||
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 574a9d7f7a5e..918d5c7c2328 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -338,7 +338,7 @@ sienna_cichlid_get_allowed_feature_mask(struct smu_context *smu,
 	if (smu->dc_controlled_by_gpio)
        *(uint64_t *)feature_mask |= FEATURE_MASK(FEATURE_ACDC_BIT);
 
-	if (amdgpu_aspm)
+	if (amdgpu_device_should_use_aspm(adev))
 		*(uint64_t *)feature_mask |= FEATURE_MASK(FEATURE_DS_LCLK_BIT);
 
 	return 0;
-- 
2.35.1



