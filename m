Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7773765D8A0
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239939AbjADQQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239948AbjADQQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:16:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4103C383
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:16:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8085CB8172B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC793C433EF;
        Wed,  4 Jan 2023 16:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848970;
        bh=zrfU231GJK/axSv6kEzBi+LS+JM7t34THONAJX0/JrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1M/Sj3YL1Vui2pxLl2C6v77rMiaXoU6ZzcSvlrrUtUSDA4BKmzi2TMW0fO5ZVXRq
         bBu1y2QcBdXWJGze5qte3Hg+aVzeiKz0NOvPOdBQlrLWYRgYe8lCUuGIdm9Ld+aPVH
         HI7EJjPCFfTT365qVhwDRnfSONB6aKFtax+Kj3ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Wang <KevinYang.Wang@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 110/207] drm/amdgpu: fix mmhub register base coding error
Date:   Wed,  4 Jan 2023 17:06:08 +0100
Message-Id: <20230104160515.388707543@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Yang Wang <KevinYang.Wang@amd.com>

commit 347fafe0eb46df941965c355c77ce480e4d49f1f upstream.

fix MMHUB register base coding error.

Fixes: ec6837591f992 ("drm/amdgpu/gmc10: program the smallK fragment size")

Signed-off-by: Yang Wang <KevinYang.Wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c   |    2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c   |    2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c   |    2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c |    2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -319,7 +319,7 @@ static void mmhub_v2_0_init_cache_regs(s
 
 	tmp = mmMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, mmMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, mmMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v2_0_enable_system_domain(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
@@ -243,7 +243,7 @@ static void mmhub_v2_3_init_cache_regs(s
 
 	tmp = mmMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, mmMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, mmMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v2_3_enable_system_domain(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
@@ -275,7 +275,7 @@ static void mmhub_v3_0_init_cache_regs(s
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_enable_system_domain(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
@@ -269,7 +269,7 @@ static void mmhub_v3_0_1_init_cache_regs
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_1_enable_system_domain(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c
@@ -268,7 +268,7 @@ static void mmhub_v3_0_2_init_cache_regs
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_2_enable_system_domain(struct amdgpu_device *adev)


