Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C404FC972
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242231AbiDLAqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242315AbiDLAqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:46:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620F012622;
        Mon, 11 Apr 2022 17:44:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED573B819B4;
        Tue, 12 Apr 2022 00:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AC7C385A4;
        Tue, 12 Apr 2022 00:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724265;
        bh=bjCjhv8haIP+MHw/BiUZCXR2FoFiviSuC5QqBleHCf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9nXT6KdbSeElXWTgMqgOakxkplwFBO/zioNdQ6OucigbdeXxnnh3Tft/oLlHlbBm
         dywm5FTxrEO1zKQy/NUY44lnPo/Qegb1n6zDkfEXPV0QSYYNu6Y5fTUBHHPQQndWf2
         Ud9UMKayVGW+LVXt2XJcCwslVhTkQ48+2ijRDv805sqMVOVyLYk/zlEhJvpcjQ917T
         WPjZmbrj4iO3pctuFvUiJ3Cc+MtL/gkb17S+6SRDN1SK7bPx3uLhA0C7XR5fKLeeyt
         sJfXleU3jxEU2FnnuHD2hnm/a3tSoSIzI8aV9gnif0CkM3kHLcQSx5IYT+yHnyJUFw
         4R7UnZ3aVUqTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guchun Chen <guchun.chen@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, tao.zhou1@amd.com,
        YiPeng.Chai@amd.com, Hawking.Zhang@amd.com, john.clements@amd.com,
        victor.skvortsov@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 05/49] drm/amdgpu: conduct a proper cleanup of PDB bo
Date:   Mon, 11 Apr 2022 20:43:23 -0400
Message-Id: <20220412004411.349427-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 2d505453f38e18d42ba7d5428aaa17aaa7752c65 ]

Use amdgpu_bo_free_kernel instead of amdgpu_bo_unref to
perform a proper cleanup of PDB bo.

v2: update subject to be more accurate

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 88c1eb9ad068..34ee75cf7954 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1684,7 +1684,7 @@ static int gmc_v9_0_sw_fini(void *handle)
 	amdgpu_gem_force_release(adev);
 	amdgpu_vm_manager_fini(adev);
 	amdgpu_gart_table_vram_free(adev);
-	amdgpu_bo_unref(&adev->gmc.pdb0_bo);
+	amdgpu_bo_free_kernel(&adev->gmc.pdb0_bo, NULL, &adev->gmc.ptr_pdb0);
 	amdgpu_bo_fini(adev);
 
 	return 0;
-- 
2.35.1

