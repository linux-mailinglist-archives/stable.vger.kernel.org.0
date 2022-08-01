Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E15870CC
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbiHATDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiHATDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:03:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E222ED71;
        Mon,  1 Aug 2022 12:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 424296121C;
        Mon,  1 Aug 2022 19:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B557C433C1;
        Mon,  1 Aug 2022 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380566;
        bh=YtcresAn+qp2Ji3gQYzaNCoxUrbqceUer7l0kgvznWs=;
        h=From:To:Cc:Subject:Date:From;
        b=GDz8wNFEqovaEkVRPCQ7i/w9iEBZqF94YYvvGV1LlrtzW/XoHM1B02n8jkiXTl77r
         dgrb3LQiw9zvE/XjtQe3Ro/lcjJa+QHkm1+79Uiv/0Kup3yL+aBhRqHThj6l2CikfW
         pdB8F22ComXe1Ryzv4BHS055BMwdgbK1hk+zUog2AMhW+7RRXGYXMY2wvvGCco/7bU
         hzBR1TE0Im5mkOvfmRhr9Ogh8VRONC19kuMR4CNdqjiwyBrr6f+pgmY1ukqg7hTvK4
         vFTNS4iy//zCA5lI+FUumkKKoAPWPTgVcJBvxsgo126y3w67U71V43Weg1drHIVDyp
         iy/on6VdauDzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xinhui pan <xinhui.pan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 1/8] drm/amdgpu: Remove one duplicated ef removal
Date:   Mon,  1 Aug 2022 15:02:36 -0400
Message-Id: <20220801190243.3818811-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit e1aadbab445b06e072013a1365fd0cf2aa25e843 ]

That has been done in BO release notify.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2074
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 21c02f817a84..c904269b3e14 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1318,16 +1318,10 @@ void amdgpu_amdkfd_gpuvm_destroy_cb(struct amdgpu_device *adev,
 				    struct amdgpu_vm *vm)
 {
 	struct amdkfd_process_info *process_info = vm->process_info;
-	struct amdgpu_bo *pd = vm->root.bo;
 
 	if (!process_info)
 		return;
 
-	/* Release eviction fence from PD */
-	amdgpu_bo_reserve(pd, false);
-	amdgpu_bo_fence(pd, NULL, false);
-	amdgpu_bo_unreserve(pd);
-
 	/* Update process info */
 	mutex_lock(&process_info->lock);
 	process_info->n_vms--;
-- 
2.35.1

