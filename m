Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B163CE2D7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhGSPc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347951AbhGSPaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97568613CC;
        Mon, 19 Jul 2021 16:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710981;
        bh=0rOQmzH2/RHjeIWMPO1I5FaTDOuQ4tbgwtr7wXAqSH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvRV09LNul3dWZIZQRmpGNH3dgGqhfevrTHNAKx9K723ER8co5kjEUxTNzqh39KLz
         GSRYvUJnMQT1nnu5DT7Bk1toFDcZMC3jw4ktisL3oxMIadDBj7BhuDVwekF9A5NsIT
         fJvjs8LCw8/EFoUmSmQF92v20f+dE2T0D4f9x45M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 165/351] watchdog: Fix possible use-after-free in wdt_startup()
Date:   Mon, 19 Jul 2021 16:51:51 +0200
Message-Id: <20210719144950.425310541@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a947a63fb44a..7b974802dfc7 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -146,7 +146,7 @@ static void wdt_startup(void)
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



