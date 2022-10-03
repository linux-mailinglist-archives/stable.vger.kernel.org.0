Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520465F2966
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiJCHS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiJCHRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:17:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0753FA21;
        Mon,  3 Oct 2022 00:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FE6A60F9C;
        Mon,  3 Oct 2022 07:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405E4C433C1;
        Mon,  3 Oct 2022 07:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781256;
        bh=8Mslj1HpVI930cyTmfnLKiQ1vm20+stzMVxebWCR37s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvCIe3VPpwEi6a5YTkWTsz3rrA5G1wKDrEsyVYj1MnUgBgJu71Y6aPDRNoLNbCz8F
         VQzVwoxVkkW/HlhhsWt0QAQhbDxLvPWyAZbBgzAD2r2u7HY1ofmbnVCtWWKBzMacOH
         hVpU1CjtHIlryI2UwRu+v3aYFDcfoNM9q/TUlsUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bokun Zhang <Bokun.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 027/101] drm/amdgpu: Add amdgpu suspend-resume code path under SRIOV
Date:   Mon,  3 Oct 2022 09:10:23 +0200
Message-Id: <20221003070725.155253949@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Bokun Zhang <Bokun.Zhang@amd.com>

commit 3b7329cf5a767c1be38352d43066012e220ad43c upstream.

- Under SRIOV, we need to send REQ_GPU_FINI to the hypervisor
  during the suspend time. Furthermore, we cannot request a
  mode 1 reset under SRIOV as VF. Therefore, we will skip it
  as it is called in suspend_noirq() function.

- In the resume code path, we need to send REQ_GPU_INIT to the
  hypervisor and also resume PSP IP block under SRIOV.

Signed-off-by: Bokun Zhang <Bokun.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c   |    4 ++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   27 ++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1056,6 +1056,10 @@ bool amdgpu_acpi_should_gpu_reset(struct
 {
 	if (adev->flags & AMD_IS_APU)
 		return false;
+
+	if (amdgpu_sriov_vf(adev))
+		return false;
+
 	return pm_suspend_target_state != PM_SUSPEND_TO_IDLE;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3178,7 +3178,8 @@ static int amdgpu_device_ip_resume_phase
 			continue;
 		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_COMMON ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC ||
-		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_IH) {
+		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_IH ||
+		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP && amdgpu_sriov_vf(adev))) {
 
 			r = adev->ip_blocks[i].version->funcs->resume(adev);
 			if (r) {
@@ -4124,12 +4125,20 @@ static void amdgpu_device_evict_resource
 int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
+	int r = 0;
 
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
 	adev->in_suspend = true;
 
+	if (amdgpu_sriov_vf(adev)) {
+		amdgpu_virt_fini_data_exchange(adev);
+		r = amdgpu_virt_request_full_gpu(adev, false);
+		if (r)
+			return r;
+	}
+
 	if (amdgpu_acpi_smart_shift_update(dev, AMDGPU_SS_DEV_D3))
 		DRM_WARN("smart shift update failed\n");
 
@@ -4153,6 +4162,9 @@ int amdgpu_device_suspend(struct drm_dev
 
 	amdgpu_device_ip_suspend_phase2(adev);
 
+	if (amdgpu_sriov_vf(adev))
+		amdgpu_virt_release_full_gpu(adev, false);
+
 	return 0;
 }
 
@@ -4171,6 +4183,12 @@ int amdgpu_device_resume(struct drm_devi
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	int r = 0;
 
+	if (amdgpu_sriov_vf(adev)) {
+		r = amdgpu_virt_request_full_gpu(adev, true);
+		if (r)
+			return r;
+	}
+
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
@@ -4185,6 +4203,13 @@ int amdgpu_device_resume(struct drm_devi
 	}
 
 	r = amdgpu_device_ip_resume(adev);
+
+	/* no matter what r is, always need to properly release full GPU */
+	if (amdgpu_sriov_vf(adev)) {
+		amdgpu_virt_init_data_exchange(adev);
+		amdgpu_virt_release_full_gpu(adev, true);
+	}
+
 	if (r) {
 		dev_err(adev->dev, "amdgpu_device_ip_resume failed (%d).\n", r);
 		return r;


