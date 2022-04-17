Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAD150484A
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 18:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbiDQQSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 12:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiDQQSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 12:18:46 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C181EC4C;
        Sun, 17 Apr 2022 09:16:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 107)
        id 91FD668D0A; Sun, 17 Apr 2022 18:16:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
Received: from blackhole (p5b0d8d05.dip0.t-ipconnect.de [91.13.141.5])
        by verein.lst.de (Postfix) with ESMTPSA id 6412A67373;
        Sun, 17 Apr 2022 18:15:43 +0200 (CEST)
Date:   Sun, 17 Apr 2022 18:15:38 +0200
From:   Torsten Duwe <duwe@lst.de>
To:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Thierry Reding <treding@nvidia.com>,
        Lyude Paul <lyude@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Harald Geyer <harald@ccbib.org>,
        stable@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH] drm/bridge: fix anx6345 power up sequence
Message-ID: <20220417181538.57fa1303@blackhole>
Organization: LST e.V.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Align the power-up sequence with the known-good procedure documented in [1]:
un-swap dvdd12 and dvdd25, and allow a little extra time for them to settle
before de-asserting reset.
Fixes: 6aa192698089b ("drm/bridge: Add Analogix anx6345 support")

[1] https://github.com/OLIMEX/DIY-LAPTOP/blob/master/
HARDWARE/A64-TERES/TERES-PCB1-A64-MAIN/Rev.C/TERES_PCB1-A64-MAIN_Rev.C.pdf
(page 5, blue comment down left)

Reported-by: Harald Geyer <harald@ccbib.org>
Signed-off-by: Torsten Duwe <duwe@lst.de>
Cc: stable@vger.kernel.org

---

This fixes the problem that e.g. X screensaver turns the screen black,
and it stays black until the next reboot; definitely on the Teres-I,
probably on the pinebook64, too.

--- a/drivers/gpu/drm/bridge/analogix/analogix-anx6345.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix-anx6345.c
@@ -309,27 +309,27 @@ static void anx6345_poweron(struct anx63
 	gpiod_set_value_cansleep(anx6345->gpiod_reset, 1);
 	usleep_range(1000, 2000);
 
-	err = regulator_enable(anx6345->dvdd12);
+	err = regulator_enable(anx6345->dvdd25);
 	if (err) {
-		DRM_ERROR("Failed to enable dvdd12 regulator: %d\n",
+		DRM_ERROR("Failed to enable dvdd25 regulator: %d\n",
 			  err);
 		return;
 	}
 
-	/* T1 - delay between VDD12 and VDD25 should be 0-2ms */
+	/* T1 - delay between VDD25 and VDD12 should be 0-2ms */
 	usleep_range(1000, 2000);
 
-	err = regulator_enable(anx6345->dvdd25);
+	err = regulator_enable(anx6345->dvdd12);
 	if (err) {
-		DRM_ERROR("Failed to enable dvdd25 regulator: %d\n",
+		DRM_ERROR("Failed to enable dvdd12 regulator: %d\n",
 			  err);
 		return;
 	}
 
 	/* T2 - delay between RESETN and all power rail stable,
-	 * should be 2-5ms
+	 * should be at least 2-5ms, 10ms to be safe.
 	 */
-	usleep_range(2000, 5000);
+	usleep_range(9000, 11000);
 
 	gpiod_set_value_cansleep(anx6345->gpiod_reset, 0);
 
