Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585E514B8E0
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387482AbgA1O2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:28:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387480AbgA1O2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C7120716;
        Tue, 28 Jan 2020 14:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221698;
        bh=TWHetQeApuPwWwnFAnNwR4s/mLNZZaOaZdJP3JYknWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWyKqdboi5OAe8vV8R1Pn+0D8N8DT60zdyMXdLlQmXrDuGA/0tXAIy/NUz+KnSIcw
         OZxR+Jd2KRS+uXOd/szkwfnpND5tm1W0yeEdMVF9HFZg8Yk3neOJ61kGi8CBqi3MSO
         9WjC3u6vpbMyJMU5erMf8H56r/d8B6zHIRCeG0+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 38/92] Input: sun4i-ts - add a check for devm_thermal_zone_of_sensor_register
Date:   Tue, 28 Jan 2020 15:08:06 +0100
Message-Id: <20200128135813.965752394@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit 97e24b095348a15ec08c476423c3b3b939186ad7 upstream.

The driver misses a check for devm_thermal_zone_of_sensor_register().
Add a check to fix it.

Fixes: e28d0c9cd381 ("input: convert sun4i-ts to use devm_thermal_zone_of_sensor_register")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/sun4i-ts.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/input/touchscreen/sun4i-ts.c
+++ b/drivers/input/touchscreen/sun4i-ts.c
@@ -246,6 +246,7 @@ static int sun4i_ts_probe(struct platfor
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	struct device *hwmon;
+	struct thermal_zone_device *thermal;
 	int error;
 	u32 reg;
 	bool ts_attached;
@@ -365,7 +366,10 @@ static int sun4i_ts_probe(struct platfor
 	if (IS_ERR(hwmon))
 		return PTR_ERR(hwmon);
 
-	devm_thermal_zone_of_sensor_register(ts->dev, 0, ts, &sun4i_ts_tz_ops);
+	thermal = devm_thermal_zone_of_sensor_register(ts->dev, 0, ts,
+						       &sun4i_ts_tz_ops);
+	if (IS_ERR(thermal))
+		return PTR_ERR(thermal);
 
 	writel(TEMP_IRQ_EN(1), ts->base + TP_INT_FIFOC);
 


