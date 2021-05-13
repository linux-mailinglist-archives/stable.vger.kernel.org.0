Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A85037FAB8
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbhEMPcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234830AbhEMPcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3153613C3;
        Thu, 13 May 2021 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620919864;
        bh=oC2c0nRK8e03RZMi0uDJqwAw3UzA6G4RiUg2z06UGeg=;
        h=Subject:To:From:Date:From;
        b=M8BIgQh6J2n+PcznlOLKbiB6GzO3U+VEqCjaY121Vs0gwvORjloJ+M2G2F9x5V3Zk
         e5xg2wrpmi1QKwXUap/eGGxjlyEjW4/3maaRMK/CzqYzN9SX7PhWyrqIiudPknlUXn
         HTqrMRnQ/F84IZuqfZCAc4+Enmd/gXbIZ5d/nmsE=
Subject: patch "Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, kjlu@umn.edu, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:31:00 +0200
Message-ID: <1620919860171187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 99ae3417672a6d4a3bf68d4fc43d7c6ca074d477 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:56:31 +0200
Subject: Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"

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
Link: https://lore.kernel.org/r/20210503115736.2104747-5-gregkh@linuxfoundation.org
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


