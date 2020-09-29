Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3366C27CA2E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbgI2MRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:17:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730044AbgI2LhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA16C23EB3;
        Tue, 29 Sep 2020 11:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379162;
        bh=5oHdL/SvUebyxDWf8Sl4MMKGthfafe7CIrkoDOYf8F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DP4FL8uU66d/6sNm20bJMdKvZI9Msev1ib3wvmwyIaSWnbBSq3mmb+tcFYRYozGGw
         vGGprY2zxk6oiwvdI4b0s5JkhKW3AJI9Ny3SeWmyMWG/qdiy/6Gg1SJ1Zv5CBtcf4x
         xhhQ05qQ+CkvL4Dck2xvn3vBQf3vFcsIrVLmNJGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Oleh Kravchenko <oleg@kaa.org.ua>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/388] leds: mlxreg: Fix possible buffer overflow
Date:   Tue, 29 Sep 2020 12:55:54 +0200
Message-Id: <20200929110011.606750822@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleh Kravchenko <oleg@kaa.org.ua>

[ Upstream commit 7c6082b903ac28dc3f383fba57c6f9e7e2594178 ]

Error was detected by PVS-Studio:
V512 A call of the 'sprintf' function will lead to overflow of
the buffer 'led_data->led_cdev_name'.

Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-mlxreg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-mlxreg.c b/drivers/leds/leds-mlxreg.c
index cabe379071a7c..82aea1cd0c125 100644
--- a/drivers/leds/leds-mlxreg.c
+++ b/drivers/leds/leds-mlxreg.c
@@ -228,8 +228,8 @@ static int mlxreg_led_config(struct mlxreg_led_priv_data *priv)
 			brightness = LED_OFF;
 			led_data->base_color = MLXREG_LED_GREEN_SOLID;
 		}
-		sprintf(led_data->led_cdev_name, "%s:%s", "mlxreg",
-			data->label);
+		snprintf(led_data->led_cdev_name, sizeof(led_data->led_cdev_name),
+			 "mlxreg:%s", data->label);
 		led_cdev->name = led_data->led_cdev_name;
 		led_cdev->brightness = brightness;
 		led_cdev->max_brightness = LED_ON;
-- 
2.25.1



