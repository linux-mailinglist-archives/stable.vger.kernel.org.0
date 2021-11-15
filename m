Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A89F45148A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348832AbhKOUKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344745AbhKOTZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAD65636BD;
        Mon, 15 Nov 2021 19:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003010;
        bh=+eXMQUbTK7EmfoH7qhPKf4mlY/tKwzD5uBt9so9pzys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GniG7aI4xFDQ8gOIoHWLL9TcF+6J1qG1PPbKiMIL6PNDAXk/l/mgAU378FsDjfNlS
         ArcEjRgbwn/WhbES9IEtezXUjauCZZQiPN0ioh4VVSwic3D7j9gEaoZmlWoB82Z2In
         a8fYCbWs5Ad19rASvvr1UMDBPcYm+EKEmKSqtTag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 744/917] watchdog: f71808e_wdt: fix inaccurate report in WDIOC_GETTIMEOUT
Date:   Mon, 15 Nov 2021 18:03:59 +0100
Message-Id: <20211115165454.139586586@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 164483c735190775f29d0dcbac0363adc51a068d ]

The fintek watchdog timer can configure timeouts of second granularity
only up to 255 seconds. Beyond that, the timeout needs to be configured
with minute granularity. WDIOC_GETTIMEOUT should report the actual
timeout configured, not just echo back the timeout configured by the
user. Do so.

Fixes: 96cb4eb019ce ("watchdog: f71808e_wdt: new watchdog driver for Fintek F71808E and F71882FG")
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/5e17960fe8cc0e3cb2ba53de4730b75d9a0f33d5.1628525954.git-series.a.fatoum@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/f71808e_wdt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index f60beec1bbaea..f7d82d2619133 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -228,15 +228,17 @@ static int watchdog_set_timeout(int timeout)
 
 	mutex_lock(&watchdog.lock);
 
-	watchdog.timeout = timeout;
 	if (timeout > 0xff) {
 		watchdog.timer_val = DIV_ROUND_UP(timeout, 60);
 		watchdog.minutes_mode = true;
+		timeout = watchdog.timer_val * 60;
 	} else {
 		watchdog.timer_val = timeout;
 		watchdog.minutes_mode = false;
 	}
 
+	watchdog.timeout = timeout;
+
 	mutex_unlock(&watchdog.lock);
 
 	return 0;
-- 
2.33.0



