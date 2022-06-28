Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F5955D1CD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244853AbiF1C34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244656AbiF1C1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DCAC31;
        Mon, 27 Jun 2022 19:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF89B61753;
        Tue, 28 Jun 2022 02:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCFDC34115;
        Tue, 28 Jun 2022 02:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383114;
        bh=fuSloeFz2lT+mUR13yFai2fyTADedPdYS+ySKdSNBlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mg6zpcl/YtuagmmzSBn/AtrIsJZev9fkL4seNgYnKKRQAD6kHD7wdyZGP+zpGNcU9
         25xm4jpoGfPamfdLNHizy7puxufVy0YRIht5/8nKyK7YPSh6rVV1WWjQyvvwo1/oon
         lNBnrpCx/LlUoK4qPtf2Qb9+i2SM/iXBkJHbj1Vi0cal1F3ki+8rv8omWDyRY+kebI
         VGjkwdbjZdek17TtnLWkVVOEHdDpaUkDpAHTe+6Fmi2qK+NREfWwDFFFvGt+YGdEIX
         VJ8/A3ST6wmLhM+SK0mN8Y3TnJVy9opO6ddji3YReoPdm2lSsFvn3dU1H0i9sGGLo2
         pvCgKpm0ksrNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Felix.Kuehling@amd.com, nirmoy.das@amd.com, jonathan.kim@amd.com,
        kevin1.wang@amd.com, zackr@vmware.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 25/27] drm/amdgpu: Adjust logic around GTT size (v3)
Date:   Mon, 27 Jun 2022 22:24:11 -0400
Message-Id: <20220628022413.596341-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022413.596341-1-sashal@kernel.org>
References: <20220628022413.596341-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit f15345a377c6ea9c7cc74f079616af8856aff37f ]

Certain GL unit tests for large textures can cause problems
with the OOM killer since there is no way to link this memory
to a process.  This was originally mitigated (but not necessarily
eliminated) by limiting the GTT size.  The problem is this limit
is often too low for many modern games so just make the limit 1/2
of system memory. The OOM accounting needs to be addressed, but
we shouldn't prevent common 3D applications from being usable
just to potentially mitigate that corner case.

Set default GTT size to max(3G, 1/2 of system ram) by default.

v2: drop previous logic and default to 3/4 of ram
v3: default to half of ram to align with ttm
v4: fix spelling in comment (Kent)

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1942
Reviewed-by: Marek Olšák <marek.olsak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 870dd78d5a21..e70b33f3f363 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1749,18 +1749,26 @@ int amdgpu_ttm_init(struct amdgpu_device *adev)
 	DRM_INFO("amdgpu: %uM of VRAM memory ready\n",
 		 (unsigned) (adev->gmc.real_vram_size / (1024 * 1024)));
 
-	/* Compute GTT size, either bsaed on 3/4th the size of RAM size
+	/* Compute GTT size, either based on 1/2 the size of RAM size
 	 * or whatever the user passed on module init */
 	if (amdgpu_gtt_size == -1) {
 		struct sysinfo si;
 
 		si_meminfo(&si);
-		gtt_size = min(max((AMDGPU_DEFAULT_GTT_SIZE_MB << 20),
-			       adev->gmc.mc_vram_size),
-			       ((uint64_t)si.totalram * si.mem_unit * 3/4));
-	}
-	else
+		/* Certain GL unit tests for large textures can cause problems
+		 * with the OOM killer since there is no way to link this memory
+		 * to a process.  This was originally mitigated (but not necessarily
+		 * eliminated) by limiting the GTT size.  The problem is this limit
+		 * is often too low for many modern games so just make the limit 1/2
+		 * of system memory which aligns with TTM. The OOM accounting needs
+		 * to be addressed, but we shouldn't prevent common 3D applications
+		 * from being usable just to potentially mitigate that corner case.
+		 */
+		gtt_size = max((AMDGPU_DEFAULT_GTT_SIZE_MB << 20),
+			       (u64)si.totalram * si.mem_unit / 2);
+	} else {
 		gtt_size = (uint64_t)amdgpu_gtt_size << 20;
+	}
 
 	/* Initialize GTT memory pool */
 	r = ttm_bo_init_mm(&adev->mman.bdev, TTM_PL_TT, gtt_size >> PAGE_SHIFT);
-- 
2.35.1

