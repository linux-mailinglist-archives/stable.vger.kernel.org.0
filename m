Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CC38FCE1
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 09:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfHPH7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 03:59:02 -0400
Received: from mail.heine.tech ([195.201.24.99]:37346 "EHLO mail.heine.tech"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbfHPH7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 03:59:01 -0400
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: michael@nosthoff.rocks)
        by mail.heine.tech (Postcow) with ESMTPSA id 9B0541814A5;
        Fri, 16 Aug 2019 09:58:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heine.so; s=dkim;
        t=1565942339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GkQ4o+vnZ8bfYSlgoMHLP37yPkIuBnAX45qO7WjdZqU=;
        b=aFZ4wiSZUPYEU/2ifm6MIxYKR1BCt+ckvNQfFnxemkkajVf+YfTr3e7Y/wu86QnxjHPuNj
        AVLEsDYz5PBwJnuwTDm0dTPqVvdmKMaVkZJlvEhlI1vlrk74TzsTd32i4jxOot23ugP+CC
        IMPzeiXPFYsw4HpCV8AkjGpq0mJPaGE=
From:   Michael Nosthoff <committed@heine.so>
To:     linux-pm@vger.kernel.org
Cc:     Michael Nosthoff <committed@heine.so>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] power: supply: sbs-battery: only return health when battery present
Date:   Fri, 16 Aug 2019 09:58:42 +0200
Message-Id: <20190816075842.27333-1-committed@heine.so>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

when the battery is set to sbs-mode and  no gpio detection is enabled
"health" is always returning a value even when the battery is not present.
All other fields return "not present".
This leads to a scenario where the driver is constantly switching between
"present" and "not present" state. This generates a lot of constant
traffic on the i2c.

This commit changes the response of "health" to an error when the battery
is not responding leading to a consistent "not present" state.

Fixes: 76b16f4cdfb8 ("power: supply: sbs-battery: don't assume
MANUFACTURER_DATA formats")

Signed-off-by: Michael Nosthoff <committed@heine.so>
Cc: Brian Norris <briannorris@chromium.org>
Cc: <stable@vger.kernel.org>
---
 drivers/power/supply/sbs-battery.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/power/supply/sbs-battery.c b/drivers/power/supply/sbs-battery.c
index 2e86cc1e0e35..f8d74e9f7931 100644
--- a/drivers/power/supply/sbs-battery.c
+++ b/drivers/power/supply/sbs-battery.c
@@ -314,17 +314,22 @@ static int sbs_get_battery_presence_and_health(
 {
 	int ret;
 
-	if (psp == POWER_SUPPLY_PROP_PRESENT) {
-		/* Dummy command; if it succeeds, battery is present. */
-		ret = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
-		if (ret < 0)
-			val->intval = 0; /* battery disconnected */
-		else
-			val->intval = 1; /* battery present */
-	} else { /* POWER_SUPPLY_PROP_HEALTH */
+	/* Dummy command; if it succeeds, battery is present. */
+	ret = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
+
+	if (ret < 0) { /* battery not present*/
+		if (psp == POWER_SUPPLY_PROP_PRESENT) {
+			val->intval = 0;
+			return 0;
+		}
+		return ret;
+	}
+
+	if (psp == POWER_SUPPLY_PROP_PRESENT)
+		val->intval = 1; /* battery present */
+	else /* POWER_SUPPLY_PROP_HEALTH */
 		/* SBS spec doesn't have a general health command. */
 		val->intval = POWER_SUPPLY_HEALTH_UNKNOWN;
-	}
 
 	return 0;
 }
@@ -626,6 +631,8 @@ static int sbs_get_property(struct power_supply *psy,
 		else
 			ret = sbs_get_battery_presence_and_health(client, psp,
 								  val);
+
+		/* this can only be true if no gpio is used */
 		if (psp == POWER_SUPPLY_PROP_PRESENT)
 			return 0;
 		break;
-- 
2.20.1

