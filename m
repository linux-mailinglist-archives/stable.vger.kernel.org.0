Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2CD2ED28C
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbhAGOeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:34:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729729AbhAGOeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:34:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A496A23356;
        Thu,  7 Jan 2021 14:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610030006;
        bh=FqVysjNP+b8PJG6ChRomrOjuYU/iFnz9gv4SFRb8mkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnZwn/RUhw7m2nkX+0Q6kL1JzylxKREE/MvGDpgp5Vo5oqu7opj0gNF9sCXzj/8Jy
         qWPljaDDqzX73NTnV0jGIJ4bNq/ALm8Kb5hHBHoEC4lNKyErCp81RTYe49upo4Bxf7
         JV6K6d7e80R+xrIzXnoqmmQz07wuFdQq1ncXIzlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 04/20] rtc: pcf2127: only use watchdog when explicitly available
Date:   Thu,  7 Jan 2021 15:33:59 +0100
Message-Id: <20210107143053.030563490@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 71ac13457d9d1007effde65b54818106b2c2b525 upstream.

Most boards using the pcf2127 chip (in my bubble) don't make use of the
watchdog functionality and the respective output is not connected. The
effect on such a board is that there is a watchdog device provided that
doesn't work.

So only register the watchdog if the device tree has a "reset-source"
property.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
[RV: s/has-watchdog/reset-source/]
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201218101054.25416-3-rasmus.villemoes@prevas.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-pcf2127.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -336,7 +336,8 @@ static int pcf2127_watchdog_init(struct
 	u32 wdd_timeout;
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_WATCHDOG))
+	if (!IS_ENABLED(CONFIG_WATCHDOG) ||
+	    !device_property_read_bool(dev, "reset-source"))
 		return 0;
 
 	pcf2127->wdd.parent = dev;


