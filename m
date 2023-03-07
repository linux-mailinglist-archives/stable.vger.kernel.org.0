Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B686AEF12
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjCGSUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjCGST2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:19:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314A69E06B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:13:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7B1CB819CA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB5AC4339C;
        Tue,  7 Mar 2023 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212832;
        bh=impEQMByE7j8QlvqSycPv+iKvi0jJq014W5AOlVwQFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdcAQZ6+RygTeOpNx2BCD5UPVjY6fwUK341x2/hvinITUx6JT9aKjwANPNDAT30Q6
         OAroD/bBk3zwZ45CBqYKymXROPKAHzOrllP2soholV1hKDKkmpEnPLOwQu2nKJ1nHV
         q6JZcknaZ0mzScs2MS4ySrb6+z5jSIkhoaSArgb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 282/885] drm/vc4: hvs: SCALER_DISPBKGND_AUTOHS is only valid on HVS4
Date:   Tue,  7 Mar 2023 17:53:36 +0100
Message-Id: <20230307170014.263801093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 982ee94486863a41c6af9f2ab3f6681f72bc5c48 ]

The bit used for SCALER_DISPBKGND_AUTOHS in SCALER_DISPBKGNDX
has been repurposed on HVS5 to configure whether a display can
win back-to-back arbitration wins for the COB.

This is not desirable, therefore only select this bit on HVS4,
and explicitly clear it on HVS5.

Fixes: c54619b0bfb3 ("drm/vc4: Add support for the BCM2711 HVS5")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20221207-rpi-hvs-crtc-misc-v1-3-1f8e0770798b@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c  | 10 ++++++----
 drivers/gpu/drm/vc4/vc4_regs.h |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index ee55520c2f11d..413ebb6f56a23 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -368,28 +368,30 @@ static int vc4_hvs_init_channel(struct vc4_hvs *hvs, struct drm_crtc *crtc,
 	 * mode.
 	 */
 	dispctrl = SCALER_DISPCTRLX_ENABLE;
+	dispbkgndx = HVS_READ(SCALER_DISPBKGNDX(chan));
 
-	if (!vc4->is_vc5)
+	if (!vc4->is_vc5) {
 		dispctrl |= VC4_SET_FIELD(mode->hdisplay,
 					  SCALER_DISPCTRLX_WIDTH) |
 			    VC4_SET_FIELD(mode->vdisplay,
 					  SCALER_DISPCTRLX_HEIGHT) |
 			    (oneshot ? SCALER_DISPCTRLX_ONESHOT : 0);
-	else
+		dispbkgndx |= SCALER_DISPBKGND_AUTOHS;
+	} else {
 		dispctrl |= VC4_SET_FIELD(mode->hdisplay,
 					  SCALER5_DISPCTRLX_WIDTH) |
 			    VC4_SET_FIELD(mode->vdisplay,
 					  SCALER5_DISPCTRLX_HEIGHT) |
 			    (oneshot ? SCALER5_DISPCTRLX_ONESHOT : 0);
+		dispbkgndx &= ~SCALER5_DISPBKGND_BCK2BCK;
+	}
 
 	HVS_WRITE(SCALER_DISPCTRLX(chan), dispctrl);
 
-	dispbkgndx = HVS_READ(SCALER_DISPBKGNDX(chan));
 	dispbkgndx &= ~SCALER_DISPBKGND_GAMMA;
 	dispbkgndx &= ~SCALER_DISPBKGND_INTERLACE;
 
 	HVS_WRITE(SCALER_DISPBKGNDX(chan), dispbkgndx |
-		  SCALER_DISPBKGND_AUTOHS |
 		  ((!vc4->is_vc5) ? SCALER_DISPBKGND_GAMMA : 0) |
 		  (interlace ? SCALER_DISPBKGND_INTERLACE : 0));
 
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index f121905c404d1..95deacdc31e77 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -366,6 +366,7 @@
 
 #define SCALER_DISPBKGND0                       0x00000044
 # define SCALER_DISPBKGND_AUTOHS		BIT(31)
+# define SCALER5_DISPBKGND_BCK2BCK		BIT(31)
 # define SCALER_DISPBKGND_INTERLACE		BIT(30)
 # define SCALER_DISPBKGND_GAMMA			BIT(29)
 # define SCALER_DISPBKGND_TESTMODE_MASK		VC4_MASK(28, 25)
-- 
2.39.2



