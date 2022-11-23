Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BFE635D87
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbiKWMoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237608AbiKWMns (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:43:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ACB6DFCF;
        Wed, 23 Nov 2022 04:42:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A35AE61C41;
        Wed, 23 Nov 2022 12:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E0AC433D6;
        Wed, 23 Nov 2022 12:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207330;
        bh=9CdGFcI6NSYYFit7v8Tf2qp4SHvPUavvWg7w2trO2Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDQueprYJALAkgiJ/N91J6zEo5mBZETwnY/8vK5FNoEqo+wagX5nMJ2tOj9MISGZa
         0bmNh32AxG4br64Xv1avrk9e5Tqa9qgiwU1Mmc1rm3zoj3O7MDCcTAhLNud4aEPtRK
         CVmu438goyqB6KhTAeI9s1uP6rk3DHxqWorGVD53EUqqNXYTOxApSRKmt45qM+3qAp
         nmbfSl+NXj50vlZltcZ4uEDF/XBAiIG1e+or2Hj0nwRhdfM9XZTj9KbgsEv+lX6ZPO
         xNQNezsy+vU8zN936WEuoXoZD2p4LIOGtOgaFsMyjZ5q+rd5suZ+ybTPZLS5xP79sX
         p5wJj+YbdyJOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Huang <jinhuieric.huang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 28/44] drm/amdkfd: Fix a memory limit issue
Date:   Wed, 23 Nov 2022 07:40:37 -0500
Message-Id: <20221123124057.264822-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit 6f9eea4392a178af19360694b1db64f985d0b459 ]

It is to resolve a regression, which fails to allocate
VRAM due to no free memory in application, the reason
is we add check of vram_pin_size for memory limit, and
application is pinning the memory for Peerdirect, KFD
should not count it in memory limit. So removing
vram_pin_size will resolve it.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 93ad00453f4b..7db4aef9c45c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -170,9 +170,7 @@ int amdgpu_amdkfd_reserve_mem_limit(struct amdgpu_device *adev,
 	    (kfd_mem_limit.ttm_mem_used + ttm_mem_needed >
 	     kfd_mem_limit.max_ttm_mem_limit) ||
 	    (adev && adev->kfd.vram_used + vram_needed >
-	     adev->gmc.real_vram_size -
-	     atomic64_read(&adev->vram_pin_size) -
-	     reserved_for_pt)) {
+	     adev->gmc.real_vram_size - reserved_for_pt)) {
 		ret = -ENOMEM;
 		goto release;
 	}
-- 
2.35.1

