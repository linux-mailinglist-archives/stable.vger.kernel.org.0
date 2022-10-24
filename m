Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0524E60AAEE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiJXNmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbiJXNkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:40:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C305FB3B12;
        Mon, 24 Oct 2022 05:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDA85612BB;
        Mon, 24 Oct 2022 12:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086BCC433C1;
        Mon, 24 Oct 2022 12:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614912;
        bh=p3GXiVr5YR4RO0NRzMuEbRh05Hvssbnu1YzSmUJ70h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrOsWBWxk4iXK6JVizr+RedtRyUF30pceNwfehDXZJdj46aglcVM5zTXpi834kUId
         Cy5SVRuWcEFiQIzBbCqar+pq6pzt3lY3aKskv2gx/qNhvjomhH0mudf6PCRV3YYAHy
         MQ8PGMR0dlAXZ28/8CNNed0O5TDWgC+Q82q6X5Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 050/530] Revert "drm/amdgpu: use dirty framebuffer helper"
Date:   Mon, 24 Oct 2022 13:26:34 +0200
Message-Id: <20221024113047.284017470@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit 17d819e2828cacca2e4c909044eb9798ed379cd2 upstream.

This reverts commit 66f99628eb24409cb8feb5061f78283c8b65f820.

Unfortunately, that commit causes performance regressions on non-PSR
setups. So, just revert it until FB_DAMAGE_CLIPS support can be added.

Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2189
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216554
Fixes: 66f99628eb2440 ("drm/amdgpu: use dirty framebuffer helper")
Fixes: abbc7a3dafb91b ("drm/amdgpu: don't register a dirty callback for non-atomic")
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -35,8 +35,6 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <drm/drm_crtc_helper.h>
-#include <drm/drm_damage_helper.h>
-#include <drm/drm_drv.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_fb_helper.h>
@@ -494,12 +492,6 @@ static const struct drm_framebuffer_func
 	.create_handle = drm_gem_fb_create_handle,
 };
 
-static const struct drm_framebuffer_funcs amdgpu_fb_funcs_atomic = {
-	.destroy = drm_gem_fb_destroy,
-	.create_handle = drm_gem_fb_create_handle,
-	.dirty = drm_atomic_helper_dirtyfb,
-};
-
 uint32_t amdgpu_display_supported_domains(struct amdgpu_device *adev,
 					  uint64_t bo_flags)
 {
@@ -1117,10 +1109,8 @@ int amdgpu_display_gem_fb_verify_and_ini
 	if (ret)
 		goto err;
 
-	if (drm_drv_uses_atomic_modeset(dev))
-		ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs_atomic);
-	else
-		ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs);
+	ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs);
+
 	if (ret)
 		goto err;
 


