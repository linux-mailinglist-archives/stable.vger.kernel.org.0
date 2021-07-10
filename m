Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853CC3C381B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhGJXx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhGJXxV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 167F961369;
        Sat, 10 Jul 2021 23:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961035;
        bh=0rOQmzH2/RHjeIWMPO1I5FaTDOuQ4tbgwtr7wXAqSH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuCKLBe1Ozwd+6KZuk/r9zK2n7b3JrBt1aHaT4F+G2Vq4PBIMLi86lDevOCdMHIyr
         QzTv6H882d7oCIfN3KAcrxsyrJR/cazvkoX+yNQ4bKgO/eEhiwOkfPnYyXOD9jICXr
         LUiy6nmqc0VQ3RRcsdMu+3xa7bAMQLN3lzL9I/vsLV3nHPibUxyVwkjImdyXhL0709
         eGkgGAIeuZ2AEipLX0U1ph+ODZ7vUGmXiiamEePBGnoPoSjQYp0RQwh6BH8MTeTRvU
         4SH5eDaSR0+gOk/xuD2eTZMydqQyVdCQD0yVQUBqB2DYpMHi5vIUVcIup1Ee30pbal
         2HcYduFUq5qXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/37] watchdog: Fix possible use-after-free in wdt_startup()
Date:   Sat, 10 Jul 2021 19:49:52 -0400
Message-Id: <20210710235016.3221124-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
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

