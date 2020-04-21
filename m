Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02081B266B
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgDUMlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728923AbgDUMlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:05 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58592C061A41
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:05 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t63so3379810wmt.3
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Z20wcAGJt+rsOO0qFIXrokKyfVoYrM8wAvpmSP5OEA=;
        b=f9keeZ5/Zr0qcNzYQWj3UhUhed5uW1Tzwa0AhAPH7EYK+POEa7E3PUxIRU3wKJdxmE
         zsAPH9I/ORGahdVkre8kP9iAvrnldV6BgmO8jdnJZGXkFYPK4HVUr0w2ac+qicjUri69
         Qpc2bwYj4X4Ui2EGGZaEAAr6ftTJ8ofEP/xtn/IRcFJMGaz7NRPe45Yv+aN8Am3cxAX1
         o4X1NmhVdqs0w8PhciZF2AaM6aFTk+IW+UrcHoqxXvCRTELpJSV8eI0hh+VQ7CXWIvjU
         JwQ7JP7v1sP7OCd1RINv5m1P5NqiDTrEbo8uSHXhTMIP2S17WFZJXd4Z3x4ehxBfeADH
         lVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Z20wcAGJt+rsOO0qFIXrokKyfVoYrM8wAvpmSP5OEA=;
        b=HoJGpLpql4wOBhK8S27tma3BBiRFov1EMhyjTdlZXssd9ym3XiVpSGEgzvE5O/RgKk
         LDUbh+faGzi30Na7fh2SVDwFd6IPPMr3snKdKYPkHC75Rouom6JEmJgcqfOpxpH6MXM7
         /QPZYOJ53s9+/Z7BcQHTGaSElev/Ajk0l/D5QbPr5StsIzyRQuyDl+yOcR6vw+g3VbG9
         6rQk2zoCwMD6Ro4V+4qrJSZFvV1p2rdAxCICel6KMw6U/jdzJDklJugNWH3jBkpg4rTt
         ZMj8CSH/vbVao728j7YxMIBdgluK/ItrXMQGxeSp1ifZWkG23h6punJP6yL9+D3GVeo6
         6e+Q==
X-Gm-Message-State: AGi0PuYLWCnrdO+h8YEjLU/N/MoJjqGvtwyBtlz/ru42d1JGTpGcq183
        /RudlSp+FneQpn4wcmBRBaSNhFb4KAE=
X-Google-Smtp-Source: APiQypK9m7hLyt3vRh9kO5qi3HvOWWfNcvxuEw4kF327MasYKw//tLFRh63RTfIR5+7h4j/73pgYFQ==
X-Received: by 2002:a1c:41d7:: with SMTP id o206mr4763276wma.89.1587472863793;
        Tue, 21 Apr 2020 05:41:03 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Mohit Aggarwal <maggarwa@codeaurora.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 14/24] rtc: pm8xxx: Fix issue in RTC write path
Date:   Tue, 21 Apr 2020 13:40:07 +0100
Message-Id: <20200421124017.272694-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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

