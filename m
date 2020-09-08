Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A86F261893
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731639AbgIHR5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731567AbgIHQMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:12:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2570124894;
        Tue,  8 Sep 2020 15:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580340;
        bh=8wi9nywhbSkGTfU+a+4Vcq/jZKF7T4biVH1GEefgsu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJ9zdUND9vP6X31P0njy32+5TK60RQVJoyKh7vM97McSWKn2ZdFDtOuR0G9vsWfLJ
         dVJ7gc1yQ0GEyepjbQdmWm1pQwqkJnwwCmYZVJsKC/xtPVA9Wgfz4eg0F+IrdMLXSc
         zC7uLcWOzYQuniZR6gsXeeCbViSlPUFyLttIPUGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tony Lindgren <tony@atomide.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/65] thermal: ti-soc-thermal: Fix bogus thermal shutdowns for omap4430
Date:   Tue,  8 Sep 2020 17:26:21 +0200
Message-Id: <20200908152218.895634697@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 30d24faba0532d6972df79a1bf060601994b5873 ]

We can sometimes get bogus thermal shutdowns on omap4430 at least with
droid4 running idle with a battery charger connected:

thermal thermal_zone0: critical temperature reached (143 C), shutting down

Dumping out the register values shows we can occasionally get a 0x7f value
that is outside the TRM listed values in the ADC conversion table. And then
we get a normal value when reading again after that. Reading the register
multiple times does not seem help avoiding the bogus values as they stay
until the next sample is ready.

Looking at the TRM chapter "18.4.10.2.3 ADC Codes Versus Temperature", we
should have values from 13 to 107 listed with a total of 95 values. But
looking at the omap4430_adc_to_temp array, the values are off, and the
end values are missing. And it seems that the 4430 ADC table is similar
to omap3630 rather than omap4460.

Let's fix the issue by using values based on the omap3630 table and just
ignoring invalid values. Compared to the 4430 TRM, the omap3630 table has
the missing values added while the TRM table only shows every second
value.

Note that sometimes the ADC register values within the valid table can
also be way off for about 1 out of 10 values. But it seems that those
just show about 25 C too low values rather than too high values. So those
do not cause a bogus thermal shutdown.

Fixes: 1a31270e54d7 ("staging: omap-thermal: add OMAP4 data structures")
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200706183338.25622-1-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ti-soc-thermal/omap4-thermal-data.c       | 23 ++++++++++---------
 .../thermal/ti-soc-thermal/omap4xxx-bandgap.h | 10 +++++---
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/thermal/ti-soc-thermal/omap4-thermal-data.c b/drivers/thermal/ti-soc-thermal/omap4-thermal-data.c
index fd11133606038..0c3141746edfe 100644
--- a/drivers/thermal/ti-soc-thermal/omap4-thermal-data.c
+++ b/drivers/thermal/ti-soc-thermal/omap4-thermal-data.c
@@ -49,20 +49,21 @@ static struct temp_sensor_data omap4430_mpu_temp_sensor_data = {
 
 /*
  * Temperature values in milli degree celsius
- * ADC code values from 530 to 923
+ * ADC code values from 13 to 107, see TRM
+ * "18.4.10.2.3 ADC Codes Versus Temperature".
  */
 static const int
 omap4430_adc_to_temp[OMAP4430_ADC_END_VALUE - OMAP4430_ADC_START_VALUE + 1] = {
-	-38000, -35000, -34000, -32000, -30000, -28000, -26000, -24000, -22000,
-	-20000, -18000, -17000, -15000, -13000, -12000, -10000, -8000, -6000,
-	-5000, -3000, -1000, 0, 2000, 3000, 5000, 6000, 8000, 10000, 12000,
-	13000, 15000, 17000, 19000, 21000, 23000, 25000, 27000, 28000, 30000,
-	32000, 33000, 35000, 37000, 38000, 40000, 42000, 43000, 45000, 47000,
-	48000, 50000, 52000, 53000, 55000, 57000, 58000, 60000, 62000, 64000,
-	66000, 68000, 70000, 71000, 73000, 75000, 77000, 78000, 80000, 82000,
-	83000, 85000, 87000, 88000, 90000, 92000, 93000, 95000, 97000, 98000,
-	100000, 102000, 103000, 105000, 107000, 109000, 111000, 113000, 115000,
-	117000, 118000, 120000, 122000, 123000,
+	-40000, -38000, -35000, -34000, -32000, -30000, -28000, -26000, -24000,
+	-22000,	-20000, -18500, -17000, -15000, -13500, -12000, -10000, -8000,
+	-6500, -5000, -3500, -1500, 0, 2000, 3500, 5000, 6500, 8500, 10000,
+	12000, 13500, 15000, 17000, 19000, 21000, 23000, 25000, 27000, 28500,
+	30000, 32000, 33500, 35000, 37000, 38500, 40000, 42000, 43500, 45000,
+	47000, 48500, 50000, 52000, 53500, 55000, 57000, 58500, 60000, 62000,
+	64000, 66000, 68000, 70000, 71500, 73500, 75000, 77000, 78500, 80000,
+	82000, 83500, 85000, 87000, 88500, 90000, 92000, 93500, 95000, 97000,
+	98500, 100000, 102000, 103500, 105000, 107000, 109000, 111000, 113000,
+	115000, 117000, 118500, 120000, 122000, 123500, 125000,
 };
 
 /* OMAP4430 data */
diff --git a/drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h b/drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h
index 6f2de3a3356d4..86850082b24b9 100644
--- a/drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h
+++ b/drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h
@@ -67,9 +67,13 @@
  * and thresholds for OMAP4430.
  */
 
-/* ADC conversion table limits */
-#define OMAP4430_ADC_START_VALUE			0
-#define OMAP4430_ADC_END_VALUE				127
+/*
+ * ADC conversion table limits. Ignore values outside the TRM listed
+ * range to avoid bogus thermal shutdowns. See omap4430 TRM chapter
+ * "18.4.10.2.3 ADC Codes Versus Temperature".
+ */
+#define OMAP4430_ADC_START_VALUE			13
+#define OMAP4430_ADC_END_VALUE				107
 /* bandgap clock limits (no control on 4430) */
 #define OMAP4430_MAX_FREQ				32768
 #define OMAP4430_MIN_FREQ				32768
-- 
2.25.1



