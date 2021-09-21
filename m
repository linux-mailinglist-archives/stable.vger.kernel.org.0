Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55ABD413865
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 19:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhIURg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 13:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhIURg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 13:36:58 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B18C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 10:35:29 -0700 (PDT)
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E06A882DB2;
        Tue, 21 Sep 2021 19:35:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1632245728;
        bh=fQ8JZO4D4mNVyYLfcl8scGzQjWbJK5VrU1vg9jCg9ug=;
        h=From:To:Cc:Subject:Date:From;
        b=zNcgC9Ba/Vsmr5Z7ZG/ODU5/lWrnnW/V+C49YzfAYa15ZFx7b372eq1HsYN9C0tUy
         6BC5ZDMPPujlH9PhedPlEVZv8CMmz4s/VWuXFgyETxGQDHhW9+utNVvSRWcHZE6oLT
         r6fIsiCV586kfBjco3RcbLNXDyDFZ55eLWnXnG+qLfEdvd62tecrU2C6vajvd3tmNY
         Kd/XsoYVLOvSJ1q2LIz+2ULEcbZb6o1ObXPJ8AUAHlrybDmzOS7Nkq8hDR+zZkdsX0
         ANqnHdisI+yd2wO4vpvqD9/8TGU6ePH8T4+1boYrH7Yl5IlKe0HCAQMEbW73IgbzOZ
         HxoCT8Cy55SEw==
From:   Marek Vasut <marex@denx.de>
To:     dri-devel@lists.freedesktop.org
Cc:     lee.jones@linaro.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        stable@vger.kernel.org,
        Meghana Madhyastha <meghana.madhyastha@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Thierry Reding <treding@nvidia.com>
Subject: [RESEND][PATCH v2] video: backlight: Drop maximum brightness override for brightness zero
Date:   Tue, 21 Sep 2021 19:35:06 +0200
Message-Id: <20210921173506.19675-1-marex@denx.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The note in c2adda27d202f ("video: backlight: Add of_find_backlight helper
in backlight.c") says that gpio-backlight uses brightness as power state.
This has been fixed since in ec665b756e6f7 ("backlight: gpio-backlight:
Correct initial power state handling") and other backlight drivers do not
require this workaround. Drop the workaround.

This fixes the case where e.g. pwm-backlight can perfectly well be set to
brightness 0 on boot in DT, which without this patch leads to the display
brightness to be max instead of off.

Fixes: c2adda27d202f ("video: backlight: Add of_find_backlight helper in backlight.c")
Acked-by: Noralf Trønnes <noralf@tronnes.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: <stable@vger.kernel.org> # 5.4+
Cc: <stable@vger.kernel.org> # 4.19.x: ec665b756e6f7: backlight: gpio-backlight: Correct initial power state handling
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Meghana Madhyastha <meghana.madhyastha@gmail.com>
Cc: Noralf Trønnes <noralf@tronnes.org>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Thierry Reding <treding@nvidia.com>
---
V2: Add AB/RB, CC stable
---
 drivers/video/backlight/backlight.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 537fe1b376ad7..fc990e576340b 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -688,12 +688,6 @@ static struct backlight_device *of_find_backlight(struct device *dev)
 			of_node_put(np);
 			if (!bd)
 				return ERR_PTR(-EPROBE_DEFER);
-			/*
-			 * Note: gpio_backlight uses brightness as
-			 * power state during probe
-			 */
-			if (!bd->props.brightness)
-				bd->props.brightness = bd->props.max_brightness;
 		}
 	}
 
-- 
2.33.0

