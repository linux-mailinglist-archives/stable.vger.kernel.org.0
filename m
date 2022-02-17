Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E474BACCF
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 23:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343938AbiBQWmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 17:42:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343907AbiBQWmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 17:42:21 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D271704C
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 14:42:06 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id l73so6213404pge.11
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 14:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/pFhxh4a1mIJWKVvwWf0TWI0PzyzDNvxgd8MaYxtB4g=;
        b=DRjZUlF38aKhKGF1HEEXpShz5dNW4rV1EZ3PJsdeXyBLxzGJJMj2+9g6pi+MiKGhYt
         H+9E29WZ8V4Np9zsahnlGJmkvOu6FMFXZxC9SU+qF5bJdkcsbldinSAPqonRI6Ftb1Dz
         YKCtyN3JvqpZZ/nc5796hnay3gO0nfEdVSefs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/pFhxh4a1mIJWKVvwWf0TWI0PzyzDNvxgd8MaYxtB4g=;
        b=jSlvlq7wtp8GWPjZOFeguNxuVHtOOCOCE9ToyH974sCcNp/IU+KpVRU4x89nEiKkHq
         dZZtjQDvAyMQ0l3FQh3g3cb6tsSV3B95I2Gsuw5UdRBx63KC/PAMI0buRuBjgQkpOQNb
         VpZGYYuNCfJtyMfpE3efA3vgpjGTPn43oUZwvmZxyODpM1h/cYnqARM5qKG0ZgekgnDa
         fLKHnFWg6byiDfUiqwqLIFh6p5TOPhWxlblxUmquP/Jdh8YLwFHAsHDAjwsWNSIQPX+P
         mbbGwuWqQooNDUEvZ+2d4l0P4vPATSlJ53yPDidIvad59KizaqSRYvjQM77MBSiG7J4U
         2QiA==
X-Gm-Message-State: AOAM533Y8WNjfcghqzRCgH9L1mPOE8oBItmwwAY5ZeOlXpnIT06Cr2IL
        PM6ZD1ejHx4o6jVT13VyvTSM8g==
X-Google-Smtp-Source: ABdhPJx0I/9dms8bGvA0MQ9aczlCf/u6f2qI/Tw9lU7d6SMBvt5gmujVGb3LwnbbS//bPCI4KYGOjg==
X-Received: by 2002:aa7:83c2:0:b0:4e0:91c1:6795 with SMTP id j2-20020aa783c2000000b004e091c16795mr4885484pfn.54.1645137726160;
        Thu, 17 Feb 2022 14:42:06 -0800 (PST)
Received: from localhost ([2620:15c:202:201:677e:1914:4c14:1662])
        by smtp.gmail.com with UTF8SMTPSA id u1sm628435pfg.151.2022.02.17.14.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 14:42:05 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Cc:     linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>,
        Sean Paul <sean@poorly.run>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        dri-devel@lists.freedesktop.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v3 1/2] drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX
Date:   Thu, 17 Feb 2022 14:41:45 -0800
Message-Id: <20220217144136.v3.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the display is not enable()d, then we aren't holding a runtime PM
reference here. Thus, it's easy to accidentally cause a hang, if user
space is poking around at /dev/drm_dp_aux0 at the "wrong" time.

Let's get a runtime PM reference, and check that we "see" the panel.
Don't force any panel power-up, etc., because that can be intrusive, and
that's not what other drivers do (see
drivers/gpu/drm/bridge/ti-sn65dsi86.c and
drivers/gpu/drm/bridge/parade-ps8640.c.)

Fixes: 0d97ad03f422 ("drm/bridge: analogix_dp: Remove duplicated code")
Cc: <stable@vger.kernel.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---

Changes in v3:
- Avoid panel power-up; just check for HPD state, and let the rest
  happen "as-is" (e.g., time out, if the caller hasn't prepared things
  properly)

Changes in v2:
- Fix spelling in Subject
- DRM_DEV_ERROR() -> drm_err()
- Propagate errors from un-analogix_dp_prepare_panel()

 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index b7d2e4449cfa..16be279aed2c 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1632,8 +1632,19 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
 				       struct drm_dp_aux_msg *msg)
 {
 	struct analogix_dp_device *dp = to_dp(aux);
+	int ret;
+
+	pm_runtime_get_sync(dp->dev);
+
+	ret = analogix_dp_detect_hpd(dp);
+	if (ret)
+		goto out;
 
-	return analogix_dp_transfer(dp, msg);
+	ret = analogix_dp_transfer(dp, msg);
+out:
+	pm_runtime_put(dp->dev);
+
+	return ret;
 }
 
 struct analogix_dp_device *
-- 
2.35.1.265.g69c8d7142f-goog

