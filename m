Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A13F304178
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 16:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406046AbhAZPGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 10:06:14 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:12190 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406093AbhAZPEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 10:04:49 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611673459; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=IztOt7KkSVqYmC1VzzYEoYQ79+qoX3F00dyOKDY9YFY=; b=C2C43MX+R3UhEkt+Cc0gB/CUYLlmPE7n6nylOECXsqKuETj8kzQjsdoQCW1Q59JjZx8wVNTo
 WWqkRvoGNlK6dMBlbFoyhgRca97BoeaCuQVxmj/qEIaTBGf+OGmOrr9s7sfM0ippYJ7No9ns
 Xe0Yazfxgei/osHSYADPI31YWN4=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60102f305677aca7bd5a4f8f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 26 Jan 2021 15:03:12
 GMT
Sender: saiprakash.ranjan=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 05215C43461; Tue, 26 Jan 2021 15:03:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from blr-ubuntu-253.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: saiprakash.ranjan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 51099C433CA;
        Tue, 26 Jan 2021 15:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 51099C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=saiprakash.ranjan@codeaurora.org
From:   Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-watchdog@vger.kernel.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        jorge@foundries.io
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH] watchdog: qcom: Remove incorrect usage of QCOM_WDT_ENABLE_IRQ
Date:   Tue, 26 Jan 2021 20:32:41 +0530
Message-Id: <20210126150241.10009-1-saiprakash.ranjan@codeaurora.org>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As per register documentation, QCOM_WDT_ENABLE_IRQ which is BIT(1)
of watchdog control register is wakeup interrupt enable bit and
not related to bark interrupt at all, BIT(0) is used for that.
So remove incorrect usage of this bit when supporting bark irq for
pre-timeout notification. Currently with this bit set and bark
interrupt specified, pre-timeout notification and/or watchdog
reset/bite does not occur.

Fixes: 36375491a439 ("watchdog: qcom: support pre-timeout when the bark irq is available")
Cc: stable@vger.kernel.org
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
---

Reading the conversations from when qcom pre-timeout support was
added [1], Bjorn already had mentioned it was not right to touch this
bit, not sure which SoC the pre-timeout was tested on at that time,
but I have tested this on SDM845, SM8150, SC7180 and watchdog bark
and bite does not occur with enabling this bit with the bark irq
specified in DT.

[1] https://lore.kernel.org/linux-watchdog/20190906174009.GC11938@tuxbook-pro/

---
 drivers/watchdog/qcom-wdt.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
index 7cf0f2ec649b..e38a87ffe5f5 100644
--- a/drivers/watchdog/qcom-wdt.c
+++ b/drivers/watchdog/qcom-wdt.c
@@ -22,7 +22,6 @@ enum wdt_reg {
 };
 
 #define QCOM_WDT_ENABLE		BIT(0)
-#define QCOM_WDT_ENABLE_IRQ	BIT(1)
 
 static const u32 reg_offset_data_apcs_tmr[] = {
 	[WDT_RST] = 0x38,
@@ -63,16 +62,6 @@ struct qcom_wdt *to_qcom_wdt(struct watchdog_device *wdd)
 	return container_of(wdd, struct qcom_wdt, wdd);
 }
 
-static inline int qcom_get_enable(struct watchdog_device *wdd)
-{
-	int enable = QCOM_WDT_ENABLE;
-
-	if (wdd->pretimeout)
-		enable |= QCOM_WDT_ENABLE_IRQ;
-
-	return enable;
-}
-
 static irqreturn_t qcom_wdt_isr(int irq, void *arg)
 {
 	struct watchdog_device *wdd = arg;
@@ -91,7 +80,7 @@ static int qcom_wdt_start(struct watchdog_device *wdd)
 	writel(1, wdt_addr(wdt, WDT_RST));
 	writel(bark * wdt->rate, wdt_addr(wdt, WDT_BARK_TIME));
 	writel(wdd->timeout * wdt->rate, wdt_addr(wdt, WDT_BITE_TIME));
-	writel(qcom_get_enable(wdd), wdt_addr(wdt, WDT_EN));
+	writel(QCOM_WDT_ENABLE, wdt_addr(wdt, WDT_EN));
 	return 0;
 }
 
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

