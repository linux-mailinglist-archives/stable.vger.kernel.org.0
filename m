Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22104BE7D3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348993AbiBUJX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349808AbiBUJVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D0D366BF;
        Mon, 21 Feb 2022 01:09:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49666CE0E97;
        Mon, 21 Feb 2022 09:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA6DC340E9;
        Mon, 21 Feb 2022 09:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434543;
        bh=nhUzr9lx0VmfQA3yfqnH6QBCTASMBayqS1H3ObjAQ6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ncft+q2J8+SS5G28fZ5XlMlc4aMl8AXelGa1H1aaZOqaGFkdSA0TWEn1jZHQ0cLxr
         PXn3sD1KpLnDQ/7PJF5VFxislKxlS7MK+AwE1Sf9VTxUzk0csHzIPOEXyfDlQAsywL
         PXGvQgxnVAY3eFmwdxCVwQF9K9KBa/TTX4pWUR5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjoren Dasse <bjoern.daase@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/196] drm/amd: Warn users about potential s0ix problems
Date:   Mon, 21 Feb 2022 09:47:55 +0100
Message-Id: <20220221084932.373510902@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit a6ed2035878e5ad2e43ed175d8812ac9399d6c40 ]

On some OEM setups users can configure the BIOS for S3 or S2idle.
When configured to S3 users can still choose 's2idle' in the kernel by
using `/sys/power/mem_sleep`.  Before commit 6dc8265f9803 ("drm/amdgpu:
always reset the asic in suspend (v2)"), the GPU would crash.  Now when
configured this way, the system should resume but will use more power.

As such, adjust the `amdpu_acpi_is_s0ix function` to warn users about
potential power consumption issues during their first attempt at
suspending.

Reported-by: Bjoren Dasse <bjoern.daase@gmail.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1824
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h      |  8 ++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 24 +++++++++++++++++++-----
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index f428f94b43c0a..c8d31a22176f3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1397,12 +1397,10 @@ int amdgpu_acpi_smart_shift_update(struct drm_device *dev, enum amdgpu_ss ss_sta
 int amdgpu_acpi_pcie_notify_device_ready(struct amdgpu_device *adev);
 
 void amdgpu_acpi_get_backlight_caps(struct amdgpu_dm_backlight_caps *caps);
-bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
 void amdgpu_acpi_detect(void);
 #else
 static inline int amdgpu_acpi_init(struct amdgpu_device *adev) { return 0; }
 static inline void amdgpu_acpi_fini(struct amdgpu_device *adev) { }
-static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
 static inline void amdgpu_acpi_detect(void) { }
 static inline bool amdgpu_acpi_is_power_shift_control_supported(void) { return false; }
 static inline int amdgpu_acpi_power_shift_control(struct amdgpu_device *adev,
@@ -1411,6 +1409,12 @@ static inline int amdgpu_acpi_smart_shift_update(struct drm_device *dev,
 						 enum amdgpu_ss ss_state) { return 0; }
 #endif
 
+#if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
+bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
+#else
+static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
+#endif
+
 int amdgpu_cs_find_mapping(struct amdgpu_cs_parser *parser,
 			   uint64_t addr, struct amdgpu_bo **bo,
 			   struct amdgpu_bo_va_mapping **mapping);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 4811b0faafd9a..b19d407518024 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1031,6 +1031,7 @@ void amdgpu_acpi_detect(void)
 	}
 }
 
+#if IS_ENABLED(CONFIG_SUSPEND)
 /**
  * amdgpu_acpi_is_s0ix_active
  *
@@ -1040,11 +1041,24 @@ void amdgpu_acpi_detect(void)
  */
 bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev)
 {
-#if IS_ENABLED(CONFIG_AMD_PMC) && IS_ENABLED(CONFIG_SUSPEND)
-	if (acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0) {
-		if (adev->flags & AMD_IS_APU)
-			return pm_suspend_target_state == PM_SUSPEND_TO_IDLE;
+	if (!(adev->flags & AMD_IS_APU) ||
+	    (pm_suspend_target_state != PM_SUSPEND_TO_IDLE))
+		return false;
+
+	if (!(acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0)) {
+		dev_warn_once(adev->dev,
+			      "Power consumption will be higher as BIOS has not been configured for suspend-to-idle.\n"
+			      "To use suspend-to-idle change the sleep mode in BIOS setup.\n");
+		return false;
 	}
-#endif
+
+#if !IS_ENABLED(CONFIG_AMD_PMC)
+	dev_warn_once(adev->dev,
+		      "Power consumption will be higher as the kernel has not been compiled with CONFIG_AMD_PMC.\n");
 	return false;
+#else
+	return true;
+#endif /* CONFIG_AMD_PMC */
 }
+
+#endif /* CONFIG_SUSPEND */
-- 
2.34.1



