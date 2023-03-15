Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993C06BB2FB
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbjCOMkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbjCOMk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405DAFF0E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3B8661CC2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B945BC433D2;
        Wed, 15 Mar 2023 12:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883939;
        bh=W1GGh+y+lQ+uzIOiQmxJG9GWzitLt5jpKIlKrY4FUt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szdJUukqYvifwMvxE7GFxyYMRJZKc/qhIPigMhvRfNqUI2JPliWS1KsK435HVPwij
         QMji6NHlk9hOa/a5+/lpEE7GHMTFAYbLPa199D+VRNjNE1hfnuKwjkx0K77nqyNmOm
         6U1/eIylqNpQ24P6KReRyhZAE69UOakBaXPN5908=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 046/141] drm/nouveau/fb/gp102-: cache scrubber binary on first load
Date:   Wed, 15 Mar 2023 13:12:29 +0100
Message-Id: <20230315115741.372910397@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 1b9b4f922f96108da3bb5d87b2d603f5dfbc5650 ]

During system shutdown nouveau might not be able to request firmware from
Userspace, which then leads to a regression preventing the system from
shutting down.

Cache the scrubber binary for this case.

Fixes: 0e44c21708761 ("drm/nouveau/flcn: new code to load+boot simple HS FWs (VPR scrubber)")
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/CACAvsv7Uf5=K44y8YLsiy0aMnc1zvGEQdeDe7RQF=AV+fxxzuQ@mail.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/nouveau/include/nvkm/subdev/fb.h  |  3 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c |  8 +++-
 .../gpu/drm/nouveau/nvkm/subdev/fb/ga100.c    |  2 +-
 .../gpu/drm/nouveau/nvkm/subdev/fb/ga102.c    | 21 ++++------
 .../gpu/drm/nouveau/nvkm/subdev/fb/gp102.c    | 41 +++++++------------
 .../gpu/drm/nouveau/nvkm/subdev/fb/gv100.c    |  4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/priv.h |  3 +-
 .../gpu/drm/nouveau/nvkm/subdev/fb/tu102.c    |  4 +-
 8 files changed, 36 insertions(+), 50 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/subdev/fb.h b/drivers/gpu/drm/nouveau/include/nvkm/subdev/fb.h
index c5a4f49ee2065..01a22a13b4520 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/fb.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/fb.h
@@ -2,6 +2,7 @@
 #ifndef __NVKM_FB_H__
 #define __NVKM_FB_H__
 #include <core/subdev.h>
+#include <core/falcon.h>
 #include <core/mm.h>
 
 /* memory type/access flags, do not match hardware values */
