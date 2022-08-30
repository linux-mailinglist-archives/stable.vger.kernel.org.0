Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C60A5A6A8F
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiH3Ras (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbiH3RaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:30:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0507F44;
        Tue, 30 Aug 2022 10:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36AEE617AE;
        Tue, 30 Aug 2022 17:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F60C433D7;
        Tue, 30 Aug 2022 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880300;
        bh=J6bY75iJ1h9Z6yJ8vIVGtMGTgX8TS40R6GyThvgxfUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeQXygwVoOcxj6CJAog5pvXYX2H568UcRHied7auerHgxXeaYV7cWk1/+qRBBl9iy
         FR+hQX7jdUBweknX52Nks3tNu7rFu7EtAiznnUgPRamz3/bMo7UJdGAj5c4DzV8Gop
         DCdRAclop6c6WW5LNXcA3VgVBVFajvs6LaDLZ0hm4m0sy4bbsYJi8qBiuBt61UVP0h
         0H6K5FGywApgyqdOqBbfc5M1+CjQGRJb51UACVDDUEW0XYBXysCN4g1PTFrf/A8mob
         aubjRK3MbkrVqbzDG1ofpKLzmX1Z1NqnMpWb4lZdmanD7vZEOD+0L49JcsQB/3K9gv
         nfKMBg5rMAKGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Candice Li <candice.li@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        YiPeng.Chai@amd.com, tao.zhou1@amd.com, evan.quan@amd.com,
        desowin@gmail.com, victor.skvortsov@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 04/12] drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.
Date:   Tue, 30 Aug 2022 13:24:35 -0400
Message-Id: <20220830172444.581654-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172444.581654-1-sashal@kernel.org>
References: <20220830172444.581654-1-sashal@kernel.org>
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
index 5906a8951a6c6..685a2df01d096 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2472,7 +2472,8 @@ static void gfx_v9_0_constants_init(struct amdgpu_device *adev)
 
 	gfx_v9_0_tiling_mode_table_init(adev);
 
-	gfx_v9_0_setup_rb(adev);
+	if (adev->gfx.num_gfx_rings)
+		gfx_v9_0_setup_rb(adev);
 	gfx_v9_0_get_cu_info(adev, &adev->gfx.cu_info);
 	adev->gfx.config.db_debug2 = RREG32_SOC15(GC, 0, mmDB_DEBUG2);
 
-- 
2.35.1

