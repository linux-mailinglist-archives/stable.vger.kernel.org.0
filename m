Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357E53CDF2C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345137AbhGSPIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345565AbhGSPEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:04:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1094F6128A;
        Mon, 19 Jul 2021 15:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709456;
        bh=W3YjjptMEBGQZLlHyRQRxy/NRzcHtf1hsTFJCYNcqZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7vjU8JIbsMtr14eK5BaADK8nX8/C+rJRJSo+XbjAXTc9ZXaCkv71W0QoD4QXA/oo
         r6VwKRF7ZNF9V5pyekSODqxfAdqYvRKCixunPv4Gxv4baMSssD99rmqzrm7Jrf7SUQ
         x4pxJSaV2Rj46IB5KiWsXqPAmjQ/wyretafBzmbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 364/421] watchdog: Fix possible use-after-free in wdt_startup()
Date:   Mon, 19 Jul 2021 16:52:55 +0200
Message-Id: <20210719144958.870147710@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 87333a41f753..1702df7f8c38 100644
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



