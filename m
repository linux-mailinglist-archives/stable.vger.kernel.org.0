Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4102127CC03
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbgI2McT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbgI2LXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:23:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F6E9208B8;
        Tue, 29 Sep 2020 11:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378449;
        bh=RuHzoO7xlF64Rg2hxhbru7L2etZcn5Mmcuz6f9Y0ZKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0h9pw8XOIin7UDhwi9BMJSi2MF1v8k/zi56qST8L28qSuoj8V5jwot5nTLSIXBz6
         3WOYSPimNBgc/PxFg4799hShs8iFbNmr+WHvPt5HlAzxPnNBsrhHpRxYkwEoA8HJpA
         4x8wDxKjmomEciUKUgaFQzbA+7sj/ySayRoP2kok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Oleh Kravchenko <oleg@kaa.org.ua>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/245] leds: mlxreg: Fix possible buffer overflow
Date:   Tue, 29 Sep 2020 12:57:49 +0200
Message-Id: <20200929105947.879915087@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index 1ee48cb21df95..022e973dc7c31 100644
--- a/drivers/leds/leds-mlxreg.c
+++ b/drivers/leds/leds-mlxreg.c
@@ -209,8 +209,8 @@ static int mlxreg_led_config(struct mlxreg_led_priv_data *priv)
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



