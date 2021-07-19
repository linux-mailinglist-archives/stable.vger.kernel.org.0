Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08E63CE2F5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbhGSPc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347549AbhGSPTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FFCF606A5;
        Mon, 19 Jul 2021 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710304;
        bh=YeRPjHzK5EX/g2s1sPPjUmg37Dt96+T3QGH7KXDyeJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQb/uJsh/h5kf0CxNJ5TvlCvZxJjWfiBTq0Rg73kM0s1aKv7lVAY3pOB/QF2xmgSH
         XvDrsH5R5Mr4b1kPFyhNHX7GF3elkfb+o6bsy7S3cZ9Jvc0fCTVUiePMVvV04Llwd7
         qIh7tVYv+GL2+XKF53JwXEWYhYuuV0s29W5uiCEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amithash Prasad <amithash@fb.com>,
        Tao Ren <rentao.bupt@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/243] watchdog: aspeed: fix hardware timeout calculation
Date:   Mon, 19 Jul 2021 16:53:10 +0200
Message-Id: <20210719144946.097638229@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

[ Upstream commit e7dc481c92060f9ce872878b0b7a08c24713a7e5 ]

Fix hardware timeout calculation in aspeed_wdt_set_timeout function to
ensure the reload value does not exceed the hardware limit.

Fixes: efa859f7d786 ("watchdog: Add Aspeed watchdog driver")
Reported-by: Amithash Prasad <amithash@fb.com>
Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20210417034249.5978-1-rentao.bupt@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/aspeed_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/aspeed_wdt.c b/drivers/watchdog/aspeed_wdt.c
index 7e00960651fa..507fd815d767 100644
--- a/drivers/watchdog/aspeed_wdt.c
+++ b/drivers/watchdog/aspeed_wdt.c
@@ -147,7 +147,7 @@ static int aspeed_wdt_set_timeout(struct watchdog_device *wdd,
 
 	wdd->timeout = timeout;
 
-	actual = min(timeout, wdd->max_hw_heartbeat_ms * 1000);
+	actual = min(timeout, wdd->max_hw_heartbeat_ms / 1000);
 
 	writel(actual * WDT_RATE_1MHZ, wdt->base + WDT_RELOAD_VALUE);
 	writel(WDT_RESTART_MAGIC, wdt->base + WDT_RESTART);
-- 
2.30.2



