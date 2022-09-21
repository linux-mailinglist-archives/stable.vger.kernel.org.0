Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E990A5C03B7
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiIUQJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbiIUQIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:08:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCCFA50E8;
        Wed, 21 Sep 2022 08:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FDEE6318C;
        Wed, 21 Sep 2022 15:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD16C433D7;
        Wed, 21 Sep 2022 15:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775680;
        bh=v5EDMi5xv8Yp5djZlevGniTsGU8hyj95KCeXj7CWXZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hx6C6QpmEop/DNOhefbEZrnf3tCn0RokgNUyvbXdz39bDLItCEIHym3lEC2Hs1wvl
         jtQwltN2tGnRya6Nt6+D1B/BnrngTYhaoC3oAEnYXMQO6PRDUr08Xk7htHwUM8F9fY
         93m9e9RwCXaeExjPX/qjZa7IxSh47zr9GcNC/VU2mUv4RIE8MX2xytuUegLhsC3QMe
         8ewGCYlVWuVR/QvIbf3p8Shjg2AlOX+6qc6SR64WFv580hOvHfTLS1wji6iO9hfkX0
         p6eIutVEm1KY/0JRDHCn1PIp0oBQC2VgDTuF01Zc6ExfgJDRBxPRLdoJqaYg/xzkoU
         F0jZ5XLVKeSqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        guchun.chen@amd.com, aurabindo.pillai@amd.com, evan.quan@amd.com,
        contact@emersion.fr, seanpaul@chromium.org, greenfoo@u92.eu,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 3/5] drm/amdgpu: use dirty framebuffer helper
Date:   Wed, 21 Sep 2022 11:54:34 -0400
Message-Id: <20220921155436.235371-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921155436.235371-1-sashal@kernel.org>
References: <20220921155436.235371-1-sashal@kernel.org>
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

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit 66f99628eb24409cb8feb5061f78283c8b65f820 ]

Currently, we aren't handling DRM_IOCTL_MODE_DIRTYFB. So, use
drm_atomic_helper_dirtyfb() as the dirty callback in the amdgpu_fb_funcs
struct.

Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index b588e0e409e7..d8687868407d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -35,6 +35,7 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <drm/drm_crtc_helper.h>
+#include <drm/drm_damage_helper.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_fb_helper.h>
@@ -495,6 +496,7 @@ bool amdgpu_display_ddc_probe(struct amdgpu_connector *amdgpu_connector,
 static const struct drm_framebuffer_funcs amdgpu_fb_funcs = {
 	.destroy = drm_gem_fb_destroy,
 	.create_handle = drm_gem_fb_create_handle,
+	.dirty = drm_atomic_helper_dirtyfb,
 };
 
 uint32_t amdgpu_display_supported_domains(struct amdgpu_device *adev,
-- 
2.35.1

