Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA05C41F71D
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 23:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhJAVwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 17:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhJAVwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 17:52:02 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFF1C061775
        for <stable@vger.kernel.org>; Fri,  1 Oct 2021 14:50:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y5so7154850pll.3
        for <stable@vger.kernel.org>; Fri, 01 Oct 2021 14:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NL7Ui4pDzKD6Cqfc/rSld3tguEIwYPG7fUSYDal4DEY=;
        b=m5z3+8aUGB1/aVqhdvcvLjWaweeugGKaJ2xm3YgW2o29YhTbamwXAXZg7cLIQD1tCZ
         fvN2Q8ZX5iSk4zKhCdWb49sctlPcBg+q1vWgc1vYwKqU9r/8vkuzpBrHdzDf921Ezfiv
         q5Lh1OIAONXX9dSbdT7CpFkVidsPqatUSsulg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NL7Ui4pDzKD6Cqfc/rSld3tguEIwYPG7fUSYDal4DEY=;
        b=2sJMaCyO5BVG0dkyCNh9RnmtWveJ2KLB5ZjlKLDt9mYpFUNxsHxNphGWVwNgGAz6/3
         tSEdoXA6wj1yweeGKzSIUhKcYwkWEseWV5Trj6K6rao0hWSrUHSEQPRaffCDvws3iXbM
         3st+6AsHyvSI90fO8BSa1bmMM8Rau3vCcuKvH2mJPsM5NseKRDursCe45RiH8uT6MpKj
         DnqS8/iMRRUK8m2zzOqHj7KI69pz0wSALMiEtxhcnZDO4JykQqcxoZPcp7t8v2ySe+mJ
         0EDOD9+jUInI2wE7M8f+3Jfec4hZ7QzJvnI0RKafCFxSV95G5gWy3/s7QwPISOcTDfI/
         6rlA==
X-Gm-Message-State: AOAM531lQa/eaEiwNVabanoCMKF2r1CUMAaYRUVfikS9mtiIkiwcIFpv
        fxBqDs0Z3xh78Sq/plyL3h4eFg==
X-Google-Smtp-Source: ABdhPJxAa+ytqGV91qQywYgHfFgfudFxi7R0Gdv7bI8eSjvNvxkJPbbYbO5+jovj0Lp9k88a23k6hA==
X-Received: by 2002:a17:90a:16:: with SMTP id 22mr22720079pja.25.1633125017619;
        Fri, 01 Oct 2021 14:50:17 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:1e7d:5e91:4390:d04b])
        by smtp.gmail.com with UTF8SMTPSA id d5sm6405749pjs.53.2021.10.01.14.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 14:50:17 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Cc:     Sean Paul <sean@poorly.run>, Jonas Karlman <jonas@kwiboo.se>,
        linux-kernel@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v2] drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX
Date:   Fri,  1 Oct 2021 14:42:55 -0700
Message-Id: <20211001144212.v2.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
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

Changes in v2:
- Fix spelling in Subject
- DRM_DEV_ERROR() -> drm_err()
- Propagate errors from un-analogix_dp_prepare_panel()

 .../drm/bridge/analogix/analogix_dp_core.c    | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index b7d2e4449cfa..6fc46ac93ef8 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1632,8 +1632,27 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
 				       struct drm_dp_aux_msg *msg)
 {
 	struct analogix_dp_device *dp = to_dp(aux);
+	int ret, ret2;
 
-	return analogix_dp_transfer(dp, msg);
+	ret = analogix_dp_prepare_panel(dp, true, false);
+	if (ret) {
+		drm_err(dp->drm_dev, "Failed to prepare panel (%d)\n", ret);
+		return ret;
+	}
+
+	pm_runtime_get_sync(dp->dev);
+	ret = analogix_dp_transfer(dp, msg);
+	pm_runtime_put(dp->dev);
+
+	ret2 = analogix_dp_prepare_panel(dp, false, false);
+	if (ret2) {
+		drm_err(dp->drm_dev, "Failed to unprepare panel (%d)\n", ret2);
+		/* Prefer the analogix_dp_transfer() error, if it exists. */
+		if (!ret)
+			ret = ret2;
+	}
+
+	return ret;
 }
 
 struct analogix_dp_device *
-- 
2.33.0.800.g4c38ced690-goog

