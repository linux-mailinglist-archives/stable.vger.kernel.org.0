Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11E72E39FB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390437AbgL1Nal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:30:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389538AbgL1Naj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:30:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7730A20728;
        Mon, 28 Dec 2020 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162224;
        bh=pfD6n+dMjSgsgcCaFqx0s82OEDfqk9zlNEUGjw106Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0RJ7Lcs7Wqiu+M4vdCg4m6MjrHhvUM2zkLHFT5NO7PVz2q3NsT9OAdHztUTxSAhy
         G5xFS1foEkhK1sGj7bd8xVz+ZxmL+qb7gZ+0OqoddVrIJe+qyKLwyRJ0qIS+g1ERmF
         5WCpavwhyCmOcUoHDsz2yDI2MFRJRw7qCcPfb9tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lingling Xu <ling_ling.xu@unisoc.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 230/346] watchdog: sprd: check busy bit before new loading rather than after that
Date:   Mon, 28 Dec 2020 13:49:09 +0100
Message-Id: <20201228124930.893010780@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lingling Xu <ling_ling.xu@unisoc.com>

[ Upstream commit 3e07d240939803bed9feb2a353d94686a411a7ca ]

As the specification described, users must check busy bit before start
a new loading operation to make sure that the previous loading is done
and the device is ready to accept a new one.

[ chunyan: Massaged changelog ]

Fixes: 477603467009 ("watchdog: Add Spreadtrum watchdog driver")
Signed-off-by: Lingling Xu <ling_ling.xu@unisoc.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20201029023933.24548-3-zhang.lyra@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sprd_wdt.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/sprd_wdt.c b/drivers/watchdog/sprd_wdt.c
index ffe0346c5d0eb..86cf93af951b5 100644
--- a/drivers/watchdog/sprd_wdt.c
+++ b/drivers/watchdog/sprd_wdt.c
@@ -116,18 +116,6 @@ static int sprd_wdt_load_value(struct sprd_wdt *wdt, u32 timeout,
 	u32 tmr_step = timeout * SPRD_WDT_CNT_STEP;
 	u32 prtmr_step = pretimeout * SPRD_WDT_CNT_STEP;
 
-	sprd_wdt_unlock(wdt->base);
-	writel_relaxed((tmr_step >> SPRD_WDT_CNT_HIGH_SHIFT) &
-		      SPRD_WDT_LOW_VALUE_MASK, wdt->base + SPRD_WDT_LOAD_HIGH);
-	writel_relaxed((tmr_step & SPRD_WDT_LOW_VALUE_MASK),
-		       wdt->base + SPRD_WDT_LOAD_LOW);
-	writel_relaxed((prtmr_step >> SPRD_WDT_CNT_HIGH_SHIFT) &
-			SPRD_WDT_LOW_VALUE_MASK,
-		       wdt->base + SPRD_WDT_IRQ_LOAD_HIGH);
-	writel_relaxed(prtmr_step & SPRD_WDT_LOW_VALUE_MASK,
-		       wdt->base + SPRD_WDT_IRQ_LOAD_LOW);
-	sprd_wdt_lock(wdt->base);
-
 	/*
 	 * Waiting the load value operation done,
 	 * it needs two or three RTC clock cycles.
@@ -142,6 +130,19 @@ static int sprd_wdt_load_value(struct sprd_wdt *wdt, u32 timeout,
 
 	if (delay_cnt >= SPRD_WDT_LOAD_TIMEOUT)
 		return -EBUSY;
+
+	sprd_wdt_unlock(wdt->base);
+	writel_relaxed((tmr_step >> SPRD_WDT_CNT_HIGH_SHIFT) &
+		      SPRD_WDT_LOW_VALUE_MASK, wdt->base + SPRD_WDT_LOAD_HIGH);
+	writel_relaxed((tmr_step & SPRD_WDT_LOW_VALUE_MASK),
+		       wdt->base + SPRD_WDT_LOAD_LOW);
+	writel_relaxed((prtmr_step >> SPRD_WDT_CNT_HIGH_SHIFT) &
+			SPRD_WDT_LOW_VALUE_MASK,
+		       wdt->base + SPRD_WDT_IRQ_LOAD_HIGH);
+	writel_relaxed(prtmr_step & SPRD_WDT_LOW_VALUE_MASK,
+		       wdt->base + SPRD_WDT_IRQ_LOAD_LOW);
+	sprd_wdt_lock(wdt->base);
+
 	return 0;
 }
 
-- 
2.27.0



