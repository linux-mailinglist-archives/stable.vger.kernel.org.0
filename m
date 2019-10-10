Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91949D25DE
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387909AbfJJIjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387908AbfJJIjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCD320B7C;
        Thu, 10 Oct 2019 08:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696775;
        bh=6tbXvVaKRk6fxxefrdGvDY9Lbd+z9PQqGTiTVs0NcvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2cOgXK4GmO3f5ohkGPOtpoZafhgSPnAMp/7ivsAm+HMoBmMvIJK/wPIPIcNBE1B1
         9B2cEExgYwl6tukXqWus4g2otupYfYR/zG60ogrqJtBwkRUmFBoBkMLPXT/YM6j1kC
         qTEaJHVyI0hxeWxY7pZUw3s/+L1NEJYaBGCETcJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Nosthoff <committed@heine.so>,
        Brian Norris <briannorris@chromium.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.3 049/148] power: supply: sbs-battery: only return health when battery present
Date:   Thu, 10 Oct 2019 10:35:10 +0200
Message-Id: <20191010083614.117013387@linuxfoundation.org>
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

From: Michael Nosthoff <committed@heine.so>

commit fe55e770327363304c4111423e6f7ff3c650136d upstream.

when the battery is set to sbs-mode and  no gpio detection is enabled
"health" is always returning a value even when the battery is not present.
All other fields return "not present".
This leads to a scenario where the driver is constantly switching between
"present" and "not present" state. This generates a lot of constant
traffic on the i2c.

This commit changes the response of "health" to an error when the battery
is not responding leading to a consistent "not present" state.

Fixes: 76b16f4cdfb8 ("power: supply: sbs-battery: don't assume MANUFACTURER_DATA formats")
Cc: <stable@vger.kernel.org>
Signed-off-by: Michael Nosthoff <committed@heine.so>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/supply/sbs-battery.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/power/supply/sbs-battery.c
+++ b/drivers/power/supply/sbs-battery.c
@@ -314,17 +314,22 @@ static int sbs_get_battery_presence_and_
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
@@ -626,6 +631,8 @@ static int sbs_get_property(struct power
 		else
 			ret = sbs_get_battery_presence_and_health(client, psp,
 								  val);
+
+		/* this can only be true if no gpio is used */
 		if (psp == POWER_SUPPLY_PROP_PRESENT)
 			return 0;
 		break;


