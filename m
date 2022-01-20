Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA53494407
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 01:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357654AbiATALj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 19:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357643AbiATALj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 19:11:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3390EC06173F
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 16:11:39 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id a7so3740289plh.1
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 16:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xVjyliV2Seqod5G5KIrqETEB6DdMnlj/gwwO0Ms37r0=;
        b=m2Cq3pKgOPSZH8kQrR3RmS6xRkj5mu1noGfRe3JZhs8okQ1LqSuYyK//XFTZkx1aQs
         yHUXZol3p03WVKjGCTEpbNIwX1Y17hojgjvIyt4T8a5US0T0fRGuh5XrTFE7N2jsmURt
         d5YyE0CUQIeGJ0Q571BvcoBoXM5+SCFLLetkw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xVjyliV2Seqod5G5KIrqETEB6DdMnlj/gwwO0Ms37r0=;
        b=cdhbB+pK89E+0Us+ItPHVFxKVSCIGqezerQVkMVqjD23geEuEs1lJ9cxGlVhAiQmz+
         q2nrqDM+5GAS0tIcZi9xx3ijY1dYH9jXgK5fhvZ0DNJU1yUXu7OcnAA53DQzRxR05pUA
         aeWwCqceDE19U1br0XwPwchVqzyDs++NZv0VXS6JcrHk4iZQG/KsAGinffkXN8rHOKXa
         b2Tzy8FWgqn+QgWSRpfNvcknKBnyigPhTLr8u5DIBKzMdnYj8tRb0+f0aGne4Qun+iyU
         S3sXuXNCeN+DfIES8NMx1//APpwv+gyCRpG+wEItWaVwuTyYy3aWsOllVo9mR/B5ghlG
         FX9Q==
X-Gm-Message-State: AOAM532DmGqTqOIK/BEF84ea28sur+UtLgfalABQo5qoXQg3OkRf213p
        qyuGW6o4i3BSBVBC6TlJmHRjrw==
X-Google-Smtp-Source: ABdhPJwLpxXuY7FO2TAuqYWaVf818ZHbHTTM8JXzcEhXz0whOElvDA2CBgU9tYGH1YmFEb+a9qtFGg==
X-Received: by 2002:a17:902:7c89:b0:14a:a76f:78d2 with SMTP id y9-20020a1709027c8900b0014aa76f78d2mr21640702pll.166.1642637498672;
        Wed, 19 Jan 2022 16:11:38 -0800 (PST)
Received: from localhost ([2620:15c:202:201:bebd:c462:321a:9b63])
        by smtp.gmail.com with UTF8SMTPSA id j4sm804788pfc.125.2022.01.19.16.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 16:11:37 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     Daniel Vetter <daniel@ffwll.ch>, David Airlie <airlied@linux.ie>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>
Cc:     Sandy Huang <hjc@rock-chips.com>, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Mark Yao <markyao0591@gmail.com>,
        dri-devel@lists.freedesktop.org,
        Brian Norris <briannorris@chromium.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/rockchip: vop: Correct RK3399 VOP register fields
Date:   Wed, 19 Jan 2022 16:11:22 -0800
Message-Id: <20220119161104.1.I1d01436bef35165a8cdfe9308789c0badb5ff46a@changeid>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7707f7227f09 ("drm/rockchip: Add support for afbc") switched up
the rk3399_vop_big[] register windows, but it did so incorrectly.

The biggest problem is in rk3288_win23_data[] vs.
rk3368_win23_data[] .format field:

  RK3288's format: VOP_REG(RK3288_WIN2_CTRL0, 0x7, 1)
  RK3368's format: VOP_REG(RK3368_WIN2_CTRL0, 0x3, 5)

Bits 5:6 (i.e., shift 5, mask 0x3) are correct for RK3399, according to
the TRM.

There are a few other small differences between the 3288 and 3368
definitions that were swapped in commit 7707f7227f09. I reviewed them to
the best of my ability according to the RK3399 TRM and fixed them up.

This fixes IOMMU issues (and display errors) when testing with BG24
color formats.

Fixes: 7707f7227f09 ("drm/rockchip: Add support for afbc")
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
I'd appreciate notes or testing from Andrzej, since I'm not sure how he
tested his original AFBC work.

 drivers/gpu/drm/rockchip/rockchip_vop_reg.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
index 1f7353f0684a..798b542e5916 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
@@ -902,6 +902,7 @@ static const struct vop_win_phy rk3399_win01_data = {
 	.enable = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 0),
 	.format = VOP_REG(RK3288_WIN0_CTRL0, 0x7, 1),
 	.rb_swap = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 12),
+	.x_mir_en = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 21),
 	.y_mir_en = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 22),
 	.act_info = VOP_REG(RK3288_WIN0_ACT_INFO, 0x1fff1fff, 0),
 	.dsp_info = VOP_REG(RK3288_WIN0_DSP_INFO, 0x0fff0fff, 0),
@@ -912,6 +913,7 @@ static const struct vop_win_phy rk3399_win01_data = {
 	.uv_vir = VOP_REG(RK3288_WIN0_VIR, 0x3fff, 16),
 	.src_alpha_ctl = VOP_REG(RK3288_WIN0_SRC_ALPHA_CTRL, 0xff, 0),
 	.dst_alpha_ctl = VOP_REG(RK3288_WIN0_DST_ALPHA_CTRL, 0xff, 0),
+	.channel = VOP_REG(RK3288_WIN0_CTRL2, 0xff, 0),
 };
 
 /*
@@ -922,11 +924,11 @@ static const struct vop_win_phy rk3399_win01_data = {
 static const struct vop_win_data rk3399_vop_win_data[] = {
 	{ .base = 0x00, .phy = &rk3399_win01_data,
 	  .type = DRM_PLANE_TYPE_PRIMARY },
-	{ .base = 0x40, .phy = &rk3288_win01_data,
+	{ .base = 0x40, .phy = &rk3368_win01_data,
 	  .type = DRM_PLANE_TYPE_OVERLAY },
-	{ .base = 0x00, .phy = &rk3288_win23_data,
+	{ .base = 0x00, .phy = &rk3368_win23_data,
 	  .type = DRM_PLANE_TYPE_OVERLAY },
-	{ .base = 0x50, .phy = &rk3288_win23_data,
+	{ .base = 0x50, .phy = &rk3368_win23_data,
 	  .type = DRM_PLANE_TYPE_CURSOR },
 };
 
-- 
2.34.1.703.g22d0c6ccf7-goog

