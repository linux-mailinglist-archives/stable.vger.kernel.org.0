Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FB44F4481
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350606AbiDEMIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357993AbiDEK1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977365D5D9;
        Tue,  5 Apr 2022 03:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36BB16179E;
        Tue,  5 Apr 2022 10:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429BFC385A1;
        Tue,  5 Apr 2022 10:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153542;
        bh=lYJIZpG9+uCGqrzFy8FRL9lrEPzdl6jxqDZR4PCvxOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDJXt0yCkPvHtNtLUd2MXlnGhdbwQ94xAaizUJjo3y0iMmCMFj+5veNzkVqXpz1lo
         mpyM6ro4g/YhjX0Btfj9SLizs2lXCZqdCJSuQzzp8qc4WM3EsqcHbxoj5sVp3hHFw7
         50MR8N0RjQQVTvZ1RGwV1oNHxOGXrid6kYY5OfiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/599] drm/meson: osd_afbcd: Add an exit callback to struct meson_afbcd_ops
Date:   Tue,  5 Apr 2022 09:29:14 +0200
Message-Id: <20220405070306.575987204@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 04b8a5d9cfd171f65df75f444b5617a372649edd ]

Use this to simplify the driver shutdown. It will also come handy when
fixing the error handling in meson_drv_bind_master().

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Fixes: d1b5e41e13a7e9 ("drm/meson: Add AFBCD module driver")
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211230235515.1627522-2-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c       |  6 ++--
 drivers/gpu/drm/meson/meson_osd_afbcd.c | 41 ++++++++++++++++---------
 drivers/gpu/drm/meson/meson_osd_afbcd.h |  1 +
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 2753067c08e6..728fea509412 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -396,10 +396,8 @@ static void meson_drv_unbind(struct device *dev)
 	drm_irq_uninstall(drm);
 	drm_dev_put(drm);
 
-	if (priv->afbcd.ops) {
-		priv->afbcd.ops->reset(priv);
-		meson_rdma_free(priv);
-	}
+	if (priv->afbcd.ops)
+		priv->afbcd.ops->exit(priv);
 }
 
 static const struct component_master_ops meson_drv_master_ops = {
diff --git a/drivers/gpu/drm/meson/meson_osd_afbcd.c b/drivers/gpu/drm/meson/meson_osd_afbcd.c
index ffc6b584dbf8..0cdbe899402f 100644
--- a/drivers/gpu/drm/meson/meson_osd_afbcd.c
+++ b/drivers/gpu/drm/meson/meson_osd_afbcd.c
@@ -79,11 +79,6 @@ static bool meson_gxm_afbcd_supported_fmt(u64 modifier, uint32_t format)
 	return meson_gxm_afbcd_pixel_fmt(modifier, format) >= 0;
 }
 
-static int meson_gxm_afbcd_init(struct meson_drm *priv)
-{
-	return 0;
-}
-
 static int meson_gxm_afbcd_reset(struct meson_drm *priv)
 {
 	writel_relaxed(VIU_SW_RESET_OSD1_AFBCD,
@@ -93,6 +88,16 @@ static int meson_gxm_afbcd_reset(struct meson_drm *priv)
 	return 0;
 }
 
+static int meson_gxm_afbcd_init(struct meson_drm *priv)
+{
+	return 0;
+}
+
+static void meson_gxm_afbcd_exit(struct meson_drm *priv)
+{
+	meson_gxm_afbcd_reset(priv);
+}
+
 static int meson_gxm_afbcd_enable(struct meson_drm *priv)
 {
 	writel_relaxed(FIELD_PREP(OSD1_AFBCD_ID_FIFO_THRD, 0x40) |
@@ -172,6 +177,7 @@ static int meson_gxm_afbcd_setup(struct meson_drm *priv)
 
 struct meson_afbcd_ops meson_afbcd_gxm_ops = {
 	.init = meson_gxm_afbcd_init,
+	.exit = meson_gxm_afbcd_exit,
 	.reset = meson_gxm_afbcd_reset,
 	.enable = meson_gxm_afbcd_enable,
 	.disable = meson_gxm_afbcd_disable,
@@ -269,6 +275,18 @@ static bool meson_g12a_afbcd_supported_fmt(u64 modifier, uint32_t format)
 	return meson_g12a_afbcd_pixel_fmt(modifier, format) >= 0;
 }
 
+static int meson_g12a_afbcd_reset(struct meson_drm *priv)
+{
+	meson_rdma_reset(priv);
+
+	meson_rdma_writel_sync(priv, VIU_SW_RESET_G12A_AFBC_ARB |
+			       VIU_SW_RESET_G12A_OSD1_AFBCD,
+			       VIU_SW_RESET);
+	meson_rdma_writel_sync(priv, 0, VIU_SW_RESET);
+
+	return 0;
+}
+
 static int meson_g12a_afbcd_init(struct meson_drm *priv)
 {
 	int ret;
@@ -286,16 +304,10 @@ static int meson_g12a_afbcd_init(struct meson_drm *priv)
 	return 0;
 }
 
-static int meson_g12a_afbcd_reset(struct meson_drm *priv)
+static void meson_g12a_afbcd_exit(struct meson_drm *priv)
 {
-	meson_rdma_reset(priv);
-
-	meson_rdma_writel_sync(priv, VIU_SW_RESET_G12A_AFBC_ARB |
-			       VIU_SW_RESET_G12A_OSD1_AFBCD,
-			       VIU_SW_RESET);
-	meson_rdma_writel_sync(priv, 0, VIU_SW_RESET);
-
-	return 0;
+	meson_g12a_afbcd_reset(priv);
+	meson_rdma_free(priv);
 }
 
 static int meson_g12a_afbcd_enable(struct meson_drm *priv)
@@ -380,6 +392,7 @@ static int meson_g12a_afbcd_setup(struct meson_drm *priv)
 
 struct meson_afbcd_ops meson_afbcd_g12a_ops = {
 	.init = meson_g12a_afbcd_init,
+	.exit = meson_g12a_afbcd_exit,
 	.reset = meson_g12a_afbcd_reset,
 	.enable = meson_g12a_afbcd_enable,
 	.disable = meson_g12a_afbcd_disable,
diff --git a/drivers/gpu/drm/meson/meson_osd_afbcd.h b/drivers/gpu/drm/meson/meson_osd_afbcd.h
index 5e5523304f42..e77ddeb6416f 100644
--- a/drivers/gpu/drm/meson/meson_osd_afbcd.h
+++ b/drivers/gpu/drm/meson/meson_osd_afbcd.h
@@ -14,6 +14,7 @@
 
 struct meson_afbcd_ops {
 	int (*init)(struct meson_drm *priv);
+	void (*exit)(struct meson_drm *priv);
 	int (*reset)(struct meson_drm *priv);
 	int (*enable)(struct meson_drm *priv);
 	int (*disable)(struct meson_drm *priv);
-- 
2.34.1



