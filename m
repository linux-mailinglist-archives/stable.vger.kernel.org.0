Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CEB26F482
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIRDOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgIRCBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B79C235F8;
        Fri, 18 Sep 2020 02:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394501;
        bh=5oHdL/SvUebyxDWf8Sl4MMKGthfafe7CIrkoDOYf8F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgaP3XbYXb1e4ajAwbwKISlL5T68+ujhDdIByM79eqQq2ROo/G5TFb2quPhlZDXtZ
         juBl7Gdr+nIWFT2rF0+gSl5uthdkpUcw5j8YNE0KZcCH2ZbivtY4oH2XNZuIa9fxi5
         zEqEouzDsIulRhaNygU3Xo7Jqmigk2/KD7tQWvn0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleh Kravchenko <oleg@kaa.org.ua>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 025/330] leds: mlxreg: Fix possible buffer overflow
Date:   Thu, 17 Sep 2020 21:56:05 -0400
Message-Id: <20200918020110.2063155-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

