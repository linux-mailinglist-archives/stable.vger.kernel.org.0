Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A283676EF3
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjAVPQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjAVPQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:16:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D9C22032
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:16:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5056A60C61
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2AFC433EF;
        Sun, 22 Jan 2023 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400566;
        bh=+o9TrdFs0uxcjCT/J2TzT5yMhSpV5kReMsHWVvRW6kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2tGJ3haVYu/rCHIXQzMMelCxTTN0TB9uLoz8XQ4x0fzMOELp2iGCXDrYU1lFdoRU
         mjfdY3PWmsuwhXRnArIZ1nid+j6mZ5VIImiP8q8S5qcZnv69edJhYOCccRz8lsIB1n
         kfDgRHXXewYAFdtOk/1UDQkBIW+0AJD5M29u62Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guchun Chen <guchun.chen@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/117] drm/amdgpu: disable runtime pm on several sienna cichlid cards(v2)
Date:   Sun, 22 Jan 2023 16:03:34 +0100
Message-Id: <20230122150233.700445185@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit d1acd68b2b8924c804e1e3cc1bc5fa4d6b76176c ]

Disable runtime power management on several sienna cichlid
cards, otherwise SMU will possibly fail to be resumed from
runtime suspend. Will drop this after a clean solution between
kernel driver and SMU FW is available.

amdgpu 0000:63:00.0: amdgpu: GECC is enabled
amdgpu 0000:63:00.0: amdgpu: SECUREDISPLAY: securedisplay ta ucode is not available
amdgpu 0000:63:00.0: amdgpu: SMU is resuming...
amdgpu 0000:63:00.0: amdgpu: SMU: I'm not done with your command: SMN_C2PMSG_66:0x0000000E SMN_C2PMSG_82:0x00000080
amdgpu 0000:63:00.0: amdgpu: Failed to SetDriverDramAddr!
amdgpu 0000:63:00.0: amdgpu: Failed to setup smc hw!
[drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block <smu> failed -62
amdgpu 0000:63:00.0: amdgpu: amdgpu_device_ip_resume failed (-62)

v2: seperate to a function.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 1923bc5a56da ("drm/amd: Delay removal of the firmware framebuffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 6744427577b3..43e30b9a2e02 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -43,6 +43,17 @@
 #include "amdgpu_display.h"
 #include "amdgpu_ras.h"
 
+static void amdgpu_runtime_pm_quirk(struct amdgpu_device *adev)
+{
+	/*
+	 * Add below quirk on several sienna_cichlid cards to disable
+	 * runtime pm to fix EMI failures.
+	 */
+	if (((adev->pdev->device == 0x73A1) && (adev->pdev->revision == 0x00)) ||
+	    ((adev->pdev->device == 0x73BF) && (adev->pdev->revision == 0xCF)))
+		adev->runpm = false;
+}
+
 void amdgpu_unregister_gpu_instance(struct amdgpu_device *adev)
 {
 	struct amdgpu_gpu_instance *gpu_instance;
@@ -201,6 +212,9 @@ int amdgpu_driver_load_kms(struct amdgpu_device *adev, unsigned long flags)
 		 */
 		if (adev->is_fw_fb)
 			adev->runpm = false;
+
+		amdgpu_runtime_pm_quirk(adev);
+
 		if (adev->runpm)
 			dev_info(adev->dev, "Using BACO for runtime pm\n");
 	}
-- 
2.39.0



