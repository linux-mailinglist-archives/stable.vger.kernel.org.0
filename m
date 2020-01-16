Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0828313F5B1
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbgAPS6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389024AbgAPRGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8FF021582;
        Thu, 16 Jan 2020 17:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194413;
        bh=HkmnNsR1/AIFnpJIxKjbHUx1bnzgrSlA32Fwzvhzxdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swz7TVaqcyn8QwyeqFDi2LFRGuIMNH+fLmqhXejHxxNFZnYVs299sNm4X+wGKChWq
         T4duWZNOG9WAdHFVC/4NMKOlh5ph8Grfc2Mk3O2iOTSIUaAvSTE2nHIywNXhNwslAO
         bc23HJGEU+Utn8yG+NzqM9yLoBNDLSLa6lPrkEWc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 335/671] watchdog: rtd119x_wdt: Fix remove function
Date:   Thu, 16 Jan 2020 11:59:33 -0500
Message-Id: <20200116170509.12787-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 8dd29f19512cc75ee470d7bb8ec86af199de23a8 ]

The driver registers the watchdog with devm_watchdog_register_device() but
still calls watchdog_unregister_device() on remove. Since clocks have to
be stopped when removing the driver, after the watchdog device has been
unregistered, we can not drop the call to watchdog_unregister_device().
Use watchdog_register_device() to register the watchdog.

Fixes: 2bdf6acbfead7 ("watchdog: Add Realtek RTD1295")
Cc: Andreas Färber <afaerber@suse.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rtd119x_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/rtd119x_wdt.c b/drivers/watchdog/rtd119x_wdt.c
index d001c17ddfde..99caec6882d2 100644
--- a/drivers/watchdog/rtd119x_wdt.c
+++ b/drivers/watchdog/rtd119x_wdt.c
@@ -135,7 +135,7 @@ static int rtd119x_wdt_probe(struct platform_device *pdev)
 	rtd119x_wdt_set_timeout(&data->wdt_dev, data->wdt_dev.timeout);
 	rtd119x_wdt_stop(&data->wdt_dev);
 
-	ret = devm_watchdog_register_device(&pdev->dev, &data->wdt_dev);
+	ret = watchdog_register_device(&data->wdt_dev);
 	if (ret) {
 		clk_disable_unprepare(data->clk);
 		clk_put(data->clk);
-- 
2.20.1

