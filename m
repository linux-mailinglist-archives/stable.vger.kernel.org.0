Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E92D6BB0E1
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjCOMWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjCOMVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:21:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BF1968F4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:21:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A82E56174E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF150C433EF;
        Wed, 15 Mar 2023 12:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882859;
        bh=ybYcEA46Rta2tWc1+l1vxwRAf+DPipaXJHJ5vM7nxrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LftUee2ttYUS7BOi6g5/y/K6vSBcftyaWawhc27clTLm/HO1IUSry36Lm5IR8PJN1
         2AICdZn41xpHIIMhPFQUpZRqRqp0XZWEBEkGiYbTCiZtzou69I8wP4/HQsoS/lqxNp
         bSwUc3P5RIVPjJAMcPz358P48iOEj9Dx9clPGCJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/104] drm/nouveau/kms/nv50-: remove unused functions
Date:   Wed, 15 Mar 2023 13:11:59 +0100
Message-Id: <20230315115733.222695064@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
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
index c2d34c91e840c..804ea035fa46b 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2555,14 +2555,6 @@ nv50_display_fini(struct drm_device *dev, bool runtime, bool suspend)
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
@@ -2578,7 +2570,6 @@ nv50_display_init(struct drm_device *dev, bool resume, bool runtime)
 {
 	struct nv50_core *core = nv50_disp(dev)->core;
 	struct drm_encoder *encoder;
-	struct drm_plane *plane;
 
 	if (resume || runtime)
 		core->func->init(core);
@@ -2591,13 +2582,6 @@ nv50_display_init(struct drm_device *dev, bool resume, bool runtime)
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
index f07916ffe42cb..831125b4453df 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -690,18 +690,6 @@ nv50_wndw_notify(struct nvif_notify *notify)
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
index 3278e28800343..8bed195ae098a 100644
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



