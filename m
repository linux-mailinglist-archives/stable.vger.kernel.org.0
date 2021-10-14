Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A43642DEE3
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 18:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhJNQJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 12:09:48 -0400
Received: from mail.nic.cz ([217.31.204.67]:37392 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231966AbhJNQJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 12:09:48 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Oct 2021 12:09:47 EDT
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8747:7254:5571:3010])
        by mail.nic.cz (Postfix) with ESMTPSA id 65CA2140A27;
        Thu, 14 Oct 2021 17:58:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1634227100; bh=+y37umJZh/NCTAGlBP5Dp1xzrHH7ti5Fo5CeU/5DHfo=;
        h=From:To:Date;
        b=IRjVknKHuooLvpdACTa6XRUUUxUJZvd1BStDuJYHhBPdaDQmCVodAfceoXHlcpSRb
         JqaWCfwUhlKL89J3SJCDOLzY4afz+Gikvfyg54pagZVfXhVTcXl/d1DA+j1rTnTWuf
         EGb5+lEVfCMbUh3oZ5WZ6WhO6Sim6iP7/SDgq72M=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4] watchdog: orion: use 0 for unset heartbeat
Date:   Thu, 14 Oct 2021 17:58:19 +0200
Message-Id: <20211014155819.14680-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.4 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit bb914088bd8a91c382f54d469367b2e5508b5493 upstream.

If the heartbeat module param is not specified we would get an error
message

  watchdog: f1020300.watchdog: driver supplied timeout (4294967295) out of range
  watchdog: f1020300.watchdog: falling back to default timeout (171)

This is because we were initialising heartbeat to -1. By removing the
initialisation (thus letting the C run time initialise it to 0) we
silence the warning message and the default timeout is still used.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200313031312.1485-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
The error message appears also in 5.4, but not 4.19. So apply also for 5.4.
---
 drivers/watchdog/orion_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 8e6dfe76f9c9..4ddb4ea2e4a3 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -52,7 +52,7 @@
 #define WDT_A370_RATIO		(1 << WDT_A370_RATIO_SHIFT)
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
-static int heartbeat = -1;		/* module parameter (seconds) */
+static int heartbeat;		/* module parameter (seconds) */
 
 struct orion_watchdog;
 
-- 
2.32.0

