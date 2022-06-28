Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3203C55C1D8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244262AbiF1C3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244441AbiF1C0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:26:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8117324BD8;
        Mon, 27 Jun 2022 19:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3143FB81C0E;
        Tue, 28 Jun 2022 02:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06D8C34115;
        Tue, 28 Jun 2022 02:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383047;
        bh=2lXpoLGX/5sce5S8q9mI9YyZ6a1pDpUqEFvKw/MPCzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWkCfXrg2LbmFz0yfWtaZQI0AfhsK8TLE736pX8RsWf2viPHTyOlIGdGQ304oZy3d
         wN6nT52SSb8qwexxM3VciDrHUCbtGsv9fjaKHbz8qvAVFZXnAeno5HCCZ8y0fxc8Ot
         3nHNWEsLuW/K4gfD2y0vKVPdp8aRoFzVpHE4QarUiK8O9xijx781VHlkmq0a/8ixub
         +53csID0QwNVMp2WAk2fw1n8gEgcl6mLLaJCRH927USGPR5P/pf4qGcvA8KtsOLnG0
         1sMHXViA+IOhrWRPU+AjROSjHbGyYPzitbwSibxtZlLmiiudkYlcFhx4MqMp4xYRQA
         5LorsVEWXnVmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Felix.Kuehling@amd.com, nirmoy.das@amd.com, jonathan.kim@amd.com,
        Philip.Yang@amd.com, kevin1.wang@amd.com, zackr@vmware.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 31/34] drm/amdgpu: Adjust logic around GTT size (v3)
Date:   Mon, 27 Jun 2022 22:22:38 -0400
Message-Id: <20220628022241.595835-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022241.595835-1-sashal@kernel.org>
References: <20220628022241.595835-1-sashal@kernel.org>
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
index 0b162928a248..b6d5987efc6a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1960,18 +1960,26 @@ int amdgpu_ttm_init(struct amdgpu_device *adev)
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
 	r = amdgpu_gtt_mgr_init(adev, gtt_size);
-- 
2.35.1

