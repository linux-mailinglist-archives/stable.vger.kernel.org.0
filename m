Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33E65CB73
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfGBINg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:13:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbfGBIHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:07:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D889921871;
        Tue,  2 Jul 2019 08:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054838;
        bh=PScR0iWl+uXaeaqDVi/x/ZMcF5kpu/c8XZ1GlNOadzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hmySojLN++GoPL42w40J8KKbaa3deQxs5vFa6FZVBQVG2ezYeYovBgQk8eiRuJFJ
         g3mzJ3p9dCzueO790TlVJl6asi9qENr+5XxmGpED5Wd27HEvM1ofav8bZZIFfmdKXE
         OC9WhrfqBrdJeOo9bOZQZeSEzTFGGldRj6Lc31jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Xin <xin.wang7@cn.bosch.com>,
        Mark Jonas <mark.jonas@de.bosch.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 4.19 49/72] eeprom: at24: fix unexpected timeout under high load
Date:   Tue,  2 Jul 2019 10:01:50 +0200
Message-Id: <20190702080127.132720374@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
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
 drivers/misc/eeprom/at24.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -106,23 +106,6 @@ static unsigned int at24_write_timeout =
 module_param_named(write_timeout, at24_write_timeout, uint, 0);
 MODULE_PARM_DESC(at24_write_timeout, "Time (in ms) to try writes (default 25)");
 
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
-#define at24_loop_until_timeout(tout, op_time)				\
-	for (tout = jiffies + msecs_to_jiffies(at24_write_timeout),	\
-	     op_time = 0;						\
-	     op_time ? time_before(op_time, tout) : true;		\
-	     usleep_range(1000, 1500), op_time = jiffies)
-
 struct at24_chip_data {
 	/*
 	 * these fields mirror their equivalents in
@@ -311,13 +294,22 @@ static ssize_t at24_regmap_read(struct a
 	/* adjust offset for mac and serial read ops */
 	offset += at24->offset_adj;
 
-	at24_loop_until_timeout(timeout, read_time) {
+	timeout = jiffies + msecs_to_jiffies(at24_write_timeout);
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		read_time = jiffies;
+
 		ret = regmap_bulk_read(regmap, offset, buf, count);
 		dev_dbg(&client->dev, "read %zu@%d --> %d (%ld)\n",
 			count, offset, ret, jiffies);
 		if (!ret)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(read_time, timeout));
 
 	return -ETIMEDOUT;
 }
@@ -361,14 +353,23 @@ static ssize_t at24_regmap_write(struct
 	regmap = at24_client->regmap;
 	client = at24_client->client;
 	count = at24_adjust_write_count(at24, offset, count);
+	timeout = jiffies + msecs_to_jiffies(at24_write_timeout);
+
+	do {
+		/*
+		 * The timestamp shall be taken before the actual operation
+		 * to avoid a premature timeout in case of high CPU load.
+		 */
+		write_time = jiffies;
 
-	at24_loop_until_timeout(timeout, write_time) {
 		ret = regmap_bulk_write(regmap, offset, buf, count);
 		dev_dbg(&client->dev, "write %zu@%d --> %d (%ld)\n",
 			count, offset, ret, jiffies);
 		if (!ret)
 			return count;
-	}
+
+		usleep_range(1000, 1500);
+	} while (time_before(write_time, timeout));
 
 	return -ETIMEDOUT;
 }


