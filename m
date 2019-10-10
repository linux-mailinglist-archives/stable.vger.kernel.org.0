Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF00D2333
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388013AbfJJIkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388040AbfJJIkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DAA120B7C;
        Thu, 10 Oct 2019 08:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696805;
        bh=Cj6zVdwil1V9LHOzG+BAeozXgHOjbyNXgx+HXxMd0CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehMEOvsWFr8s/gIdwojZZaTp/IoYht/LG2J3wZg/6lFFnMlYM/DL0FD1N/1sgFg/N
         Z4bK+utnG1F41GTVvcgnRzKTkq4PN37kFtCJe9tC03BQTbhZSfIBOOd2d2LvV5j/9D
         nur0+TpDNTlyCk5ZA/w1M3GmWKYY/RghvxGc61+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.3 059/148] watchdog: imx2_wdt: fix min() calculation in imx2_wdt_set_timeout
Date:   Thu, 10 Oct 2019 10:35:20 +0200
Message-Id: <20191010083614.722223370@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 144783a80cd2cbc45c6ce17db649140b65f203dd upstream.

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
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20190812131356.23039-1-linux@rasmusvillemoes.dk
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/imx2_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -55,7 +55,7 @@
 
 #define IMX2_WDT_WMCR		0x08		/* Misc Register */
 
-#define IMX2_WDT_MAX_TIME	128
+#define IMX2_WDT_MAX_TIME	128U
 #define IMX2_WDT_DEFAULT_TIME	60		/* in seconds */
 
 #define WDOG_SEC_TO_COUNT(s)	((s * 2 - 1) << 8)
@@ -180,7 +180,7 @@ static int imx2_wdt_set_timeout(struct w
 {
 	unsigned int actual;
 
-	actual = min(new_timeout, wdog->max_hw_heartbeat_ms * 1000);
+	actual = min(new_timeout, IMX2_WDT_MAX_TIME);
 	__imx2_wdt_set_timeout(wdog, actual);
 	wdog->timeout = new_timeout;
 	return 0;


