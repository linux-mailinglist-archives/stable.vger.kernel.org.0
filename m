Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF926357A0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbiKWJoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238184AbiKWJn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:43:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202F632B91
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:41:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA0B2B81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FD9C433D6;
        Wed, 23 Nov 2022 09:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196510;
        bh=ynJMAko0Cev1HJer0Gp6DI98RJFx5eN+7+bDY7lW7To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgxmZhmHfYZslVE4FZFwyV56kSpVjXULfXz0WGXo29Jgcp1bP8h4/wPbbjIxumbN+
         d9UOw8gS6vNA3x4h+2u8qeq9P/5XkY0h9nsu/BRI1IPdijWAxSG6GWIil9XQ7aVVxX
         8O/+ED7V6ReyGLMabM3f87TOgRkKCkHEmTKYXVfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, post@davidak.de,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 052/314] drm/amd: Fail the suspend if resources cant be evicted
Date:   Wed, 23 Nov 2022 09:48:17 +0100
Message-Id: <20221123084627.866604717@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



