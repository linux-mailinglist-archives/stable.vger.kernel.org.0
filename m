Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A305165D643
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239550AbjADOnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239539AbjADOnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:43:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5C8B2A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:43:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A470B81694
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DAAC433F2;
        Wed,  4 Jan 2023 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843386;
        bh=OoOGACQmvSKjECDH1SPBA2Z5jLqQ8poUveAF8HbQlKQ=;
        h=Subject:To:Cc:From:Date:From;
        b=A6aRqderpdLnL6lzK7zNRrjMwwIGcpA70vWRiVVI2eBmBwYPcMIuTYG/TjL5gaddo
         BNCXMTKqAMphvvxjGdsYB21M0q7KU1VyHkQ3Nd9fbTkCl0nLC2wmB6YBgMlGtsg5wH
         3qwo+tGR6wDMP79n4itI0NWW737ECrGujuOfCbqw=
Subject: FAILED: patch "[PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x" failed to apply to 6.0-stable tree
To:     lijo.lazar@amd.com, alexander.deucher@amd.com, guchun.chen@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:42:55 +0100
Message-ID: <16728433751181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

20293269d817 ("drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 20293269d81779a0d0c0865f5877b240c3335c97 Mon Sep 17 00:00:00 2001
From: Lijo Lazar <lijo.lazar@amd.com>
Date: Fri, 30 Sep 2022 10:43:08 +0530
Subject: [PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x

MMHUB 2.1.x versions don't have ATCL2. Remove accesses to ATCL2 registers.

Since they are non-existing registers, read access will cause a
'Completer Abort' and gets reported when AER is enabled with the below patch.
Tagging with the patch so that this is backported along with it.

v2: squash in uninitialized warning fix (Nathan Chancellor)

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
index 4d304f22889e..998b5d17b271 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -32,8 +32,6 @@
 #include "gc/gc_10_1_0_offset.h"
 #include "soc15_common.h"
 
-#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid                      0x064d
-#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid_BASE_IDX             0
 #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid                       0x0070
 #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid_BASE_IDX              0
 
@@ -574,7 +572,6 @@ static void mmhub_v2_0_update_medium_grain_clock_gating(struct amdgpu_device *ad
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
 		def1 = data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
 		break;
 	default:
@@ -608,8 +605,6 @@ static void mmhub_v2_0_update_medium_grain_clock_gating(struct amdgpu_device *ad
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		if (def != data)
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
 		if (def1 != data1)
 			WREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid, data1);
 		break;
@@ -634,8 +629,8 @@ static void mmhub_v2_0_update_medium_grain_light_sleep(struct amdgpu_device *ade
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
-		break;
+		/* There is no ATCL2 in MMHUB for 2.1.x */
+		return;
 	default:
 		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG);
 		break;
@@ -646,18 +641,8 @@ static void mmhub_v2_0_update_medium_grain_light_sleep(struct amdgpu_device *ade
 	else
 		data &= ~MM_ATC_L2_MISC_CG__MEM_LS_ENABLE_MASK;
 
-	if (def != data) {
-		switch (adev->ip_versions[MMHUB_HWIP][0]) {
-		case IP_VERSION(2, 1, 0):
-		case IP_VERSION(2, 1, 1):
-		case IP_VERSION(2, 1, 2):
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
-			break;
-		default:
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
-			break;
-		}
-	}
+	if (def != data)
+		WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
 }
 
 static int mmhub_v2_0_set_clockgating(struct amdgpu_device *adev,
@@ -695,7 +680,10 @@ static void mmhub_v2_0_get_clockgating(struct amdgpu_device *adev, u64 *flags)
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
+		/* There is no ATCL2 in MMHUB for 2.1.x. Keep the status
+		 * based on DAGB
+		 */
+		data = MM_ATC_L2_MISC_CG__ENABLE_MASK;
 		data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
 		break;
 	default:

