Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9928E224E46
	for <lists+stable@lfdr.de>; Sun, 19 Jul 2020 01:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgGRXd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jul 2020 19:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgGRXd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jul 2020 19:33:28 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28973C0619D2
        for <stable@vger.kernel.org>; Sat, 18 Jul 2020 16:33:28 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id q7so16572754ljm.1
        for <stable@vger.kernel.org>; Sat, 18 Jul 2020 16:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/uOHqtO1l7zkVQ8bbrjF3EFuuScxemsHl8Jv5NCr0Zs=;
        b=wZWp6ChjpBomhs7feoixsNH6mvZLKAYA8u/pFpS6/4nXNwsMmcWx1WrkYAa6kpeyhw
         ut1SO2AgAFg6va3LkF4XlPm8dhKGm8IRhMu+s/52INWp8R2v5f777thEv9Z2BmsFva+p
         tbvz0Dfvyrb8M8PNIGClarnUhD8glzwj4RxsQrH7DGmoWQ3hG0zA4kfDhYXULDfUifqC
         6Pia5lWZ07e49ux85FjYMggGYJFae0DeZVbbW9cDHIWz+9lxFMj4jk06rPuJ4jOchqBf
         ZBJdLaWhjbhZ6ngabbnkjbl4hEiOPNOjbJsipvegjgu17Hme8z1GhDtB5FCw/Wpor4GQ
         Wm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/uOHqtO1l7zkVQ8bbrjF3EFuuScxemsHl8Jv5NCr0Zs=;
        b=JRE4RkEGTi+KOxwn2/X6/57w0wuYCyOqiz6pdq5qkjcMS6VzAdh5fCekiqMUAe8+9+
         HoAO2z1Py+8agnKRtVv6gc43lU/sSeI9ahZVL8PbPBp7ofJkybn6cDl1ksWHIo3E65Pt
         Oe8Mz6e/yNQNXayfOY39p9O7QU8YwHC3kEMeUWSbeHU7vMs4ZoG0i8RBrll7nauiUYMD
         3uQA3O/87Se8Ke+ehdILn5lnLVSfsGXFIYqFT6vaAxzaU8HgHXqIQYVVYOwsiFqoRTLl
         sB1vEfcOlu1E/3VxzCn0TanFV3xRVte4hlRAIt9u/jLMfW5FD2xfAz+Hhs6k5HYDvwle
         wpPw==
X-Gm-Message-State: AOAM53131jDrTRYSwoG8G48qHGbq6HyJzvMRUPCEs8MIw4o+R3ttStkK
        Utyz8D03dsOMIYiDSWBedGoLIA==
X-Google-Smtp-Source: ABdhPJzM97xRZHLijv/cmF6LPcoOA2S7d7QGKXpHi41IClGjjZvS6hGjF7P3ul7SN5iMTYkM1sHJgw==
X-Received: by 2002:a2e:978c:: with SMTP id y12mr7173559lji.270.1595115205664;
        Sat, 18 Jul 2020 16:33:25 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id d22sm2014139lfs.26.2020.07.18.16.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 16:33:24 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     dri-devel@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>, Sean Paul <sean@poorly.run>
Cc:     linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>, stable@vger.kernel.org
Subject: [PATCH] drm/mcde: Fix stability issue
Date:   Sun, 19 Jul 2020 01:33:22 +0200
Message-Id: <20200718233323.3407670-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Whenener a display update was sent, apart from updating
the memory base address we called mcde_display_send_one_frame()
which also sent a command to the display requesting the TE IRQ
and enabling the FIFO.

When continous updates are running this is wrong: we need
to only send this to start the flow to the display on
the very first update. This lead to the display pipeline
locking up and crashing.

Check if the flow is already running and in that case
do not call mcde_display_send_one_frame().

This fixes crashes on the Samsung GT-S7710 (Skomer).

Cc: Stephan Gerhold <stephan@gerhold.net>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpu/drm/mcde/mcde_display.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mcde/mcde_display.c b/drivers/gpu/drm/mcde/mcde_display.c
index 212aee60cf61..1d8ea8830a17 100644
--- a/drivers/gpu/drm/mcde/mcde_display.c
+++ b/drivers/gpu/drm/mcde/mcde_display.c
@@ -1086,9 +1086,14 @@ static void mcde_display_update(struct drm_simple_display_pipe *pipe,
 	 */
 	if (fb) {
 		mcde_set_extsrc(mcde, drm_fb_cma_get_gem_addr(fb, pstate, 0));
-		if (!mcde->video_mode)
-			/* Send a single frame using software sync */
-			mcde_display_send_one_frame(mcde);
+		if (!mcde->video_mode) {
+			/*
+			 * Send a single frame using software sync if the flow
+			 * is not active yet.
+			 */
+			if (mcde->flow_active == 0)
+				mcde_display_send_one_frame(mcde);
+		}
 		dev_info_once(mcde->dev, "sent first display update\n");
 	} else {
 		/*
-- 
2.26.2

