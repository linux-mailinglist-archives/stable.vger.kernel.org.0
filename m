Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5F9106D28
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbfKVK56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:57:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730742AbfKVK56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFC322073B;
        Fri, 22 Nov 2019 10:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420277;
        bh=pPjVqW+TzBuF+V00o4hpuDk0lt7UMlrEz4zrYZiDHD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCzWHFHQvb+bHKex08ljJvRi3j9SWq/SFku//HKTHu9K2zC7zDUa6CpRZ9VHwnxD/
         KbYnsY0FUKToDBE7lQNwKtqVCZRQ+XMy6F739222cnPokFXukPyZABGIQTYfFsLY+C
         Hb9yRLQ5iTUxQ/ZDgCu2JSi2WZIJKQWgZYK+Hhf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Romain Izard <romain.izard.pro@gmail.com>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/220] watchdog: sama5d4: fix timeout-sec usage
Date:   Fri, 22 Nov 2019 11:26:57 +0100
Message-Id: <20191122100915.919777684@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Romain Izard <romain.izard.pro@gmail.com>

[ Upstream commit 2e0432f8f8ad11b4bd208445360220efa5b37d82 ]

When using watchdog_init_timeout to update the default timeout value,
an error means that there is no "timeout-sec" in the relevant device
tree node.

This should not prevent binding of the driver to the device.

Fixes: 976932e40036 ("watchdog: sama5d4: make use of timeout-secs provided in devicetree")
Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
Reviewed-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sama5d4_wdt.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/watchdog/sama5d4_wdt.c b/drivers/watchdog/sama5d4_wdt.c
index 255169916dbb6..1e93c1b0e3cfc 100644
--- a/drivers/watchdog/sama5d4_wdt.c
+++ b/drivers/watchdog/sama5d4_wdt.c
@@ -247,11 +247,7 @@ static int sama5d4_wdt_probe(struct platform_device *pdev)
 		}
 	}
 
-	ret = watchdog_init_timeout(wdd, wdt_timeout, &pdev->dev);
-	if (ret) {
-		dev_err(&pdev->dev, "unable to set timeout value\n");
-		return ret;
-	}
+	watchdog_init_timeout(wdd, wdt_timeout, &pdev->dev);
 
 	timeout = WDT_SEC2TICKS(wdd->timeout);
 
-- 
2.20.1



