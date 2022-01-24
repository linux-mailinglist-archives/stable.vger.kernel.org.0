Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0655E499F96
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841651AbiAXW7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588258AbiAXWbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:31:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF19C095430;
        Mon, 24 Jan 2022 12:57:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89761612C8;
        Mon, 24 Jan 2022 20:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C986C340E8;
        Mon, 24 Jan 2022 20:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057847;
        bh=TN6v4/4sN1+XYeIpKg4vF/SxBkB5QkaJ3j9sK91D2XA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3d3ETxxwe94ITcip4+QmAbib9egIyrr7khkDSECqvwyDZ5EnQSz0JPq10Dh+jylE
         /xWWBcL5qxL8vomttAgAU7VkR1z5oudm0C+LLpaOWPxUQnRal16pUps8BK/YrxvwsW
         dbw3z7rBP71eunQKX+ndJAYpfesjROQZBoY7JSv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0099/1039] drm/vc4: hdmi: Make sure the controller is powered up during bind
Date:   Mon, 24 Jan 2022 19:31:28 +0100
Message-Id: <20220124184128.482138775@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 9c6e4f6ed1d61d5f46946e5c151ceb279eedadb1 ]

In the bind hook, we actually need the device to have the HSM clock
running during the final part of the display initialisation where we
reset the controller and initialise the CEC component.

Failing to do so will result in a complete, silent, hang of the CPU.

Fixes: 411efa18e4b0 ("drm/vc4: hdmi: Move the HSM clock enable to runtime_pm")
Link: https://patchwork.freedesktop.org/patch/msgid/20210819135931.895976-3-maxime@cerno.tech
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index f7e48bc6cb114..29ee9264b0870 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2191,6 +2191,18 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 	if (ret)
 		goto err_put_ddc;
 
+	/*
+	 * We need to have the device powered up at this point to call
+	 * our reset hook and for the CEC init.
+	 */
+	ret = vc4_hdmi_runtime_resume(dev);
+	if (ret)
+		goto err_put_ddc;
+
+	pm_runtime_get_noresume(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	if (vc4_hdmi->variant->reset)
 		vc4_hdmi->variant->reset(vc4_hdmi);
 
@@ -2202,8 +2214,6 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 		clk_prepare_enable(vc4_hdmi->pixel_bvb_clock);
 	}
 
-	pm_runtime_enable(dev);
-
 	drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_TMDS);
 	drm_encoder_helper_add(encoder, &vc4_hdmi_encoder_helper_funcs);
 
@@ -2227,6 +2237,8 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 			     vc4_hdmi_debugfs_regs,
 			     vc4_hdmi);
 
+	pm_runtime_put_sync(dev);
+
 	return 0;
 
 err_free_cec:
@@ -2237,6 +2249,7 @@ err_destroy_conn:
 	vc4_hdmi_connector_destroy(&vc4_hdmi->connector);
 err_destroy_encoder:
 	drm_encoder_cleanup(encoder);
+	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 err_put_ddc:
 	put_device(&vc4_hdmi->ddc->dev);
-- 
2.34.1



