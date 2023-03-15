Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE1F6BB197
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbjCOM2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjCOM22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:28:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6499BE20
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E71DB81E06
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F58C433EF;
        Wed, 15 Mar 2023 12:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883253;
        bh=CLQCi32XALQCeFoT350WOxU4qJ4EXUKnaul/jbpzpkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zP9P2qkkdinTSthzNoXEbbwB8y5nAyuJIZ2j77s+Tr00L3RUgXSebT4062Sfa37ft
         I3yJ5N1AArnBQQVMISGMREhcE6n9hCxxbVwBDEFNUMGN9MSE9IxyOzHGKw2JOsopNp
         2u3qVtwNbaTh10dvVIGnznZ4yhoXbsQ4qYHo2jNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/145] drm/nouveau/kms/nv50-: remove unused functions
Date:   Wed, 15 Mar 2023 13:11:49 +0100
Message-Id: <20230315115740.504896721@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
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

[ Upstream commit 89ed996b888faaf11c69bb4cbc19f21475c9050e ]

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Stable-dep-of: 3638a820c5c3 ("drm/nouveau/kms/nv50: fix nv50_wndw_new_ prototype")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 16 ----------------
 drivers/gpu/drm/nouveau/dispnv50/wndw.c | 12 ------------
 drivers/gpu/drm/nouveau/dispnv50/wndw.h |  2 --
 3 files changed, 30 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index d7b9f7f8c9e31..0722b907bfcf4 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2622,14 +2622,6 @@ nv50_display_fini(struct drm_device *dev, bool runtime, bool suspend)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct drm_encoder *encoder;
-	struct drm_plane *plane;
-
-	drm_for_each_plane(plane, dev) {
-		struct nv50_wndw *wndw = nv50_wndw(plane);
-		if (plane->funcs != &nv50_wndw)
-			continue;
-		nv50_wndw_fini(wndw);
-	}
 
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
 		if (encoder->encoder_type != DRM_MODE_ENCODER_DPMST)
@@ -2645,7 +2637,6 @@ nv50_display_init(struct drm_device *dev, bool resume, bool runtime)
 {
 	struct nv50_core *core = nv50_disp(dev)->core;
 	struct drm_encoder *encoder;
-	struct drm_plane *plane;
 
 	if (resume || runtime)
 		core->func->init(core);
@@ -2658,13 +2649,6 @@ nv50_display_init(struct drm_device *dev, bool resume, bool runtime)
 		}
 	}
 
-	drm_for_each_plane(plane, dev) {
-		struct nv50_wndw *wndw = nv50_wndw(plane);
-		if (plane->funcs != &nv50_wndw)
-			continue;
-		nv50_wndw_init(wndw);
-	}
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.c b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
index 8d048bacd6f02..e1e62674e82d3 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -694,18 +694,6 @@ nv50_wndw_notify(struct nvif_notify *notify)
 	return NVIF_NOTIFY_KEEP;
 }
 
-void
-nv50_wndw_fini(struct nv50_wndw *wndw)
-{
-	nvif_notify_put(&wndw->notify);
-}
-
-void
-nv50_wndw_init(struct nv50_wndw *wndw)
-{
-	nvif_notify_get(&wndw->notify);
-}
-
 static const u64 nv50_cursor_format_modifiers[] = {
 	DRM_FORMAT_MOD_LINEAR,
 	DRM_FORMAT_MOD_INVALID,
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.h b/drivers/gpu/drm/nouveau/dispnv50/wndw.h
index f4e0c50800344..980f8ea96d54a 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.h
@@ -40,8 +40,6 @@ int nv50_wndw_new_(const struct nv50_wndw_func *, struct drm_device *,
 		   enum drm_plane_type, const char *name, int index,
 		   const u32 *format, enum nv50_disp_interlock_type,
 		   u32 interlock_data, u32 heads, struct nv50_wndw **);
-void nv50_wndw_init(struct nv50_wndw *);
-void nv50_wndw_fini(struct nv50_wndw *);
 void nv50_wndw_flush_set(struct nv50_wndw *, u32 *interlock,
 			 struct nv50_wndw_atom *);
 void nv50_wndw_flush_clr(struct nv50_wndw *, u32 *interlock, bool flush,
-- 
2.39.2



