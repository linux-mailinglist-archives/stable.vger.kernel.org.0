Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D89E1B65A2
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgDWUkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:35 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55994C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:35 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j1so8247868wrt.1
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S0aruERS6sfoWL0NP6GQHXbCNqWez73bZgk7AnMorZI=;
        b=cbT+j4EogdVvIDwApO617ClMrE0gK4OjD6TtBEyH6NOuzv+8Um+GRr6K7txdnefJgr
         VZbW+wFRs1ugxl7IoTxm9AyQBjh13UCQkinyzRaohON1UGb1Ur5kqeBFbBQmJwMzWlEb
         9vqIUJtusWhmKTnPbo4BRP1kapddfhRCzDtsB2rYu9QQp56FdWuC4NrOgp5Gy1nVhLcj
         v4Pgdo//bn7xmwaOIWzhKJgySkifVbMHCwPu7SknH0aBIbHL/w6lIv+6T/XFi2koDWfx
         TfcWy6Fi/AYQKw9VVLoQ6W26ByJUzo4LspP1Lrd465YN0uV5DFWUaJHvh5RZ/vxBB2d8
         wbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S0aruERS6sfoWL0NP6GQHXbCNqWez73bZgk7AnMorZI=;
        b=l3Cs3Yfr4B2NhgYVokuADT0tS255lAq1Sor3z/DRnW0Vr4vVaZgTTny+oTywVkAi7F
         tVHCUhdBycaeP4O26vNjTp0BeiekZocXpnOwiJrqr/T0nh4qPL2guWdgipdLIFlK2v5G
         nsqJle3QdBnrtNsIHSHUZ1w6brNDu8mgkdtITJ+MtwGHiYzlUnGf9F3qPYDixIhxRHlt
         kx3etcfo/mt2c9rlg1eyU3sH15jkv2eeHj+LTlyADhteX5tfpTJgTzBWcimmwzvl+11Y
         xxs/s+FSLloxEY5YPvY6KRlGlHHJPZ7+STQDNoP8F6hu3a5lahKnrGfzY8h0eRJuMSyN
         1yyw==
X-Gm-Message-State: AGi0Puay5ZcocJnETRMDZYKH6OrLboQogxPu0ZvB0k9SPHhTPf9hghLd
        XaIlfMc3ctrMPFTqeTU+8h7jdfi4pxc=
X-Google-Smtp-Source: APiQypLxwkvJykct0rLxI+zZ4xb4PTKh7DMv/jo+YOW58uwF1GNtJEcW+FD5b2JX0kaJI9weW7yM+A==
X-Received: by 2002:adf:fc4f:: with SMTP id e15mr6967472wrs.415.1587674433774;
        Thu, 23 Apr 2020 13:40:33 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:32 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Mohit Aggarwal <maggarwa@codeaurora.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 13/16] rtc: pm8xxx: Fix issue in RTC write path
Date:   Thu, 23 Apr 2020 21:40:11 +0100
Message-Id: <20200423204014.784944-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
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

