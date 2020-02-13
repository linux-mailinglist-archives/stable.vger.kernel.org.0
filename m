Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 567CA15C211
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgBMP2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbgBMP2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:50 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5CEA2465D;
        Thu, 13 Feb 2020 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607730;
        bh=vF3vpiJfV5jRF2elPwqFz17RlyJWH7ft1gujGBsgYYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6SMki5fdIEjMBYyqlA9N0M94YdYG4F93C5eP7TLMnK8CYqK5aP8KERV1vwbbmaxy
         7itek2APbzpOZMSQSg/JfvTHYyMOsG28872D4LYoqh11wE51ENIIuBpIAz3QcRZSvo
         0gmLgQiom5wQyTAnomf9K44PgpGAlWtNTFJ0RHdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Boyd <swboyd@chromium.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.5 051/120] watchdog: qcom: Use platform_get_irq_optional() for bark irq
Date:   Thu, 13 Feb 2020 07:20:47 -0800
Message-Id: <20200213151919.340210137@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

commit e0b4f4e0cf7fa9d62628d4249c765ec18dffd143 upstream.

platform_get_irq() prints an error message when the interrupt
is not available. So on platforms where bark interrupt is
not specified, following error message is observed on SDM845.

[    2.975888] qcom_wdt 17980000.watchdog: IRQ index 0 not found

This is also seen on SC7180, SM8150 SoCs as well.
Fix this by using platform_get_irq_optional() instead.

Fixes: 36375491a4395654 ("watchdog: qcom: support pre-timeout when the bark irq is available")
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20191213064934.4112-1-saiprakash.ranjan@codeaurora.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/qcom-wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/qcom-wdt.c
+++ b/drivers/watchdog/qcom-wdt.c
@@ -246,7 +246,7 @@ static int qcom_wdt_probe(struct platfor
 	}
 
 	/* check if there is pretimeout support */
-	irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq_optional(pdev, 0);
 	if (irq > 0) {
 		ret = devm_request_irq(dev, irq, qcom_wdt_isr,
 				       IRQF_TRIGGER_RISING,


