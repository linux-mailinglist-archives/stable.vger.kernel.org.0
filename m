Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7E845BF09
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244907AbhKXMyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345961AbhKXMwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:52:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 976046152A;
        Wed, 24 Nov 2021 12:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757039;
        bh=FVOvnMvkPK4ksADWDAsi89Fo6Iad0oncQfJ4nlRm52Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbY+uDE19Lo1Kr8XccJ9F1idI6v1JF4NKEF4mSgMyoQNzSUMmivTSlvKRKqZkj4u6
         3hW9HD//VpYZIShP3mCwfGNZmGr8M7LGAEEYOkThQyf8aSwuWhnz8QUql/qRRWP7fa
         yfgFUL8uTZbcUrfCj+j5sGZiflw0krsELaNUGckk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Walter Stoll <walter.stoll@duagon.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/323] watchdog: Fix OMAP watchdog early handling
Date:   Wed, 24 Nov 2021 12:53:46 +0100
Message-Id: <20211124115720.088836751@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index cbd752f9ac563..7376ba56cdf2e 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -272,8 +272,12 @@ static int omap_wdt_probe(struct platform_device *pdev)
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



