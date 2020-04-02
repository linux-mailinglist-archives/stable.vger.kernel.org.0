Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C6619C99C
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389397AbgDBTNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52131 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388892AbgDBTNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:23 -0400
Received: by mail-wm1-f67.google.com with SMTP id z7so4610811wmk.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8Z20wcAGJt+rsOO0qFIXrokKyfVoYrM8wAvpmSP5OEA=;
        b=yaXz2ct3ZMS4CeatTunlhe4+4Tu5ghKGkYX7vL9yMEChD1yVBObKz7sqNLeerBpr6p
         YJMWsz08CxvCp8aQ/4GBaT/3/dZV+qes3c/N923Efcet22ctMuSht2qf31z8oW9lSrAt
         DIV3QKXiURb2Cn2hR2kzj0RMTg31cWPE0b8cYJ4tjeSwWoJ32UycpVaTBB2QuJtvOPA5
         2PSs+RrKTVZ13qmdZoTRdMVO3J7B04tMNoUbzUBR5r63nmzWKIYqzOpahn8nhQo57khD
         C2gs64F4oWSrozSbc2eNRLzqpVwZ5QUaXayFdCvD/RdAljJ2+eqeb+5DqWkFreVX9Rvc
         sNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Z20wcAGJt+rsOO0qFIXrokKyfVoYrM8wAvpmSP5OEA=;
        b=MeGx7tYCeQDLcAZO0KHosAzfJbzxI+q91GUAT19168ek8mxc3TyAD9X+ITHd5XsfjS
         nz3KILTTeFVq9IamhF3b0KtYhRcS74d7N2ZixKTKcnSslmQ4HvQjYD+ZWVs3EP3aHQaq
         Qv+jkwLT4Us++t0cZF39l00qFYfGvcnEVc7jPsb4s99o3Mz6jZN3RR9N4LSp8jSq5V7x
         DkHu5ovFkml2l94shvzDByj2rwO3UuBBIvRHUwESJ1fyH6n4NV84PECCs2ng84O0euzf
         CYVGhA86iLAJ6n6V3/Hd0D90T81F4F+4j15U28c4xslMTug/MCj1v3yKh60iPIotMa4X
         nvgg==
X-Gm-Message-State: AGi0Pua+5Xwqcd2ptm1JgtTGSBL+rsox/+LuZfqc+2TqXm5Ql0t5OG1v
        sJ0nsKsjcwnbaQfOzPBQsXIV/+W0xcIr8g==
X-Google-Smtp-Source: APiQypKZmk5kCXneFATbqD5CTcVOqOyriGQrHHF7ovV5lRJ8FTQlxgJqaekQvqf8s7Sw4Kv8E/DfEg==
X-Received: by 2002:a7b:c18e:: with SMTP id y14mr4542679wmi.99.1585854799119;
        Thu, 02 Apr 2020 12:13:19 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 20/33] rtc: pm8xxx: Fix issue in RTC write path
Date:   Thu,  2 Apr 2020 20:13:40 +0100
Message-Id: <20200402191353.787836-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index a1b4b0ed1f196..3b619b7b2c530 100644
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

