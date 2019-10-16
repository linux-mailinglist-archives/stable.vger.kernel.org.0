Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E3FD9F78
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437759AbfJPVzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437801AbfJPVzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:24 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87DAC21A49;
        Wed, 16 Oct 2019 21:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262923;
        bh=EE8r8kOpU5cZ96Shez9OnNPtZeQUgC5DTwgzYVqlx8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=en/BkUV/yw1ox3wElZSZb0x7Fj+P7GfxdnoLdw0x1C0S5KCtI2+6kZv/vP4gGR15E
         Ddlyc5DFbX013WOY3YuqrE0CkiYVAS7CMjZDr3GbyDUpL2Zt9MlrutTULEBaQWg5QX
         ur5BU61dr2hR3VaymUZw55phTvc+j8zGVQdUlIos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 83/92] staging: fbtft: Stop using BL_CORE_DRIVER1
Date:   Wed, 16 Oct 2019 14:50:56 -0700
Message-Id: <20191016214847.581586403@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 9adfe5c89be497bb8761a9f788297c258d535334 ]

Leaking driver internal tracking into the already massively confusing
backlight power tracking is really confusing.

Luckily we have already a drvdata structure, so fixing this is really
easy.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 4 ++--
 drivers/staging/fbtft/fbtft.h      | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 587f68aa466c2..f4682ba44cd74 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -247,7 +247,7 @@ static int fbtft_request_gpios_dt(struct fbtft_par *par)
 static int fbtft_backlight_update_status(struct backlight_device *bd)
 {
 	struct fbtft_par *par = bl_get_data(bd);
-	bool polarity = !!(bd->props.state & BL_CORE_DRIVER1);
+	bool polarity = par->polarity;
 
 	fbtft_par_dbg(DEBUG_BACKLIGHT, par,
 		"%s: polarity=%d, power=%d, fb_blank=%d\n",
@@ -296,7 +296,7 @@ void fbtft_register_backlight(struct fbtft_par *par)
 	/* Assume backlight is off, get polarity from current state of pin */
 	bl_props.power = FB_BLANK_POWERDOWN;
 	if (!gpio_get_value(par->gpio.led[0]))
-		bl_props.state |= BL_CORE_DRIVER1;
+		par->polarity = true;
 
 	bd = backlight_device_register(dev_driver_string(par->info->device),
 				par->info->device, par, &fbtft_bl_ops, &bl_props);
diff --git a/drivers/staging/fbtft/fbtft.h b/drivers/staging/fbtft/fbtft.h
index 89c4b5b76ce69..0275319906748 100644
--- a/drivers/staging/fbtft/fbtft.h
+++ b/drivers/staging/fbtft/fbtft.h
@@ -241,6 +241,7 @@ struct fbtft_par {
 	ktime_t update_time;
 	bool bgr;
 	void *extra;
+	bool polarity;
 };
 
 #define NUMARGS(...)  (sizeof((int[]){__VA_ARGS__})/sizeof(int))
-- 
2.20.1



