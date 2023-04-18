Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E2C6E6489
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjDRMuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjDRMuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:50:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479D4167FE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6D7663403
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90F8C4339B;
        Tue, 18 Apr 2023 12:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822201;
        bh=ttPfqKU8tBpqAGFsxkqzheDJ2xQwkaS3xpjM45mBpO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNWnd60cPbNoIc4dx0XUXF6yRchECP7ftx5YhsQ6MdbIp1OgOQeo34+vrYOMoDpGP
         vg0vIMchfGm3JHHP75mkQTe8J6Pd1x/JTAxUIK1k/5VXq0/IWvkA0s2wLe38BfSw6X
         GTOeKt2AUera2Ds4o1dWCqbPRT1v5Ug59tNZ30K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 060/139] drm/nouveau/fb: add missing sysmen flush callbacks
Date:   Tue, 18 Apr 2023 14:22:05 +0200
Message-Id: <20230418120316.030405443@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

[ Upstream commit 86d8740dae5a397d8344ae75f8758103c1fcba97 ]

Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/203
Fixes: 5728d064190e1 ("drm/nouveau/fb: handle sysmem flush page from common code")
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230405110455.1368428-1-kherbst@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gf108.c | 1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk104.c | 1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk110.c | 1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gm107.c | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gf108.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gf108.c
index 76678dd60f93f..c4c6f67af7ccc 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gf108.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gf108.c
@@ -31,6 +31,7 @@ gf108_fb = {
 	.init = gf100_fb_init,
 	.init_page = gf100_fb_init_page,
 	.intr = gf100_fb_intr,
+	.sysmem.flush_page_init = gf100_fb_sysmem_flush_page_init,
 	.ram_new = gf108_ram_new,
 	.default_bigpage = 17,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk104.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk104.c
index f73442ccb424b..433fa966ba231 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk104.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk104.c
@@ -77,6 +77,7 @@ gk104_fb = {
 	.init = gf100_fb_init,
 	.init_page = gf100_fb_init_page,
 	.intr = gf100_fb_intr,
+	.sysmem.flush_page_init = gf100_fb_sysmem_flush_page_init,
 	.ram_new = gk104_ram_new,
 	.default_bigpage = 17,
 	.clkgate_pack = gk104_fb_clkgate_pack,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk110.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk110.c
index 45d6cdffafeed..4dc283dedf8b5 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk110.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk110.c
@@ -59,6 +59,7 @@ gk110_fb = {
 	.init = gf100_fb_init,
 	.init_page = gf100_fb_init_page,
 	.intr = gf100_fb_intr,
+	.sysmem.flush_page_init = gf100_fb_sysmem_flush_page_init,
 	.ram_new = gk104_ram_new,
 	.default_bigpage = 17,
 	.clkgate_pack = gk110_fb_clkgate_pack,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gm107.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gm107.c
index de52462a92bf0..90bfff616d35b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gm107.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/gm107.c
@@ -31,6 +31,7 @@ gm107_fb = {
 	.init = gf100_fb_init,
 	.init_page = gf100_fb_init_page,
 	.intr = gf100_fb_intr,
+	.sysmem.flush_page_init = gf100_fb_sysmem_flush_page_init,
 	.ram_new = gm107_ram_new,
 	.default_bigpage = 17,
 };
-- 
2.39.2



