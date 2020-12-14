Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D852D9DE3
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502257AbgLNRhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:37:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502263AbgLNRhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:45 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 023/105] drm/panel: sony-acx565akm: Fix race condition in probe
Date:   Mon, 14 Dec 2020 18:27:57 +0100
Message-Id: <20201214172556.389622190@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 7c4bada12d320d8648ba3ede6f9b6f9e10f1126a ]

The probe routine acquires the reset GPIO using GPIOD_OUT_LOW. Directly
afterwards it calls acx565akm_detect(), which sets the GPIO value to
HIGH. If the bootloader initialized the GPIO to HIGH before the probe
routine was called, there is only a very short time period of a few
instructions where the reset signal is LOW. Exact time depends on
compiler optimizations, kernel configuration and alignment of the stars,
but I expect it to be always way less than 10us. There are no public
datasheets for the panel, but acx565akm_power_on() has a comment with
timings and reset period should be at least 10us. So this potentially
brings the panel into a half-reset state.

The result is, that panel may not work after boot and can get into a
working state by re-enabling it (e.g. by blanking + unblanking), since
that does a clean reset cycle. This bug has recently been hit by Ivaylo
Dimitrov, but there are some older reports which are probably the same
bug. At least Tony Lindgren, Peter Ujfalusi and Jarkko Nikula have
experienced it in 2017 describing the blank/unblank procedure as
possible workaround.

Note, that the bug really goes back in time. It has originally been
introduced in the predecessor of the omapfb driver in commit 3c45d05be382
("OMAPDSS: acx565akm panel: handle gpios in panel driver") in 2012.
That driver eventually got replaced by a newer one, which had the bug
from the beginning in commit 84192742d9c2 ("OMAPDSS: Add Sony ACX565AKM
panel driver") and still exists in fbdev world. That driver has later
been copied to omapdrm and then was used as a basis for this driver.
Last but not least the omapdrm specific driver has been removed in
commit 45f16c82db7e ("drm/omap: displays: Remove unused panel drivers").

Reported-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Reported-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reported-by: Tony Lindgren <tony@atomide.com>
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reported-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Fixes: 1c8fc3f0c5d2 ("drm/panel: Add driver for the Sony ACX565AKM panel")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20201127200429.129868-1-sebastian.reichel@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sony-acx565akm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-sony-acx565akm.c b/drivers/gpu/drm/panel/panel-sony-acx565akm.c
index fc6a7e451abef..304267f7849ac 100644
--- a/drivers/gpu/drm/panel/panel-sony-acx565akm.c
+++ b/drivers/gpu/drm/panel/panel-sony-acx565akm.c
@@ -629,7 +629,7 @@ static int acx565akm_probe(struct spi_device *spi)
 	lcd->spi = spi;
 	mutex_init(&lcd->mutex);
 
-	lcd->reset_gpio = devm_gpiod_get(&spi->dev, "reset", GPIOD_OUT_LOW);
+	lcd->reset_gpio = devm_gpiod_get(&spi->dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(lcd->reset_gpio)) {
 		dev_err(&spi->dev, "failed to get reset GPIO\n");
 		return PTR_ERR(lcd->reset_gpio);
-- 
2.27.0



