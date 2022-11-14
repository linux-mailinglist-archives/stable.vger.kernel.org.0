Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB84F627FCD
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbiKNNCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237762AbiKNNBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE9229344
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAC1FB80EC3
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C25BC433D6;
        Mon, 14 Nov 2022 13:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430903;
        bh=S1qIVyasZyfql/mxOWnsXPLZXhXK7opXr/AFLx/qXFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTY+Z7VRI9TUL86EXDg94khseZRbVsQSeSP7bctLmRCHepkfbDbLDDUG3yEHS3TTs
         DYFVIm5sesddyBVsyCUC6OhQUQ5T+y63ewGVKS8a8pWDTeLcxSdxKUef6Dq2URsmLj
         TqWkJAnIVLiLKg22YTfLZaLt1HLevH5iSQvZcfBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Robinson <pbrobinson@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 029/190] drm/vc4: hdmi: Fix HSM clock too low on Pi4
Date:   Mon, 14 Nov 2022 13:44:13 +0100
Message-Id: <20221114124500.026845861@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: maxime@cerno.tech <maxime@cerno.tech>

[ Upstream commit 3bc6a37f59f21a8bfaf74d0975b2eb0b2d52a065 ]

Commit ae71ab585c81 ("drm/vc4: hdmi: Enforce the minimum rate at
runtime_resume") reintroduced the call to clk_set_min_rate in an attempt
to fix the boot without a monitor connected on the RaspberryPi3.

However, that introduced a regression breaking the display output
entirely (black screen but no vblank timeout) on the Pi4.

This is due to the fact that we now have in a typical modeset at boot,
in vc4_hdmi_encoder_pre_crtc_configure(), we have a first call to
clk_set_min_rate() asking for the minimum rate of the HSM clock for our
given resolution, and then a call to pm_runtime_resume_and_get(). We
will thus execute vc4_hdmi_runtime_resume() which, since the commit
mentioned above, will call clk_set_min_rate() a second time with the
absolute minimum rate we want to enforce on the HSM clock.

We're thus effectively erasing the minimum mandated by the mode we're
trying to set. The fact that only the Pi4 is affected is due to the fact
that it uses a different clock driver that tries to minimize the HSM
clock at all time. It will thus lower the HSM clock rate to 120MHz on
the second clk_set_min_rate() call.

The Pi3 doesn't use the same driver and will not change the frequency on
the second clk_set_min_rate() call since it's still within the new
boundaries and it doesn't have the code to minimize the clock rate as
needed. So even though the boundaries are still off, the clock rate is
still the right one for our given mode, so everything works.

There is a lot of moving parts, so I couldn't find any obvious
solution:

  - Reverting the original is not an option, as that would break the Pi3
    again.

  - We can't move the clk_set_min_rate() call in _pre_crtc_configure()
    since because, on the Pi3, the HSM clock has the CLK_SET_RATE_GATE
    flag which prevents the clock rate from being changed after it's
    been enabled. Our calls to clk_set_min_rate() can change it, so they
    need to be done before clk_prepare_enable().

  - We can't remove the call to clk_prepare_enable() from the
    runtime_resume hook to put it into _pre_crtc_configure() either,
    since we need that clock to be enabled to access the registers, and
    we can't count on the fact that the display will be active in all
    situations (doing any CEC operation, or listing the modes while
    inactive are valid for example()).

  - We can't drop the call to clk_set_min_rate() in
    _pre_crtc_configure() since we would need to still enforce the
    minimum rate for a given resolution, and runtime_resume doesn't have
    access to the current mode, if there's any.

  - We can't copy the TMDS character rate into vc4_hdmi and reuse it
    since, because it's part of the KMS atomic state, it needs to be
    protected by a mutex. Unfortunately, some functions (CEC operations,
    mostly) can be reentrant (through the CEC framework) and still need
    a pm_runtime_get.

However, we can work around this issue by leveraging the fact that the
clk_set_min_rate() calls set boundaries for its given struct clk, and
that each different clk_get() call will return a different instance of
struct clk. The clock framework will then aggregate the boundaries for
each struct clk instances linked to a given clock, plus its hardware
boundaries, and will use that.

We can thus get an extra HSM clock user for runtime_pm use only, and use
our different clock instances depending on the context: runtime_pm will
use its own to set the absolute minimum clock setup so that we never
lock the CPU waiting for a register access, and the modeset part will
set its requirement for the current resolution. And we let the CCF do
the coordination.

It's not an ideal solution, but it's fairly unintrusive and doesn't
really change any part of the logic so it looks like a rather safe fix.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2136234
Fixes: ae71ab585c81 ("drm/vc4: hdmi: Enforce the minimum rate at runtime_resume")
Reported-by: Peter Robinson <pbrobinson@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20221021131339.2203291-1-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 21 +++++++++++++++++----
 drivers/gpu/drm/vc4/vc4_hdmi.h |  1 +
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 874c6bd787c5..4e5bba0822a5 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2712,9 +2712,16 @@ static int vc4_hdmi_init_resources(struct vc4_hdmi *vc4_hdmi)
 		DRM_ERROR("Failed to get HDMI state machine clock\n");
 		return PTR_ERR(vc4_hdmi->hsm_clock);
 	}
