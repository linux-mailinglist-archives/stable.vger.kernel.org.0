Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3540541991
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378529AbiFGVWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380798AbiFGVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82BF527D2;
        Tue,  7 Jun 2022 11:57:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BFD76159D;
        Tue,  7 Jun 2022 18:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3849CC385A2;
        Tue,  7 Jun 2022 18:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628248;
        bh=Iv21szQQ0IsjJwXsnfNc9wifZ6YaVnjO+Lc5Z9nTGic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkheCahfwoxuZXc4vxF3HAVyh8H63n31pvgKLIXTojg5YzU2WggWT/y1E75DhSYf1
         kl9dwuKGICI+H8gFq/LtMeVsQexksdnuT1NMMhcWz0yVjCFaprAIaZ3oiRSyWY1N3+
         24rMjErX8VaWS8BOtiVSLa6fswAR2m26Ot6J2PyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 260/879] drm: ssd130x: Always apply segment remap setting
Date:   Tue,  7 Jun 2022 18:56:18 +0200
Message-Id: <20220607165010.397560644@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit a134109c301736ea2ac5054ba3c29c30c87f6ba7 ]

Currently the ssd130x driver only sets the segment remap setting when
the device tree requests it; it however does not clear the setting if
it is not requested. This leads to the setting incorrectly persisting
if the hardware is always on and has no reset GPIO wired. This might
happen when a developer is trying to find the correct settings for an
unknown module, and cause the developer to get confused because the
settings from the device tree are not consistently applied.

Make the driver apply the segment remap setting consistently, setting
the value correctly based on the device tree setting. This also makes
this setting's behavior consistent with the other settings, which are
always applied.

Fixes: a61732e80867 ("drm: Add driver for Solomon SSD130x OLED displays")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220308160758.26060-2-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index ccd378135589..d08d86ef07bc 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -48,7 +48,7 @@
 #define SSD130X_CONTRAST			0x81
 #define SSD130X_SET_LOOKUP_TABLE		0x91
 #define SSD130X_CHARGE_PUMP			0x8d
-#define SSD130X_SEG_REMAP_ON			0xa1
+#define SSD130X_SET_SEG_REMAP			0xa0
 #define SSD130X_DISPLAY_OFF			0xae
 #define SSD130X_SET_MULTIPLEX_RATIO		0xa8
 #define SSD130X_DISPLAY_ON			0xaf
@@ -61,6 +61,8 @@
 #define SSD130X_SET_COM_PINS_CONFIG		0xda
 #define SSD130X_SET_VCOMH			0xdb
 
+#define SSD130X_SET_SEG_REMAP_MASK		GENMASK(0, 0)
+#define SSD130X_SET_SEG_REMAP_SET(val)		FIELD_PREP(SSD130X_SET_SEG_REMAP_MASK, (val))
 #define SSD130X_SET_COM_SCAN_DIR_MASK		GENMASK(3, 3)
 #define SSD130X_SET_COM_SCAN_DIR_SET(val)	FIELD_PREP(SSD130X_SET_COM_SCAN_DIR_MASK, (val))
 #define SSD130X_SET_CLOCK_DIV_MASK		GENMASK(3, 0)
@@ -235,7 +237,7 @@ static void ssd130x_power_off(struct ssd130x_device *ssd130x)
 
 static int ssd130x_init(struct ssd130x_device *ssd130x)
 {
-	u32 precharge, dclk, com_invdir, compins, chargepump;
+	u32 precharge, dclk, com_invdir, compins, chargepump, seg_remap;
 	int ret;
 
 	/* Set initial contrast */
@@ -244,11 +246,11 @@ static int ssd130x_init(struct ssd130x_device *ssd130x)
 		return ret;
 
 	/* Set segment re-map */
-	if (ssd130x->seg_remap) {
-		ret = ssd130x_write_cmd(ssd130x, 1, SSD130X_SEG_REMAP_ON);
-		if (ret < 0)
-			return ret;
-	}
+	seg_remap = (SSD130X_SET_SEG_REMAP |
+		     SSD130X_SET_SEG_REMAP_SET(ssd130x->seg_remap));
+	ret = ssd130x_write_cmd(ssd130x, 1, seg_remap);
+	if (ret < 0)
+		return ret;
 
 	/* Set COM direction */
 	com_invdir = (SSD130X_SET_COM_SCAN_DIR |
-- 
2.35.1



