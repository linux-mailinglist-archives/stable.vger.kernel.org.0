Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529C629B938
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802257AbgJ0PqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368738AbgJ0P1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:27:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBFF62224A;
        Tue, 27 Oct 2020 15:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812432;
        bh=iKwuqUxTdA+/O7yct0YnKnqBNWfc0YsfQK3RyIXI6H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJ6ytbdnRenEQCZ1i2ypjP2QMf0MGeQspMyb6C3ioA5TemNU3BPXltIT3lLOOTRZX
         r2v0L7okGWIBppHT965fgU0dwQU5mMw3Hb6L/be4wBHQ5Z8y2KIyZ9cupMVw1myitd
         DeG1wVq/pADjDBJwsLi6dtT9QSAArPZGH/RInlKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 177/757] hwmon: (bt1-pvt) Test sensor power supply on probe
Date:   Tue, 27 Oct 2020 14:47:07 +0100
Message-Id: <20201027135458.895131092@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit a6db1561291fc0f2f9aa23bf38f381adc63e7b14 ]

Baikal-T1 PVT sensor has got a dedicated power supply domain (feed up by
the external GPVT/VPVT_18 pins). In case if it isn't powered up, the
registers will be accessible, but the sensor conversion just won't happen.
Due to that an attempt to read data from any PVT sensor will cause the
task hanging up.  For instance that will happen if XP11 jumper isn't
installed on the Baikal-T1-based BFK3.1 board. Let's at least test whether
the conversion work on the device probe procedure. By doing so will make
sure that the PVT sensor is powered up at least at boot time.

Fixes: 87976ce2825d ("hwmon: Add Baikal-T1 PVT sensor driver")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20200920110924.19741-2-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/bt1-pvt.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/hwmon/bt1-pvt.c b/drivers/hwmon/bt1-pvt.c
index 94698cae04971..f4b7353c078a8 100644
--- a/drivers/hwmon/bt1-pvt.c
+++ b/drivers/hwmon/bt1-pvt.c
@@ -13,6 +13,7 @@
 #include <linux/bitops.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/hwmon.h>
@@ -982,6 +983,41 @@ static int pvt_request_clks(struct pvt_hwmon *pvt)
 	return 0;
 }
 
+static int pvt_check_pwr(struct pvt_hwmon *pvt)
+{
+	unsigned long tout;
+	int ret = 0;
+	u32 data;
+
+	/*
+	 * Test out the sensor conversion functionality. If it is not done on
+	 * time then the domain must have been unpowered and we won't be able
+	 * to use the device later in this driver.
+	 * Note If the power source is lost during the normal driver work the
+	 * data read procedure will either return -ETIMEDOUT (for the
+	 * alarm-less driver configuration) or just stop the repeated
+	 * conversion. In the later case alas we won't be able to detect the
+	 * problem.
+	 */
+	pvt_update(pvt->regs + PVT_INTR_MASK, PVT_INTR_ALL, PVT_INTR_ALL);
+	pvt_update(pvt->regs + PVT_CTRL, PVT_CTRL_EN, PVT_CTRL_EN);
+	pvt_set_tout(pvt, 0);
+	readl(pvt->regs + PVT_DATA);
+
+	tout = PVT_TOUT_MIN / NSEC_PER_USEC;
+	usleep_range(tout, 2 * tout);
+
+	data = readl(pvt->regs + PVT_DATA);
+	if (!(data & PVT_DATA_VALID)) {
+		ret = -ENODEV;
+		dev_err(pvt->dev, "Sensor is powered down\n");
+	}
+
+	pvt_update(pvt->regs + PVT_CTRL, PVT_CTRL_EN, 0);
+
+	return ret;
+}
+
 static void pvt_init_iface(struct pvt_hwmon *pvt)
 {
 	u32 trim, temp;
@@ -1109,6 +1145,10 @@ static int pvt_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	ret = pvt_check_pwr(pvt);
+	if (ret)
+		return ret;
+
 	pvt_init_iface(pvt);
 
 	ret = pvt_request_irq(pvt);
-- 
2.25.1



