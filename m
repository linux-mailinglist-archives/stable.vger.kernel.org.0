Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF3A3CA931
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239616AbhGOTFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243681AbhGOTEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B276161404;
        Thu, 15 Jul 2021 19:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375631;
        bh=AykE/DNX1ohxHWrctLld96qWYnNgwrQLNEkWEleFwec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDADvKUlvuDW/1gREkyEoPWIQ/1OLbqur+YVxKypVaZiE9i4S8xdyd8qkML8eRWi5
         jp5yBe2a+Bu2i27HHfq83xmoFHATa2fneEgpYfb6jC1EznvXrq1lgtpRHKDP2ysQ3c
         qJKpA/WjcLFoevcmD/AJYKrij23c0qdtZTAfs9kY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>
Subject: [PATCH 5.12 170/242] drm/vc4: hdmi: Prevent clock unbalance
Date:   Thu, 15 Jul 2021 20:38:52 +0200
Message-Id: <20210715182623.159968385@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit 5b006000423667ef0f55721fc93e477b31f22d28 upstream.

Since we fixed the hooks to disable the encoder at boot, we now have an
unbalanced clk_disable call at boot since we never enabled them in the
first place.

Let's mimic the state of the hardware and enable the clocks at boot if
the controller is enabled to get the use-count right.

Cc: <stable@vger.kernel.org> # v5.10+
Fixes: 09c438139b8f ("drm/vc4: hdmi: Implement finer-grained hooks")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210507150515.257424-7-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vc4/vc4_hdmi.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2012,6 +2012,14 @@ static int vc4_hdmi_bind(struct device *
 	if (vc4_hdmi->variant->reset)
 		vc4_hdmi->variant->reset(vc4_hdmi);
 
+	if ((of_device_is_compatible(dev->of_node, "brcm,bcm2711-hdmi0") ||
+	     of_device_is_compatible(dev->of_node, "brcm,bcm2711-hdmi1")) &&
+	    HDMI_READ(HDMI_VID_CTL) & VC4_HD_VID_CTL_ENABLE) {
+		clk_prepare_enable(vc4_hdmi->pixel_clock);
+		clk_prepare_enable(vc4_hdmi->hsm_clock);
+		clk_prepare_enable(vc4_hdmi->pixel_bvb_clock);
+	}
+
 	pm_runtime_enable(dev);
 
 	drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_TMDS);


