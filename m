Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C253603C6A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiJSIqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiJSIpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:45:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1863783204;
        Wed, 19 Oct 2022 01:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83F16B82256;
        Wed, 19 Oct 2022 08:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF34C433D6;
        Wed, 19 Oct 2022 08:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168856;
        bh=J4GXFMdeRLZix8AZSV4/nBwMjiWe1xjgzdQTqZP/uF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPBGNx11kGqhHHgvIynAmBOxJ23NFj3rkwCYbiA39eBRkSdJVx3JA4M3hMzydJW2M
         TDrt64JHrdTyekVCevszTV6AHl4F33b1nHcpj8B3svMeTfVoIRzN9rntPbdlU9QUnU
         f2npV52gcTugcECeptU4XzhzDXo0s4v4k+/hFuBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 069/862] Revert "drm/amdgpu: use dirty framebuffer helper"
Date:   Wed, 19 Oct 2022 10:22:36 +0200
Message-Id: <20221019083252.970352308@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -38,8 +38,6 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <drm/drm_crtc_helper.h>
-#include <drm/drm_damage_helper.h>
-#include <drm/drm_drv.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_fb_helper.h>
@@ -500,12 +498,6 @@ static const struct drm_framebuffer_func
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
@@ -1108,10 +1100,8 @@ static int amdgpu_display_gem_fb_verify_
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
 


