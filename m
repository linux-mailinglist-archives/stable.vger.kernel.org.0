Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF0C450AC3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbhKOROe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232473AbhKORM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:12:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8A7D63238;
        Mon, 15 Nov 2021 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996202;
        bh=hVirGNAM+IwRFxwFSJqDgKWbJuDQREgWjMEvmcDtHFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqGbjAuu9JgFxFs/rNK6akfO09v47jxzkw7iWBBvyigENgIxnWV5QrctqNderCIfO
         dzr5eIEKdRH0mJiqBb9kso/cfvPoJN5yc8PQ45uwB0DMtFwmoEJTPS1YeKHQqAJdfy
         vJm5GCLaYU6qOLUw1WQS94GgLhwQYbUf30/8vYh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Walter Stoll <walter.stoll@duagon.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/355] watchdog: Fix OMAP watchdog early handling
Date:   Mon, 15 Nov 2021 17:59:37 +0100
Message-Id: <20211115165315.261440416@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Walter Stoll <walter.stoll@duagon.com>

[ Upstream commit cd004d8299f1dc6cfa6a4eea8f94cb45eaedf070 ]

TI's implementation does not service the watchdog even if the kernel
command line parameter omap_wdt.early_enable is set to 1. This patch
fixes the issue.

Signed-off-by: Walter Stoll <walter.stoll@duagon.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/88a8fe5229cd68fa0f1fd22f5d66666c1b7057a0.camel@duagon.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/omap_wdt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 9b91882fe3c41..6d7ccbc0b666c 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -268,8 +268,12 @@ static int omap_wdt_probe(struct platform_device *pdev)
 			wdev->wdog.bootstatus = WDIOF_CARDRESET;
 	}
 
-	if (!early_enable)
+	if (early_enable) {
+		omap_wdt_start(&wdev->wdog);
+		set_bit(WDOG_HW_RUNNING, &wdev->wdog.status);
+	} else {
 		omap_wdt_disable(wdev);
+	}
 
 	ret = watchdog_register_device(&wdev->wdog);
 	if (ret) {
-- 
2.33.0



