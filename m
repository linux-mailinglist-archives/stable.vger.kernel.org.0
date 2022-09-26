Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540285EA38A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiIZL1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbiIZL0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BABC69F4A;
        Mon, 26 Sep 2022 03:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E96BD609FE;
        Mon, 26 Sep 2022 10:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5914C433D6;
        Mon, 26 Sep 2022 10:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188847;
        bh=p308GEKL87lFJ0U7hsKmHpyPZR1lRw7skm/TfB2cL2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zuHlKXhZbIAHBmVBkAccjAayF6SWl3sQQZ15IR3QcsDASjpPC48EXE5ElRyQAwYGu
         4LaaJRR43i+m5FKUmoeNOqWd2fblt5hwhMSh//3op+6jL9ZMk9qaSYvjkhF6pqEGSJ
         RTPFonfz7dHPHUdE+kdRR2SUEOQhT5kICH8ezjT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/148] drm/amdgpu: dont register a dirty callback for non-atomic
Date:   Mon, 26 Sep 2022 12:12:54 +0200
Message-Id: <20220926100801.461684305@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit abbc7a3dafb91b9d4ec56b70ec9a7520f8e13334 ]

Some asics still support non-atomic code paths.

Fixes: 66f99628eb2440 ("drm/amdgpu: use dirty framebuffer helper")
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Reviewed-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 47fb722ab374..d3d2c214554e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -36,6 +36,7 @@
 #include <linux/pm_runtime.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_damage_helper.h>
+#include <drm/drm_drv.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_fb_helper.h>
@@ -491,6 +492,11 @@ bool amdgpu_display_ddc_probe(struct amdgpu_connector *amdgpu_connector,
 static const struct drm_framebuffer_funcs amdgpu_fb_funcs = {
 	.destroy = drm_gem_fb_destroy,
 	.create_handle = drm_gem_fb_create_handle,
+};
+
+static const struct drm_framebuffer_funcs amdgpu_fb_funcs_atomic = {
+	.destroy = drm_gem_fb_destroy,
+	.create_handle = drm_gem_fb_create_handle,
 	.dirty = drm_atomic_helper_dirtyfb,
 };
 
@@ -1111,7 +1117,10 @@ int amdgpu_display_gem_fb_verify_and_init(
 	if (ret)
 		goto err;
 
-	ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs);
+	if (drm_drv_uses_atomic_modeset(dev))
+		ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs_atomic);
+	else
+		ret = drm_framebuffer_init(dev, &rfb->base, &amdgpu_fb_funcs);
 	if (ret)
 		goto err;
 
-- 
2.35.1



