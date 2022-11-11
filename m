Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8512B62507A
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiKKCfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiKKCfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:35:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D745682BD;
        Thu, 10 Nov 2022 18:34:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7B0761E85;
        Fri, 11 Nov 2022 02:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D64C43143;
        Fri, 11 Nov 2022 02:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134065;
        bh=gISBxv/LWiXRjrU9C/SlDLpioy9jyy9o+asTMKurs3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fs9q+Fizgerd6WTzNc7qYADBcAwGdpM6/75grL5XhG6f5nJMjggfYJgMtmEdKuFE2
         LXoYqammSPrbCie9F5sFQNuOX0YpMtdGemME0keVdm8A6uSHrozmK4KmcUt6vEh9ub
         5tA81Ci8dxdhqiyy8GunE+tScSit5U9f5c/2VDP3pG9f69hBU7gdNbCGZ4LDfV+xsn
         0toXH2StQf80g1opqZjacZAG3KUtjkOrwt+6/HZXQVZpQynR51PuPjnAVXK55vWpQl
         TT7ENuqBPm4ksAqVqVujoYKDK0w0ZflX3cPr/JttizH7BaYt9JRfQGwF0aQA02YeUF
         qV4evzOyH3jAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zhang <yifan1.zhang@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Tim Huang <Tim.Huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        flora.cui@amd.com, Yuliang.Shi@amd.com, evan.quan@amd.com,
        isabbasso@riseup.net, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 20/30] drm/amdgpu: set fb_modifiers_not_supported in vkms
Date:   Thu, 10 Nov 2022 21:33:28 -0500
Message-Id: <20221111023340.227279-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
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

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 89b3554782e6b65894f0551e9e0a82ad02dac94d ]

This patch to fix the gdm3 start failure with virual display:

/usr/libexec/gdm-x-session[1711]: (II) AMDGPU(0): Setting screen physical size to 270 x 203
/usr/libexec/gdm-x-session[1711]: (EE) AMDGPU(0): Failed to make import prime FD as pixmap: 22
/usr/libexec/gdm-x-session[1711]: (EE) AMDGPU(0): failed to set mode: Invalid argument
/usr/libexec/gdm-x-session[1711]: (WW) AMDGPU(0): Failed to set mode on CRTC 0
/usr/libexec/gdm-x-session[1711]: (EE) AMDGPU(0): Failed to enable any CRTC
gnome-shell[1840]: Running GNOME Shell (using mutter 42.2) as a X11 window and compositing manager
/usr/libexec/gdm-x-session[1711]: (EE) AMDGPU(0): failed to set mode: Invalid argument

vkms doesn't have modifiers support, set fb_modifiers_not_supported to bring the gdm back.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
index 576849e95296..f69827aefb57 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
@@ -500,6 +500,8 @@ static int amdgpu_vkms_sw_init(void *handle)
 
 	adev_to_drm(adev)->mode_config.fb_base = adev->gmc.aper_base;
 
+	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
+
 	r = amdgpu_display_modeset_create_props(adev);
 	if (r)
 		return r;
-- 
2.35.1

