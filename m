Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FDF5A6989
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiH3RUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiH3RTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:19:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0E7F14CB;
        Tue, 30 Aug 2022 10:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9697861734;
        Tue, 30 Aug 2022 17:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61997C43140;
        Tue, 30 Aug 2022 17:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661879955;
        bh=Gf6K69+lkv4ZJgkil7/pyHJXXMnEeC5gYZJ9LHoQ7lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKP3vYY24CmubrNCKO3BRXr+e22U110iV5ZJPtAZeJ6n3Yi5XHdYRPbl5Kmw23cwO
         HYWO4RSq8ImfEcQWxOjVXV5ZTBXeYeuZ8ZDIFQZUe8lCQgUAy4lnmRrJ/mndJjterd
         ImzlvHtPb7cNGKIaFcOA4KyQkm2DkgKK/oEQ9rORdoR36+x7Z2EFoHffcYvUXvepb1
         epSjpYZcl2VOEZyepTV95Dok94gxnqdMRqJoHwVofM5Uc84S+/lsZlGXIBIXtQXjqZ
         7tmG2/ay22CPURFhdnc1jg3qQOb8XQ4K6385zIONsGxR2tIpOeXIF+YJliFp8IyOO8
         iDo00+zMmNw9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Candice Li <candice.li@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        YiPeng.Chai@amd.com, tao.zhou1@amd.com, ricetons@gmail.com,
        evan.quan@amd.com, victor.skvortsov@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 11/33] drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.
Date:   Tue, 30 Aug 2022 13:18:02 -0400
Message-Id: <20220830171825.580603-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
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
index 5349ca4d19e38..6d8ff3b099422 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2587,7 +2587,8 @@ static void gfx_v9_0_constants_init(struct amdgpu_device *adev)
 
 	gfx_v9_0_tiling_mode_table_init(adev);
 
-	gfx_v9_0_setup_rb(adev);
+	if (adev->gfx.num_gfx_rings)
+		gfx_v9_0_setup_rb(adev);
 	gfx_v9_0_get_cu_info(adev, &adev->gfx.cu_info);
 	adev->gfx.config.db_debug2 = RREG32_SOC15(GC, 0, mmDB_DEBUG2);
 
-- 
2.35.1

