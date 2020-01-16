Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1471B13F369
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390134AbgAPRLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:11:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390150AbgAPRLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1151E24681;
        Thu, 16 Jan 2020 17:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194664;
        bh=T4VCaHC+ePrb6r+sRWQJAYXbx7hN/HtgqjgSgzkrnCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQq8lltYyrSwBwjQIku5b9fPUq8PnQ/Q+8GX7NEm+uVnKdiwkfr0kJxfaN89kpXuz
         yGGryqaMo8PnIM3rA+4HJbgZIGbdHfAuFXJEyE01tZvG9y+G/kCnAWgnetXvjiFt0p
         xxJfyXIz9hJGmMqOxrhRN62epEGDv+++dOYRA0bk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Iker Perez del Palomar Sustatxa 
        <iker.perez@codethink.co.uk>, Sasha Levin <sashal@kernel.org>,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 514/671] hwmon: (lm75) Fix write operations for negative temperatures
Date:   Thu, 16 Jan 2020 12:02:32 -0500
Message-Id: <20200116170509.12787-251-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 7d82fcc9d9e81241778aaa22fda7be753e237d86 ]

Writes into limit registers fail if the temperature written is negative.
The regmap write operation checks the value range, regmap_write accepts
an unsigned int as parameter, and the temperature value passed to
regmap_write is kept in a variable declared as long. Negative values
are converted large unsigned integers, which fails the range check.
Fix by type casting the temperature to u16 when calling regmap_write().

Cc: Iker Perez del Palomar Sustatxa <iker.perez@codethink.co.uk>
Fixes: e65365fed87f ("hwmon: (lm75) Convert to use regmap")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm75.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index 49f4b33a5685..7f28912c9abc 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -165,7 +165,7 @@ static int lm75_write(struct device *dev, enum hwmon_sensor_types type,
 	temp = DIV_ROUND_CLOSEST(temp  << (resolution - 8),
 				 1000) << (16 - resolution);
 
-	return regmap_write(data->regmap, reg, temp);
+	return regmap_write(data->regmap, reg, (u16)temp);
 }
 
 static umode_t lm75_is_visible(const void *data, enum hwmon_sensor_types type,
-- 
2.20.1

