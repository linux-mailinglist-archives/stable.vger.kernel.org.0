Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E2038EF16
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhEXP4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235463AbhEXPzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDE426192F;
        Mon, 24 May 2021 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870879;
        bh=FIA/5K/kG1WwB9DXMHcoqy2r/9XvjKvqQCAY6qlo/MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgWC6m6A3rY2YmuzMZZxmE3fQ/NZ95f41uYSrOaW9psU5elU9UpYTg83Cu1XJ0MtH
         MQW76OP9eiE5+1Itkugkdh/REE8Dbe9mlZxeGSJNKYAOX2yKAI96BkrC+Imwj1zWPl
         engeSoYmgz5nWPbiGzgGjbUKgN5AvUz+devsVd90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 076/104] Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"
Date:   Mon, 24 May 2021 17:26:11 +0200
Message-Id: <20210524152335.375762582@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 99ae3417672a6d4a3bf68d4fc43d7c6ca074d477 upstream.

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
 drivers/hwmon/lm80.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/hwmon/lm80.c
+++ b/drivers/hwmon/lm80.c
@@ -596,7 +596,6 @@ static int lm80_probe(struct i2c_client
 	struct device *dev = &client->dev;
 	struct device *hwmon_dev;
 	struct lm80_data *data;
-	int rv;
 
 	data = devm_kzalloc(dev, sizeof(struct lm80_data), GFP_KERNEL);
 	if (!data)
@@ -609,14 +608,8 @@ static int lm80_probe(struct i2c_client
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


