Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE2C328E99
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241997AbhCATeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:34:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241715AbhCAT2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:28:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19D8765270;
        Mon,  1 Mar 2021 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619802;
        bh=NDRW62qnRvyWrPNdc9LmBSFs6kuxQsxGHc7S/pWcmUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6l0p/QE4Ahodyfb0Pvxcga62iJftbjEv60B6kd7cqtoT9T7THrPImBP10GHw0BSX
         2Ge0t0XRWySf9AS7+xAA2tIWJqKyaPJ7lzEWmpXqAZftGyd7NDy1nrqBCLS+4T/m3R
         Sdpy5kqg+c8iRzQgHJCSIm/zrGk+wtuv0az1czzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Boyd <swboyd@chromium.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.10 585/663] watchdog: qcom: Remove incorrect usage of QCOM_WDT_ENABLE_IRQ
Date:   Mon,  1 Mar 2021 17:13:53 +0100
Message-Id: <20210301161210.804408190@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

commit a4f3407c41605d14f09e490045d0609990cd5d94 upstream.

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
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210126150241.10009-1-saiprakash.ranjan@codeaurora.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/qcom-wdt.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/watchdog/qcom-wdt.c
+++ b/drivers/watchdog/qcom-wdt.c
@@ -22,7 +22,6 @@ enum wdt_reg {
 };
 
 #define QCOM_WDT_ENABLE		BIT(0)
-#define QCOM_WDT_ENABLE_IRQ	BIT(1)
 
 static const u32 reg_offset_data_apcs_tmr[] = {
 	[WDT_RST] = 0x38,
@@ -63,16 +62,6 @@ struct qcom_wdt *to_qcom_wdt(struct watc
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
@@ -91,7 +80,7 @@ static int qcom_wdt_start(struct watchdo
 	writel(1, wdt_addr(wdt, WDT_RST));
 	writel(bark * wdt->rate, wdt_addr(wdt, WDT_BARK_TIME));
 	writel(wdd->timeout * wdt->rate, wdt_addr(wdt, WDT_BITE_TIME));
-	writel(qcom_get_enable(wdd), wdt_addr(wdt, WDT_EN));
+	writel(QCOM_WDT_ENABLE, wdt_addr(wdt, WDT_EN));
 	return 0;
 }
 


