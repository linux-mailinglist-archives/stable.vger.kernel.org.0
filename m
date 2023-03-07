Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855B66AEBED
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjCGRud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjCGRuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:50:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA53231ED
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D857AB81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05B0C4339B;
        Tue,  7 Mar 2023 17:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211089;
        bh=eiyPRHTKbFMhk/WfNo54jTafuAH6RpDmIKMet5d2GsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmoGCQmx8SwIzaPT646FlkCw6zbe+KKfqqfUw/FHLWSX/S+CYOSOB+Rwn0up/eZ5S
         EKp1UDT6emh1KrTdYWz+D3TpG/bD2ueYQjuwgkUjN3zLEarQHihPv/KCUsMrSs3Q3q
         jHB1Mwq2DglxYV5SmAPZrpiS/8RFDNqJfv8Ik2NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        David Collins <quic_collinsd@quicinc.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.2 0749/1001] rtc: pm8xxx: fix set-alarm race
Date:   Tue,  7 Mar 2023 17:58:41 +0100
Message-Id: <20230307170054.225071429@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit c88db0eff9722fc2b6c4d172a50471d20e08ecc6 upstream.

Make sure to disable the alarm before updating the four alarm time
registers to avoid spurious alarms during the update.

Note that the disable needs to be done outside of the ctrl_reg_lock
section to prevent a racing alarm interrupt from disabling the newly set
alarm when the lock is released.

Fixes: 9a9a54ad7aa2 ("drivers/rtc: add support for Qualcomm PMIC8xxx RTC")
Cc: stable@vger.kernel.org      # 3.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: David Collins <quic_collinsd@quicinc.com>
Link: https://lore.kernel.org/r/20230202155448.6715-2-johan+linaro@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-pm8xxx.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -221,7 +221,6 @@ static int pm8xxx_rtc_set_alarm(struct d
 {
 	int rc, i;
 	u8 value[NUM_8_BIT_RTC_REGS];
-	unsigned int ctrl_reg;
 	unsigned long secs, irq_flags;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
@@ -233,6 +232,11 @@ static int pm8xxx_rtc_set_alarm(struct d
 		secs >>= 8;
 	}
 
+	rc = regmap_update_bits(rtc_dd->regmap, regs->alarm_ctrl,
+				regs->alarm_en, 0);
+	if (rc)
+		return rc;
+
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	rc = regmap_bulk_write(rtc_dd->regmap, regs->alarm_rw, value,
@@ -242,19 +246,11 @@ static int pm8xxx_rtc_set_alarm(struct d
 		goto rtc_rw_fail;
 	}
 
-	rc = regmap_read(rtc_dd->regmap, regs->alarm_ctrl, &ctrl_reg);
-	if (rc)
-		goto rtc_rw_fail;
-
-	if (alarm->enabled)
-		ctrl_reg |= regs->alarm_en;
-	else
-		ctrl_reg &= ~regs->alarm_en;
-
-	rc = regmap_write(rtc_dd->regmap, regs->alarm_ctrl, ctrl_reg);
-	if (rc) {
-		dev_err(dev, "Write to RTC alarm control register failed\n");
-		goto rtc_rw_fail;
+	if (alarm->enabled) {
+		rc = regmap_update_bits(rtc_dd->regmap, regs->alarm_ctrl,
+					regs->alarm_en, regs->alarm_en);
+		if (rc)
+			goto rtc_rw_fail;
 	}
 
 	dev_dbg(dev, "Alarm Set for h:m:s=%ptRt, y-m-d=%ptRdr\n",


