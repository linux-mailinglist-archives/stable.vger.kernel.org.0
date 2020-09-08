Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927072618E9
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731585AbgIHSEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731529AbgIHQMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:12:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 776B4247BC;
        Tue,  8 Sep 2020 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580289;
        bh=IQ4F+qoYkAzgMNeGwGj8KmuUX6Ix0afDmrRyS92ms8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p07mdHikxk+vvaos4tpeGRqj3QN5uhwayBDdi4ZbbPaErWe22zjEqX2t2PexMSviV
         o+p/kPfeTC+IGmp4mbGsNr626RQy4LEQQSlCrWVVLaleByezryRFRhrVjvsjz+He1k
         lc8PI88ZS+AyNYoT/A6ChrVWJGNNKFgod2an74ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/65] hwmon: (applesmc) check status earlier.
Date:   Tue,  8 Sep 2020 17:25:50 +0200
Message-Id: <20200908152217.303990371@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit cecf7560f00a8419396a2ed0f6e5d245ccb4feac ]

clang static analysis reports this representative problem

applesmc.c:758:10: warning: 1st function call argument is an
  uninitialized value
        left = be16_to_cpu(*(__be16 *)(buffer + 6)) >> 2;
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

buffer is filled by the earlier call

	ret = applesmc_read_key(LIGHT_SENSOR_LEFT_KEY, ...

This problem is reported because a goto skips the status check.
Other similar problems use data from applesmc_read_key before checking
the status.  So move the checks to before the use.

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Henrik Rydberg <rydberg@bitmath.org>
Link: https://lore.kernel.org/r/20200820131932.10590-1-trix@redhat.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/applesmc.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 5c677ba440143..b201129a9beae 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -760,15 +760,18 @@ static ssize_t applesmc_light_show(struct device *dev,
 	}
 
 	ret = applesmc_read_key(LIGHT_SENSOR_LEFT_KEY, buffer, data_length);
+	if (ret)
+		goto out;
 	/* newer macbooks report a single 10-bit bigendian value */
 	if (data_length == 10) {
 		left = be16_to_cpu(*(__be16 *)(buffer + 6)) >> 2;
 		goto out;
 	}
 	left = buffer[2];
+
+	ret = applesmc_read_key(LIGHT_SENSOR_RIGHT_KEY, buffer, data_length);
 	if (ret)
 		goto out;
-	ret = applesmc_read_key(LIGHT_SENSOR_RIGHT_KEY, buffer, data_length);
 	right = buffer[2];
 
 out:
@@ -817,12 +820,11 @@ static ssize_t applesmc_show_fan_speed(struct device *dev,
 		  to_index(attr));
 
 	ret = applesmc_read_key(newkey, buffer, 2);
-	speed = ((buffer[0] << 8 | buffer[1]) >> 2);
-
 	if (ret)
 		return ret;
-	else
-		return snprintf(sysfsbuf, PAGE_SIZE, "%u\n", speed);
+
+	speed = ((buffer[0] << 8 | buffer[1]) >> 2);
+	return snprintf(sysfsbuf, PAGE_SIZE, "%u\n", speed);
 }
 
 static ssize_t applesmc_store_fan_speed(struct device *dev,
@@ -858,12 +860,11 @@ static ssize_t applesmc_show_fan_manual(struct device *dev,
 	u8 buffer[2];
 
 	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
-	manual = ((buffer[0] << 8 | buffer[1]) >> to_index(attr)) & 0x01;
-
 	if (ret)
 		return ret;
-	else
-		return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", manual);
+
+	manual = ((buffer[0] << 8 | buffer[1]) >> to_index(attr)) & 0x01;
+	return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", manual);
 }
 
 static ssize_t applesmc_store_fan_manual(struct device *dev,
@@ -879,10 +880,11 @@ static ssize_t applesmc_store_fan_manual(struct device *dev,
 		return -EINVAL;
 
 	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
-	val = (buffer[0] << 8 | buffer[1]);
 	if (ret)
 		goto out;
 
+	val = (buffer[0] << 8 | buffer[1]);
+
 	if (input)
 		val = val | (0x01 << to_index(attr));
 	else
@@ -958,13 +960,12 @@ static ssize_t applesmc_key_count_show(struct device *dev,
 	u32 count;
 
 	ret = applesmc_read_key(KEY_COUNT_KEY, buffer, 4);
-	count = ((u32)buffer[0]<<24) + ((u32)buffer[1]<<16) +
-						((u32)buffer[2]<<8) + buffer[3];
-
 	if (ret)
 		return ret;
-	else
-		return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", count);
+
+	count = ((u32)buffer[0]<<24) + ((u32)buffer[1]<<16) +
+						((u32)buffer[2]<<8) + buffer[3];
+	return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", count);
 }
 
 static ssize_t applesmc_key_at_index_read_show(struct device *dev,
-- 
2.25.1



