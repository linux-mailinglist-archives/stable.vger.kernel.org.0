Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8AE6213E4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiKHNzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbiKHNzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:55:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096BE2BF6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:55:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7090B81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0800EC433C1;
        Tue,  8 Nov 2022 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915704;
        bh=THKkjz9RDO0SfqEFohUF/qGAssTs23jXyspYaMMdz3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaseT0n0W8uDht13SXjf9+Yut1RUQHqWYefwydj40McaXtv0ounWOq44aZ1JpuUOj
         6yJ5C8G26rsBxTVj7kJubtH0zBuffGWh+gi/LMWMTX/EqYq+IOYMvnSZaTUqQMzlvY
         gQMpwn7bARCYqGHLNlgxSlLpb+p3/1XVX4CW/om8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Danijel Slivka <danijel.slivka@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/118] drm/amdgpu: set vm_update_mode=0 as default for Sienna Cichlid in SRIOV case
Date:   Tue,  8 Nov 2022 14:39:05 +0100
Message-Id: <20221108133343.655839869@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Danijel Slivka <danijel.slivka@amd.com>

[ Upstream commit 65f8682b9aaae20c2cdee993e6fe52374ad513c9 ]

For asic with VF MMIO access protection avoid using CPU for VM table updates.
CPU pagetable updates have issues with HDP flush as VF MMIO access protection
blocks write to mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL register
during sriov runtime.

v3: introduce virtualization capability flag AMDGPU_VF_MMIO_ACCESS_PROTECT
which indicates that VF MMIO write access is not allowed in sriov runtime

Signed-off-by: Danijel Slivka <danijel.slivka@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 6 ++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h | 4 ++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c   | 6 +++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 16bfb36c27e4..d6f295103595 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -670,6 +670,12 @@ void amdgpu_detect_virtualization(struct amdgpu_device *adev)
 			adev->virt.caps |= AMDGPU_PASSTHROUGH_MODE;
 	}
 
+	if (amdgpu_sriov_vf(adev) && adev->asic_type == CHIP_SIENNA_CICHLID)
+		/* VF MMIO access (except mailbox range) from CPU
+		 * will be blocked during sriov runtime
+		 */
+		adev->virt.caps |= AMDGPU_VF_MMIO_ACCESS_PROTECT;
+
 	/* we have the ability to check now */
 	if (amdgpu_sriov_vf(adev)) {
 		switch (adev->asic_type) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index 77b9d37bfa1b..aea49bad914f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -31,6 +31,7 @@
 #define AMDGPU_SRIOV_CAPS_IS_VF        (1 << 2) /* this GPU is a virtual function */
 #define AMDGPU_PASSTHROUGH_MODE        (1 << 3) /* thw whole GPU is pass through for VM */
 #define AMDGPU_SRIOV_CAPS_RUNTIME      (1 << 4) /* is out of full access mode */
+#define AMDGPU_VF_MMIO_ACCESS_PROTECT  (1 << 5) /* MMIO write access is not allowed in sriov runtime */
 
 /* all asic after AI use this offset */
 #define mmRCC_IOV_FUNC_IDENTIFIER 0xDE5
@@ -241,6 +242,9 @@ struct amdgpu_virt {
 #define amdgpu_passthrough(adev) \
 ((adev)->virt.caps & AMDGPU_PASSTHROUGH_MODE)
 
+#define amdgpu_sriov_vf_mmio_access_protection(adev) \
+((adev)->virt.caps & AMDGPU_VF_MMIO_ACCESS_PROTECT)
+
 static inline bool is_virtual_machine(void)
 {
 #ifdef CONFIG_X86
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 635601d8b131..45b1f00c5968 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -3200,7 +3200,11 @@ void amdgpu_vm_manager_init(struct amdgpu_device *adev)
 	 */
 #ifdef CONFIG_X86_64
 	if (amdgpu_vm_update_mode == -1) {
-		if (amdgpu_gmc_vram_full_visible(&adev->gmc))
+		/* For asic with VF MMIO access protection
+		 * avoid using CPU for VM table updates
+		 */
+		if (amdgpu_gmc_vram_full_visible(&adev->gmc) &&
+		    !amdgpu_sriov_vf_mmio_access_protection(adev))
 			adev->vm_manager.vm_update_mode =
 				AMDGPU_VM_USE_CPU_FOR_COMPUTE;
 		else
-- 
2.35.1



