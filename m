Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5C91F2BDD
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbgFHXSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbgFHXSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B39A20885;
        Mon,  8 Jun 2020 23:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658289;
        bh=wtn7EdCa698or5TkAj8+NLx0LcLzplalDi2MP5Q8pLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnI78AOL2TsgopTvdxpGcOn7fWM9IrOk0Bp0JT4uQ/nhWEY8tAFv2iOPub777xUy7
         S00klizWhOgwXkkIQFAlD28KiC1QavC3j5TTgRr0A9gWPXmr7OSbemZeZH/HEUvB8j
         J9n3RcLoVw8BpY7on7ye5MGVlqtKgRbAZ1xUgKnM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 293/606] gpio: mvebu: Fix probing for chips without PWM
Date:   Mon,  8 Jun 2020 19:06:58 -0400
Message-Id: <20200608231211.3363633-293-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 19c26d90ff4ca08ef2a2fef23cc9c13cfbfd891e ]

The PWM iomem resource is optional and its presence indicates whether
the GPIO chip has a PWM or not, which is why mvebu_pwm_probe() returned
successfully when the PWM resource was not present. With f51b18d92b66
the driver switched to devm_platform_ioremap_resource_byname() and
its error return is propagated to the caller, so now a missing PWM resource
leads to a probe error in the driver.

To fix this explicitly test for the presence of the PWM resource and
return successfully when it's not there. Do this check before the check
for the clock is done (which GPIO chips without a PWM do not have). Also
move the existing comment why the PWM resource is optional up to the
actual check.

Fixes: f51b18d92b66 ("gpio: mvebu: use devm_platform_ioremap_resource_byname()")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index d2b999c7987f..f0c5433a327f 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -782,6 +782,15 @@ static int mvebu_pwm_probe(struct platform_device *pdev,
 				     "marvell,armada-370-gpio"))
 		return 0;
 
+	/*
+	 * There are only two sets of PWM configuration registers for
+	 * all the GPIO lines on those SoCs which this driver reserves
+	 * for the first two GPIO chips. So if the resource is missing
+	 * we can't treat it as an error.
+	 */
+	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "pwm"))
+		return 0;
+
 	if (IS_ERR(mvchip->clk))
 		return PTR_ERR(mvchip->clk);
 
@@ -804,12 +813,6 @@ static int mvebu_pwm_probe(struct platform_device *pdev,
 	mvchip->mvpwm = mvpwm;
 	mvpwm->mvchip = mvchip;
 
-	/*
-	 * There are only two sets of PWM configuration registers for
-	 * all the GPIO lines on those SoCs which this driver reserves
-	 * for the first two GPIO chips. So if the resource is missing
-	 * we can't treat it as an error.
-	 */
 	mvpwm->membase = devm_platform_ioremap_resource_byname(pdev, "pwm");
 	if (IS_ERR(mvpwm->membase))
 		return PTR_ERR(mvpwm->membase);
-- 
2.25.1

