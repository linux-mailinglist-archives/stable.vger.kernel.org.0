Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83ED089F5F
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 15:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfHLNOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 09:14:17 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32939 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbfHLNOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 09:14:16 -0400
Received: by mail-lf1-f67.google.com with SMTP id x3so74288029lfc.0
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 06:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aq15uZv8xBi+7QX6pj+P3bLrLuKXC4K13SfaPhpLIj4=;
        b=Y2GjrovYNohFsnsD8ciajT27sqvSn01hpt4Z5PC636oRWvUSmYlb+XE+3ZrBNiBrzC
         U4scsXayonlV3e6+qqmJT6KiKAL+F/rZ4mX7j6hmro2/GItaisZjMbxxHq1v4iuXEQGG
         WDGoLN31V3DZ/jSRog/u6XrPNCSQgRygJkpoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aq15uZv8xBi+7QX6pj+P3bLrLuKXC4K13SfaPhpLIj4=;
        b=KKLX6/HPmiDCh2VcnNGNhDIU92Jq5xiI6pgpMzvjrM5S2obfkwTTOnV5Dytf/9fVYo
         VnzAxIzoLEwA9uGTdYXmFAfGAe64smYodA5yQCgv4wqCESkn565bOTecveTyvfehrRSx
         D2HXHxSrIuVX4RPnCeBTMKw3BwP3kx5jZHV1o0k4UVS3Q1PZy9BPD1ShIYaGthFaWjli
         6QepROlVQVixenSg3A7ku3X727PFhW/6NXNIGOc9s1lxqaFBJJRsxliEBRqkrgv0MO6o
         P3zOF2A+pwcdaHo3to9DR//3GEeEqZDA4t9sJsLhsMYVuOAjIvq+LUoNd9MVnQ+IP/1/
         Zslg==
X-Gm-Message-State: APjAAAWByMZHtfAWwmvs/OYrID3eE4gDfs3I7cBpqXXUZSMVOSDvPC87
        9rp1xz1rgCUqiVpY4H1KqcAmOA==
X-Google-Smtp-Source: APXvYqwhSXbcm+JgnqzrlLAwwHEqYBaxmEhkloUs4ysxnW6S798i5e1PUm9fiCkxRgxs0XC7mOwADg==
X-Received: by 2002:ac2:5b09:: with SMTP id v9mr19500192lfn.22.1565615654686;
        Mon, 12 Aug 2019 06:14:14 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id t1sm20953912lji.52.2019.08.12.06.14.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 06:14:14 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Georg Hofmann <georg@hofmannsweb.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        stable@vger.kernel.org
Subject: [PATCH] watchdog: imx2_wdt: fix min() calculation in imx2_wdt_set_timeout
Date:   Mon, 12 Aug 2019 15:13:56 +0200
Message-Id: <20190812131356.23039-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Converting from ms to s requires dividing by 1000, not multiplying. So
this is currently taking the smaller of new_timeout and 1.28e8,
i.e. effectively new_timeout.

The driver knows what it set max_hw_heartbeat_ms to, so use that
value instead of doing a division at run-time.

FWIW, this can easily be tested by booting into a busybox shell and
doing "watchdog -t 5 -T 130 /dev/watchdog" - without this patch, the
watchdog fires after 130&127 == 2 seconds.

Fixes: b07e228eee69 "watchdog: imx2_wdt: Fix set_timeout for big timeout values"
Cc: stable@vger.kernel.org # 5.2 plus anything the above got backported to
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
This should really be handled in the watchdog core for any driver that
reports max_hw_heartbeat_ms.

The same pattern appears in aspeed_wdt.c. I don't have the hardware, but
s#wdd->max_hw_heartbeat_ms * 1000#WDT_MAX_TIMEOUT_MS/1000U# should fix that one.


 drivers/watchdog/imx2_wdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 32af3974e6bb..8d019a961ccc 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -55,7 +55,7 @@
 
 #define IMX2_WDT_WMCR		0x08		/* Misc Register */
 
-#define IMX2_WDT_MAX_TIME	128
+#define IMX2_WDT_MAX_TIME	128U
 #define IMX2_WDT_DEFAULT_TIME	60		/* in seconds */
 
 #define WDOG_SEC_TO_COUNT(s)	((s * 2 - 1) << 8)
@@ -180,7 +180,7 @@ static int imx2_wdt_set_timeout(struct watchdog_device *wdog,
 {
 	unsigned int actual;
 
-	actual = min(new_timeout, wdog->max_hw_heartbeat_ms * 1000);
+	actual = min(new_timeout, IMX2_WDT_MAX_TIME);
 	__imx2_wdt_set_timeout(wdog, actual);
 	wdog->timeout = new_timeout;
 	return 0;
-- 
2.20.1

