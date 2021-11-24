Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9718C45BC9B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbhKXMbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343685AbhKXM33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:29:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 113AD6108F;
        Wed, 24 Nov 2021 12:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756276;
        bh=FqW0wWGemMvwvNch1wIPWssto4XkBxiPLA1H7go5zPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDuanhsndCZ2G+Hd3N2ULUSQbkhMNrZgHcnIF1RXWKyMmqY1YT4dCQRbQk4jFBB/h
         fzH1JRoqVJK0JXJqfKLBoYUuqmQ9kXNcDUJhjnxnF+VRt0hGHg2LnH043ihGftsHtB
         SRYRvaQEke/WEdyPZD6azw1M6sQsPGtq/JgCOG24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Walter Stoll <walter.stoll@duagon.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 029/251] watchdog: Fix OMAP watchdog early handling
Date:   Wed, 24 Nov 2021 12:54:31 +0100
Message-Id: <20211124115711.251964974@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 1b02bfa81b296..40c006ee8492d 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -271,8 +271,12 @@ static int omap_wdt_probe(struct platform_device *pdev)
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



