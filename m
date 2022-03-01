Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCAA14C95E9
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbiCAUSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238344AbiCAUSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:18:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4930538BD4;
        Tue,  1 Mar 2022 12:17:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9B7561642;
        Tue,  1 Mar 2022 20:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEC7C340F2;
        Tue,  1 Mar 2022 20:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165873;
        bh=Qw/TSEqu3187tiIZfPiCaoDI+0CGQKmUat2XoI5t67w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d31PVOWLLO241kUtmbrnn0qaTC0OSGpJsbcc6HAw3Z31QEOTUDkvXCCRONldLxkO8
         mXCvuDw0cZgtp58nyuCk2djp+D+XGWVEeLwGjBJ3FBh83jcf7XyhegijX6nA1+qGPs
         GhW4CSzpvAyQhgaseNr6Ym6fRL5HKL/7ORVk//qkblUFEV8IaWxULRlvUnlmRIvrUf
         HV0K3MuEoyhb/aFjAnV2JfX36xdCbLg1JA4pD+RuZLHzV8K4i0upYWs1dYnDCKisD3
         WGKiubJ/b8x5roh+SbzHsWkiZ2Xliv/3qeksS0cCkgUxFNB66V+wY3DDAf58cvUtRu
         AOn/vzaI1xwrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guchun Chen <guchun.chen@amd.com>,
        Leslie Shi <Yuliang.Shi@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        mdaenzer@redhat.com, contact@emersion.fr, evan.quan@amd.com,
        bas@basnieuwenhuizen.nl, markyacoub@chromium.org,
        seanpaul@chromium.org, qingqing.zhuo@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 16/23] drm/amdgpu: bypass tiling flag check in virtual display case (v2)
Date:   Tue,  1 Mar 2022 15:16:15 -0500
Message-Id: <20220301201629.18547-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit e2b993302f40c4eb714ecf896dd9e1c5be7d4cd7 ]

vkms leverages common amdgpu framebuffer creation, and
also as it does not support FB modifier, there is no need
to check tiling flags when initing framebuffer when virtual
display is enabled.

This can fix below calltrace:

amdgpu 0000:00:08.0: GFX9+ requires FB check based on format modifier
WARNING: CPU: 0 PID: 1023 at drivers/gpu/drm/amd/amdgpu/amdgpu_display.c:1150 amdgpu_display_framebuffer_init+0x8e7/0xb40 [amdgpu]

v2: check adev->enable_virtual_display instead as vkms can be
	enabled in bare metal as well.

Signed-off-by: Leslie Shi <Yuliang.Shi@amd.com>
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index dc50c05f23fc2..5c08047adb594 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -1145,7 +1145,7 @@ int amdgpu_display_framebuffer_init(struct drm_device *dev,
 	if (ret)
 		return ret;
 
-	if (!dev->mode_config.allow_fb_modifiers) {
+	if (!dev->mode_config.allow_fb_modifiers && !adev->enable_virtual_display) {
 		drm_WARN_ONCE(dev, adev->family >= AMDGPU_FAMILY_AI,
 			      "GFX9+ requires FB check based on format modifier\n");
 		ret = check_tiling_flags_gfx6(rfb);
-- 
2.34.1

