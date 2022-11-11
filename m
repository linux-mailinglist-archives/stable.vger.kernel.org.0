Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4569B62507F
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiKKCf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbiKKCfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:35:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409B5686B5;
        Thu, 10 Nov 2022 18:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A48861E8B;
        Fri, 11 Nov 2022 02:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56351C433C1;
        Fri, 11 Nov 2022 02:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134070;
        bh=ynJMAko0Cev1HJer0Gp6DI98RJFx5eN+7+bDY7lW7To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taLxIYMUqskDuabpr0Jh4SpNPZaQVvatYF6VgIYfBUKct+X/5RG6tL2uWkeF0Y1NG
         OqNpMiTQc4L0NNHmd+9WjqSlluOY9sSWaLrDH0Sqf2y3YJy2oBSqfO12MU8Pp8gThT
         4FON6zEfZ16Ja8N5flsHQ7XR5j1pYedkt0Gqdfql1BJwAd0Qlkt8KK2yLI8yDKydbM
         0ZbET2AuR0o8oXn9hqk+TeJ2IqgRUtLITRFSpAGSf9M4CtST4ldo4uAQFroCIVa2Pt
         aHkHypB9fzj/s1/zKlkJdimGV+Jdxc8cBjHRl17Nzwjf/ZLiBNB3zs+XB4Z3krjIk5
         QB49whQUflryg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>, post@davidak.de,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@gmail.com, daniel@ffwll.ch, andrey.grodzovsky@amd.com,
        evan.quan@amd.com, Amaranath.Somalapuram@amd.com, lang.yu@amd.com,
        Jack.Xiao@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 21/30] drm/amd: Fail the suspend if resources can't be evicted
Date:   Thu, 10 Nov 2022 21:33:29 -0500
Message-Id: <20221111023340.227279-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 8d4de331f1b24a22d18e3c6116aa25228cf54854 ]

If a system does not have swap and memory is under 100% usage,
amdgpu will fail to evict resources.  Currently the suspend
carries on proceeding to reset the GPU:

```
[drm] evicting device resources failed
[drm:amdgpu_device_ip_suspend_phase2 [amdgpu]] *ERROR* suspend of IP block <vcn_v3_0> failed -12
[drm] free PSP TMR buffer
[TTM] Failed allocating page table
[drm] evicting device resources failed
amdgpu 0000:03:00.0: amdgpu: MODE1 reset
amdgpu 0000:03:00.0: amdgpu: GPU mode1 reset
amdgpu 0000:03:00.0: amdgpu: GPU smu mode1 reset
```

At this point if the suspend actually succeeded I think that amdgpu
would have recovered because the GPU would have power cut off and
restored.  However the kernel fails to continue the suspend from the
memory pressure and amdgpu fails to run the "resume" from the aborted
suspend.

```
ACPI: PM: Preparing to enter system sleep state S3
SLUB: Unable to allocate memory on node -1, gfp=0xdc0(GFP_KERNEL|__GFP_ZERO)
  cache: Acpi-State, object size: 80, buffer size: 80, default order: 0, min order: 0
  node 0: slabs: 22, objs: 1122, free: 0
ACPI Error: AE_NO_MEMORY, Could not update object reference count (20210730/utdelete-651)

[drm:psp_hw_start [amdgpu]] *ERROR* PSP load kdb failed!
[drm:psp_resume [amdgpu]] *ERROR* PSP resume failed
[drm:amdgpu_device_fw_loading [amdgpu]] *ERROR* resume of IP block <psp> failed -62
amdgpu 0000:03:00.0: amdgpu: amdgpu_device_ip_resume failed (-62).
PM: dpm_run_callback(): pci_pm_resume+0x0/0x100 returns -62
amdgpu 0000:03:00.0: PM: failed to resume async: error -62
```

To avoid this series of unfortunate events, fail amdgpu's suspend
when the memory eviction fails.  This will let the system gracefully
recover and the user can try suspend again when the memory pressure
is relieved.

Reported-by: post@davidak.de
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2223
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 9170aeaad93e..e0c960cc1d2e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4055,15 +4055,18 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
  * at suspend time.
  *
  */
-static void amdgpu_device_evict_resources(struct amdgpu_device *adev)
+static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
 {
+	int ret;
+
 	/* No need to evict vram on APUs for suspend to ram or s2idle */
 	if ((adev->in_s3 || adev->in_s0ix) && (adev->flags & AMD_IS_APU))
-		return;
+		return 0;
 
-	if (amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM))
+	ret = amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM);
+	if (ret)
 		DRM_WARN("evicting device resources failed\n");
-
+	return ret;
 }
 
 /*
@@ -4113,7 +4116,9 @@ int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 	if (!adev->in_s0ix)
 		amdgpu_amdkfd_suspend(adev, adev->in_runpm);
 
-	amdgpu_device_evict_resources(adev);
+	r = amdgpu_device_evict_resources(adev);
+	if (r)
+		return r;
 
 	amdgpu_fence_driver_hw_fini(adev);
 
-- 
2.35.1

