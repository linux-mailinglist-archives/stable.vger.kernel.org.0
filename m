Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1043328D27
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240986AbhCATGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240801AbhCATBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6681B64F46;
        Mon,  1 Mar 2021 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618916;
        bh=j1Q1T63eINs/3s64OsPlzq+a4ciRHKucyGez2lTkyp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyyaw9I1tqkTV3qcZPQQDhcheoT+KNN4+5HI/FfS8L1BMVwpMDkA/tOeeQzSFXwMD
         DqldwlrLiOST2oP29BvNS2qbh88zYj9bVlchHbLgB0OTXpVEJAVGdTX+FYOnhjZw47
         iKp0rWRrb93/3jNEHyAsxHTtuWMNSjYKyXDHX3fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/663] drm/vc4: hdmi: Update the CEC clock divider on HSM rate change
Date:   Mon,  1 Mar 2021 17:08:02 +0100
Message-Id: <20210301161153.389730750@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 47fa9a80270e20a0c4ddaffca1f144d22cc59620 ]

As part of the enable sequence we might change the HSM clock rate if the
pixel rate is different than the one we were already dealing with.

On the BCM2835 however, the CEC clock derives from the HSM clock so any
rate change will need to be reflected in the CEC clock divider to output
40kHz.

Fixes: cd4cb49dc5bb ("drm/vc4: hdmi: Adjust HSM clock rate depending on pixel rate")
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111142309.193441-8-maxime@cerno.tech
(cherry picked from commit a9dd0b9a5c3e11c79e6ff9c7fdf07c471732dcb6)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 39 +++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 08b3f9c87e6ec..af5f01eff872c 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -119,6 +119,27 @@ static void vc5_hdmi_reset(struct vc4_hdmi *vc4_hdmi)
 		   HDMI_READ(HDMI_CLOCK_STOP) | VC4_DVP_HT_CLOCK_STOP_PIXEL);
 }
 
+#ifdef CONFIG_DRM_VC4_HDMI_CEC
+static void vc4_hdmi_cec_update_clk_div(struct vc4_hdmi *vc4_hdmi)
+{
+	u16 clk_cnt;
+	u32 value;
+
+	value = HDMI_READ(HDMI_CEC_CNTRL_1);
+	value &= ~VC4_HDMI_CEC_DIV_CLK_CNT_MASK;
+
+	/*
+	 * Set the clock divider: the hsm_clock rate and this divider
+	 * setting will give a 40 kHz CEC clock.
+	 */
+	clk_cnt = clk_get_rate(vc4_hdmi->hsm_clock) / CEC_CLOCK_FREQ;
+	value |= clk_cnt << VC4_HDMI_CEC_DIV_CLK_CNT_SHIFT;
+	HDMI_WRITE(HDMI_CEC_CNTRL_1, value);
+}
+#else
+static void vc4_hdmi_cec_update_clk_div(struct vc4_hdmi *vc4_hdmi) {}
+#endif
+
 static enum drm_connector_status
 vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 {
@@ -652,6 +673,8 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder)
 		return;
 	}
 
+	vc4_hdmi_cec_update_clk_div(vc4_hdmi);
+
 	/*
 	 * FIXME: When the pixel freq is 594MHz (4k60), this needs to be setup
 	 * at 300MHz.
@@ -1468,7 +1491,6 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 {
 	struct cec_connector_info conn_info;
 	struct platform_device *pdev = vc4_hdmi->pdev;
-	u16 clk_cnt;
 	u32 value;
 	int ret;
 
@@ -1487,17 +1509,14 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 	cec_s_conn_info(vc4_hdmi->cec_adap, &conn_info);
 
 	HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, 0xffffffff);
+
 	value = HDMI_READ(HDMI_CEC_CNTRL_1);
-	value &= ~VC4_HDMI_CEC_DIV_CLK_CNT_MASK;
-	/*
-	 * Set the logical address to Unregistered and set the clock
-	 * divider: the hsm_clock rate and this divider setting will
-	 * give a 40 kHz CEC clock.
-	 */
-	clk_cnt = clk_get_rate(vc4_hdmi->hsm_clock) / CEC_CLOCK_FREQ;
-	value |= VC4_HDMI_CEC_ADDR_MASK |
-		 (clk_cnt << VC4_HDMI_CEC_DIV_CLK_CNT_SHIFT);
+	/* Set the logical address to Unregistered */
+	value |= VC4_HDMI_CEC_ADDR_MASK;
 	HDMI_WRITE(HDMI_CEC_CNTRL_1, value);
+
+	vc4_hdmi_cec_update_clk_div(vc4_hdmi);
+
 	ret = devm_request_threaded_irq(&pdev->dev, platform_get_irq(pdev, 0),
 					vc4_cec_irq_handler,
 					vc4_cec_irq_handler_thread, 0,
-- 
2.27.0



