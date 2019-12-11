Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAED511B698
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731404AbfLKPNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731400AbfLKPNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D566F2467D;
        Wed, 11 Dec 2019 15:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077201;
        bh=7RziOHfJeJsaaiPT85Sftb0DFf3AWIRTO8IXVor0O+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ok0nBNmOxTh7hbpEum4hrkCbFcct66D4jI55DzHJraIPBbrKt3B8ssqKR3mZI8Npo
         FQEZiKILDr7RSKk5ArnC3nqSV85M2KIMmVkjaXxcQBpM4NNT8lpDF9voQz01SZBcmN
         V9AohPg/csBifP0QOZhQNB7NtNbP/oPOpng4ZrVY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 084/134] watchdog: imx7ulp: Fix reboot hang
Date:   Wed, 11 Dec 2019 10:11:00 -0500
Message-Id: <20191211151150.19073-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 6083ab7b2f3f25022e2e8f4c42f14a8521f47873 ]

The following hang is observed when a 'reboot' command is issued:

# reboot
# Stopping network: OK
Stopping klogd: OK
Stopping syslogd: OK
umount: devtmpfs busy - remounted read-only
[    8.612079] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
The system is going down NOW!
Sent SIGTERM to all processes
Sent SIGKILL to all processes
Requesting system reboot
[   10.694753] reboot: Restarting system
[   11.699008] Reboot failed -- System halted

Fix this problem by adding a .restart ops member.

Fixes: 41b630f41bf7 ("watchdog: Add i.MX7ULP watchdog support")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20191029174037.25381-1-festevam@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/imx7ulp_wdt.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/watchdog/imx7ulp_wdt.c b/drivers/watchdog/imx7ulp_wdt.c
index 5ce51026989a4..ba5d535a6db2e 100644
--- a/drivers/watchdog/imx7ulp_wdt.c
+++ b/drivers/watchdog/imx7ulp_wdt.c
@@ -106,12 +106,28 @@ static int imx7ulp_wdt_set_timeout(struct watchdog_device *wdog,
 	return 0;
 }
 
+static int imx7ulp_wdt_restart(struct watchdog_device *wdog,
+			       unsigned long action, void *data)
+{
+	struct imx7ulp_wdt_device *wdt = watchdog_get_drvdata(wdog);
+
+	imx7ulp_wdt_enable(wdt->base, true);
+	imx7ulp_wdt_set_timeout(&wdt->wdd, 1);
+
+	/* wait for wdog to fire */
+	while (true)
+		;
+
+	return NOTIFY_DONE;
+}
+
 static const struct watchdog_ops imx7ulp_wdt_ops = {
 	.owner = THIS_MODULE,
 	.start = imx7ulp_wdt_start,
 	.stop  = imx7ulp_wdt_stop,
 	.ping  = imx7ulp_wdt_ping,
 	.set_timeout = imx7ulp_wdt_set_timeout,
+	.restart = imx7ulp_wdt_restart,
 };
 
 static const struct watchdog_info imx7ulp_wdt_info = {
-- 
2.20.1

