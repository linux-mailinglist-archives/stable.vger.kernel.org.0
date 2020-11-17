Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8154E2B636E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733030AbgKQNiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732516AbgKQNiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 655A82466D;
        Tue, 17 Nov 2020 13:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620284;
        bh=r4/VO0Vz2KSlbL4qUQ8pQFMc4C+JJyeZXsu18rJEAFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/umFILPn4HJrufxTerK6Yoyae68HlEVX5Jk0GFyVx2tteh3loWNSFHj44VQwVrZy
         +zrtZZHry9gjlLq6BlBQ2TLzCK1GklPPWJ547Kg+UjVPfdEMMfciV0lo8uKdHv4VK0
         2Zxgnd8r5c/DXIxJKrmzlQbCHfXCnDfe+YTOltcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Arnd Bergmann <arnd@arndb.de>,
        Brad Campbell <brad@fnarfbargle.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 168/255] hwmon: (applesmc) Re-work SMC comms
Date:   Tue, 17 Nov 2020 14:05:08 +0100
Message-Id: <20201117122147.112851283@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brad Campbell <brad@fnarfbargle.com>

[ Upstream commit 4d64bb4ba5ecf4831448cdb2fe16d0ae91b2b40b ]

Commit fff2d0f701e6 ("hwmon: (applesmc) avoid overlong udelay()")
introduced an issue whereby communication with the SMC became
unreliable with write errors like :

[  120.378614] applesmc: send_byte(0x00, 0x0300) fail: 0x40
[  120.378621] applesmc: LKSB: write data fail
[  120.512782] applesmc: send_byte(0x00, 0x0300) fail: 0x40
[  120.512787] applesmc: LKSB: write data fail

The original code appeared to be timing sensitive and was not reliable
with the timing changes in the aforementioned commit.

This patch re-factors the SMC communication to remove the timing
dependencies and restore function with the changes previously
committed.

Tested on : MacbookAir6,2 MacBookPro11,1 iMac12,2, MacBookAir1,1,
MacBookAir3,1

Fixes: fff2d0f701e6 ("hwmon: (applesmc) avoid overlong udelay()")
Reported-by: Andreas Kemnade <andreas@kemnade.info>
Tested-by: Andreas Kemnade <andreas@kemnade.info> # MacBookAir6,2
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Brad Campbell <brad@fnarfbargle.com>
Signed-off-by: Henrik Rydberg <rydberg@bitmath.org>
Link: https://lore.kernel.org/r/194a7d71-a781-765a-d177-c962ef296b90@fnarfbargle.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/applesmc.c | 130 ++++++++++++++++++++++++---------------
 1 file changed, 82 insertions(+), 48 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index a18887990f4a2..79b498f816fe9 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -32,6 +32,7 @@
 #include <linux/hwmon.h>
 #include <linux/workqueue.h>
 #include <linux/err.h>
+#include <linux/bits.h>
 
 /* data port used by Apple SMC */
 #define APPLESMC_DATA_PORT	0x300
@@ -42,10 +43,13 @@
 
 #define APPLESMC_MAX_DATA_LENGTH 32
 
-/* wait up to 128 ms for a status change. */
-#define APPLESMC_MIN_WAIT	0x0010
-#define APPLESMC_RETRY_WAIT	0x0100
-#define APPLESMC_MAX_WAIT	0x20000
+/* Apple SMC status bits */
+#define SMC_STATUS_AWAITING_DATA  BIT(0) /* SMC has data waiting to be read */
+#define SMC_STATUS_IB_CLOSED      BIT(1) /* Will ignore any input */
+#define SMC_STATUS_BUSY           BIT(2) /* Command in progress */
+
+/* Initial wait is 8us */
+#define APPLESMC_MIN_WAIT      0x0008
 
 #define APPLESMC_READ_CMD	0x10
 #define APPLESMC_WRITE_CMD	0x11
@@ -151,65 +155,84 @@ static unsigned int key_at_index;
 static struct workqueue_struct *applesmc_led_wq;
 
 /*
- * wait_read - Wait for a byte to appear on SMC port. Callers must
- * hold applesmc_lock.
+ * Wait for specific status bits with a mask on the SMC.
+ * Used before all transactions.
+ * This does 10 fast loops of 8us then exponentially backs off for a
+ * minimum total wait of 262ms. Depending on usleep_range this could
+ * run out past 500ms.
  */
-static int wait_read(void)
+
+static int wait_status(u8 val, u8 mask)
 {
-	unsigned long end = jiffies + (APPLESMC_MAX_WAIT * HZ) / USEC_PER_SEC;
 	u8 status;
 	int us;
+	int i;
 
-	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
-		usleep_range(us, us * 16);
+	us = APPLESMC_MIN_WAIT;
+	for (i = 0; i < 24 ; i++) {
 		status = inb(APPLESMC_CMD_PORT);
-		/* read: wait for smc to settle */
-		if (status & 0x01)
+		if ((status & mask) == val)
 			return 0;
-		/* timeout: give up */
-		if (time_after(jiffies, end))
-			break;
+		usleep_range(us, us * 2);
+		if (i > 9)
+			us <<= 1;
 	}
-
-	pr_warn("wait_read() fail: 0x%02x\n", status);
 	return -EIO;
 }
 
