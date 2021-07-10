Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DF43C388E
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhGJXz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233425AbhGJXya (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95F22613AF;
        Sat, 10 Jul 2021 23:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961080;
        bh=ms9YRNTIYNavmZmPXDww3mZ1tmy/t85F9z+8UsdPNmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FICOR2iclACOn4bbJClUP38dDtQB+n35JpTogonOmMox9tb4xYcfwZbu8cLBwc9qS
         VL12/U2VMgvYnEk+AH9gvC9VBc9i2a1QIDUWTkxiMYdk+Js/iCfc2Xjasd5LZcolG4
         VN9Bqorui7BjgC1R0/Vbd/C3OZS2ZkkqLddrmuB+u1mExBO3kKzY9PpsKcZqo9tNWR
         0tag2JG/+3+D8lO8jAjNM2PLnLcgDXRMfTG4OdNZGjGGTMFnJeE8v8SL2Jq82CfARs
         CQO+XzVX+DOtCVn2TwjVTEjHVTTqf1GUrUlApK3acRRxpLrQmsuYiEXl2hlTxrW9Ou
         YWq+czRsmRIzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/28] watchdog: sc520_wdt: Fix possible use-after-free in wdt_turnoff()
Date:   Sat, 10 Jul 2021 19:50:49 -0400
Message-Id: <20210710235107.3221840-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 90b7c141132244e8e49a34a4c1e445cce33e07f4 ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/1620716691-108460-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sc520_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index a612128c5f80..57969564c7f9 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -186,7 +186,7 @@ static int wdt_startup(void)
 static int wdt_turnoff(void)
 {
 	/* Stop the timer */
-	del_timer(&timer);
+	del_timer_sync(&timer);
 
 	/* Stop the watchdog */
 	wdt_config(0);
-- 
2.30.2

