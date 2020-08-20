Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AEC24C6C7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgHTUc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728387AbgHTUc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:32:27 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CB0C061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 13:32:26 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h19so3535817ljg.13
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 13:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B+5a4asgciydQamginfFinQ+btRZ3Gtdmbm4xtiLW3k=;
        b=iH+WC0dpspVp4Kujk/eflrBrTJcLLuI+Fplk7cxI7tkrBRdZ3hrsQlPv0OQFZ42TO8
         b9Tr3UawzJrM0BxazjSu8IDRzkBYvwO93OLSrxcOItslUnjPTHZXPOq7nYAnkS/ru0kH
         Fq9X+kvbHWIzm3gCz1FnzTpv0lEqOz28rz3JWqL9rKSdHLwS1AyIToOFsBcKPqDNqLMl
         jTxTC5unRSNGzrljfauGPLEUKW7lwVY2TFR3evbv9BIvjw6OgjlM5YVJfsJs6x1tubPO
         NDrE3YmsAk1ChtcKnlMY+5ExvWQMuJA/04gjJ8StOr0tx7znVX0nMza97Fd2xYMTdUsY
         Er7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B+5a4asgciydQamginfFinQ+btRZ3Gtdmbm4xtiLW3k=;
        b=qCLrQeBcXr5WleJmKmLHM394+tREvuVST1cvIAWS2err4bXgkgQOaAIdNgFO46j54i
         d1r/+RnvxT0PhDbqAkwf8+8UkCSDBFrTISgKxpnit2gBvEhQHvARtN2yS0PIfrKExvD7
         YzoJnX90n6lieigMAVH1tTqQSQvCbnbAPy5gynTue2P27QlFe83e8ERQ2E9hZkSfVME6
         DAPT+QVOiU/NI1ngf+GW5HGfCkGcEhfTzodrUVWxO2hndvx5bF/qs0Gw4bEYYYRuHXxN
         eo5I59GLMAulcei84slWQ567n4cVvH7/aKWZ9hZoauY98O5uAxgCJkEO+w55Aace+Lut
         Hf/A==
X-Gm-Message-State: AOAM532M8HU90DfNmW2JPkcS+C3oPOB5bJBaiMrOO0/wXjyhdq2EZ2NV
        IbyNXUseAH7Authmg9d/AAvKvQ==
X-Google-Smtp-Source: ABdhPJy2YjlpMxO7ibMb5AcpXuRxoYaYQ284dZC9M+05E1nyqoxVgj7TWg/zBhq4qzgfl+LZ71Ecww==
X-Received: by 2002:a2e:b546:: with SMTP id a6mr32533ljn.284.1597955544965;
        Thu, 20 Aug 2020 13:32:24 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id x205sm705261lfa.96.2020.08.20.13.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 13:32:24 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     dri-devel@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>, Sean Paul <sean@poorly.run>
Cc:     linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] drm/tve200: Stabilize enable/disable
Date:   Thu, 20 Aug 2020 22:31:44 +0200
Message-Id: <20200820203144.271081-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpu/drm/tve200/tve200_display.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tve200/tve200_display.c b/drivers/gpu/drm/tve200/tve200_display.c
index d733bbc4ac0e..17ff24d999d1 100644
--- a/drivers/gpu/drm/tve200/tve200_display.c
+++ b/drivers/gpu/drm/tve200/tve200_display.c
@@ -14,6 +14,7 @@
 #include <linux/version.h>
 #include <linux/dma-buf.h>
 #include <linux/of_graph.h>
+#include <linux/delay.h>
 
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fourcc.h>
@@ -130,9 +131,25 @@ static void tve200_display_enable(struct drm_simple_display_pipe *pipe,
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
@@ -230,8 +247,9 @@ static void tve200_display_disable(struct drm_simple_display_pipe *pipe)
 
 	drm_crtc_vblank_off(crtc);
 
-	/* Disable and Power Down */
+	/* Disable put into reset and Power Down */
 	writel(0, priv->regs + TVE200_CTRL);
+	writel(TVE200_CTRL_4_RESET, priv->regs + TVE200_CTRL_4);
 
 	clk_disable_unprepare(priv->clk);
 }
@@ -279,6 +297,8 @@ static int tve200_display_enable_vblank(struct drm_simple_display_pipe *pipe)
 	struct drm_device *drm = crtc->dev;
 	struct tve200_drm_dev_private *priv = drm->dev_private;
 
+	/* Clear any IRQs and enable */
+	writel(0xFF, priv->regs + TVE200_INT_CLR);
 	writel(TVE200_INT_V_STATUS, priv->regs + TVE200_INT_EN);
 	return 0;
 }
-- 
2.26.2