@@ -33,7 +34,7 @@ struct nvkm_fb {
 	const struct nvkm_fb_func *func;
 	struct nvkm_subdev subdev;
 
-	struct nvkm_blob vpr_scrubber;
+	struct nvkm_falcon_fw vpr_scrubber;
 
 	struct {
 		struct page *flush_page;
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c
index bac7dcc4c2c13..0955340cc4218 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c
@@ -143,6 +143,10 @@ nvkm_fb_mem_unlock(struct nvkm_fb *fb)
 	if (!fb->func->vpr.scrub_required)
 		return 0;
 
+	ret = nvkm_subdev_oneinit(subdev);
+	if (ret)
+		return ret;
+
 	if (!fb->func->vpr.scrub_required(fb)) {
 		nvkm_debug(subdev, "VPR not locked\n");
 		return 0;
@@ -150,7 +154,7 @@ nvkm_fb_mem_unlock(struct nvkm_fb *fb)
 
 	nvkm_debug(subdev, "VPR locked, running scrubber binary\n");
 
-	if (!fb->vpr_scrubber.size) {
+	if (!fb->vpr_scrubber.fw.img) {
 		nvkm_warn(subdev, "VPR locked, but no scrubber binary!\n");
 		return 0;
 	}
@@ -229,7 +233,7 @@ nvkm_fb_dtor(struct nvkm_subdev *subdev)
 
 	nvkm_ram_del(&fb->ram);
 
-	nvkm_blob_dtor(&fb->vpr_scrubber);
+	nvkm_falcon_fw_dtor(&fb->vpr_scrubber);
 
 	if (fb->sysmem.flush_page) {
 		dma_unmap_page(subdev->device->dev, fb->sysmem.flush_page_addr,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga100.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga100.c
index 5098f219e3e6f..a7456e7864636 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga100.c
@@ -37,5 +37,5 @@ ga100_fb = {
 int
 ga100_fb_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
 {
-	return gp102_fb_new_(&ga100_fb, device, type, inst, pfb);
+	return gf100_fb_new_(&ga100_fb, device, type, inst, pfb);
 }
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga102.c
index 5a21b0ae45958..dd476e079fe1c 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ga102.c
@@ -25,25 +25,20 @@
 #include <engine/nvdec.h>
 
 static int
-ga102_fb_vpr_scrub(struct nvkm_fb *fb)
+ga102_fb_oneinit(struct nvkm_fb *fb)
 {
-	struct nvkm_falcon_fw fw = {};
-	int ret;
+	struct nvkm_subdev *subdev = &fb->subdev;
 
-	ret = nvkm_falcon_fw_ctor_hs_v2(&ga102_flcn_fw, "mem-unlock", &fb->subdev, "nvdec/scrubber",
-					0, &fb->subdev.device->nvdec[0]->falcon, &fw);
-	if (ret)
-		return ret;
+	nvkm_falcon_fw_ctor_hs_v2(&ga102_flcn_fw, "mem-unlock", subdev, "nvdec/scrubber",
+				  0, &subdev->device->nvdec[0]->falcon, &fb->vpr_scrubber);
 
-	ret = nvkm_falcon_fw_boot(&fw, &fb->subdev, true, NULL, NULL, 0, 0);
-	nvkm_falcon_fw_dtor(&fw);
-	return ret;
+	return gf100_fb_oneinit(fb);
 }
 
 static const struct nvkm_fb_func
 ga102_fb = {
 	.dtor = gf100_fb_dtor,
-	.oneinit = gf100_fb_oneinit,
+	.oneinit = ga102_fb_oneinit,
 	.init = gm200_fb_init,
 	.init_page = gv100_fb_init_page,
 	.init_unkn = gp100_fb_init_unkn,
@@ -51,13 +46,13 @@ ga102_fb = {
 	.ram_new = ga102_ram_new,
 	.default_bigpage = 16,
 	.vpr.scrub_required = tu102_fb_vpr_scrub_required,
-	.vpr.scrub = ga102_fb_vpr_scrub,
+	.vpr.scrub = gp102_fb_vpr_scrub,
 };
 
 int
 ga102_fb_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
 {
-	return gp102_fb_new_(&ga102_fb, device, type, inst, pfb);
+	return gf100_fb_new_(&ga102_fb, device, type, inst, pfb);
 }
 
 MODULE_FIRMWARE("nvidia/ga102/nvdec/scrubber.bin");
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gp102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gp102.c
index 2658481d575b6..14d942e8b857f 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gp102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gp102.c
@@ -29,18 +29,7 @@
 int
 gp102_fb_vpr_scrub(struct nvkm_fb *fb)
 {
-	struct nvkm_subdev *subdev = &fb->subdev;
-	struct nvkm_falcon_fw fw = {};
-	int ret;
-
-	ret = nvkm_falcon_fw_ctor_hs(&gm200_flcn_fw, "mem-unlock", subdev, NULL,
-				     "nvdec/scrubber", 0, &subdev->device->nvdec[0]->falcon, &fw);
-	if (ret)
-		return ret;
-
-	ret = nvkm_falcon_fw_boot(&fw, subdev, true, NULL, NULL, 0, 0x00000000);
-	nvkm_falcon_fw_dtor(&fw);
-	return ret;
+	return nvkm_falcon_fw_boot(&fb->vpr_scrubber, &fb->subdev, true, NULL, NULL, 0, 0x00000000);
 }
 
 bool
@@ -51,10 +40,21 @@ gp102_fb_vpr_scrub_required(struct nvkm_fb *fb)
 	return (nvkm_rd32(device, 0x100cd0) & 0x00000010) != 0;
 }
 
+int
+gp102_fb_oneinit(struct nvkm_fb *fb)
+{
+	struct nvkm_subdev *subdev = &fb->subdev;
+
+	nvkm_falcon_fw_ctor_hs(&gm200_flcn_fw, "mem-unlock", subdev, NULL, "nvdec/scrubber",
+			       0, &subdev->device->nvdec[0]->falcon, &fb->vpr_scrubber);
+
+	return gf100_fb_oneinit(fb);
+}
+
 static const struct nvkm_fb_func
 gp102_fb = {
 	.dtor = gf100_fb_dtor,
-	.oneinit = gf100_fb_oneinit,
+	.oneinit = gp102_fb_oneinit,
 	.init = gm200_fb_init,
 	.init_remapper = gp100_fb_init_remapper,
 	.init_page = gm200_fb_init_page,
@@ -64,23 +64,10 @@ gp102_fb = {
 	.ram_new = gp100_ram_new,
 };
 
-int
-gp102_fb_new_(const struct nvkm_fb_func *func, struct nvkm_device *device,
-	      enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
-{
-	int ret = gf100_fb_new_(func, device, type, inst, pfb);
-	if (ret)
-		return ret;
-
-	nvkm_firmware_load_blob(&(*pfb)->subdev, "nvdec/scrubber", "", 0,
-				&(*pfb)->vpr_scrubber);
-	return 0;
-}
-
 int
 gp102_fb_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
 {
-	return gp102_fb_new_(&gp102_fb, device, type, inst, pfb);
+	return gf100_fb_new_(&gp102_fb, device, type, inst, pfb);
 }
 
 MODULE_FIRMWARE("nvidia/gp102/nvdec/scrubber.bin");
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gv100.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gv100.c
index 0e3c0a8f5d716..4d8a286a7a348 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gv100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gv100.c
@@ -31,7 +31,7 @@ gv100_fb_init_page(struct nvkm_fb *fb)
 static const struct nvkm_fb_func
 gv100_fb = {
 	.dtor = gf100_fb_dtor,
-	.oneinit = gf100_fb_oneinit,
+	.oneinit = gp102_fb_oneinit,
 	.init = gm200_fb_init,
 	.init_page = gv100_fb_init_page,
 	.init_unkn = gp100_fb_init_unkn,
@@ -45,7 +45,7 @@ gv100_fb = {
 int
 gv100_fb_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
 {
-	return gp102_fb_new_(&gv100_fb, device, type, inst, pfb);
+	return gf100_fb_new_(&gv100_fb, device, type, inst, pfb);
 }
 
 MODULE_FIRMWARE("nvidia/gv100/nvdec/scrubber.bin");
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/priv.h b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/priv.h
index f517751f94acd..726c30c8bf95d 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/priv.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/priv.h
@@ -83,8 +83,7 @@ int gm200_fb_init_page(struct nvkm_fb *);
 void gp100_fb_init_remapper(struct nvkm_fb *);
 void gp100_fb_init_unkn(struct nvkm_fb *);
 
-int gp102_fb_new_(const struct nvkm_fb_func *, struct nvkm_device *, enum nvkm_subdev_type, int,
-		  struct nvkm_fb **);
+int gp102_fb_oneinit(struct nvkm_fb *);
 bool gp102_fb_vpr_scrub_required(struct nvkm_fb *);
 int gp102_fb_vpr_scrub(struct nvkm_fb *);
 
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/tu102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/tu102.c
index be82af0364ee4..b8803c124c3b2 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/tu102.c
@@ -31,7 +31,7 @@ tu102_fb_vpr_scrub_required(struct nvkm_fb *fb)
 static const struct nvkm_fb_func
 tu102_fb = {
 	.dtor = gf100_fb_dtor,
-	.oneinit = gf100_fb_oneinit,
+	.oneinit = gp102_fb_oneinit,
 	.init = gm200_fb_init,
 	.init_page = gv100_fb_init_page,
 	.init_unkn = gp100_fb_init_unkn,
@@ -45,7 +45,7 @@ tu102_fb = {
 int
 tu102_fb_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst, struct nvkm_fb **pfb)
 {
-	return gp102_fb_new_(&tu102_fb, device, type, inst, pfb);
+	return gf100_fb_new_(&tu102_fb, device, type, inst, pfb);
 }
 
 MODULE_FIRMWARE("nvidia/tu102/nvdec/scrubber.bin");
-- 
2.39.2



