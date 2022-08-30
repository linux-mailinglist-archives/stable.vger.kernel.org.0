Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC0A5A6AAA
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiH3RcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiH3Rbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:31:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7546C742;
        Tue, 30 Aug 2022 10:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCF5DB81D1C;
        Tue, 30 Aug 2022 17:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D366C433D6;
        Tue, 30 Aug 2022 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880400;
        bh=pVGX3lUAokxnhXBJdkUrS/2va8kh1ON7b6FM2FZm/c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8ih82nwZRVXfs0yyFn8Tw4IYdPK8j5hwC8BTssGhAQRqiovMvjdjM7DW1TBqTq0M
         Rn1iJZaCWdAnByod1iiYvQalXUM2LQ50d2L1q19OH3+0tJ62fGCEPwKtgD/pexz2Ri
         63xuu0Q17IziF072E/0vSGvZpd3i1tHNMF5AKEHb9jXkWbNZ8GvoDc53INat3CcrYO
         z8N5i9+5OEcyQLjRArLp/ByY7X4RePWGwbH/2yr1J3v/SvKK0WtyC5Y/t4FdzS2xtj
         y6/ZbfPj89mwn9VsZDhFO8a026Cp07I0W+sAIGh6YiHnlNztcKQ0NnRW4PXu19UecA
         dqu1bVdRXEhYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Candice Li <candice.li@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        tao.zhou1@amd.com, YiPeng.Chai@amd.com, ricetons@gmail.com,
        desowin@gmail.com, victor.skvortsov@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 2/8] drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.
Date:   Tue, 30 Aug 2022 13:26:25 -0400
Message-Id: <20220830172631.581969-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172631.581969-1-sashal@kernel.org>
References: <20220830172631.581969-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Candice Li <candice.li@amd.com>

[ Upstream commit c351938350ab9b5e978dede2c321da43de7eb70c ]

No need to set up rb when no gfx rings.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 53186c5e1066b..bb0d32b4be74d 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1514,7 +1514,8 @@ static void gfx_v9_0_gpu_init(struct amdgpu_device *adev)
 
 	gfx_v9_0_tiling_mode_table_init(adev);
 
-	gfx_v9_0_setup_rb(adev);
+	if (adev->gfx.num_gfx_rings)
+		gfx_v9_0_setup_rb(adev);
 	gfx_v9_0_get_cu_info(adev, &adev->gfx.cu_info);
 
 	/* XXX SH_MEM regs */
-- 
2.35.1

