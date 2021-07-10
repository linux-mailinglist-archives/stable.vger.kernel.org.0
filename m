Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38D63C398E
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhGKAA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 20:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233227AbhGJX6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:58:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48426613D7;
        Sat, 10 Jul 2021 23:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961191;
        bh=Z1n8wsZv+jOd5MN9VkohCRg6WHiM6xigm4+S3agCXjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjDTp449YII5OHNc1xtkv4LRj8SVhRmkIYPlJNk9TUQwtK85P2ncxqkTms6OhwPP4
         YqKhtR3AzNpeODbm1KcG9E63gH4JE6K8BJO+BYB3D+MA61nRwQmMh3LWK5AW3uT+TB
         v4AuDl1/aVplJ77PA0nYuTMqEmphEADthDilN3ob/NlpFx/u34Frkb5QCDuj/zeJk8
         cPHe5n22enDfQ08yvlqgxmd+KH7xTjs1ep78dj4fh8FLPOjYaAs8a61o5kc8TmvKc8
         tjxBpmVqTbzcY55dk2ZE765dFkOa5Lphg1dQy4VyLGJuv+Pua/cB0bmnNP/mJ+V9Df
         96Bj1pXrbT7mQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/12] watchdog: sc520_wdt: Fix possible use-after-free in wdt_turnoff()
Date:   Sat, 10 Jul 2021 19:52:56 -0400
Message-Id: <20210710235302.3222809-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235302.3222809-1-sashal@kernel.org>
References: <20210710235302.3222809-1-sashal@kernel.org>
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
index 1cfd3f6a13d5..08500db8324f 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -190,7 +190,7 @@ static int wdt_startup(void)
 static int wdt_turnoff(void)
 {
 	/* Stop the timer */
-	del_timer(&timer);
+	del_timer_sync(&timer);
 
 	/* Stop the watchdog */
 	wdt_config(0);
-- 
2.30.2

