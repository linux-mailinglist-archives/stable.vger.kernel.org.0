Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9165A6A9C
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiH3RbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiH3Raw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:30:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2ED12EC40;
        Tue, 30 Aug 2022 10:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1565EB81C35;
        Tue, 30 Aug 2022 17:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375D2C433D7;
        Tue, 30 Aug 2022 17:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880351;
        bh=57IC6E6AX7usppRwB0rZ/Wdn5wt79iBpTKmZzSEOBwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmWRB3vFCBmQO89hzhadFWV1lPX+6cW7W+FSjsq7v1HaXFx6dlFRcEeXlDRjvE1fH
         zr/XrxsRSeivxRhqiiMU1EOVbo6hAY3rZqarHfbbZBf8eO5waL+bMnezDuqbq+An6g
         kDl8S9zdA67fbe8IY7hQHMD8vgwHnc9R0ffiP4B2PWg/B2zssssNPo4OJaPsbygInu
         RLbc/vNpw5YNiyO3rkEeE937PQFEkKREvCl758txt2qJeV11kJeNwqOAdONO6pzDQ2
         ovcS6nsH/xlgd+6L2MmLx97e9i0ESaKLaY+lXxCeHhHGKIKNe7+n/V3MiI/YMz6VYI
         zD09r/JVV7G/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Candice Li <candice.li@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        YiPeng.Chai@amd.com, tao.zhou1@amd.com, ricetons@gmail.com,
        le.ma@amd.com, victor.skvortsov@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 02/10] drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.
Date:   Tue, 30 Aug 2022 13:25:33 -0400
Message-Id: <20220830172541.581820-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172541.581820-1-sashal@kernel.org>
References: <20220830172541.581820-1-sashal@kernel.org>
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
index d8ae6a23e6133..d36bea68a67e1 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1771,7 +1771,8 @@ static void gfx_v9_0_gpu_init(struct amdgpu_device *adev)
 
 	gfx_v9_0_tiling_mode_table_init(adev);
 
-	gfx_v9_0_setup_rb(adev);
+	if (adev->gfx.num_gfx_rings)
+		gfx_v9_0_setup_rb(adev);
 	gfx_v9_0_get_cu_info(adev, &adev->gfx.cu_info);
 	adev->gfx.config.db_debug2 = RREG32_SOC15(GC, 0, mmDB_DEBUG2);
 
-- 
2.35.1

