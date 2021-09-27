Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFF3419C9A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbhI0Ra2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237848AbhI0R2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:28:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F03626147F;
        Mon, 27 Sep 2021 17:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763052;
        bh=9a4kw7YzLGml/rNOEqvcM3ABWPSDISAbctBS3QeWVLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3HFPKu9g6g6JUY5f5Xp3o/07WI4R1326JY4AfqO0zEKGLbSq6OtLjGvTZHn/uK45
         OSls3rV21JNnhvuftrkOd24Y13FubpyjXweZ9qNy/VQeGIoowt+K+yuhUmvb7EsY3r
         j5O0fBJnF33d/A7g24BKfj0wZWE7no2Om9tgYpqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Michael Stapelberg <michael@stapelberg.ch>
Subject: [PATCH 5.14 149/162] Revert drm/vc4 hdmi runtime PM changes
Date:   Mon, 27 Sep 2021 19:03:15 +0200
Message-Id: <20210927170238.590144175@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit b1044a9b8100a0cc5c9d2e1e2f9ca4bb8e32b23a ]

This reverts commits

  9984d6664ce9 ("drm/vc4: hdmi: Make sure the controller is powered in detect")
  411efa18e4b0 ("drm/vc4: hdmi: Move the HSM clock enable to runtime_pm")

as Michael Stapelberg reports that the new runtime PM changes cause his
Raspberry Pi 3 to hang on boot, probably due to interactions with other
changes in the DRM tree (because a bisect points to the merge in commit
e058a84bfddc: "Merge tag 'drm-next-2021-07-01' of git://.../drm").

Revert these two commits until it's been resolved.

Link: https://lore.kernel.org/all/871r5mp7h2.fsf@midna.i-did-not-set--mail-host-address--so-tickle-me/
Reported-and-tested-by: Michael Stapelberg <michael@stapelberg.ch>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.com>
Cc: Dave Airlie <airlied@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 44 ++++++++--------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index f91d37beb113..3b391dee3044 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -166,8 +166,6 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 	struct vc4_hdmi *vc4_hdmi = connector_to_vc4_hdmi(connector);
 	bool connected = false;
 
-	WARN_ON(pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev));
-
 	if (vc4_hdmi->hpd_gpio &&
 	    gpiod_get_value_cansleep(vc4_hdmi->hpd_gpio)) {
 		connected = true;
@@ -188,12 +186,10 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 			}
 		}
 
-		pm_runtime_put(&vc4_hdmi->pdev->dev);
 		return connector_status_connected;
 	}
 
 	cec_phys_addr_invalidate(vc4_hdmi->cec_adap);
-	pm_runtime_put(&vc4_hdmi->pdev->dev);
 	return connector_status_disconnected;
 }
 
@@ -635,6 +631,7 @@ static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder,
 		vc4_hdmi->variant->phy_disable(vc4_hdmi);
 
 	clk_disable_unprepare(vc4_hdmi->pixel_bvb_clock);
+	clk_disable_unprepare(vc4_hdmi->hsm_clock);
 	clk_disable_unprepare(vc4_hdmi->pixel_clock);
 
 	ret = pm_runtime_put(&vc4_hdmi->pdev->dev);
@@ -945,6 +942,13 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 		return;
 	}
 
+	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
+	if (ret) {
+		DRM_ERROR("Failed to turn on HSM clock: %d\n", ret);
+		clk_disable_unprepare(vc4_hdmi->pixel_clock);
+		return;
+	}
+
 	vc4_hdmi_cec_update_clk_div(vc4_hdmi);
 
 	if (pixel_rate > 297000000)
@@ -957,6 +961,7 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 	ret = clk_set_min_rate(vc4_hdmi->pixel_bvb_clock, bvb_rate);
 	if (ret) {
 		DRM_ERROR("Failed to set pixel bvb clock rate: %d\n", ret);
+		clk_disable_unprepare(vc4_hdmi->hsm_clock);
 		clk_disable_unprepare(vc4_hdmi->pixel_clock);
 		return;
 	}
@@ -964,6 +969,7 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 	ret = clk_prepare_enable(vc4_hdmi->pixel_bvb_clock);
 	if (ret) {
 		DRM_ERROR("Failed to turn on pixel bvb clock: %d\n", ret);
+		clk_disable_unprepare(vc4_hdmi->hsm_clock);
 		clk_disable_unprepare(vc4_hdmi->pixel_clock);
 		return;
 	}
@@ -2110,29 +2116,6 @@ static int vc5_hdmi_init_resources(struct vc4_hdmi *vc4_hdmi)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int vc4_hdmi_runtime_suspend(struct device *dev)
-{
-	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
-
-	clk_disable_unprepare(vc4_hdmi->hsm_clock);
-
-	return 0;
-}
-
-static int vc4_hdmi_runtime_resume(struct device *dev)
-{
-	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
-	int ret;
-
-	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-#endif
-
 static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 {
 	const struct vc4_hdmi_variant *variant = of_device_get_match_data(dev);
@@ -2380,18 +2363,11 @@ static const struct of_device_id vc4_hdmi_dt_match[] = {
 	{}
 };
 
-static const struct dev_pm_ops vc4_hdmi_pm_ops = {
-	SET_RUNTIME_PM_OPS(vc4_hdmi_runtime_suspend,
-			   vc4_hdmi_runtime_resume,
-			   NULL)
-};
-
 struct platform_driver vc4_hdmi_driver = {
 	.probe = vc4_hdmi_dev_probe,
 	.remove = vc4_hdmi_dev_remove,
 	.driver = {
 		.name = "vc4_hdmi",
 		.of_match_table = vc4_hdmi_dt_match,
-		.pm = &vc4_hdmi_pm_ops,
 	},
 };
-- 
2.33.0



