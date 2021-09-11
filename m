Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134E340775C
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbhIKNQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236090AbhIKNOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:14:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79D71611CC;
        Sat, 11 Sep 2021 13:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365979;
        bh=8YZEMHsLG3BuOCuXFZG8Zydc7f/xFEd6Ys2Rg4ECE7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JH6VMTo/zG+m67fFa73HMNtYlpbjyiC2YeAcM/xLONe6d/OdYBSsV5g/Bxm+JaRl3
         ZyOHSb7f4hij3FTzD2sTPBYz2LAdNupHmgZR0Uqk+qFKQj4kEnnx0F+KzaXSOH006I
         ngk/p6Al52EORoMPwVKBijxHEiugqYFf22ouCU6k3GOIzeGehKb6CJVfrOlXUAWMGu
         asmESqQG3X0mcuuXpmhj6NpkFg60UYx0jwYodTJvD7tFixKttDgs5X+bxjlJOJoPb6
         q9sIe+ULyZ5a0dx5HIZfFENWev6Wa0G83rwRb0OejBf8sF3OSiMCEu9sSqHhC1IqAa
         0ITzqiumT5POw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 19/29] watchdog: Start watchdog in watchdog_set_last_hw_keepalive only if appropriate
Date:   Sat, 11 Sep 2021 09:12:23 -0400
Message-Id: <20210911131233.284800-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131233.284800-1-sashal@kernel.org>
References: <20210911131233.284800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit dbe80cf471f940db3063197b7adb1169f89be9ed ]

We must not pet a running watchdog when handle_boot_enabled is off
because this will kick off automatic triggering before userland is
running, defeating the purpose of the handle_boot_enabled control.
Furthermore, don't ping in case watchdog_set_last_hw_keepalive was
called incorrectly when the hardware watchdog is actually not running.

Fixed: cef9572e9af3 ("watchdog: add support for adjusting last known HW keepalive time")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/93d56386-6e37-060b-55ce-84de8cde535f@web.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 2946f3a63110..2ee017442dfc 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1164,7 +1164,10 @@ int watchdog_set_last_hw_keepalive(struct watchdog_device *wdd,
 
 	wd_data->last_hw_keepalive = ktime_sub(now, ms_to_ktime(last_ping_ms));
 
-	return __watchdog_ping(wdd);
+	if (watchdog_hw_running(wdd) && handle_boot_enabled)
+		return __watchdog_ping(wdd);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(watchdog_set_last_hw_keepalive);
 
-- 
2.30.2

