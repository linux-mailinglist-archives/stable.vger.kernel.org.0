Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D013C3956
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhGJX6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233089AbhGJX5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6F23613B5;
        Sat, 10 Jul 2021 23:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961167;
        bh=8vf89cqAEiEpOFAna+3saqsBdZd00cUqtRl2GaRnTcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aY/Cy6XNhSYzCb1iFRxPxPSp+b9icbsP2OuWNsExR1QBKRd2n4hjk05/awSa1sjW0
         7ond9aqlg9Sa+Il2EPdNKwuZYARJdHnaaBW6KMWtziKCg59aQdm22CcDRHlA+5URQA
         /l5pyAlJ1FgpdloC1+R4NMJCb15qHnD2MtsrMdbt6U8ZVbMpfxDIkdbs+cGYzmPwkO
         rEf9c6TKp00G+h33AUT6gPR7i9ZiauYW/nxgczLdCYvF36Qj6PW9SoOPV/wiESWtKL
         fgMW1gMv5qN2O2GSKoZqAgg2CLysBfWwl6xpKzxnemiexjJ9CRXTA8h4QAfmCDQLCc
         zKstupBoaNeZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/16] watchdog: Fix possible use-after-free in wdt_startup()
Date:   Sat, 10 Jul 2021 19:52:29 -0400
Message-Id: <20210710235240.3222618-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235240.3222618-1-sashal@kernel.org>
References: <20210710235240.3222618-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit c08a6b31e4917034f0ed0cb457c3bb209576f542 ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/1620716495-108352-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sbc60xxwdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index 2eef58a0cf05..152db059d5aa 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -152,7 +152,7 @@ static void wdt_startup(void)
 static void wdt_turnoff(void)
 {
 	/* Stop the timer */
-	del_timer(&timer);
+	del_timer_sync(&timer);
 	inb_p(wdt_stop);
 	pr_info("Watchdog timer is now disabled...\n");
 }
-- 
2.30.2

