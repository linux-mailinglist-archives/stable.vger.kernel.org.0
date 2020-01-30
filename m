Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A023E14E16C
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbgA3SoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730811AbgA3SoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D15432082E;
        Thu, 30 Jan 2020 18:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409859;
        bh=qsORcU52zr2Vq4Oqy+qSQle/OTS7u/Pcf1nBx+OzJBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQ9kApeRIXc8bC52KGCGBPez5wX2A3Vn67X2cvEP1L8qbOcqv/Cn7xAZuz3Vtazs8
         Hg2QIv+CaswrQNQzR+xagQCAI3o1NLspic5i/yqcoag5v+xQJuonEQQCcrhQ7TS428
         bMVqzFUKiYuouxJ5xVRQr5UcbaduuBYCUqGOKdkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/110] watchdog: orion: fix platform_get_irq() complaints
Date:   Thu, 30 Jan 2020 19:38:38 +0100
Message-Id: <20200130183622.243888264@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit dcbce5fbcc69bf2553f650004aad44bf390eca73 ]

Fix:

orion_wdt f1020300.watchdog: IRQ index 1 not found

which is caused by platform_get_irq() now complaining when optional
IRQs are not found.  Neither interrupt for orion is required, so
make them both optional.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/E1iahcN-0000AT-Co@rmk-PC.armlinux.org.uk
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/orion_wdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 1cccf8eb1c5d4..8e6dfe76f9c9d 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -602,7 +602,7 @@ static int orion_wdt_probe(struct platform_device *pdev)
 		set_bit(WDOG_HW_RUNNING, &dev->wdt.status);
 
 	/* Request the IRQ only after the watchdog is disabled */
-	irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq_optional(pdev, 0);
 	if (irq > 0) {
 		/*
 		 * Not all supported platforms specify an interrupt for the
@@ -617,7 +617,7 @@ static int orion_wdt_probe(struct platform_device *pdev)
 	}
 
 	/* Optional 2nd interrupt for pretimeout */
-	irq = platform_get_irq(pdev, 1);
+	irq = platform_get_irq_optional(pdev, 1);
 	if (irq > 0) {
 		orion_wdt_info.options |= WDIOF_PRETIMEOUT;
 		ret = devm_request_irq(&pdev->dev, irq, orion_wdt_pre_irq,
-- 
2.20.1



