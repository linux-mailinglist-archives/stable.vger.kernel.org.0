Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4DC148434
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390714AbgAXLSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:18:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390498AbgAXLSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:18:52 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6829E20704;
        Fri, 24 Jan 2020 11:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864732;
        bh=bFdSWV6KGot4Ftog2vGlmBdgbfDjbkKx2e5oo65z+lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mq+XFsBZgjkDn+MQn1/sECqYT7gXaTiz3qkEkiQTujcOgR1TbRUcizL4eYJ7iC5oy
         vwFhhT0LaM+6qCV0FbuDSdiyqJaLc8BJdT0nQO3HqHzfQi+jqIN666Z8pUi8laiqqp
         mlGCJ3esiJjpRkyhKqFMCjeEcSbtuIoKRDpatYpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 350/639] watchdog: rtd119x_wdt: Fix remove function
Date:   Fri, 24 Jan 2020 10:28:40 +0100
Message-Id: <20200124093130.961598598@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d001c17ddfdee..99caec6882d2f 100644
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



