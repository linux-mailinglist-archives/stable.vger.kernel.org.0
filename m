Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493D54AFA5F
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239698AbiBISg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239831AbiBISgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:36:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7803C03E941;
        Wed,  9 Feb 2022 10:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5682F61C2C;
        Wed,  9 Feb 2022 18:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28E3C340E9;
        Wed,  9 Feb 2022 18:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431785;
        bh=indKywp9dJc52epAbrsaZRVK+A2snuJPkcrV1d8PNDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4Xo5Y1NVbeVP0mDNg7e5/4yLhINhvkfqf5IKl3zDZpaFi/w60NlTMuc0nSJjpRUU
         dj+LuZCMY0eb0t8A+JoThE+jR+iK/3bRhett5/K4taSAaksOrb/uZsvyVqbdP9BoCC
         WJGYHY6qZEE9uD46YKl56CNgwlHCZR9xKKI4w9N9TvsVRX09ksfu+EcssB7MDsR8mr
         yCQTkKRFKHPX3ljaJ3rrXzpXpyQfN+hvA+SXtzRUx14slGD36DI41B5JMkUU2fkMsn
         Gu2t91Uvt4C1JleeJKsfUJAIcoiP9xH/AkGn/vVVf4hAYRSjH/wgeINHBKeNWWhTz2
         CL7A+OEWUEVSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Bjoren Dasse <bjoern.daase@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        lijo.lazar@amd.com, Hawking.Zhang@amd.com, evan.quan@amd.com,
        sathishkumar.sundararaju@amd.com,
        veerabadhran.gopalakrishnan@amd.com, shaoyun.liu@amd.com,
        nirmoy.das@amd.com, Prike.Liang@amd.com,
        Pratik.Vishwakarma@amd.com, bp@suse.de,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 30/42] drm/amd: Warn users about potential s0ix problems
Date:   Wed,  9 Feb 2022 13:33:02 -0500
Message-Id: <20220209183335.46545-30-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7d67aec6f4a2b..0a5a5370a2004 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1406,12 +1406,10 @@ int amdgpu_acpi_smart_shift_update(struct drm_device *dev, enum amdgpu_ss ss_sta
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
@@ -1420,6 +1418,12 @@ static inline int amdgpu_acpi_smart_shift_update(struct drm_device *dev,
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

