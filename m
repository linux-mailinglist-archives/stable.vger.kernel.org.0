Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161A685341
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 20:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389384AbfHGSwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 14:52:03 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44503 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389245AbfHGSwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 14:52:03 -0400
Received: by mail-yw1-f68.google.com with SMTP id l79so32811388ywe.11
        for <stable@vger.kernel.org>; Wed, 07 Aug 2019 11:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uBJnbcNgXL4Ewt9aXEKXXTybz6mgacmlW9xupC/bPsc=;
        b=OBhAk4Pt26i2GgK6u2y94cEldEvtZoBVr3PpcqvWMNCMP6HulT4f78bxyX/lOT8XKn
         kqpb+5re5/nFIrPpIi5i/4mjIweIMh+P5h2tirVbmynk3utJX/HmtlIpcS1ZBEsjIVM8
         fQIJvH7GRYCBaPDgYsHx/G+ozoKKY4Y7JCN0hFvJphK11AN7GCR4izHCrVJWPVja6Vpv
         bujaV0FA1QJUszApem6HCR0mBa7LB+xqDcNjMCVjIPAEVjUB19/rLjgFUQCrsPsZ+Y/p
         TSQPGn7M83PVj/JtYfogXPxe3icU1L7oeCS48ITWJMlpcm+tL+IRPXIr6d++P8Oi5FZy
         elSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uBJnbcNgXL4Ewt9aXEKXXTybz6mgacmlW9xupC/bPsc=;
        b=MdAdbIJdzkPxyEgOkJU/Fr8jVd/k3aOFOkZrHFvgQYWA/kfiDs3xIpT+OqP/N1Wuqd
         2hBXW2jBnrrHODuxiBwoOk3cNvKZF+tzoxRM9SZXbGHV1G3wGK8+wlu15iNLhfzZ80Hr
         33QVnvNv1/Sg4gW0kTa/b1NPAHAia32j5IOUNAD89tk87Fyz9aRywKyC104ZoxiIW7Ky
         kzuHE1kjr8ItvYArDoCS+Lmmyq1wJIlwyVxhmjKMun1dgaS5V8wFJxf+5zyl3SxQEgaD
         aOOb/6SP3eEDDHUTs4jeqCSjMZaUOqsrmxRn0XGfNO7iAVoVG1ShsLxskC71VUul+mji
         cEjA==
X-Gm-Message-State: APjAAAVfmUStRTYNABgetDicN1mxvjlT2ndUot1M4TCoNS78PwRLrVFB
        mW4m+h11Uh52vJx2ixO08My4Ig==
X-Google-Smtp-Source: APXvYqybR9mHxZg127Kte6AYTK7OAVaW22KUyjQarf6IV6TetInW4a+GbgKCDa1r0Ey/tvuSRyQjYw==
X-Received: by 2002:a81:5f82:: with SMTP id t124mr6836554ywb.344.1565203922409;
        Wed, 07 Aug 2019 11:52:02 -0700 (PDT)
Received: from rosewood.cam.corp.google.com ([2620:0:1013:11:89c6:2139:5435:371d])
        by smtp.gmail.com with ESMTPSA id d127sm20174910ywb.27.2019.08.07.11.52.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 11:52:02 -0700 (PDT)
From:   Sean Paul <sean@poorly.run>
To:     freedreno@lists.freedesktop.org
Cc:     Sean Paul <seanpaul@chromium.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>, stable@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/msm/dsi: Fix return value check for clk_get_parent
Date:   Wed,  7 Aug 2019 14:51:50 -0400
Message-Id: <20190807185201.16072-1-sean@poorly.run>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

clk_get_parent returns an error pointer upon failure, not NULL. So the
checks as they exist won't catch a failure. This patch changes the
checks and the return values to properly handle an error pointer.

Fixes: c4d8cfe516dc ("drm/msm/dsi: add implementation for helper functions")
Cc: Sibi Sankar <sibis@codeaurora.org>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Rob Clark <robdclark@chromium.org>
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index aa35d18ab43c9..02acb4338721a 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -421,15 +421,15 @@ static int dsi_clk_init(struct msm_dsi_host *msm_host)
 	}
 
 	msm_host->byte_clk_src = clk_get_parent(msm_host->byte_clk);
-	if (!msm_host->byte_clk_src) {
-		ret = -ENODEV;
+	if (IS_ERR(msm_host->byte_clk_src)) {
+		ret = PTR_ERR(msm_host->byte_clk_src);
 		pr_err("%s: can't find byte_clk clock. ret=%d\n", __func__, ret);
 		goto exit;
 	}
 
 	msm_host->pixel_clk_src = clk_get_parent(msm_host->pixel_clk);
-	if (!msm_host->pixel_clk_src) {
-		ret = -ENODEV;
+	if (IS_ERR(msm_host->pixel_clk_src)) {
+		ret = PTR_ERR(msm_host->pixel_clk_src);
 		pr_err("%s: can't find pixel_clk clock. ret=%d\n", __func__, ret);
 		goto exit;
 	}
-- 
Sean Paul, Software Engineer, Google / Chromium OS

