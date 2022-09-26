Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6AB5EA18B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbiIZKwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbiIZKub (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:50:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA5558B52;
        Mon, 26 Sep 2022 03:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8545B80835;
        Mon, 26 Sep 2022 10:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2251EC433B5;
        Mon, 26 Sep 2022 10:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188038;
        bh=GyB5GUrzcQyPq3iygaNyUtv7q+M8hf1uaNCYDhH7ugM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oMYnT7oUTVN3YH1S5tWN/M8V6phCEkxDO9nqye22lXEw46i27AjHSq/8Q/DhoDB/
         EntXzuDTUZ/y7jrSf+B3fYh0+i6/P69CR7PZh7lxIm/PtPa8CVKaJIXCUHoSXhqDlP
         5H+9iYoctOq2fdBK+jfATg6+PcrMEFKa0VFBmMog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Victor Skvortsov <victor.skvortsov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/141] drm/amdgpu: Separate vf2pf work item init from virt data exchange
Date:   Mon, 26 Sep 2022 12:10:29 +0200
Message-Id: <20220926100754.750119898@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Skvortsov <victor.skvortsov@amd.com>

[ Upstream commit 892deb48269c65376f3eeb5b4c032ff2c2979bd7 ]

We want to be able to call virt data exchange conditionally
after gmc sw init to reserve bad pages as early as possible.
Since this is a conditional call, we will need
to call it again unconditionally later in the init sequence.

Refactor the data exchange function so it can be
called multiple times without re-initializing the work item.

v2: Cleaned up the code. Kept the original call to init_exchange_data()
inside early init to initialize the work item, afterwards call
exchange_data() when needed.

Signed-off-by: Victor Skvortsov <victor.skvortsov@amd.com>
Reviewed By: Shaoyun.liu <Shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  6 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c   | 36 ++++++++++++++--------
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h   |  1 +
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index a5f9f51cf583..9ccc8c82353b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2181,6 +2181,10 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 
 		/* need to do gmc hw init early so we can allocate gpu mem */
 		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC) {
+			/* Try to reserve bad pages early */
+			if (amdgpu_sriov_vf(adev))
+				amdgpu_virt_exchange_data(adev);
+
 			r = amdgpu_device_vram_scratch_init(adev);
 			if (r) {
 				DRM_ERROR("amdgpu_vram_scratch_init failed %d\n", r);
@@ -2212,7 +2216,7 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 	}
 
 	if (amdgpu_sriov_vf(adev))
-		amdgpu_virt_init_data_exchange(adev);
+		amdgpu_virt_exchange_data(adev);
 
 	r = amdgpu_ib_pool_init(adev);
 	if (r) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index d17bd0140bf6..5217eadd7214 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -580,17 +580,35 @@ void amdgpu_virt_fini_data_exchange(struct amdgpu_device *adev)
 
 void amdgpu_virt_init_data_exchange(struct amdgpu_device *adev)
 {
-	uint64_t bp_block_offset = 0;
-	uint32_t bp_block_size = 0;
-	struct amd_sriov_msg_pf2vf_info *pf2vf_v2 = NULL;
-
 	adev->virt.fw_reserve.p_pf2vf = NULL;
 	adev->virt.fw_reserve.p_vf2pf = NULL;
 	adev->virt.vf2pf_update_interval_ms = 0;
 
-	if (adev->mman.fw_vram_usage_va != NULL) {
+	if (adev->bios != NULL) {
 		adev->virt.vf2pf_update_interval_ms = 2000;
 
+		adev->virt.fw_reserve.p_pf2vf =
+			(struct amd_sriov_msg_pf2vf_info_header *)
+			(adev->bios + (AMD_SRIOV_MSG_PF2VF_OFFSET_KB << 10));
+
+		amdgpu_virt_read_pf2vf_data(adev);
+	}
+
+	if (adev->virt.vf2pf_update_interval_ms != 0) {
+		INIT_DELAYED_WORK(&adev->virt.vf2pf_work, amdgpu_virt_update_vf2pf_work_item);
+		schedule_delayed_work(&(adev->virt.vf2pf_work), msecs_to_jiffies(adev->virt.vf2pf_update_interval_ms));
+	}
+}
+
+
+void amdgpu_virt_exchange_data(struct amdgpu_device *adev)
+{
+	uint64_t bp_block_offset = 0;
+	uint32_t bp_block_size = 0;
+	struct amd_sriov_msg_pf2vf_info *pf2vf_v2 = NULL;
+
+	if (adev->mman.fw_vram_usage_va != NULL) {
+
 		adev->virt.fw_reserve.p_pf2vf =
 			(struct amd_sriov_msg_pf2vf_info_header *)
 			(adev->mman.fw_vram_usage_va + (AMD_SRIOV_MSG_PF2VF_OFFSET_KB << 10));
@@ -621,16 +639,10 @@ void amdgpu_virt_init_data_exchange(struct amdgpu_device *adev)
 			(adev->bios + (AMD_SRIOV_MSG_PF2VF_OFFSET_KB << 10));
 
 		amdgpu_virt_read_pf2vf_data(adev);
-
-		return;
-	}
-
-	if (adev->virt.vf2pf_update_interval_ms != 0) {
-		INIT_DELAYED_WORK(&adev->virt.vf2pf_work, amdgpu_virt_update_vf2pf_work_item);
-		schedule_delayed_work(&(adev->virt.vf2pf_work), adev->virt.vf2pf_update_interval_ms);
 	}
 }
 
+
 void amdgpu_detect_virtualization(struct amdgpu_device *adev)
 {
 	uint32_t reg;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index 8dd624c20f89..77b9d37bfa1b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -271,6 +271,7 @@ int amdgpu_virt_alloc_mm_table(struct amdgpu_device *adev);
 void amdgpu_virt_free_mm_table(struct amdgpu_device *adev);
 void amdgpu_virt_release_ras_err_handler_data(struct amdgpu_device *adev);
 void amdgpu_virt_init_data_exchange(struct amdgpu_device *adev);
+void amdgpu_virt_exchange_data(struct amdgpu_device *adev);
 void amdgpu_virt_fini_data_exchange(struct amdgpu_device *adev);
 void amdgpu_detect_virtualization(struct amdgpu_device *adev);
 
-- 
2.35.1



