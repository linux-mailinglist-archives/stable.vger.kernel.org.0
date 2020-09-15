Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D126B40A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIOXPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727238AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35EC023D1C;
        Tue, 15 Sep 2020 14:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180187;
        bh=kJTTzebs1uAYr4TkT17ToBGVy6L10UaQOp5OfMXmmYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b61xDlteGp1i9ZN5XHI9uzxkwfqJkyv4nbDukhiRRxY66MNsUmD5Socr7N/O1QNG1
         qxS0iCSzEluag/ZKtH0uzGEV3JqWJt9CFJk5ir3iO1pi48823Wo7yNCvYnriOrDdyp
         YAUP0e3pti8jvtouoy/gV0vJKhihT2legkPfnTnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.8 142/177] drm/tve200: Stabilize enable/disable
Date:   Tue, 15 Sep 2020 16:13:33 +0200
Message-Id: <20200915140700.463157628@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit f71800228dc74711c3df43854ce7089562a3bc2d upstream.

The TVE200 will occasionally print a bunch of lost interrupts
and similar dmesg messages, sometimes during boot and sometimes
after disabling and coming back to enablement. This is probably
because the hardware is left in an unknown state by the boot
loader that displays a logo.

This can be fixed by bringing the controller into a known state
by resetting the controller while enabling it. We retry reset 5
times like the vendor driver does. We also put the controller
into reset before de-clocking it and clear all interrupts before
enabling the vblank IRQ.

This makes the video enable/disable/enable cycle rock solid
on the D-Link DIR-685. Tested extensively.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200820203144.271081-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/tve200/tve200_display.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tve200/tve200_display.c
+++ b/drivers/gpu/drm/tve200/tve200_display.c
@@ -14,6 +14,7 @@
 #include <linux/version.h>
 #include <linux/dma-buf.h>
 #include <linux/of_graph.h>
+#include <linux/delay.h>
 
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fourcc.h>
@@ -130,9 +131,25 @@ static void tve200_display_enable(struct
 	struct drm_connector *connector = priv->connector;
 	u32 format = fb->format->format;
 	u32 ctrl1 = 0;
+	int retries;
 
 	clk_prepare_enable(priv->clk);
 
+	/* Reset the TVE200 and wait for it to come back online */
+	writel(TVE200_CTRL_4_RESET, priv->regs + TVE200_CTRL_4);
+	for (retries = 0; retries < 5; retries++) {
+		usleep_range(30000, 50000);
+		if (readl(priv->regs + TVE200_CTRL_4) & TVE200_CTRL_4_RESET)
+			continue;
+		else
+			break;
+	}
+	if (retries == 5 &&
+	    readl(priv->regs + TVE200_CTRL_4) & TVE200_CTRL_4_RESET) {
+		dev_err(drm->dev, "can't get hardware out of reset\n");
+		return;
+	}
+
 	/* Function 1 */
 	ctrl1 |= TVE200_CTRL_CSMODE;
 	/* Interlace mode for CCIR656: parameterize? */
@@ -230,8 +247,9 @@ static void tve200_display_disable(struc
 
 	drm_crtc_vblank_off(crtc);
 
-	/* Disable and Power Down */
+	/* Disable put into reset and Power Down */
 	writel(0, priv->regs + TVE200_CTRL);
+	writel(TVE200_CTRL_4_RESET, priv->regs + TVE200_CTRL_4);
 
 	clk_disable_unprepare(priv->clk);
 }
@@ -279,6 +297,8 @@ static int tve200_display_enable_vblank(
 	struct drm_device *drm = crtc->dev;
 	struct tve200_drm_dev_private *priv = drm->dev_private;
 
+	/* Clear any IRQs and enable */
+	writel(0xFF, priv->regs + TVE200_INT_CLR);
 	writel(TVE200_INT_V_STATUS, priv->regs + TVE200_INT_EN);
 	return 0;
 }