-/*
- * send_byte - Write to SMC port, retrying when necessary. Callers
- * must hold applesmc_lock.
- */
+/* send_byte - Write to SMC data port. Callers must hold applesmc_lock. */
+
 static int send_byte(u8 cmd, u16 port)
 {
-	u8 status;
-	int us;
-	unsigned long end = jiffies + (APPLESMC_MAX_WAIT * HZ) / USEC_PER_SEC;
+	int status;
+
+	status = wait_status(0, SMC_STATUS_IB_CLOSED);
+	if (status)
+		return status;
+	/*
+	 * This needs to be a separate read looking for bit 0x04
+	 * after bit 0x02 falls. If consolidated with the wait above
+	 * this extra read may not happen if status returns both
+	 * simultaneously and this would appear to be required.
+	 */
+	status = wait_status(SMC_STATUS_BUSY, SMC_STATUS_BUSY);
+	if (status)
+		return status;
 
 	outb(cmd, port);
-	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
-		usleep_range(us, us * 16);
-		status = inb(APPLESMC_CMD_PORT);
-		/* write: wait for smc to settle */
-		if (status & 0x02)
-			continue;
-		/* ready: cmd accepted, return */
-		if (status & 0x04)
-			return 0;
-		/* timeout: give up */
-		if (time_after(jiffies, end))
-			break;
-		/* busy: long wait and resend */
-		udelay(APPLESMC_RETRY_WAIT);
-		outb(cmd, port);
-	}
-
-	pr_warn("send_byte(0x%02x, 0x%04x) fail: 0x%02x\n", cmd, port, status);
-	return -EIO;
+	return 0;
 }
 
+/* send_command - Write a command to the SMC. Callers must hold applesmc_lock. */
+
 static int send_command(u8 cmd)
 {
-	return send_byte(cmd, APPLESMC_CMD_PORT);
+	int ret;
+
+	ret = wait_status(0, SMC_STATUS_IB_CLOSED);
+	if (ret)
+		return ret;
+	outb(cmd, APPLESMC_CMD_PORT);
+	return 0;
+}
+
+/*
+ * Based on logic from the Apple driver. This is issued before any interaction
+ * If busy is stuck high, issue a read command to reset the SMC state machine.
+ * If busy is stuck high after the command then the SMC is jammed.
+ */
+
+static int smc_sane(void)
+{
+	int ret;
+
+	ret = wait_status(0, SMC_STATUS_BUSY);
+	if (!ret)
+		return ret;
+	ret = send_command(APPLESMC_READ_CMD);
+	if (ret)
+		return ret;
+	return wait_status(0, SMC_STATUS_BUSY);
 }
 
 static int send_argument(const char *key)
@@ -226,6 +249,11 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 {
 	u8 status, data = 0;
 	int i;
+	int ret;
+
+	ret = smc_sane();
+	if (ret)
+		return ret;
 
 	if (send_command(cmd) || send_argument(key)) {
 		pr_warn("%.4s: read arg fail\n", key);
@@ -239,7 +267,8 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 	}
 
 	for (i = 0; i < len; i++) {
-		if (wait_read()) {
+		if (wait_status(SMC_STATUS_AWAITING_DATA | SMC_STATUS_BUSY,
+				SMC_STATUS_AWAITING_DATA | SMC_STATUS_BUSY)) {
 			pr_warn("%.4s: read data[%d] fail\n", key, i);
 			return -EIO;
 		}
@@ -250,19 +279,24 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 	for (i = 0; i < 16; i++) {
 		udelay(APPLESMC_MIN_WAIT);
 		status = inb(APPLESMC_CMD_PORT);
-		if (!(status & 0x01))
+		if (!(status & SMC_STATUS_AWAITING_DATA))
 			break;
 		data = inb(APPLESMC_DATA_PORT);
 	}
 	if (i)
 		pr_warn("flushed %d bytes, last value is: %d\n", i, data);
 
-	return 0;
+	return wait_status(0, SMC_STATUS_BUSY);
 }
 
 static int write_smc(u8 cmd, const char *key, const u8 *buffer, u8 len)
 {
 	int i;
+	int ret;
+
+	ret = smc_sane();
+	if (ret)
+		return ret;
 
 	if (send_command(cmd) || send_argument(key)) {
 		pr_warn("%s: write arg fail\n", key);
@@ -281,7 +315,7 @@ static int write_smc(u8 cmd, const char *key, const u8 *buffer, u8 len)
 		}
 	}
 
-	return 0;
+	return wait_status(0, SMC_STATUS_BUSY);
 }
 
 static int read_register_count(unsigned int *count)
-- 
2.27.0



