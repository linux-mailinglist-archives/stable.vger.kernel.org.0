Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F385A5CB0D
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbfGBIKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbfGBIKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:10:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04286206A2;
        Tue,  2 Jul 2019 08:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562055045;
        bh=Vx9DkmCnEUQSOhGDZdt1CgFSoxs+WL6oyvc7wV8s+vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5oZ2/G5ZU9hI06PnLs3Ksb7M1kS7d0Px34NUtJUPg6R2HLA/MP2Gk4m0gmHEciML
         YMTk3qr0rePtM7WkzmgOlnTG3/zuT0QFMeTF/Lft4r0Ce+q5HjusSGGQONeaX1bWn9
         xNwul39M9G4Y+QA74sB9ERAehj3uSy+QM0xXcSio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Xin <xin.wang7@cn.bosch.com>,
        Mark Jonas <mark.jonas@de.bosch.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 4.14 26/43] eeprom: at24: fix unexpected timeout under high load
Date:   Tue,  2 Jul 2019 10:02:06 +0200
Message-Id: <20190702080125.196152902@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Xin <xin.wang7@cn.bosch.com>

commit 9a9e295e7c5c0409c020088b0ae017e6c2b7df6e upstream.

Within at24_loop_until_timeout the timestamp used for timeout checking
is recorded after the I2C transfer and sleep_range(). Under high CPU
load either the execution time for I2C transfer or sleep_range() could
actually be larger than the timeout value. Worst case the I2C transfer
is only tried once because the loop will exit due to the timeout
although the EEPROM is now ready.

To fix this issue the timestamp is recorded at the beginning of each
iteration. That is, before I2C transfer and sleep. Then the timeout
is actually checked against the timestamp of the previous iteration.
This makes sure that even if the timeout is reached, there is still one
more chance to try the I2C transfer in case the EEPROM is ready.

Example:

If you have a system which combines high CPU load with repeated EEPROM
writes you will run into the following scenario.

 - System makes a successful regmap_bulk_write() to EEPROM.
 - System wants to perform another write to EEPROM but EEPROM is still
   busy with the last write.
 - Because of high CPU load the usleep_range() will sleep more than
   25 ms (at24_write_timeout).
 - Within the over-long sleeping the EEPROM finished the previous write
   operation and is ready again.
 - at24_loop_until_timeout() will detect timeout and won't try to write.

Signed-off-by: Wang Xin <xin.wang7@cn.bosch.com>
Signed-off-by: Mark Jonas <mark.jonas@de.bosch.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/misc/eeprom/at24.c |  107 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 77 insertions(+), 30 deletions(-)

--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -113,22 +113,6 @@ MODULE_PARM_DESC(write_timeout, "Time (i
 	((1 << AT24_SIZE_FLAGS | (_flags)) 		\
 	    << AT24_SIZE_BYTELEN | ilog2(_len))
 
-/*
- * Both reads and writes fail if the previous write didn't complete yet. This
- * macro loops a few times waiting at least long enough for one entire page
- * write to work while making sure that at least one iteration is run before
- * checking the break condition.
- *
- * It takes two parameters: a variable in which the future timeout in jiffies
- * will be stored and a temporary variable holding the time of the last
- * iteration of processing the request. Both should be unsigned integers
- * holding at least 32 bits.
- */
-#define loop_until_timeout(tout, op_time)				\
-	for (tout = jiffies + msecs_to_jiffies(write_timeout), op_time = 0; \
-	     op_time ? time_before(op_time, tout) : true;		\
-	     usleep_range(1000, 1500), op_time = jiffies)
-
 static const struct i2c_device_id at24_ids[] = {
 	/* needs 8 addresses as A0-A2 are ignored */
 	{ "24c00",	AT24_DEVICE_MAGIC(128 / 8,	AT24_FLAG_TAKE8ADDR) },
@@ -234,7 +218,14 @@ static ssize_t at24_eeprom_read_smbus(st
 	if (count > I2C_SMBUS_BLOCK_MAX)
 		count = I2C_SMBUS_BLOCK_MAX;
 
-	loop_until_timeout(timeout, read_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		read_time = jiffies;
+
 		status = i2c_smbus_read_i2c_block_data_or_emulated(client,
 								   offset,
 								   count, buf);
@@ -244,7 +235,9 @@ static ssize_t at24_eeprom_read_smbus(st
 
 		if (status == count)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(read_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -284,7 +277,14 @@ static ssize_t at24_eeprom_read_i2c(stru
 	msg[1].buf = buf;
 	msg[1].len = count;
 
-	loop_until_timeout(timeout, read_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		read_time = jiffies;
+
 		status = i2c_transfer(client->adapter, msg, 2);
 		if (status == 2)
 			status = count;
@@ -294,7 +294,9 @@ static ssize_t at24_eeprom_read_i2c(stru
 
 		if (status == count)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(read_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -343,11 +345,20 @@ static ssize_t at24_eeprom_read_serial(s
 	msg[1].buf = buf;
 	msg[1].len = count;
 
-	loop_until_timeout(timeout, read_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		read_time = jiffies;
+
 		status = i2c_transfer(client->adapter, msg, 2);
 		if (status == 2)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(read_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -374,11 +385,20 @@ static ssize_t at24_eeprom_read_mac(stru
 	msg[1].buf = buf;
 	msg[1].len = count;
 
-	loop_until_timeout(timeout, read_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		read_time = jiffies;
+
 		status = i2c_transfer(client->adapter, msg, 2);
 		if (status == 2)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(read_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -420,7 +440,14 @@ static ssize_t at24_eeprom_write_smbus_b
 	client = at24_translate_offset(at24, &offset);
 	count = at24_adjust_write_count(at24, offset, count);
 
-	loop_until_timeout(timeout, write_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		write_time = jiffies;
+
 		status = i2c_smbus_write_i2c_block_data(client,
 							offset, count, buf);
 		if (status == 0)
@@ -431,7 +458,9 @@ static ssize_t at24_eeprom_write_smbus_b
 
 		if (status == count)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(write_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -446,7 +475,14 @@ static ssize_t at24_eeprom_write_smbus_b
 
 	client = at24_translate_offset(at24, &offset);
 
-	loop_until_timeout(timeout, write_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		write_time = jiffies;
+
 		status = i2c_smbus_write_byte_data(client, offset, buf[0]);
 		if (status == 0)
 			status = count;
@@ -456,7 +492,9 @@ static ssize_t at24_eeprom_write_smbus_b
 
 		if (status == count)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(write_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -485,7 +523,14 @@ static ssize_t at24_eeprom_write_i2c(str
 	memcpy(&msg.buf[i], buf, count);
 	msg.len = i + count;
 
-	loop_until_timeout(timeout, write_time) {
+	timeout = jiffies + msecs_to_jiffies(write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		write_time = jiffies;
+
 		status = i2c_transfer(client->adapter, &msg, 1);
 		if (status == 1)
 			status = count;
@@ -495,7 +540,9 @@ static ssize_t at24_eeprom_write_i2c(str
 
 		if (status == count)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(write_time, timeout));
 
 	return -ETIMEDOUT;
 }


