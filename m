Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19768593ED8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243852AbiHOVT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243360AbiHOVP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:15:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F082BDD74D;
        Mon, 15 Aug 2022 12:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AD0CB80FD3;
        Mon, 15 Aug 2022 19:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB864C433D6;
        Mon, 15 Aug 2022 19:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591199;
        bh=leaJCV8zypGw3gSJdo5jPsu49r3nMcYAxTlGjvMqcjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMZF6MesoOlL3jPXqDqwtM5F6gBNF3fME0L4Deu4DI2v4KTZrwn9N2o60w9xq8EG5
         QPfAVzRlkaH3gwuFLVW/bBpQYFWCCqJDEr9sinDJ0WIUA5/sntBFmx9WlWDiUhqaKY
         P2VV5si2JN+pmNJnEFZgN74qtItianoHbfAqymHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0471/1095] drm/amdgpu: use the same HDP flush registers for all nbio 2.3.x
Date:   Mon, 15 Aug 2022 19:57:50 +0200
Message-Id: <20220815180449.065185548@linuxfoundation.org>
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

[ Upstream commit 98a90f1f0fdd112b85b16ef6ceee69f319ab9311 ]

Align RDNA2.x with other asics.  One HDP bit per SDMA instance,
aligned with firmware.  This is effectively a revert of
commit 369b7d04baf3 ("drm/amdgpu/nbio2.3: don't use GPU_HDP_FLUSH bit 12").
On further discussions with the relevant hardware teams,
re-align the bits for SDMA.

Fixes: 369b7d04baf3 ("drm/amdgpu/nbio2.3: don't use GPU_HDP_FLUSH bit 12")
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |  5 +----
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c        | 21 -------------------
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.h        |  1 -
 3 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 918bb7fef6ba..d68db66d969b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1907,15 +1907,12 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(2, 3, 0):
 	case IP_VERSION(2, 3, 1):
 	case IP_VERSION(2, 3, 2):
-		adev->nbio.funcs = &nbio_v2_3_funcs;
-		adev->nbio.hdp_flush_reg = &nbio_v2_3_hdp_flush_reg;
-		break;
 	case IP_VERSION(3, 3, 0):
 	case IP_VERSION(3, 3, 1):
 	case IP_VERSION(3, 3, 2):
 	case IP_VERSION(3, 3, 3):
 		adev->nbio.funcs = &nbio_v2_3_funcs;
-		adev->nbio.hdp_flush_reg = &nbio_v2_3_hdp_flush_reg_sc;
+		adev->nbio.hdp_flush_reg = &nbio_v2_3_hdp_flush_reg;
 		break;
 	default:
 		break;
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
index ee7cab37dfd5..dae78a1e88e6 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -328,27 +328,6 @@ const struct nbio_hdp_flush_reg nbio_v2_3_hdp_flush_reg = {
 	.ref_and_mask_sdma1 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__SDMA1_MASK,
 };
 
-const struct nbio_hdp_flush_reg nbio_v2_3_hdp_flush_reg_sc = {
-	.ref_and_mask_cp0 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__CP0_MASK,
-	.ref_and_mask_cp1 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__CP1_MASK,
-	.ref_and_mask_cp2 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__CP2_MASK,
-	.ref_and_mask_cp3 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__CP3_MASK,
-	.ref_and_mask_cp4 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__CP4_MASK,
-	.ref_and_mask_cp5 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__CP5_MASK,
-	.ref_and_mask_cp6 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__CP6_MASK,
-	.ref_and_mask_cp7 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__CP7_MASK,
-	.ref_and_mask_cp8 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__CP8_MASK,
-	.ref_and_mask_cp9 = BIF_BX_PF_GPU_HDP_FLUSH_DONE__CP9_MASK,
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
 static void nbio_v2_3_init_registers(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.h b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.h
index 6074dd3a1ed8..a43b60acf7f6 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.h
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.h
@@ -27,7 +27,6 @@
 #include "soc15_common.h"
 
 extern const struct nbio_hdp_flush_reg nbio_v2_3_hdp_flush_reg;
-extern const struct nbio_hdp_flush_reg nbio_v2_3_hdp_flush_reg_sc;
 extern const struct amdgpu_nbio_funcs nbio_v2_3_funcs;
 
 #endif
-- 
2.35.1



