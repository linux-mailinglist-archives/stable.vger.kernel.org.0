Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292CA5C039D
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiIUQHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiIUQGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A2A120B2;
        Wed, 21 Sep 2022 08:55:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1074063168;
        Wed, 21 Sep 2022 15:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB25C43140;
        Wed, 21 Sep 2022 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775654;
        bh=A3CykcyFmb5dPc3EiCtbcYody8l3T4oCjQVp3ikh9dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9/QuP1nnP9xNxG4c9+IwxjfSN4CC5YscxjJpR+BVkusI5eEAP1CLTnC7glRvmuXK
         nrWU0CfHfaE5PnGD1RmVZnAESg65WAdpLh7llmBnXL8TCvlqdYek19e6mCW9dc5pVy
         1mL4FbV/jvYwx69dWTZOjfjPMmKWTpaLBLWYkZCXxOCg02dAIFFAMFsmUxzoJj636v
         Oq2rIPhshqs4iNbzHIEtdZdaQIodE+wNRyT2u4qBpABwIgcuD6GbDnTxGl11xfDp9u
         UzZRNub26oqcULTKAf1TdHiCbKUBJuhY4d8AC9Tdy+GMPjQLjdSp2LCdt+fv/oZKhn
         y2aub8JhpqQxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        guchun.chen@amd.com, aurabindo.pillai@amd.com, evan.quan@amd.com,
        contact@emersion.fr, seanpaul@chromium.org, greenfoo@u92.eu,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 05/10] drm/amdgpu: use dirty framebuffer helper
Date:   Wed, 21 Sep 2022 11:54:02 -0400
Message-Id: <20220921155407.235132-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921155407.235132-1-sashal@kernel.org>
References: <20220921155407.235132-1-sashal@kernel.org>
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
index 5c08047adb59..47fb722ab374 100644
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
@@ -490,6 +491,7 @@ bool amdgpu_display_ddc_probe(struct amdgpu_connector *amdgpu_connector,
 static const struct drm_framebuffer_funcs amdgpu_fb_funcs = {
 	.destroy = drm_gem_fb_destroy,
 	.create_handle = drm_gem_fb_create_handle,
+	.dirty = drm_atomic_helper_dirtyfb,
 };
 
 uint32_t amdgpu_display_supported_domains(struct amdgpu_device *adev,
-- 
2.35.1

