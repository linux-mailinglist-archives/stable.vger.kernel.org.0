Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6B14998F5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453805AbiAXVa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450631AbiAXVVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14356C028C25;
        Mon, 24 Jan 2022 12:14:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD1BAB8124F;
        Mon, 24 Jan 2022 20:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FFEC340E5;
        Mon, 24 Jan 2022 20:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055261;
        bh=6yOJ5HGX4s/hvqyokoZbRAiRTadbNajAI/pYKePkIRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XL+3YYzgF8i1dHRq/EdKF3OHDobkB1glVt4Q/F6GoKG4YZ4EHI1n2vhWI0Y46MkPK
         zQGSjDCo1ygGzS8JYzvgqmlhYdr9t9yAfPIA7XqeAOH17GwLMRRedakfT/gxMhsOOR
         TYljONwQHQK2HWezC3TAekdnvkbDk2EzKiaDFWsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/846] drm/vc4: crtc: Make sure the HDMI controller is powered when disabling
Date:   Mon, 24 Jan 2022 19:33:31 +0100
Message-Id: <20220124184104.232099114@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit bca10db67bdaf15997a5a2a276e7aa9b6eea1393 ]

Since commit 875a4d536842 ("drm/vc4: drv: Disable the CRTC at boot
time"), during the initial setup of the driver we call into the VC4 HDMI
controller hooks to make sure the controller is properly disabled.

However, we were never making sure that the device was properly powered
while doing so. This never resulted in any (reported) issue in practice,
but since the introduction of commit 4209f03fcb8e ("drm/vc4: hdmi: Warn
if we access the controller while disabled") we get a loud complaint
when we do that kind of access.

Let's make sure we have the HDMI controller properly powered while
disabling it.

Fixes: 875a4d536842 ("drm/vc4: drv: Disable the CRTC at boot time")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Tested-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210923185013.826679-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index 18f5009ce90e3..c0df11e5fcf2b 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -32,6 +32,7 @@
 #include <linux/clk.h>
 #include <linux/component.h>
 #include <linux/of_device.h>
+#include <linux/pm_runtime.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
@@ -42,6 +43,7 @@
 #include <drm/drm_vblank.h>
 
 #include "vc4_drv.h"
+#include "vc4_hdmi.h"
 #include "vc4_regs.h"
 
 #define HVS_FIFO_LATENCY_PIX	6
@@ -496,8 +498,10 @@ int vc4_crtc_disable_at_boot(struct drm_crtc *crtc)
 	enum vc4_encoder_type encoder_type;
 	const struct vc4_pv_data *pv_data;
 	struct drm_encoder *encoder;
+	struct vc4_hdmi *vc4_hdmi;
 	unsigned encoder_sel;
 	int channel;
+	int ret;
 
 	if (!(of_device_is_compatible(vc4_crtc->pdev->dev.of_node,
 				      "brcm,bcm2711-pixelvalve2") ||
@@ -525,7 +529,20 @@ int vc4_crtc_disable_at_boot(struct drm_crtc *crtc)
 	if (WARN_ON(!encoder))
 		return 0;
 
-	return vc4_crtc_disable(crtc, encoder, NULL, channel);
+	vc4_hdmi = encoder_to_vc4_hdmi(encoder);
+	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
+	if (ret)
+		return ret;
+
+	ret = vc4_crtc_disable(crtc, encoder, NULL, channel);
+	if (ret)
+		return ret;
+
+	ret = pm_runtime_put(&vc4_hdmi->pdev->dev);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
 static void vc4_crtc_atomic_disable(struct drm_crtc *crtc,
-- 
2.34.1



