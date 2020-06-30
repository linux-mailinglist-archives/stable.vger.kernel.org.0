Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA3C20FBB0
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 20:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390776AbgF3S0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 14:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729953AbgF3S0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 14:26:49 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F303C061755;
        Tue, 30 Jun 2020 11:26:48 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f23so22095536iof.6;
        Tue, 30 Jun 2020 11:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zHkMrF1WG28iaGTof2SgLVlAgajf1uvvDa148L1A4YA=;
        b=F4bRlhY7JPlFE5MOJNhH06ubJD/AwLxDSHTkK8prEd7WJaNbBFDvroFyM7nSqG00Qh
         zC5d+FeO3qACgBJISvU47GGOic70oP3x22flzistdPNasJi0UKqQxS4c4S1sc7PWUUi4
         xJ1Vr0NWy8FyYXBmzQVtBjQ+nMkcbeOXGvwpb547MFCGBgXdN5rR+2y2OdZGN+iUAOax
         eyGf3xANMO+ot5QApAld1RaJ+fkECK+TohwDhBwwPWS5JKI4p9uLq/W1X0CN884zX3Zo
         rQx7fAnGqeoTgkMm1dwc6vbRGEP8aYycGvJWlI2LbF5LRtP3K6WJKWVy90C2pYHUjGyL
         CApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zHkMrF1WG28iaGTof2SgLVlAgajf1uvvDa148L1A4YA=;
        b=gPjWyL+WMBeZOG0Uo1lIdiGHop1C7yR0LsrJSGJmLPtWMjLE3U3Anc0PFMW2oI7iIc
         LxZPA2B20LzFOJUUrAm3qXBXqGMInklpuNyFoiaMnj2jxzzfLj6d1D26lZiSAbbdw68Q
         h7++Z5nWwJ5N2Y28e1cfM96ax27EMgwtFgJujL3fQFYZasGBt3u0p3Ch/THhAEscxRx2
         zjpOaculwp2YdjgMWLOGsZ4GgKYEPGWqZiHMEJ7kjRSz6apn0zoMGgD1MvZk4ASbrzaj
         KyhKxtwXOAB4YNWBV8i5z+YAI6rxY1NvL00SzweBhoEOVUpPmUuYnhI9vuakYq7lzE+A
         17fA==
X-Gm-Message-State: AOAM5338bQExhAz4YoQFUJkKQ6fmrhmTw0Aww/D3hw5I2VxSaridU+YN
        TYSG5qZtshrBh71L/+8tJMLenrHL
X-Google-Smtp-Source: ABdhPJyAPNjOe2Euzd0n2GEPfkpD1dt5csCv1TH57jPtERYO/b5rK+8mNMNPSrE+XyMWMLNVkpw8xA==
X-Received: by 2002:a6b:d809:: with SMTP id y9mr23557963iob.209.1593541607533;
        Tue, 30 Jun 2020 11:26:47 -0700 (PDT)
Received: from aford-IdeaCentre-A730.lan (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id u6sm1966164ilg.32.2020.06.30.11.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 11:26:46 -0700 (PDT)
From:   Adam Ford <aford173@gmail.com>
To:     linux-fbdev@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Dave Airlie <airlied@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rob Clark <robdclark@gmail.com>, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
Date:   Tue, 30 Jun 2020 13:26:36 -0500
Message-Id: <20200630182636.439015-1-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The drm/omap driver was fixed to correct an issue where using a
divider of 32 breaks the DSS despite the TRM stating 32 is a valid
number.  Through experimentation, it appears that 31 works, and
it is consistent with the value used by the drm/omap driver.

This patch fixes the divider for fbdev driver instead of the drm.

Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")

Cc: <stable@vger.kernel.org> #4.9+
Signed-off-by: Adam Ford <aford173@gmail.com>
---
Linux 4.4 will need a similar patch, but it doesn't apply cleanly.

The DRM version of this same fix is:
e2c4ed148cf3 ("drm/omap: fix max fclk divider for omap36xx")


diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
index 7252d22dd117..bfc5c4c5a26a 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
@@ -833,7 +833,7 @@ static const struct dss_features omap34xx_dss_feats = {
 };
 
 static const struct dss_features omap3630_dss_feats = {
-	.fck_div_max		=	32,
+	.fck_div_max		=	31,
 	.dss_fck_multiplier	=	1,
 	.parent_clk_name	=	"dpll4_ck",
 	.dpi_select_source	=	&dss_dpi_select_source_omap2_omap3,
-- 
2.25.1

