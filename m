Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9FD3714B6
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhECMAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233655AbhECMAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8595561244;
        Mon,  3 May 2021 11:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043162;
        bh=79KSAg+ELuxOmSOG2bH4r4Vxa/Y8lQHe/WMHUNpcQ4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBlzS4U1eIFpHOW4Tuf0R/1kJavMSmGXpCaRjvk4BUPxe43Oj6O4evHIy+xwNwuWS
         0DIQi2+GsWGdY8e+f+zD+N8NIG4Xl5qiAm2CmZzSHTtlWD4gZGJvPC3bRcnYlSmBto
         4+1Sl2DC6hyt1y6qPCmZZmVDhZA5Nyj6DDfDsOGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, stable <stable@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 04/69] Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"
Date:   Mon,  3 May 2021 13:56:31 +0200
Message-Id: <20210503115736.2104747-5-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9aa3aa15f4c2f74f47afd6c5db4b420fadf3f315.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, it was determined that this commit is not needed at all so
just revert it.  Also, the call to lm80_init_client() was not properly
handled, so if error handling is needed in the lm80_probe() function,
then it should be done properly, not half-baked like the commit being
reverted here did.

Cc: Kangjie Lu <kjlu@umn.edu>
Fixes: 9aa3aa15f4c2 ("hwmon: (lm80) fix a missing check of bus read in lm80 probe")
Cc: stable <stable@vger.kernel.org>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/lm80.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c
index ac4adb44b224..97ab491d2922 100644
--- a/drivers/hwmon/lm80.c
+++ b/drivers/hwmon/lm80.c
@@ -596,7 +596,6 @@ static int lm80_probe(struct i2c_client *client)
 	struct device *dev = &client->dev;
 	struct device *hwmon_dev;
 	struct lm80_data *data;
-	int rv;
 
 	data = devm_kzalloc(dev, sizeof(struct lm80_data), GFP_KERNEL);
 	if (!data)
@@ -609,14 +608,8 @@ static int lm80_probe(struct i2c_client *client)
 	lm80_init_client(client);
 
 	/* A few vars need to be filled upon startup */
-	rv = lm80_read_value(client, LM80_REG_FAN_MIN(1));
-	if (rv < 0)
-		return rv;
-	data->fan[f_min][0] = rv;
-	rv = lm80_read_value(client, LM80_REG_FAN_MIN(2));
-	if (rv < 0)
-		return rv;
-	data->fan[f_min][1] = rv;
+	data->fan[f_min][0] = lm80_read_value(client, LM80_REG_FAN_MIN(1));
+	data->fan[f_min][1] = lm80_read_value(client, LM80_REG_FAN_MIN(2));
 
 	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
 							   data, lm80_groups);
-- 
2.31.1

