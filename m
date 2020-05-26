Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836E61B3C0D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgDVKCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgDVKCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:02:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9651B20774;
        Wed, 22 Apr 2020 10:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549723;
        bh=NR6BDxCl2kUKKfDXUZWP84PAIdF5Fq3+/GAPcRgkRD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yq5qd+MhJkeaBfx/khvZaV2yoRkouUEU28QL2WcgQNPgx8oLQ1S1T0Vr5Sq4UGSV9
         dNKmWUZt9OIERr+69wqSdHgf2k+6LgzcudtKNov3e1oEBBT1ibkl3c9GmlGXpAYdif
         KjScBTFV9vTfLcsAkQzezCCDW/dtkDpIEisrzs/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mohit Aggarwal <maggarwa@codeaurora.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 080/100] rtc: pm8xxx: Fix issue in RTC write path
Date:   Wed, 22 Apr 2020 11:56:50 +0200
Message-Id: <20200422095037.442615330@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-pm8xxx.c |   49 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 11 deletions(-)

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
 
@@ -92,23 +94,38 @@ static int pm8xxx_rtc_set_time(struct de
 
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
@@ -137,11 +154,21 @@ static int pm8xxx_rtc_set_time(struct de
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


