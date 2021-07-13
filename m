Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B563C76D8
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 21:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhGMTTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 15:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhGMTTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 15:19:39 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002D0C0613DD;
        Tue, 13 Jul 2021 12:16:48 -0700 (PDT)
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id BC5FB829EF;
        Tue, 13 Jul 2021 21:16:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1626203806;
        bh=wbQJGQKfin37yNew9W/wu8wDSAmPvLDBx+xhp/1201o=;
        h=From:To:Cc:Subject:Date:From;
        b=M5MvE8Fh4HkmZpOE6WwFLQv7b81qOGPl9pmxes5mORrj2H6S0PVsmJcjIaG2+e89J
         08Cuq/47ILUxiPOuY46+8VB9w/Xgf8vFQbq6rIXygQVjt2LRMwHuoqxjLHXRn4RY7M
         HY/tyFOc2kWIuQUmZA71n6Doy67v5uKcXxeka2c5iMIG/JUIUitslBAWojvuqXh6Hl
         tyiRTH5/m+6gVzNH2sllb5V4ImWoY12/BIJ+msdLoiO5/H0+toTFRiE7mQzWAc1Tgd
         BYzU4BuH890nllvyB4oYIudGxB+EGxooX6HgbIifNwLotN6SDMLAo90iI1U77FDPrb
         KARPb2MymKpSg==
From:   Marek Vasut <marex@denx.de>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-fbdev@vger.kernel.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        stable@vger.kernel.org,
        Meghana Madhyastha <meghana.madhyastha@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH V2] video: backlight: Drop maximum brightness override for brightness zero
Date:   Tue, 13 Jul 2021 21:16:33 +0200
Message-Id: <20210713191633.121317-1-marex@denx.de>
X-Mailer: git-send-email 2.30.2
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
2.30.2

