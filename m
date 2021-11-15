Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E85450F18
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbhKOS0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241176AbhKOSYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:24:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE5C961B64;
        Mon, 15 Nov 2021 17:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998854;
        bh=9ZOTFdy0CLvC9AoTM8EzwRZpMivbNxO48sYLBUK+xf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJ+ndj0YesOwo0OcUZDIbDyqJHSI69N+KLJEIGam/6oeobskZUuqjGSxFgm98hVLd
         DFp1ZQ7ySWcpkkKfC/k7/07ifNem66wpETnrocHB+KJdZRw5tB5+AOCl57TK0vl1ZP
         JnEBNgeHLfJBvaOkR5oM7WDzQhaL/EoweURYcuGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Walter Stoll <walter.stoll@duagon.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 086/849] watchdog: Fix OMAP watchdog early handling
Date:   Mon, 15 Nov 2021 17:52:49 +0100
Message-Id: <20211115165422.978143466@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Walter Stoll <walter.stoll@duagon.com>

[ Upstream commit cd004d8299f1dc6cfa6a4eea8f94cb45eaedf070 ]

TI's implementation does not service the watchdog even if the kernel
command line parameter omap_wdt.early_enable is set to 1. This patch
fixes the issue.

Signed-off-by: Walter Stoll <walter.stoll@duagon.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/88a8fe5229cd68fa0f1fd22f5d66666c1b7057a0.camel@duagon.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/omap_wdt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 1616f93dfad7f..74d785b2b478f 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -268,8 +268,12 @@ static int omap_wdt_probe(struct platform_device *pdev)
 			wdev->wdog.bootstatus = WDIOF_CARDRESET;
 	}
 
-	if (!early_enable)
+	if (early_enable) {
+		omap_wdt_start(&wdev->wdog);
+		set_bit(WDOG_HW_RUNNING, &wdev->wdog.status);
+	} else {
 		omap_wdt_disable(wdev);
+	}
 
 	ret = watchdog_register_device(&wdev->wdog);
 	if (ret) {
-- 
2.33.0



