Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369C76C81D8
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 16:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbjCXPxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 11:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjCXPxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 11:53:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD3C5FD9
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 08:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679673145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fPwPDdlv2LUiU7nI+R/JDQaCBzeZ/8ZN3G2D5wvnC8c=;
        b=I2GfmtvJGQN00tXwS6UywWgaa7Suv1CgoejbvGHpeTMLLP/y+tjBIWuU5XMxnBzyERUthp
        Eb+1QP9I6EFdyCoswePLXgiWhI4RHk9MdSJATTdlOPNtvFOY7WawUSVbMc+WmktV2ti9TW
        IOYdozq+Q875CKmi5lgWTG27LV6NHvo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-WH8ueojaOPm2p8Pk3-ubXw-1; Fri, 24 Mar 2023 11:52:24 -0400
X-MC-Unique: WH8ueojaOPm2p8Pk3-ubXw-1
Received: by mail-qk1-f200.google.com with SMTP id t21-20020a37aa15000000b00746b7fae197so971716qke.12
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 08:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679673142; x=1682265142;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fPwPDdlv2LUiU7nI+R/JDQaCBzeZ/8ZN3G2D5wvnC8c=;
        b=P4qhX/JmiQcMM13ZXoKHZ8nLEdLZOYeF7S5vVYD43OGTimohiROnWSisUi0sf0ejJx
         62u/a4oCCWs7eZTwCo0T5AAWf5ctNrY5SsKI1isKZkAHsoHBHZBmxDGHLax1oiMKSvH4
         +x0joksds1kehngBB+96n5duQ1tmsxCacFLJUPqyBavbSRtEDcjrDbj8M+QXTyEckzoL
         KKeS+sz0wvEK+TwD7uO3DpRO1hu4UbAC/gqgLb4mIa6ISDMVDpuPoSRYizxgvj6E5lTi
         htzz86uNVqFdWNvyBb/q6IeCLnMRorslFHhoIZOGD0T4YiZeEB3RmEalCgRF+dnQcost
         GOKA==
X-Gm-Message-State: AO0yUKVsqnvWwTLNGlYtNMpjmrvnGPDcyjIKIQRfLlO4QkgiYML8Ol1u
        mAHv7NfskT5HM2pSXWWfIcaqUF9bmXvNPvkgMNyqjIuNzMFKyBHy03Clg2aFSYUh9IkLQbt4lys
        q9VyIZQ05gp90K36m
X-Received: by 2002:a05:622a:1a18:b0:3bf:a60d:43b9 with SMTP id f24-20020a05622a1a1800b003bfa60d43b9mr3863467qtb.4.1679673142039;
        Fri, 24 Mar 2023 08:52:22 -0700 (PDT)
X-Google-Smtp-Source: AK7set9dGMxPoYAht2ipk1CT6ra7hRPMomwAzWoRJH8HLImNw7qE2w09Gg/j8Gpym6lsbF+2QpvsDQ==
X-Received: by 2002:a05:622a:1a18:b0:3bf:a60d:43b9 with SMTP id f24-20020a05622a1a1800b003bfa60d43b9mr3863443qtb.4.1679673141779;
        Fri, 24 Mar 2023 08:52:21 -0700 (PDT)
Received: from kherbst.pingu.com (ip1f1032bf.dynamic.kabel-deutschland.de. [31.16.50.191])
        by smtp.gmail.com with ESMTPSA id do31-20020a05620a2b1f00b00746ac77366fsm670170qkb.12.2023.03.24.08.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 08:52:20 -0700 (PDT)
From:   Karol Herbst <kherbst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Karol Herbst <kherbst@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@gmail.com>,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH] drm/nouveau/gr: enable memory loads on helper invocation on all channels
Date:   Fri, 24 Mar 2023 16:52:17 +0100
Message-Id: <20230324155217.3548232-1-kherbst@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have a lurking bug where Fragment Shader Helper Invocations can't load
from memory. But this is actually required in OpenGL and is causing random
hangs or failures in random shaders.

