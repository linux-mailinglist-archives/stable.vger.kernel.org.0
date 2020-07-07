Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E442171F9
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgGGP1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730350AbgGGP1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:27:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB9C2083B;
        Tue,  7 Jul 2020 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135633;
        bh=OPqoMn+/06zTJ/IhQ4HFgXBDX7x8RWNi3teDAPSeLTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trQR4ks0uSSRNm3b9n3zGFpmcgGUjM1CQHosT2wbCsRgAnzTyJ3K4dGOlYKuXzoYp
         WZZw6M9gM9CtfLdEEwEaOMpAn+8kZZJWe/0LQy8SlkJFUoLuH+uH51b+LLNlFp0IOa
         y7cq3oOEXVeLM9bQw0TkE0X8ejUH7iqHShNvexHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.7 095/112] hwmon: (pmbus) Fix page vs. register when accessing fans
Date:   Tue,  7 Jul 2020 17:17:40 +0200
Message-Id: <20200707145805.496172289@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kundrát <jan.kundrat@cesnet.cz>

commit b4c8af4c2a226fc9c25e1decbd26fdab1b0993ee upstream.

Commit 16358542f32f ("hwmon: (pmbus) Implement multi-phase support")
added support for multi-phase pmbus devices. However, when calling
pmbus_add_sensor() for fans, the patch swapped the `page` and `reg`
attributes. As a result, the fan speeds were reported as 0 RPM on my device.

Signed-off-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Fixes: 16358542f32f ("hwmon: (pmbus) Implement multi-phase support")
Cc: stable@vger.kernel.org # v5.7+
Link: https://lore.kernel.org/r/449bc9e6c0e4305581e45905ce9d043b356a9932.1592904387.git.jan.kundrat@cesnet.cz
[groeck: Fixed references to offending commit]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/pmbus/pmbus_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1869,7 +1869,7 @@ static int pmbus_add_fan_ctrl(struct i2c
 	struct pmbus_sensor *sensor;
 
 	sensor = pmbus_add_sensor(data, "fan", "target", index, page,
-				  PMBUS_VIRT_FAN_TARGET_1 + id, 0xff, PSC_FAN,
+				  0xff, PMBUS_VIRT_FAN_TARGET_1 + id, PSC_FAN,
 				  false, false, true);
 
 	if (!sensor)
@@ -1880,14 +1880,14 @@ static int pmbus_add_fan_ctrl(struct i2c
 		return 0;
 
 	sensor = pmbus_add_sensor(data, "pwm", NULL, index, page,
-				  PMBUS_VIRT_PWM_1 + id, 0xff, PSC_PWM,
+				  0xff, PMBUS_VIRT_PWM_1 + id, PSC_PWM,
 				  false, false, true);
 
 	if (!sensor)
 		return -ENOMEM;
 
 	sensor = pmbus_add_sensor(data, "pwm", "enable", index, page,
-				  PMBUS_VIRT_PWM_ENABLE_1 + id, 0xff, PSC_PWM,
+				  0xff, PMBUS_VIRT_PWM_ENABLE_1 + id, PSC_PWM,
 				  true, false, false);
 
 	if (!sensor)
@@ -1929,7 +1929,7 @@ static int pmbus_add_fan_attributes(stru
 				continue;
 
 			if (pmbus_add_sensor(data, "fan", "input", index,
-					     page, pmbus_fan_registers[f], 0xff,
+					     page, 0xff, pmbus_fan_registers[f],
 					     PSC_FAN, true, true, true) == NULL)
 				return -ENOMEM;
 


