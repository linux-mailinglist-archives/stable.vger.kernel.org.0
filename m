Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BF065D560
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjADOR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbjADORz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:17:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E6DBCAB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:17:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFC8EB81662
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E73C433D2;
        Wed,  4 Jan 2023 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841871;
        bh=YB+TrrjykjT84jnMTwfW2aUPLHQRhql8jdaJyD/PfrA=;
        h=Subject:To:Cc:From:Date:From;
        b=gPA/uD9JgS1tCthlvwsh5Cm+6pwwczzPetYOJxGYop5VFJFvejMbPDzhuoj5N75NW
         VUV7dtA7KalWpxvup104qoVBKLnmXUjQ335R9MoslTycSadVF8u9zj03ocCHn5cL0O
         dH9ZeVZL4wS9Xg0XKdwLb24R9MMvamzbPcA8wvpk=
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix mmhub register base coding error" failed to apply to 5.15-stable tree
To:     KevinYang.Wang@amd.com, Hawking.Zhang@amd.com,
        alexander.deucher@amd.com, christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:17:48 +0100
Message-ID: <16728418688652@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

347fafe0eb46 ("drm/amdgpu: fix mmhub register base coding error")
10c4ad3ae025 ("drm/amdgpu: add mmhub v3_0_1 ip block")
f40fc1916ce8 ("drm/amdgpu: split mmhub v3_0_2 callbacks from mmhub v3_0")
9fa57397d933 ("drm/amdgpu: add mmhub v3_0_2 ip callback functions")
1c2014da7785 ("drm/amdgpu: add gmc v11_0 ip block (v3)")
98a0f8687e31 ("drm/amdgpu: add mmhub v3_0 ip block")
2279b4e5967f ("drm/amdgpu: add gfxhub v3_0 ip block")
8b0fb0e967c1 ("drm/amdgpu: Modify gfx block to fit for the unified ras block data and ops")
9d0cb2c31891 ("drm/amdgpu/gfx9.0: convert to IP version checking")
640ae42efb82 ("drm/amdgpu: Updated RAS infrastructure")
3771449bc80f ("drm/amdgpu: Update RAS trigger error block support")
a0a2f7bb2209 ("drm/amd/amdgpu: add mpio to ras block")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 347fafe0eb46df941965c355c77ce480e4d49f1f Mon Sep 17 00:00:00 2001
From: Yang Wang <KevinYang.Wang@amd.com>
Date: Mon, 5 Dec 2022 21:16:26 +0800
Subject: [PATCH] drm/amdgpu: fix mmhub register base coding error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

fix MMHUB register base coding error.

Fixes: ec6837591f992 ("drm/amdgpu/gmc10: program the smallK fragment size")

Signed-off-by: Yang Wang <KevinYang.Wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
index 998b5d17b271..0e664d0cc8d5 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -319,7 +319,7 @@ static void mmhub_v2_0_init_cache_regs(struct amdgpu_device *adev)
 
 	tmp = mmMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, mmMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, mmMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v2_0_enable_system_domain(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
index 1b027d069ab4..4638ea7c2eec 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
@@ -243,7 +243,7 @@ static void mmhub_v2_3_init_cache_regs(struct amdgpu_device *adev)
 
 	tmp = mmMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, mmMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, mmMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v2_3_enable_system_domain(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
index a1d26c4d80b8..16cc82215e2e 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
@@ -275,7 +275,7 @@ static void mmhub_v3_0_init_cache_regs(struct amdgpu_device *adev)
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_enable_system_domain(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
index e8058edc1d10..6bdf2ef0298d 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
@@ -269,7 +269,7 @@ static void mmhub_v3_0_1_init_cache_regs(struct amdgpu_device *adev)
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_1_enable_system_domain(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c
index 770be0a8f7ce..45465acaa943 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c
@@ -268,7 +268,7 @@ static void mmhub_v3_0_2_init_cache_regs(struct amdgpu_device *adev)
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_2_enable_system_domain(struct amdgpu_device *adev)

