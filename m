Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C78C5F95EF
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJJA0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbiJJAYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:24:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BA23EA54;
        Sun,  9 Oct 2022 16:58:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31D1E60DCC;
        Sun,  9 Oct 2022 23:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24C8C433D6;
        Sun,  9 Oct 2022 23:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359885;
        bh=x64p9PIf/71AI9EqI80e9YSybdV7Rzg21I92kH5YS6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kup094IsubeVm3mUrxEkIrM/6d/Ifb/zX0SE8TObwsA4nuBqUQHMavDHMNQvOJlj6
         lD9mrb6sflmJ5BCDfabTCxOfjKa7H9LWxFhNK3OuOtTsf+rk3sX+utnmE5z+C58zCE
         q3jWMBZNBhD+iUsC0nhb6RLsNcqpGq07HGqixrYjzJbG5yFKE19qYgaThVF9PdhydN
         B0pVWUVMuZ3yKY8aPxTPQf+ScwCOgOyE6Nw0Ehy4YqdbbwChvP0HcGyMd23lu9wHXH
         ejM1b9PSq8+GISLWb9VV+x/fNeid5/WOSNAdrMBTeQcB2vEKx+aXkEIQ5MQAJiGr+E
         ihUCz4Yb+POYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     hongao <hongao@uniontech.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        harry.wentland@amd.com, ville.syrjala@linux.intel.com,
        cssk@net-c.es, tzimmermann@suse.de, maxime@cerno.tech,
        zhou1615@umn.edu, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 09/10] drm/amdgpu: fix initial connector audio value
Date:   Sun,  9 Oct 2022 19:57:44 -0400
Message-Id: <20221009235746.1232129-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235746.1232129-1-sashal@kernel.org>
References: <20221009235746.1232129-1-sashal@kernel.org>
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
index 3e4305c3c983..86ceefb8b8fb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1638,10 +1638,12 @@ amdgpu_connector_add(struct amdgpu_device *adev,
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
@@ -1746,6 +1748,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
@@ -1794,6 +1797,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
@@ -1839,6 +1843,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
-- 
2.35.1