It is unknown how widespread this issue is, but shaders hitting this can
end up with infinite loops.

We enable those only on all Kepler and newer GPUs where we use our own
Firmware.

Nvidia's firmware provides a way to set a kernelspace controlled list of
mmio registers in the gr space from push buffers via MME macros.

Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: David Airlie <airlied@gmail.com>
Cc: nouveau@lists.freedesktop.org
Cc: stable@vger.kernel.org
Signed-off-by: Karol Herbst <kherbst@redhat.com>
---
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.c  |  2 ++
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.h  |  2 ++
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk104.c  |  4 +++-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110.c  | 10 ++++++++++
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110b.c |  1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk208.c  |  1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm107.c  |  1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm200.c  |  1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp100.c  |  1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp102.c  |  1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp104.c  |  1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp107.c  |  1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgv100.c  | 10 ++++++++++
 13 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.c
index cb390e0134a23..950ab7c82582f 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.c
@@ -1332,6 +1332,8 @@ gf100_grctx_generate_floorsweep(struct gf100_gr *gr)
 		func->gpc_tpc_nr(gr);
 	if (func->r419f78)
 		func->r419f78(gr);
+	if (func->r419ba4)
+		func->r419ba4(gr);
 	if (func->tpc_mask)
 		func->tpc_mask(gr);
 	if (func->smid_config)
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.h b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.h
index 00dbeda7e3464..f31303efbc0ff 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.h
@@ -57,6 +57,7 @@ struct gf100_grctx_func {
 	void (*r406500)(struct gf100_gr *);
 	void (*gpc_tpc_nr)(struct gf100_gr *);
 	void (*r419f78)(struct gf100_gr *);
+	void (*r419ba4)(struct gf100_gr *);
 	void (*tpc_mask)(struct gf100_gr *);
 	void (*smid_config)(struct gf100_gr *);
 	/* misc other things */
@@ -117,6 +118,7 @@ void gk104_grctx_generate_r418800(struct gf100_gr *);
 
 extern const struct gf100_grctx_func gk110_grctx;
 void gk110_grctx_generate_r419eb0(struct gf100_gr *);
+void gk110_grctx_generate_r419f78(struct gf100_gr *);
 
 extern const struct gf100_grctx_func gk110b_grctx;
 extern const struct gf100_grctx_func gk208_grctx;
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk104.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk104.c
index 94233d0119dff..52a234b1ef010 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk104.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk104.c
@@ -906,7 +906,9 @@ static void
 gk104_grctx_generate_r419f78(struct gf100_gr *gr)
 {
 	struct nvkm_device *device = gr->base.engine.subdev.device;
-	nvkm_mask(device, 0x419f78, 0x00000001, 0x00000000);
+
+	/* bit 3 set disables loads in fp helper invocations, we need it enabled */
+	nvkm_mask(device, 0x419f78, 0x00000009, 0x00000000);
 }
 
 void
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110.c
index 4391458e1fb2f..3acdd9eeb74a7 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110.c
@@ -820,6 +820,15 @@ gk110_grctx_generate_r419eb0(struct gf100_gr *gr)
 	nvkm_mask(device, 0x419eb0, 0x00001000, 0x00001000);
 }
 