+
 	vc4_hdmi->audio_clock = vc4_hdmi->hsm_clock;
 	vc4_hdmi->cec_clock = vc4_hdmi->hsm_clock;
 
+	vc4_hdmi->hsm_rpm_clock = devm_clk_get(dev, "hdmi");
+	if (IS_ERR(vc4_hdmi->hsm_rpm_clock)) {
+		DRM_ERROR("Failed to get HDMI state machine clock\n");
+		return PTR_ERR(vc4_hdmi->hsm_rpm_clock);
+	}
+
 	return 0;
 }
 
@@ -2796,6 +2803,12 @@ static int vc5_hdmi_init_resources(struct vc4_hdmi *vc4_hdmi)
 		return PTR_ERR(vc4_hdmi->hsm_clock);
 	}
 
+	vc4_hdmi->hsm_rpm_clock = devm_clk_get(dev, "hdmi");
+	if (IS_ERR(vc4_hdmi->hsm_rpm_clock)) {
+		DRM_ERROR("Failed to get HDMI state machine clock\n");
+		return PTR_ERR(vc4_hdmi->hsm_rpm_clock);
+	}
+
 	vc4_hdmi->pixel_bvb_clock = devm_clk_get(dev, "bvb");
 	if (IS_ERR(vc4_hdmi->pixel_bvb_clock)) {
 		DRM_ERROR("Failed to get pixel bvb clock\n");
@@ -2859,7 +2872,7 @@ static int vc4_hdmi_runtime_suspend(struct device *dev)
 {
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
 
-	clk_disable_unprepare(vc4_hdmi->hsm_clock);
+	clk_disable_unprepare(vc4_hdmi->hsm_rpm_clock);
 
 	return 0;
 }
@@ -2877,11 +2890,11 @@ static int vc4_hdmi_runtime_resume(struct device *dev)
 	 * its frequency while the power domain is active so that it
 	 * keeps its rate.
 	 */
-	ret = clk_set_min_rate(vc4_hdmi->hsm_clock, HSM_MIN_CLOCK_FREQ);
+	ret = clk_set_min_rate(vc4_hdmi->hsm_rpm_clock, HSM_MIN_CLOCK_FREQ);
 	if (ret)
 		return ret;
 
-	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
+	ret = clk_prepare_enable(vc4_hdmi->hsm_rpm_clock);
 	if (ret)
 		return ret;
 
@@ -2894,7 +2907,7 @@ static int vc4_hdmi_runtime_resume(struct device *dev)
 	 * case, it will lead to a silent CPU stall. Let's make sure we
 	 * prevent such a case.
 	 */
-	rate = clk_get_rate(vc4_hdmi->hsm_clock);
+	rate = clk_get_rate(vc4_hdmi->hsm_rpm_clock);
 	if (!rate) {
 		ret = -EINVAL;
 		goto err_disable_clk;
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.h b/drivers/gpu/drm/vc4/vc4_hdmi.h
index c3ed2b07df23..47f141ec8c40 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.h
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.h
@@ -171,6 +171,7 @@ struct vc4_hdmi {
 	struct clk *cec_clock;
 	struct clk *pixel_clock;
 	struct clk *hsm_clock;
+	struct clk *hsm_rpm_clock;
 	struct clk *audio_clock;
 	struct clk *pixel_bvb_clock;
 
-- 
2.35.1



