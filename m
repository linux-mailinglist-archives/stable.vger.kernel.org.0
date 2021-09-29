Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21741CE4F
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 23:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346795AbhI2Vnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 17:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345431AbhI2Vnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 17:43:40 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16494C06161C
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 14:41:59 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id a73so1143379pge.0
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 14:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=abMqKB2u9rMv7oTMhh3m+4tF/IOseMheczHvshPya7I=;
        b=m2TpfLPcLu9QNlpl9HdlKoBc8s1yHlw4a109KsDKLctrx7o8muqZD1eHvNnSMFttA4
         fG/Qr03uUF4rZlyD2y5we7iu/kBHcB7kAcgNqqFQxqqdqXM4LcSJU7E1Kk2EQDquxze3
         ukoem9hVnnoq3QW4dNuZ5rJ+R/K06pjADNQPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=abMqKB2u9rMv7oTMhh3m+4tF/IOseMheczHvshPya7I=;
        b=f4pyfZUKYbbW9gjlo9FSqw48IBZcfx+jRYrQ/qTgwhb8ys8o1XBQrPW61Oopyaas7d
         4AZ3pyZCXxDcYlInyjfNpYwQRqAbvZTPyzjOpDlyjvIRuJmGSJdkq1ws/JGuSzoAZUHD
         01SPm74EVagBjts5veEtPmgae5NV3Yv1QThIpGa83I2a/2v/lKqphWj2oUc+O+9x6Blp
         j/gzkEtvGLEju3T3U9b6pNPvT1IzmP8kQZI33PPVT9WxTdeA6DBKR1em0si9HgryUGgx
         5uSsRUmMkqCSUIognDCnTCBcCCGFWVM68tXf8ZfNmOX4HoIkXJ9nGU7inRcIedFPbu+0
         sxJQ==
X-Gm-Message-State: AOAM530Wyjyl6zJgDn8Dc/G8Pp5Yt5AKU+PAvZbrnL7diUeQrALDWifD
        Om/ug5CfHnw492caCH5lqb1FNg==
X-Google-Smtp-Source: ABdhPJz6ktUCSGWMztTH+AFVhmEQXYShJtqGc2SK/UWNTJBqVnMthbvvG3CKCGzYVePbkfPuK8YC7Q==
X-Received: by 2002:a63:1d5c:: with SMTP id d28mr1797415pgm.143.1632951718606;
        Wed, 29 Sep 2021 14:41:58 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:1bde:f4ad:4338:e765])
        by smtp.gmail.com with UTF8SMTPSA id p9sm698691pfo.153.2021.09.29.14.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 14:41:57 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Cc:     dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH] drm/brdige: analogix_dp: Grab runtime PM reference for DP-AUX
Date:   Wed, 29 Sep 2021 14:41:03 -0700
Message-Id: <20210929144010.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the display is not enable()d, then we aren't holding a runtime PM
reference here. Thus, it's easy to accidentally cause a hang, if user
space is poking around at /dev/drm_dp_aux0 at the "wrong" time.

Let's get the panel and PM state right before trying to talk AUX.

Fixes: 0d97ad03f422 ("drm/bridge: analogix_dp: Remove duplicated code")
Cc: <stable@vger.kernel.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---

 .../gpu/drm/bridge/analogix/analogix_dp_core.c  | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index b7d2e4449cfa..a1b553904b85 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1632,8 +1632,23 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
 				       struct drm_dp_aux_msg *msg)
 {
 	struct analogix_dp_device *dp = to_dp(aux);
+	int ret, ret2;
 
-	return analogix_dp_transfer(dp, msg);
+	ret = analogix_dp_prepare_panel(dp, true, false);
+	if (ret) {
+		DRM_DEV_ERROR(dp->dev, "Failed to prepare panel (%d)\n", ret);
+		return ret;
+	}
+
+	pm_runtime_get_sync(dp->dev);
+	ret = analogix_dp_transfer(dp, msg);
+	pm_runtime_put(dp->dev);
+
+	ret2 = analogix_dp_prepare_panel(dp, false, false);
+	if (ret2)
+		DRM_DEV_ERROR(dp->dev, "Failed to unprepare panel (%d)\n", ret2);
+
+	return ret;
 }
 
 struct analogix_dp_device *
-- 
2.33.0.685.g46640cef36-goog

