Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E57328F91
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242320AbhCATxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242259AbhCAToS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B016365042;
        Mon,  1 Mar 2021 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621053;
        bh=KsBIlFCuWO/SvTLiZ3DNi4EKh+Q09SGZIg/htGUJeco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10aKJWBG/PPW8WeBeFoH1Am+vSNi4J2HWIZC2cPniX/toxd7461vDIurEAidg7uTN
         o+VbWiSbhZ81Wd0V9ul/Dv+ezdHHx2ioMSKqinKbm53fOvihu3LZdRXqQ+sPnxPMeH
         tRaCPNuD8Du+bwah/id596PSJ63EsDvjOpLT2gdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 377/775] watchdog: intel-mid_wdt: Postpone IRQ handler registration till SCU is ready
Date:   Mon,  1 Mar 2021 17:09:05 +0100
Message-Id: <20210301161220.231160980@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f285c9532b5bd3de7e37a6203318437cab79bd9a ]

When SCU is not ready and CONFIG_DEBUG_SHIRQ=y we got deferred probe followed
by fired test IRQ which immediately makes kernel panic. Fix this by delaying
IRQ handler registration till SCU is ready.

Fixes: 80ae679b8f86 ("watchdog: intel-mid_wdt: Convert to use new SCU IPC API")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/intel-mid_wdt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/intel-mid_wdt.c b/drivers/watchdog/intel-mid_wdt.c
index 1ae03b64ef8bf..9b2173f765c8c 100644
--- a/drivers/watchdog/intel-mid_wdt.c
+++ b/drivers/watchdog/intel-mid_wdt.c
@@ -154,6 +154,10 @@ static int mid_wdt_probe(struct platform_device *pdev)
 	watchdog_set_nowayout(wdt_dev, WATCHDOG_NOWAYOUT);
 	watchdog_set_drvdata(wdt_dev, mid);
 
+	mid->scu = devm_intel_scu_ipc_dev_get(dev);
+	if (!mid->scu)
+		return -EPROBE_DEFER;
+
 	ret = devm_request_irq(dev, pdata->irq, mid_wdt_irq,
 			       IRQF_SHARED | IRQF_NO_SUSPEND, "watchdog",
 			       wdt_dev);
@@ -162,10 +166,6 @@ static int mid_wdt_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	mid->scu = devm_intel_scu_ipc_dev_get(dev);
-	if (!mid->scu)
-		return -EPROBE_DEFER;
-
 	/*
 	 * The firmware followed by U-Boot leaves the watchdog running
 	 * with the default threshold which may vary. When we get here
-- 
2.27.0



