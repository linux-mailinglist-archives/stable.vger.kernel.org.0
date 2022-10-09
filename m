Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508B05F9572
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiJJAUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiJJASu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:18:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0B2CE7;
        Sun,  9 Oct 2022 16:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07F65B80DE9;
        Sun,  9 Oct 2022 23:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B18C433D7;
        Sun,  9 Oct 2022 23:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359625;
        bh=zvWGShizebvrdEFUd9n0bZ6NDl0vKJL3PrigdSbA9rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlPIjYdTMeKfEc58hievnx3zmKNjva2hya48O5CgYmkem3eNcQNEl6L+tkiQylWyj
         /8rZK8FYO8HTZqelI01AShycMHLQdRTOR4xraDJWRyfBizrTS7nsWTlYWhUqh2GkYj
         BMkWfnuWyMYdSQBR/ZvRQObmxQu37CECHkOlkPaqwjKUeBhP4z2B8F4afFkqis3hBy
         9K9tyNa7XEK2i+qs7ho9rQQ5p5iRxzskaO5Hh0HXYdl3x38khqGrMI8Tjq/LftmxfW
         RVvDabHr/T4YSQjRYNX1GeTQeWoSNsElTLEshii8V5awpnLsdCGoVDeKTtU8J9NnMH
         1iBWlU3xP/5TQ==
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
Subject: [PATCH AUTOSEL 5.19 27/36] drm/amdgpu: fix initial connector audio value
Date:   Sun,  9 Oct 2022 19:52:13 -0400
Message-Id: <20221009235222.1230786-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235222.1230786-1-sashal@kernel.org>
References: <20221009235222.1230786-1-sashal@kernel.org>
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
index b7933c2ce765..491d4846fc02 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1674,10 +1674,12 @@ amdgpu_connector_add(struct amdgpu_device *adev,
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
@@ -1799,6 +1801,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
@@ -1852,6 +1855,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
@@ -1902,6 +1906,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
-- 
2.35.1

