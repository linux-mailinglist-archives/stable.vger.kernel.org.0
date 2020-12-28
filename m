Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8576D2E405E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504240AbgL1Ovi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502095AbgL1OTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A898121D94;
        Mon, 28 Dec 2020 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165158;
        bh=ixOEE7phzSi3SLivtlBc9MuGcz4AkwIHzh0zfDAMKDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BrbL3+avqfy5YT2+2JEY6tuIxmF3A44NtiXg+IzgrnskNOj9NeZaQXBKx9FPq3Lwt
         4gadxJOBupHlb59uidANhEHc/KsNRA2iNqoy3pfjP7dDI3xj3Ol/F+zNEFcW/AZXz1
         gXr9xAIqiSsbbOJ0vYmK09V/YxK2K9b6T/3x4kXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Wensheng <wangwensheng4@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 432/717] watchdog: Fix potential dereferencing of null pointer
Date:   Mon, 28 Dec 2020 13:47:10 +0100
Message-Id: <20201228125041.668154203@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Wensheng <wangwensheng4@huawei.com>

[ Upstream commit 6f733cb2e7db38f8141b14740bcde577844a03b7 ]

A reboot notifier, which stops the WDT by calling the stop hook without
any check, would be registered when we set WDOG_STOP_ON_REBOOT flag.

Howerer we allow the WDT driver to omit the stop hook since commit
"d0684c8a93549" ("watchdog: Make stop function optional") and provide
a module parameter for user that controls the WDOG_STOP_ON_REBOOT flag
in commit 9232c80659e94 ("watchdog: Add stop_on_reboot parameter to
control reboot policy"). Together that commits make user potential to
insert a watchdog driver that don't provide a stop hook but with the
stop_on_reboot parameter set, then dereferencing of null pointer occurs
on system reboot.

Check the stop hook before registering the reboot notifier to fix the
issue.

Fixes: d0684c8a9354 ("watchdog: Make stop function optional")
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20201109130512.28121-1-wangwensheng4@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_core.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 4238447578128..0e9a99559609c 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -267,15 +267,19 @@ static int __watchdog_register_device(struct watchdog_device *wdd)
 	}
 
 	if (test_bit(WDOG_STOP_ON_REBOOT, &wdd->status)) {
-		wdd->reboot_nb.notifier_call = watchdog_reboot_notifier;
-
-		ret = register_reboot_notifier(&wdd->reboot_nb);
-		if (ret) {
-			pr_err("watchdog%d: Cannot register reboot notifier (%d)\n",
-			       wdd->id, ret);
-			watchdog_dev_unregister(wdd);
-			ida_simple_remove(&watchdog_ida, id);
-			return ret;
+		if (!wdd->ops->stop)
+			pr_warn("watchdog%d: stop_on_reboot not supported\n", wdd->id);
+		else {
+			wdd->reboot_nb.notifier_call = watchdog_reboot_notifier;
+
+			ret = register_reboot_notifier(&wdd->reboot_nb);
+			if (ret) {
+				pr_err("watchdog%d: Cannot register reboot notifier (%d)\n",
+					wdd->id, ret);
+				watchdog_dev_unregister(wdd);
+				ida_simple_remove(&watchdog_ida, id);
+				return ret;
+			}
 		}
 	}
 
-- 
2.27.0



