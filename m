Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1F45947B0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355364AbiHOXz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355639AbiHOXwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:52:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56884CA1C;
        Mon, 15 Aug 2022 13:17:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EE36B80EA8;
        Mon, 15 Aug 2022 20:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5D1C433C1;
        Mon, 15 Aug 2022 20:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594634;
        bh=pn337n0lEvBzbFrxqRFlt/n0y5IfqQVM3krOuno0CLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1287lrMJ9a0n4T5l4eNXoavuXbtJnRA2sXhQrgiI0fxpmIRbUeZ2sfAgwPA/h01v
         2hJnKn7lu1KOmCIEaI1BXygEiSFBiLR4r4HplX5ATIr5NV2HHgoH4JDLGLZB1w6NsE
         zhgw04YPtj2+Mcp7mqrypN0ElDapUvcwbtFvzEH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0509/1157] drm/amdgpu: use the same HDP flush registers for all nbio 7.4.x
Date:   Mon, 15 Aug 2022 19:57:45 +0200
Message-Id: <20220815180500.056588041@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 47f0344205ed..ba03238c9749 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -2194,12 +2194,9 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
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
index 4531761dcf77..11848d1e238b 100644
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



