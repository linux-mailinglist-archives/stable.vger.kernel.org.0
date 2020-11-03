Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C624D2A5419
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388033AbgKCVH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:07:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388345AbgKCVHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:07:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F36C206B5;
        Tue,  3 Nov 2020 21:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437674;
        bh=4W7mOMzad/Ugm0x2tJkIWCRui190OZvtegKywXFEoZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3YdsnP0sjdiEt0PQmMhtoWPgoYAD4NEudwss1XXop+8EJIvg3Bg6x85mgtPBSLda
         NTMxEg8kPKtwTzGPTdKtmo5QRFMXbHHvQxlEszLTxac2wktr8loJW99r7HiiJRhwbS
         J0r0ZeJrHUNVxP1PijwL7SWjPPrISMJr7VwxcVQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.19 178/191] rtc: rx8010: dont modify the global rtc ops
Date:   Tue,  3 Nov 2020 21:37:50 +0100
Message-Id: <20201103203249.312789260@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

commit d3b14296da69adb7825022f3224ac6137eb30abf upstream.

The way the driver is implemented is buggy for the (admittedly unlikely)
use case where there are two RTCs with one having an interrupt configured
and the second not. This is caused by the fact that we use a global
rtc_class_ops struct which we modify depending on whether the irq number
is present or not.

Fix it by using two const ops structs with and without alarm operations.
While at it: not being able to request a configured interrupt is an error
so don't ignore it and bail out of probe().

Fixes: ed13d89b08e3 ("rtc: Add Epson RX8010SJ RTC driver")
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200914154601.32245-2-brgl@bgdev.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/rtc/rtc-rx8010.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/rtc/rtc-rx8010.c
+++ b/drivers/rtc/rtc-rx8010.c
@@ -428,16 +428,26 @@ static int rx8010_ioctl(struct device *d
 	}
 }
 
-static struct rtc_class_ops rx8010_rtc_ops = {
+static const struct rtc_class_ops rx8010_rtc_ops_default = {
 	.read_time = rx8010_get_time,
 	.set_time = rx8010_set_time,
 	.ioctl = rx8010_ioctl,
 };
 
+static const struct rtc_class_ops rx8010_rtc_ops_alarm = {
+	.read_time = rx8010_get_time,
+	.set_time = rx8010_set_time,
+	.ioctl = rx8010_ioctl,
+	.read_alarm = rx8010_read_alarm,
+	.set_alarm = rx8010_set_alarm,
+	.alarm_irq_enable = rx8010_alarm_irq_enable,
+};
+
 static int rx8010_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	const struct rtc_class_ops *rtc_ops;
 	struct rx8010_data *rx8010;
 	int err = 0;
 
@@ -468,16 +478,16 @@ static int rx8010_probe(struct i2c_clien
 
 		if (err) {
 			dev_err(&client->dev, "unable to request IRQ\n");
-			client->irq = 0;
-		} else {
-			rx8010_rtc_ops.read_alarm = rx8010_read_alarm;
-			rx8010_rtc_ops.set_alarm = rx8010_set_alarm;
-			rx8010_rtc_ops.alarm_irq_enable = rx8010_alarm_irq_enable;
+			return err;
 		}
+
+		rtc_ops = &rx8010_rtc_ops_alarm;
+	} else {
+		rtc_ops = &rx8010_rtc_ops_default;
 	}
 
 	rx8010->rtc = devm_rtc_device_register(&client->dev, client->name,
-		&rx8010_rtc_ops, THIS_MODULE);
+					       rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rx8010->rtc)) {
 		dev_err(&client->dev, "unable to register the class device\n");


