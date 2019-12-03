Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E428111FA4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfLCXKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbfLCWly (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AB132084F;
        Tue,  3 Dec 2019 22:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412914;
        bh=5o3M3UYp5jDE3x0RN1DzajD151l0mFd9GSKZfDzrcyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlSp2XahCHL/RmAaZcIFQcDEH21md2Bk7zpMpQgkGAjvCzPFbGGmM9QmVkJ7hpCNv
         04UqRKmANmcJw3jXywd9ecmmirdTQRKtm6zX64uD3FQPe0oVFQOv5EUt7DoNjNNFIy
         IUil8yZL8mFmb4RhlkQzO9EFKwL1Jl3PAkmDktJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 065/135] watchdog: pm8916_wdt: fix pretimeout registration flow
Date:   Tue,  3 Dec 2019 23:35:05 +0100
Message-Id: <20191203213024.737650554@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>

[ Upstream commit 1993f1d7ca3f315e0459c58c8e7038039a96dd85 ]

When an IRQ is present in the dts, the probe function shall fail if
the interrupt can not be registered.

The probe function shall also be retried if getting the irq is being
deferred.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/pm8916_wdt.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/pm8916_wdt.c b/drivers/watchdog/pm8916_wdt.c
index 2d3652004e39c..1213179f863c2 100644
--- a/drivers/watchdog/pm8916_wdt.c
+++ b/drivers/watchdog/pm8916_wdt.c
@@ -163,9 +163,17 @@ static int pm8916_wdt_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq > 0) {
-		if (devm_request_irq(dev, irq, pm8916_wdt_isr, 0, "pm8916_wdt",
-				     wdt))
-			irq = 0;
+		err = devm_request_irq(dev, irq, pm8916_wdt_isr, 0,
+				       "pm8916_wdt", wdt);
+		if (err)
+			return err;
+
+		wdt->wdev.info = &pm8916_wdt_pt_ident;
+	} else {
+		if (irq == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		wdt->wdev.info = &pm8916_wdt_ident;
 	}
 
 	/* Configure watchdog to hard-reset mode */
@@ -177,7 +185,6 @@ static int pm8916_wdt_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	wdt->wdev.info = (irq > 0) ? &pm8916_wdt_pt_ident : &pm8916_wdt_ident,
 	wdt->wdev.ops = &pm8916_wdt_ops,
 	wdt->wdev.parent = dev;
 	wdt->wdev.min_timeout = PM8916_WDT_MIN_TIMEOUT;
-- 
2.20.1



