Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9845EA25F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbiIZLGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiIZLFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:05:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1994F650;
        Mon, 26 Sep 2022 03:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02A6960B60;
        Mon, 26 Sep 2022 10:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5D7C433C1;
        Mon, 26 Sep 2022 10:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188338;
        bh=3/2K3H93sz3A/W5h2g23S4x5Atb3f1yd+wC6xCWNrFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFpb12IAa2oDFXwsWSmJ3x3WAJZX7NsbooLFj2mslPINX4gN7lLPNjwHa7zSGzNf/
         BudkslG/Tn1zS3/YIltHruNviHLtwE5fseY5RxipOYK8xi+QJElte3iNjtWAlDRSLK
         S1bOwt+mNPspp3Xk1K0JMs74fMrrrJqqtnSq3YSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingwen Chen <Jingwen.Chen2@amd.com>,
        Horace Chen <horace.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 116/141] drm/amd/amdgpu: fixing read wrong pf2vf data in SRIOV
Date:   Mon, 26 Sep 2022 12:12:22 +0200
Message-Id: <20220926100758.659227043@linuxfoundation.org>
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

From: Jingwen Chen <Jingwen.Chen2@amd.com>

commit 9a458402fb69bda886aa6cbe067311b6e3d9c52a upstream.

[Why]
This fixes 892deb48269c ("drm/amdgpu: Separate vf2pf work item init from virt data exchange").
we should read pf2vf data based at mman.fw_vram_usage_va after gmc
sw_init. commit 892deb48269c breaks this logic.

[How]
calling amdgpu_virt_exchange_data in amdgpu_virt_init_data_exchange to
set the right base in the right sequence.

v2:
call amdgpu_virt_init_data_exchange after gmc sw_init to make data
exchange workqueue run

v3:
clean up the code logic

v4:
add some comment and make the code more readable

Fixes: 892deb48269c ("drm/amdgpu: Separate vf2pf work item init from virt data exchange")
Signed-off-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Reviewed-by: Horace Chen <horace.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c   |   20 +++++++-------------
 2 files changed, 8 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2224,7 +2224,7 @@ static int amdgpu_device_ip_init(struct
 	}
 
 	if (amdgpu_sriov_vf(adev))
-		amdgpu_virt_exchange_data(adev);
+		amdgpu_virt_init_data_exchange(adev);
 
 	r = amdgpu_ib_pool_init(adev);
 	if (r) {
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -584,20 +584,20 @@ void amdgpu_virt_init_data_exchange(stru
 	adev->virt.fw_reserve.p_vf2pf = NULL;
 	adev->virt.vf2pf_update_interval_ms = 0;
 
-	if (adev->bios != NULL) {
-		adev->virt.vf2pf_update_interval_ms = 2000;
+	if (adev->mman.fw_vram_usage_va != NULL) {
+		/* go through this logic in ip_init and reset to init workqueue*/
+		amdgpu_virt_exchange_data(adev);
 
+		INIT_DELAYED_WORK(&adev->virt.vf2pf_work, amdgpu_virt_update_vf2pf_work_item);
+		schedule_delayed_work(&(adev->virt.vf2pf_work), msecs_to_jiffies(adev->virt.vf2pf_update_interval_ms));
+	} else if (adev->bios != NULL) {
+		/* got through this logic in early init stage to get necessary flags, e.g. rlcg_acc related*/
 		adev->virt.fw_reserve.p_pf2vf =
 			(struct amd_sriov_msg_pf2vf_info_header *)
 			(adev->bios + (AMD_SRIOV_MSG_PF2VF_OFFSET_KB << 10));
 
 		amdgpu_virt_read_pf2vf_data(adev);
 	}
-
-	if (adev->virt.vf2pf_update_interval_ms != 0) {
-		INIT_DELAYED_WORK(&adev->virt.vf2pf_work, amdgpu_virt_update_vf2pf_work_item);
-		schedule_delayed_work(&(adev->virt.vf2pf_work), msecs_to_jiffies(adev->virt.vf2pf_update_interval_ms));
-	}
 }
 
 
@@ -633,12 +633,6 @@ void amdgpu_virt_exchange_data(struct am
 				if (adev->virt.ras_init_done)
 					amdgpu_virt_add_bad_page(adev, bp_block_offset, bp_block_size);
 			}
-	} else if (adev->bios != NULL) {
-		adev->virt.fw_reserve.p_pf2vf =
-			(struct amd_sriov_msg_pf2vf_info_header *)
-			(adev->bios + (AMD_SRIOV_MSG_PF2VF_OFFSET_KB << 10));
-
-		amdgpu_virt_read_pf2vf_data(adev);
 	}
 }
 


