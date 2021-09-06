Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81476401B7A
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbhIFM5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231825AbhIFM5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF30660238;
        Mon,  6 Sep 2021 12:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630932976;
        bh=vDWDkkhl0/rrC2qD671xVZRLlT/+NKJUV6SSm23trRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdC2iEO+hCINLvqQZ+jADYMxV4bVRJ7GDif8lecF4mNw36n6+X/Dyf3mj/P9zJ0d0
         /HiTWlIAsAMwPYrFwvA6qiWhEIdYpTXPfW7/PNR+w39bD+Q1cmf/Vs6OeEwlkRgb9Y
         McvXm10W7uiZOqahbgTJ8AC1y8+Db20WejGgff/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Falkowski <maciej.falkowski9@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.10 11/29] ARM: OMAP1: ams-delta: remove unused function ams_delta_camera_power
Date:   Mon,  6 Sep 2021 14:55:26 +0200
Message-Id: <20210906125450.155894077@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Falkowski <maciej.falkowski9@gmail.com>

commit bae989c4bc53f861cc1b706aab0194703e9907a8 upstream.

The ams_delta_camera_power() function is unused as reports
Clang compilation with omap1_defconfig on linux-next:

arch/arm/mach-omap1/board-ams-delta.c:462:12: warning: unused function 'ams_delta_camera_power' [-Wunused-function]
static int ams_delta_camera_power(struct device *dev, int power)
           ^
1 warning generated.

The soc_camera support was dropped without removing
ams_delta_camera_power() function, making it unused.

Fixes: ce548396a433 ("media: mach-omap1: board-ams-delta.c: remove soc_camera dependencies")
Signed-off-by: Maciej Falkowski <maciej.falkowski9@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1326
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap1/board-ams-delta.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -458,20 +458,6 @@ static struct gpiod_lookup_table leds_gp
 
 #ifdef CONFIG_LEDS_TRIGGERS
 DEFINE_LED_TRIGGER(ams_delta_camera_led_trigger);
-
-static int ams_delta_camera_power(struct device *dev, int power)
-{
-	/*
-	 * turn on camera LED
-	 */
-	if (power)
-		led_trigger_event(ams_delta_camera_led_trigger, LED_FULL);
-	else
-		led_trigger_event(ams_delta_camera_led_trigger, LED_OFF);
-	return 0;
-}
-#else
-#define ams_delta_camera_power	NULL
 #endif
 
 static struct platform_device ams_delta_audio_device = {


