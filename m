Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F6D3B632D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbhF1OxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235553AbhF1OvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F6AE61D2D;
        Mon, 28 Jun 2021 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891027;
        bh=wRJuFAUKBN9IqlvNRNlL4iFilXRpZrVKLPOlZFTk0FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XooFiWyOawnpIA9OuWFcZ29PCbLJBSOVn/JqHt7agriORWy3s5JzNOsbhNea8Wney
         Bqg3HIZg2FYajovckIXKGHX2kXRKf9pVF0qC4Tr6yrapMQDgCy6ApHVDa9UWiVZH0F
         5iGI4LTHjjSBScrVXkyMho4AV6jjelsX6+Jsoo4MxlTDX0xWVJhgqqLeCqPIKbPTOe
         1YOd1BLnGYUosVhC63G6r36xf7Yv4TWlBoEMHD5+bmAfXiYIK1drh45eCJeh6b1z8t
         iIL258Ky+sGg7M2yymnFyJ77NLc704Np/Nr3eR5FvkM0pZpk6yMYc5dNk8L8SMSQNq
         6Y4xu0r9rK/kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Riwen Lu <luriwen@kylinos.cn>, Xin Chen <chenxin@kylinos.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 42/88] hwmon: (scpi-hwmon) shows the negative temperature properly
Date:   Mon, 28 Jun 2021 10:35:42 -0400
Message-Id: <20210628143628.33342-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riwen Lu <luriwen@kylinos.cn>

[ Upstream commit 78d13552346289bad4a9bf8eabb5eec5e5a321a5 ]

The scpi hwmon shows the sub-zero temperature in an unsigned integer,
which would confuse the users when the machine works in low temperature
environment. This shows the sub-zero temperature in an signed value and
users can get it properly from sensors.

Signed-off-by: Riwen Lu <luriwen@kylinos.cn>
Tested-by: Xin Chen <chenxin@kylinos.cn>
Link: https://lore.kernel.org/r/20210604030959.736379-1-luriwen@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/scpi-hwmon.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hwmon/scpi-hwmon.c b/drivers/hwmon/scpi-hwmon.c
index 7e49da50bc69..562f3e287297 100644
--- a/drivers/hwmon/scpi-hwmon.c
+++ b/drivers/hwmon/scpi-hwmon.c
@@ -107,6 +107,15 @@ scpi_show_sensor(struct device *dev, struct device_attribute *attr, char *buf)
 
 	scpi_scale_reading(&value, sensor);
 
+	/*
+	 * Temperature sensor values are treated as signed values based on
+	 * observation even though that is not explicitly specified, and
+	 * because an unsigned u64 temperature does not really make practical
+	 * sense especially when the temperature is below zero degrees Celsius.
+	 */
+	if (sensor->info.class == TEMPERATURE)
+		return sprintf(buf, "%lld\n", (s64)value);
+
 	return sprintf(buf, "%llu\n", value);
 }
 
-- 
2.30.2

