Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18F260FDB1
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbiJ0Q6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236371AbiJ0Q6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43BE17E21D
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FFADB82641
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E36C433C1;
        Thu, 27 Oct 2022 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889878;
        bh=Xn8ehEoJn1MkSbx75YNswrglS8EW67eZOZ58Huy0uCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCJh+Bt6N+Qb1eHBFHVkYxUFknLA8Euxc5g+xmF21+Ud/boFNznkDAb1yn69WlqiV
         hDriuXqakN8N0TBHrtIT8Vhq4TjoSx+himzQUbbrhVf7i3FWkUSEN9TovAJebowwFb
         FcOQdvfTbtlWNOgJkuIfIcVYDGKinK6DYscR3Pc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Kleine-Budde <mkl@pengutronix.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 33/94] drm/vc4: hdmi: Enforce the minimum rate at runtime_resume
Date:   Thu, 27 Oct 2022 18:54:35 +0200
Message-Id: <20221027165058.447498626@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit ae71ab585c819f83aec84f91eb01157a90552ef2 ]

This is a revert of commit fd5894fa2413 ("drm/vc4: hdmi: Remove clock
rate initialization"), with the code slightly moved around.

It turns out that we can't downright remove that code from the driver,
since the Pi0-3 and Pi4 are in different cases, and it only works for
the Pi4.

Indeed, the commit mentioned above was relying on the RaspberryPi
firmware clocks driver to initialize the rate if it wasn't done by the
firmware. However, the Pi0-3 are using the clk-bcm2835 clock driver that
wasn't doing this initialization. We therefore end up with the clock not
being assigned a rate, and the CPU stalling when trying to access a
register.

We can't move that initialization in the clk-bcm2835 driver, since the
HSM clock we depend on is actually part of the HDMI power domain, so any
rate setup is only valid when the power domain is enabled. Thus, we
reinstated the minimum rate setup at runtime_suspend, which should
address both issues.

Link: https://lore.kernel.org/dri-devel/20220922145448.w3xfywkn5ecak2et@pengutronix.de/
Fixes: fd5894fa2413 ("drm/vc4: hdmi: Remove clock rate initialization")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220929-rpi-pi3-unplugged-fixes-v1-1-cd22e962296c@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 1e5f68704d7d..780a19a75c3f 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2871,6 +2871,15 @@ static int vc4_hdmi_runtime_resume(struct device *dev)
 	u32 __maybe_unused value;
 	int ret;
 
+	/*
+	 * The HSM clock is in the HDMI power domain, so we need to set
+	 * its frequency while the power domain is active so that it
+	 * keeps its rate.
+	 */
+	ret = clk_set_min_rate(vc4_hdmi->hsm_clock, HSM_MIN_CLOCK_FREQ);
+	if (ret)
+		return ret;
+
 	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
 	if (ret)
 		return ret;
-- 
2.35.1



