Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF13594122
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244890AbiHOVU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242705AbiHOVOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:14:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFD7DB7EE;
        Mon, 15 Aug 2022 12:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1F3C60FFD;
        Mon, 15 Aug 2022 19:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A93C433D6;
        Mon, 15 Aug 2022 19:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591196;
        bh=ZU9bzVza16EHJwtJkckwm5xW/Zg3CxMpPeOoH57DRPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbmbNTjYQZDLR5GTbqyzigF0afJNCzfQiLGv9ts1iRp5IQC9WrFPyBDgmxtQJSIi3
         pgkZic0G/9j265abj3bH0gHd0YRiduMvvthmhdw9nfh5VpIdG2zqtDM1l/0aV++yk5
         MpTnFls5N8cL4ogJAOSsRzxXXAQEIllcvcW5/Za0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0470/1095] drm/amdgpu: use the same HDP flush registers for all nbio 7.4.x
Date:   Mon, 15 Aug 2022 19:57:49 +0200
Message-Id: <20220815180449.033501019@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 912db6a58738e8be502838eb6a88f207ba356cd7 ]

Align aldebaran with all other asics.  One HDP bit per
SDMA instance, aligned with firmware.  This is effectively
a revert of
commit a0f9f8546668 ("drm/amdgpu/nbio7.4: don't use GPU_HDP_FLUSH bit 12").
On further discussions with the relevant hardware teams,
re-align the bits for SDMA.

Fixes: a0f9f8546668 ("drm/amdgpu/nbio7.4: don't use GPU_HDP_FLUSH bit 12")
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |  5 +----
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c        | 21 -------------------
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.h        |  1 -
 3 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index e4fcbb385a62..918bb7fef6ba 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1891,12 +1891,9 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		break;
 	case IP_VERSION(7, 4, 0):
 	case IP_VERSION(7, 4, 1):
-		adev->nbio.funcs = &nbio_v7_4_funcs;
-		adev->nbio.hdp_flush_reg = &nbio_v7_4_hdp_flush_reg;
-		break;
 	case IP_VERSION(7, 4, 4):
 		adev->nbio.funcs = &nbio_v7_4_funcs;
-		adev->nbio.hdp_flush_reg = &nbio_v7_4_hdp_flush_reg_ald;
+		adev->nbio.hdp_flush_reg = &nbio_v7_4_hdp_flush_reg;
 		break;
 	case IP_VERSION(7, 2, 0):
 	case IP_VERSION(7, 2, 1):
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
index c2357e83a8c4..09c0def356a1 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -339,27 +339,6 @@ const struct nbio_hdp_flush_reg nbio_v7_4_hdp_flush_reg = {
 	.ref_and_mask_sdma1 = GPU_HDP_FLUSH_DONE__SDMA1_MASK,
 };
 
-const struct nbio_hdp_flush_reg nbio_v7_4_hdp_flush_reg_ald = {
-	.ref_and_mask_cp0 = GPU_HDP_FLUSH_DONE__CP0_MASK,
-	.ref_and_mask_cp1 = GPU_HDP_FLUSH_DONE__CP1_MASK,
-	.ref_and_mask_cp2 = GPU_HDP_FLUSH_DONE__CP2_MASK,
-	.ref_and_mask_cp3 = GPU_HDP_FLUSH_DONE__CP3_MASK,
-	.ref_and_mask_cp4 = GPU_HDP_FLUSH_DONE__CP4_MASK,
-	.ref_and_mask_cp5 = GPU_HDP_FLUSH_DONE__CP5_MASK,
-	.ref_and_mask_cp6 = GPU_HDP_FLUSH_DONE__CP6_MASK,
-	.ref_and_mask_cp7 = GPU_HDP_FLUSH_DONE__CP7_MASK,
-	.ref_and_mask_cp8 = GPU_HDP_FLUSH_DONE__CP8_MASK,
-	.ref_and_mask_cp9 = GPU_HDP_FLUSH_DONE__CP9_MASK,
-	.ref_and_mask_sdma0 = GPU_HDP_FLUSH_DONE__RSVD_ENG1_MASK,
-	.ref_and_mask_sdma1 = GPU_HDP_FLUSH_DONE__RSVD_ENG2_MASK,
-	.ref_and_mask_sdma2 = GPU_HDP_FLUSH_DONE__RSVD_ENG3_MASK,
-	.ref_and_mask_sdma3 = GPU_HDP_FLUSH_DONE__RSVD_ENG4_MASK,
-	.ref_and_mask_sdma4 = GPU_HDP_FLUSH_DONE__RSVD_ENG5_MASK,
-	.ref_and_mask_sdma5 = GPU_HDP_FLUSH_DONE__RSVD_ENG6_MASK,
-	.ref_and_mask_sdma6 = GPU_HDP_FLUSH_DONE__RSVD_ENG7_MASK,
-	.ref_and_mask_sdma7 = GPU_HDP_FLUSH_DONE__RSVD_ENG8_MASK,
-};
-
 static void nbio_v7_4_init_registers(struct amdgpu_device *adev)
 {
 	uint32_t baco_cntl;
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.h b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.h
index 7490022d79d4..f27c41728822 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.h
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.h
@@ -27,7 +27,6 @@
 #include "soc15_common.h"
 
 extern const struct nbio_hdp_flush_reg nbio_v7_4_hdp_flush_reg;
-extern const struct nbio_hdp_flush_reg nbio_v7_4_hdp_flush_reg_ald;
 extern const struct amdgpu_nbio_funcs nbio_v7_4_funcs;
 extern struct amdgpu_nbio_ras nbio_v7_4_ras;
 
-- 
2.35.1



