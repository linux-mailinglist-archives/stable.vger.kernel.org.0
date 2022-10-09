Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7105F9618
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiJJA0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiJJAYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:24:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3A144566;
        Sun,  9 Oct 2022 16:58:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00AB2B80DDF;
        Sun,  9 Oct 2022 23:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C73CC433D7;
        Sun,  9 Oct 2022 23:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359920;
        bh=1f/IIM22KhSPq/tEzKR9rXQnG4Nt9yGvBNVX09/3mEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ndedgr/Ai16WObmLsdK7PNKtZc7UzRyYeu3Em8c4ntpBqjxBeCrZnAQIOoqKlHY5T
         /N6GVwOXZmkaM3ri9DtmVO17m42fglODE6R2OYp3PppkG407gihEb0lmKyi+B19dtN
         5RnWIORcvLGFx1eNUOkXDenhG3hITrxwPNywKjbYk4xgrnU6GUMP11O7QE73w7K9NE
         nEP8Sq3LD69/OrRhgm2Otezn+Diy/Wl/HJi3+0atpT3hVbFENoo2bsQEM3EJ6tm1NX
         dsYtrA8t3aqvi8XDDkUcFaBhjl2Sq69f4dz89nYQPqtO/J5xtfkxr4nHuF0YAeNmbE
         AsvkO/uxw7cKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     hongao <hongao@uniontech.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        harry.wentland@amd.com, tzimmermann@suse.de,
        ville.syrjala@linux.intel.com, cssk@net-c.es, maxime@cerno.tech,
        zhou1615@umn.edu, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 6/6] drm/amdgpu: fix initial connector audio value
Date:   Sun,  9 Oct 2022 19:58:08 -0400
Message-Id: <20221009235808.1232269-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235808.1232269-1-sashal@kernel.org>
References: <20221009235808.1232269-1-sashal@kernel.org>
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

From: hongao <hongao@uniontech.com>

[ Upstream commit 4bb71fce58f30df3f251118291d6b0187ce531e6 ]

This got lost somewhere along the way, This fixes
audio not working until set_property was called.

Signed-off-by: hongao <hongao@uniontech.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index 0894bb98dc51..be3a384cc1cf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1678,10 +1678,12 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 						   adev->mode_info.dither_property,
 						   AMDGPU_FMT_DITHER_DISABLE);
 
-			if (amdgpu_audio != 0)
+			if (amdgpu_audio != 0) {
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
+			}
 
 			subpixel_order = SubPixelHorizontalRGB;
 			connector->interlace_allowed = true;
@@ -1786,6 +1788,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
@@ -1834,6 +1837,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
@@ -1879,6 +1883,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
-- 
2.35.1

