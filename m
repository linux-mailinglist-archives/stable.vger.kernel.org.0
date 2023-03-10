Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5386B481B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjCJO6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjCJO6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:58:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154D21D901
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:53:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 213B961A43
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2910EC4339C;
        Fri, 10 Mar 2023 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459916;
        bh=dbaAF4mRPaAouPW4+FIbFgD4p4T3y+eK+GSXxuxaCVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrRrJIiGG6hFOthijxvmaqtCH27mESJwImESeH4Y49Zoaix9+ijvkUhju/ICFWZoA
         v/CbAZhk1h/7gpEvrwTae9BkgdHEciI2dvOSiJKTv1RJeDB0UtyLbF2Cb7ExJDOnOI
         RfwB+wZ2XhDtAC5uruyP9L4RPRoLeqchFrkti1o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/529] drm/vc4: hvs: Set AXI panic modes
Date:   Fri, 10 Mar 2023 14:35:06 +0100
Message-Id: <20230310133812.508969747@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

[ Upstream commit df993fced230daa8452892406f3180c93ebf7e7b ]

The HVS can change AXI request mode based on how full the COB
FIFOs are.
Until now the vc4 driver has been relying on the firmware to
have set these to sensible values.

With HVS channel 2 now being used for live video, change the
panic mode for all channels to be explicitly set by the driver,
and the same for all channels.

Fixes: c54619b0bfb3 ("drm/vc4: Add support for the BCM2711 HVS5")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20221207-rpi-hvs-crtc-misc-v1-2-1f8e0770798b@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c  | 11 +++++++++++
 drivers/gpu/drm/vc4/vc4_regs.h |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 95fa6fc052a72..f8f2fc3d15f73 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -677,6 +677,17 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 		      SCALER_DISPCTRL_DSPEISLUR(2) |
 		      SCALER_DISPCTRL_SCLEIRQ);
 
+	/* Set AXI panic mode.
+	 * VC4 panics when < 2 lines in FIFO.
+	 * VC5 panics when less than 1 line in the FIFO.
+	 */
+	dispctrl &= ~(SCALER_DISPCTRL_PANIC0_MASK |
+		      SCALER_DISPCTRL_PANIC1_MASK |
+		      SCALER_DISPCTRL_PANIC2_MASK);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC0);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC1);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC2);
+
 	HVS_WRITE(SCALER_DISPCTRL, dispctrl);
 
 	ret = devm_request_irq(dev, platform_get_irq(pdev, 0),
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index be2c32a519b31..a324ef88ceafb 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -220,6 +220,12 @@
 #define SCALER_DISPCTRL                         0x00000000
 /* Global register for clock gating the HVS */
 # define SCALER_DISPCTRL_ENABLE			BIT(31)
+# define SCALER_DISPCTRL_PANIC0_MASK		VC4_MASK(25, 24)
+# define SCALER_DISPCTRL_PANIC0_SHIFT		24
+# define SCALER_DISPCTRL_PANIC1_MASK		VC4_MASK(27, 26)
+# define SCALER_DISPCTRL_PANIC1_SHIFT		26
+# define SCALER_DISPCTRL_PANIC2_MASK		VC4_MASK(29, 28)
+# define SCALER_DISPCTRL_PANIC2_SHIFT		28
 # define SCALER_DISPCTRL_DSP3_MUX_MASK		VC4_MASK(19, 18)
 # define SCALER_DISPCTRL_DSP3_MUX_SHIFT		18
 
-- 
2.39.2



