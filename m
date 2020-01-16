Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E713FEF1
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391179AbgAPX2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:28:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbgAPX2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C95B20684;
        Thu, 16 Jan 2020 23:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217332;
        bh=PoxcrDcGEQmUeQXGusjb3WsOfqsZeYJY0WnI1BoaYy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGYqx+BMwIdxFNjrgFRn8bhUoAFWf2RhwEsHwtSqno/XfBo8Iky2CLR45jt1MQYc6
         rg2tYp81lg9w7ogLbHdy/QBND9UvDKhKoO2QrmvdMIOKLCYvvi8TYIJjPTX/58yhjy
         2NJvRI/PThOVYs9EjeVqNj2uHSuk75IrOClBI73E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Anderson <jasona.594@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 40/84] platform/x86: GPD pocket fan: Use default values when wrong modparams are given
Date:   Fri, 17 Jan 2020 00:18:14 +0100
Message-Id: <20200116231718.472607590@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 6ae01050e49f0080ae30575d9b45a6d4a3d7ee23 upstream.

Use our default values when wrong module-parameters are given, instead of
refusing to load. Refusing to load leaves the fan at the BIOS default
setting, which is "Off". The CPU's thermal throttling should protect the
system from damage, but not-loading is really not the best fallback in this
case.

This commit fixes this by re-setting module-parameter values to their
defaults if they are out of range, instead of failing the probe with
-EINVAL.

Cc: stable@vger.kernel.org
Cc: Jason Anderson <jasona.594@gmail.com>
Reported-by: Jason Anderson <jasona.594@gmail.com>
Fixes: 594ce6db326e ("platform/x86: GPD pocket fan: Use a min-speed of 2 while charging")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/gpd-pocket-fan.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/platform/x86/gpd-pocket-fan.c
+++ b/drivers/platform/x86/gpd-pocket-fan.c
@@ -16,17 +16,27 @@
 
 #define MAX_SPEED 3
 
-static int temp_limits[3] = { 55000, 60000, 65000 };
+#define TEMP_LIMIT0_DEFAULT	55000
+#define TEMP_LIMIT1_DEFAULT	60000
+#define TEMP_LIMIT2_DEFAULT	65000
+
+#define HYSTERESIS_DEFAULT	3000
+
+#define SPEED_ON_AC_DEFAULT	2
+
+static int temp_limits[3] = {
+	TEMP_LIMIT0_DEFAULT, TEMP_LIMIT1_DEFAULT, TEMP_LIMIT2_DEFAULT,
+};
 module_param_array(temp_limits, int, NULL, 0444);
 MODULE_PARM_DESC(temp_limits,
 		 "Millicelsius values above which the fan speed increases");
 
-static int hysteresis = 3000;
+static int hysteresis = HYSTERESIS_DEFAULT;
 module_param(hysteresis, int, 0444);
 MODULE_PARM_DESC(hysteresis,
 		 "Hysteresis in millicelsius before lowering the fan speed");
 
-static int speed_on_ac = 2;
+static int speed_on_ac = SPEED_ON_AC_DEFAULT;
 module_param(speed_on_ac, int, 0444);
 MODULE_PARM_DESC(speed_on_ac,
 		 "minimum fan speed to allow when system is powered by AC");
@@ -120,18 +130,21 @@ static int gpd_pocket_fan_probe(struct p
 		if (temp_limits[i] < 40000 || temp_limits[i] > 70000) {
 			dev_err(&pdev->dev, "Invalid temp-limit %d (must be between 40000 and 70000)\n",
 				temp_limits[i]);
-			return -EINVAL;
+			temp_limits[0] = TEMP_LIMIT0_DEFAULT;
+			temp_limits[1] = TEMP_LIMIT1_DEFAULT;
+			temp_limits[2] = TEMP_LIMIT2_DEFAULT;
+			break;
 		}
 	}
 	if (hysteresis < 1000 || hysteresis > 10000) {
 		dev_err(&pdev->dev, "Invalid hysteresis %d (must be between 1000 and 10000)\n",
 			hysteresis);
-		return -EINVAL;
+		hysteresis = HYSTERESIS_DEFAULT;
 	}
 	if (speed_on_ac < 0 || speed_on_ac > MAX_SPEED) {
 		dev_err(&pdev->dev, "Invalid speed_on_ac %d (must be between 0 and 3)\n",
 			speed_on_ac);
-		return -EINVAL;
+		speed_on_ac = SPEED_ON_AC_DEFAULT;
 	}
 
 	fan = devm_kzalloc(&pdev->dev, sizeof(*fan), GFP_KERNEL);


