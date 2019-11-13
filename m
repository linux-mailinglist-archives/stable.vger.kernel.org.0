Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A0EFA5F9
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfKMBvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:51:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbfKMBvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 452AD222CE;
        Wed, 13 Nov 2019 01:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609878;
        bh=pPjVqW+TzBuF+V00o4hpuDk0lt7UMlrEz4zrYZiDHD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWlSwcOjpb3KxVjp03ruAD4FXiI1ov+oGmYWYTE32EEUHJ1MV8vp8Zf1MZYouFCa3
         i6svsa1QsvY92CS23PzDpO6y+tBm1Q5ZQZjCBk7+N6G03MC8vAifO8Txi+5c+8m0un
         O/rBKd1KNbVpbdH/oo4k9oZX+LJvEEXqrONQPB2E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Romain Izard <romain.izard.pro@gmail.com>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 040/209] watchdog: sama5d4: fix timeout-sec usage
Date:   Tue, 12 Nov 2019 20:47:36 -0500
Message-Id: <20191113015025.9685-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

