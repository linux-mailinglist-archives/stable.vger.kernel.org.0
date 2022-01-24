Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A627E49992B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454141AbiAXVbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451496AbiAXVXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:23:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F642C0617AE;
        Mon, 24 Jan 2022 12:17:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 282A4B81218;
        Mon, 24 Jan 2022 20:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE40C340E5;
        Mon, 24 Jan 2022 20:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055450;
        bh=LQFQXJKh8AgcmpSq95ncbAZc/m3gURnAWKojwDiSKVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNKiD9yCo3b6y7kVWetW80FyWWtEKPgi0ksiIU0cALBs5X64YhhyuetxmSqX0ZQKX
         6AvPmht7SYtKo43u375ews+YfZBHpXg0Y5KwaFAfwrxMHdFyIJDEgbSirnTk1UxLRl
         LumURbEy3r0T5u13n0SJbIYoIW8fZLxU1Nt8oFCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/846] mfd: atmel-flexcom: Remove #ifdef CONFIG_PM_SLEEP
Date:   Mon, 24 Jan 2022 19:34:33 +0100
Message-Id: <20220124184106.371832184@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 8c0fad75dcaa650e3f3145a2c35847bc6a65cb7f ]

Remove compilation flag and use __maybe_unused and pm_ptr instead.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211028135138.3481166-2-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/atmel-flexcom.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/atmel-flexcom.c b/drivers/mfd/atmel-flexcom.c
index d2f5c073fdf31..962f66dc8813e 100644
--- a/drivers/mfd/atmel-flexcom.c
+++ b/drivers/mfd/atmel-flexcom.c
@@ -87,8 +87,7 @@ static const struct of_device_id atmel_flexcom_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, atmel_flexcom_of_match);
 
-#ifdef CONFIG_PM_SLEEP
-static int atmel_flexcom_resume(struct device *dev)
+static int __maybe_unused atmel_flexcom_resume(struct device *dev)
 {
 	struct atmel_flexcom *ddata = dev_get_drvdata(dev);
 	int err;
@@ -105,7 +104,6 @@ static int atmel_flexcom_resume(struct device *dev)
 
 	return 0;
 }
-#endif
 
 static SIMPLE_DEV_PM_OPS(atmel_flexcom_pm_ops, NULL,
 			 atmel_flexcom_resume);
@@ -114,7 +112,7 @@ static struct platform_driver atmel_flexcom_driver = {
 	.probe	= atmel_flexcom_probe,
 	.driver	= {
 		.name		= "atmel_flexcom",
-		.pm		= &atmel_flexcom_pm_ops,
+		.pm		= pm_ptr(&atmel_flexcom_pm_ops),
 		.of_match_table	= atmel_flexcom_of_match,
 	},
 };
-- 
2.34.1



