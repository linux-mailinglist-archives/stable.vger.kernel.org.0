Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A316C5EA398
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbiIZL2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237965AbiIZL1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:27:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DDE3B3;
        Mon, 26 Sep 2022 03:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F006FB80972;
        Mon, 26 Sep 2022 10:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D29C433D6;
        Mon, 26 Sep 2022 10:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188806;
        bh=A3CykcyFmb5dPc3EiCtbcYody8l3T4oCjQVp3ikh9dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgWizo90b222K4Iha50Qc19+y7KiQq7z1XuRlZTGzyah7qN6z84dvpI04GxISoo5o
         mBTu/v7v0uu09zGwJQZ/NqPzzBh3hxc4HVXTKh43R8vBT7p1Z/wayYJNJ2yI7xy4KI
         p8ACqKb6+64WFjo3OIhW7FutsgsJwImx/9WNkcgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/148] drm/amdgpu: use dirty framebuffer helper
Date:   Mon, 26 Sep 2022 12:12:42 +0200
Message-Id: <20220926100800.981514741@linuxfoundation.org>
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