+void
+gk110_grctx_generate_r419f78(struct gf100_gr *gr)
+{
+	struct nvkm_device *device = gr->base.engine.subdev.device;
+
+	/* bit 3 set disables loads in fp helper invocations, we need it enabled */
+	nvkm_mask(device, 0x419f78, 0x00000008, 0x00000000);
+}
+
 const struct gf100_grctx_func
 gk110_grctx = {
 	.main  = gf100_grctx_generate_main,
@@ -854,4 +863,5 @@ gk110_grctx = {
 	.gpc_tpc_nr = gk104_grctx_generate_gpc_tpc_nr,
 	.r418800 = gk104_grctx_generate_r418800,
 	.r419eb0 = gk110_grctx_generate_r419eb0,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110b.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110b.c
index 7b9a34f9ec3c7..5597e87624acd 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110b.c
@@ -103,4 +103,5 @@ gk110b_grctx = {
 	.gpc_tpc_nr = gk104_grctx_generate_gpc_tpc_nr,
 	.r418800 = gk104_grctx_generate_r418800,
 	.r419eb0 = gk110_grctx_generate_r419eb0,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk208.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk208.c
index c78d07a8bb7df..612656496541d 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk208.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk208.c
@@ -568,4 +568,5 @@ gk208_grctx = {
 	.dist_skip_table = gf117_grctx_generate_dist_skip_table,
 	.gpc_tpc_nr = gk104_grctx_generate_gpc_tpc_nr,
 	.r418800 = gk104_grctx_generate_r418800,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm107.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm107.c
index beac66eb2a803..9906974ac3f07 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm107.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm107.c
@@ -988,4 +988,5 @@ gm107_grctx = {
 	.r406500 = gm107_grctx_generate_r406500,
 	.gpc_tpc_nr = gk104_grctx_generate_gpc_tpc_nr,
 	.r419e00 = gm107_grctx_generate_r419e00,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm200.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm200.c
index 175da8ac656ce..839b706a86e86 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm200.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm200.c
@@ -127,4 +127,5 @@ gm200_grctx = {
 	.smid_config = gm200_grctx_generate_smid_config,
 	.r418e94 = gm200_grctx_generate_r418e94,
 	.r419a3c = gm200_grctx_generate_r419a3c,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp100.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp100.c
index 8485aaeae7a92..068d36490d14c 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp100.c
@@ -148,4 +148,5 @@ gp100_grctx = {
 	.tpc_mask = gm200_grctx_generate_tpc_mask,
 	.smid_config = gp100_grctx_generate_smid_config,
 	.r419a3c = gm200_grctx_generate_r419a3c,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp102.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp102.c
index 7537979a54927..18a5b3ca7d8c5 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp102.c
@@ -122,4 +122,5 @@ gp102_grctx = {
 	.smid_config = gp100_grctx_generate_smid_config,
 	.r419a3c = gm200_grctx_generate_r419a3c,
 	.r408840 = gp102_grctx_generate_r408840,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp104.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp104.c
index 90b5f793e5676..5366f5b5ce80a 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp104.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp104.c
@@ -47,4 +47,5 @@ gp104_grctx = {
 	.tpc_mask = gm200_grctx_generate_tpc_mask,
 	.smid_config = gp100_grctx_generate_smid_config,
 	.r419a3c = gm200_grctx_generate_r419a3c,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp107.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp107.c
index d191761a04711..d658ff1ce7bbc 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp107.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgp107.c
@@ -55,4 +55,5 @@ gp107_grctx = {
 	.tpc_mask = gm200_grctx_generate_tpc_mask,
 	.smid_config = gp100_grctx_generate_smid_config,
 	.r419a3c = gm200_grctx_generate_r419a3c,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgv100.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgv100.c
index 957ea9d6bad4b..dadc0ecd1722d 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgv100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgv100.c
@@ -192,6 +192,15 @@ gv100_grctx_unkn88c(struct gf100_gr *gr, bool on)
 	nvkm_rd32(device, 0x408a14);
 }
 
+static void
+gv100_grctx_generate_r419ba4(struct gf100_gr *gr)
+{
+	struct nvkm_device *device = gr->base.engine.subdev.device;
+
+	/* bit 3 set disables loads in fp helper invocations, we need it enabled */
+	nvkm_mask(device, 0x419ba4, 0x00000008, 0x00000000);
+}
+
 const struct gf100_grctx_func
 gv100_grctx = {
 	.unkn88c = gv100_grctx_unkn88c,
@@ -219,4 +228,5 @@ gv100_grctx = {
 	.gpc_tpc_nr = gk104_grctx_generate_gpc_tpc_nr,
 	.smid_config = gp100_grctx_generate_smid_config,
 	.r400088 = gv100_grctx_generate_r400088,
+	.r419ba4 = gv100_grctx_generate_r419ba4,
 };
-- 
2.39.2

