Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A14319C9DD
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389529AbgDBTST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33077 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389476AbgDBTSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id z14so349285wmf.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=S0aruERS6sfoWL0NP6GQHXbCNqWez73bZgk7AnMorZI=;
        b=Qx5XtiP4+x5KnF6OvP/zGgBLzpKe51o5yW/88p7zeI7q1Pkf+/avIuMUa2Ud51dfxx
         qR+Led+DbNvkg/7lW/KePlh2Khpa+kzu6qAbqIs80VOTfWGUjKN8cs5Bn/DRT+rF20Dh
         voAC+eA5gzU8RWX3H3J8boJtYNaDu+OqbbDpnxIf62InPsdykUbyOK9sZtk1OVAEZOCz
         zaQImhi97hvGCf/kWwFOxoLcjoXa/dUKIyUWfWbG7El+YbeIKXXsoXnGUx5Fqw9lwBpO
         P9Z7D+mOCVW/MV6+3m798PUAEZXtS+FpOHlxMJ9fr3qd+vjwoU+1vWFHx2k2zNfzlTk7
         W7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S0aruERS6sfoWL0NP6GQHXbCNqWez73bZgk7AnMorZI=;
        b=qN8niKBjnZn4mO3vh9qzOuvU8saLbj3OmAOkHulZXKsqzf/ywuxUm1/XHkDVcxTdcS
         HkQNvuPUwIgSTFd0ecd7Gg3GfHz8Tyc5of6MA5pnBehlFUt7zOPcS9+9wwTvSGxdVbh5
         LYh0iULv0lia6hBs8uza8D9Rdq+uX+GhEIGAy6mOyIu998sUh94sapvMh6lUM7U9z4Ix
         CHsGU1GTVPAW3bpijisQUMK5+PIuB1ur/cqg1K19X2AI9NokFJzJUvo0DG5nWEBrdFaP
         GPatifrA2iF8IUHmOiDAwUOI7yI2JAI6UEVtmwrcLXmiBAl2nMRng/oB/0K8Musd7wdm
         +AUA==
X-Gm-Message-State: AGi0PubK8Ac87etMkJ+3eLP3sjqbtPTsU1UZXgFKUr7WMjFoVRbIrPqU
        zTWftA1mGDse14VpfxtoohEaQtoREtD/FA==
X-Google-Smtp-Source: APiQypIwe+knwvY+4PG+nfXe3+wbUjrPaSfdk5lPHnGUEOdKh1cSw87QvEjaP+0T/xiEAXoacJEgDw==
X-Received: by 2002:a7b:c010:: with SMTP id c16mr5112411wmb.73.1585855097113;
        Thu, 02 Apr 2020 12:18:17 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:16 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 15/20] rtc: pm8xxx: Fix issue in RTC write path
Date:   Thu,  2 Apr 2020 20:18:51 +0100
Message-Id: <20200402191856.789622-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohit Aggarwal <maggarwa@codeaurora.org>

[ Upstream commit 83220bf38b77a830f8e62ab1a0d0408304f9b966 ]

In order to set time in rtc, need to disable
rtc hw before writing into rtc registers.

Also fixes disabling of alarm while setting
rtc time.

Signed-off-by: Mohit Aggarwal <maggarwa@codeaurora.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rtc/rtc-pm8xxx.c | 49 +++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index a0dae6271ff64..cd4434cca877c 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -74,16 +74,18 @@ struct pm8xxx_rtc {
 /*
  * Steps to write the RTC registers.
  * 1. Disable alarm if enabled.
- * 2. Write 0x00 to LSB.
- * 3. Write Byte[1], Byte[2], Byte[3] then Byte[0].
- * 4. Enable alarm if disabled in step 1.
+ * 2. Disable rtc if enabled.
+ * 3. Write 0x00 to LSB.
+ * 4. Write Byte[1], Byte[2], Byte[3] then Byte[0].
+ * 5. Enable rtc if disabled in step 2.
+ * 6. Enable alarm if disabled in step 1.
  */
 static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	int rc, i;
 	unsigned long secs, irq_flags;
-	u8 value[NUM_8_BIT_RTC_REGS], alarm_enabled = 0;
-	unsigned int ctrl_reg;
+	u8 value[NUM_8_BIT_RTC_REGS], alarm_enabled = 0, rtc_disabled = 0;
+	unsigned int ctrl_reg, rtc_ctrl_reg;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
 
@@ -92,23 +94,38 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	rtc_tm_to_time(tm, &secs);
 
+	dev_dbg(dev, "Seconds value to be written to RTC = %lu\n", secs);
+
 	for (i = 0; i < NUM_8_BIT_RTC_REGS; i++) {
 		value[i] = secs & 0xFF;
 		secs >>= 8;
 	}
 
-	dev_dbg(dev, "Seconds value to be written to RTC = %lu\n", secs);
-
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
-	rc = regmap_read(rtc_dd->regmap, regs->ctrl, &ctrl_reg);
+	rc = regmap_read(rtc_dd->regmap, regs->alarm_ctrl, &ctrl_reg);
 	if (rc)
 		goto rtc_rw_fail;
 
 	if (ctrl_reg & regs->alarm_en) {
 		alarm_enabled = 1;
 		ctrl_reg &= ~regs->alarm_en;
-		rc = regmap_write(rtc_dd->regmap, regs->ctrl, ctrl_reg);
+		rc = regmap_write(rtc_dd->regmap, regs->alarm_ctrl, ctrl_reg);
+		if (rc) {
+			dev_err(dev, "Write to RTC Alarm control register failed\n");
+			goto rtc_rw_fail;
+		}
+	}
+
+	/* Disable RTC H/w before writing on RTC register */
+	rc = regmap_read(rtc_dd->regmap, regs->ctrl, &rtc_ctrl_reg);
+	if (rc)
+		goto rtc_rw_fail;
+
+	if (rtc_ctrl_reg & PM8xxx_RTC_ENABLE) {
+		rtc_disabled = 1;
+		rtc_ctrl_reg &= ~PM8xxx_RTC_ENABLE;
+		rc = regmap_write(rtc_dd->regmap, regs->ctrl, rtc_ctrl_reg);
 		if (rc) {
 			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
@@ -137,11 +154,21 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		goto rtc_rw_fail;
 	}
 
+	/* Enable RTC H/w after writing on RTC register */
+	if (rtc_disabled) {
+		rtc_ctrl_reg |= PM8xxx_RTC_ENABLE;
+		rc = regmap_write(rtc_dd->regmap, regs->ctrl, rtc_ctrl_reg);
+		if (rc) {
+			dev_err(dev, "Write to RTC control register failed\n");
+			goto rtc_rw_fail;
+		}
+	}
+
 	if (alarm_enabled) {
 		ctrl_reg |= regs->alarm_en;
-		rc = regmap_write(rtc_dd->regmap, regs->ctrl, ctrl_reg);
+		rc = regmap_write(rtc_dd->regmap, regs->alarm_ctrl, ctrl_reg);
 		if (rc) {
-			dev_err(dev, "Write to RTC control register failed\n");
+			dev_err(dev, "Write to RTC Alarm control register failed\n");
 			goto rtc_rw_fail;
 		}
 	}
-- 
2.25.1

