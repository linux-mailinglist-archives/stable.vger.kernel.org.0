Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75D2A6E97
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbfICQ1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730805AbfICQ1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75CEF2343A;
        Tue,  3 Sep 2019 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528032;
        bh=a4NmxbwiPEzexKJXfsdWriqzulb6iQVx+mR6f8AREG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amJphO+y+O0su+lBntdi/Uqirixrhz2Rgd7b2ngzimJEr0ZStQfFp1iWOln97ab/a
         7YFZQ/RHb+u1jGIWF6MGfr/T3jrl/So+9gBfXRI0FELHFL8pgYU2HY2WbWsn3tLlqC
         3gMA/dRmM2rpG3pdz9TV+lm5OEa2E1rrYKP4dn+8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-integrity@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 062/167] tpm: Fix some name collisions with drivers/char/tpm.h
Date:   Tue,  3 Sep 2019 12:23:34 -0400
Message-Id: <20190903162519.7136-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

[ Upstream commit 8ab547a2dcfac6ec184a5e036e1093eb3f7a215c ]

* Rename TPM_BUFSIZE defined in drivers/char/tpm/st33zp24/st33zp24.h to
  ST33ZP24_BUFSIZE.
* Rename TPM_BUFSIZE defined in drivers/char/tpm/tpm_i2c_infineon.c to
  TPM_I2C_INFINEON_BUFSIZE.
* Rename TPM_RETRY in tpm_i2c_nuvoton to TPM_I2C_RETRIES.
* Remove TPM_HEADER_SIZE from tpm_i2c_nuvoton.

Cc: stable@vger.kernel.org
Fixes: bf38b8710892 ("tpm/tpm_i2c_stm_st33: Split tpm_i2c_tpm_st33 in 2 layers (core + phy)")
Fixes: aad628c1d91a ("char/tpm: Add new driver for Infineon I2C TIS TPM")
Fixes: 32d33b29ba07 ("TPM: Retry SaveState command in suspend path")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/st33zp24/i2c.c      |  2 +-
 drivers/char/tpm/st33zp24/spi.c      |  2 +-
 drivers/char/tpm/st33zp24/st33zp24.h |  4 ++--
 drivers/char/tpm/tpm_i2c_infineon.c  | 15 ++++++++-------
 drivers/char/tpm/tpm_i2c_nuvoton.c   | 16 +++++++---------
 5 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/i2c.c b/drivers/char/tpm/st33zp24/i2c.c
index be5d1abd3e8ef..8390c5b54c3be 100644
--- a/drivers/char/tpm/st33zp24/i2c.c
+++ b/drivers/char/tpm/st33zp24/i2c.c
@@ -33,7 +33,7 @@
 
 struct st33zp24_i2c_phy {
 	struct i2c_client *client;
-	u8 buf[TPM_BUFSIZE + 1];
+	u8 buf[ST33ZP24_BUFSIZE + 1];
 	int io_lpcpd;
 };
 
diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
index d7909ab287a85..ff019a1e3c68f 100644
--- a/drivers/char/tpm/st33zp24/spi.c
+++ b/drivers/char/tpm/st33zp24/spi.c
@@ -63,7 +63,7 @@
  * some latency byte before the answer is available (max 15).
  * We have 2048 + 1024 + 15.
  */
-#define ST33ZP24_SPI_BUFFER_SIZE (TPM_BUFSIZE + (TPM_BUFSIZE / 2) +\
+#define ST33ZP24_SPI_BUFFER_SIZE (ST33ZP24_BUFSIZE + (ST33ZP24_BUFSIZE / 2) +\
 				  MAX_SPI_LATENCY)
 
 
diff --git a/drivers/char/tpm/st33zp24/st33zp24.h b/drivers/char/tpm/st33zp24/st33zp24.h
index 6f4a4198af6aa..20da0a84988d6 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.h
+++ b/drivers/char/tpm/st33zp24/st33zp24.h
@@ -18,8 +18,8 @@
 #ifndef __LOCAL_ST33ZP24_H__
 #define __LOCAL_ST33ZP24_H__
 
-#define TPM_WRITE_DIRECTION             0x80
-#define TPM_BUFSIZE                     2048
+#define TPM_WRITE_DIRECTION	0x80
+#define ST33ZP24_BUFSIZE	2048
 
 struct st33zp24_dev {
 	struct tpm_chip *chip;
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 977fd42daa1b1..3b4e9672ff6cd 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -26,8 +26,7 @@
 #include <linux/wait.h>
 #include "tpm.h"
 
-/* max. buffer size supported by our TPM */
-#define TPM_BUFSIZE 1260
+#define TPM_I2C_INFINEON_BUFSIZE 1260
 
 /* max. number of iterations after I2C NAK */
 #define MAX_COUNT 3
@@ -63,11 +62,13 @@ enum i2c_chip_type {
 	UNKNOWN,
 };
 
-/* Structure to store I2C TPM specific stuff */
 struct tpm_inf_dev {
 	struct i2c_client *client;
 	int locality;
-	u8 buf[TPM_BUFSIZE + sizeof(u8)]; /* max. buffer size + addr */
+	/* In addition to the data itself, the buffer must fit the 7-bit I2C
+	 * address and the direction bit.
+	 */
+	u8 buf[TPM_I2C_INFINEON_BUFSIZE + 1];
 	struct tpm_chip *chip;
 	enum i2c_chip_type chip_type;
 	unsigned int adapterlimit;
@@ -219,7 +220,7 @@ static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
 		.buf = tpm_dev.buf
 	};
 
-	if (len > TPM_BUFSIZE)
+	if (len > TPM_I2C_INFINEON_BUFSIZE)
 		return -EINVAL;
 
 	if (!tpm_dev.client->adapter->algo->master_xfer)
@@ -527,8 +528,8 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	u8 retries = 0;
 	u8 sts = TPM_STS_GO;
 
-	if (len > TPM_BUFSIZE)
-		return -E2BIG;	/* command is too long for our tpm, sorry */
+	if (len > TPM_I2C_INFINEON_BUFSIZE)
+		return -E2BIG;
 
 	if (request_locality(chip, 0) < 0)
 		return -EBUSY;
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index b8defdfdf2dc6..2803080097841 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -35,14 +35,12 @@
 #include "tpm.h"
 
 /* I2C interface offsets */
-#define TPM_STS                0x00
-#define TPM_BURST_COUNT        0x01
-#define TPM_DATA_FIFO_W        0x20
-#define TPM_DATA_FIFO_R        0x40
-#define TPM_VID_DID_RID        0x60
-/* TPM command header size */
-#define TPM_HEADER_SIZE        10
-#define TPM_RETRY      5
+#define TPM_STS			0x00
+#define TPM_BURST_COUNT		0x01
+#define TPM_DATA_FIFO_W		0x20
+#define TPM_DATA_FIFO_R		0x40
+#define TPM_VID_DID_RID		0x60
+#define TPM_I2C_RETRIES		5
 /*
  * I2C bus device maximum buffer size w/o counting I2C address or command
  * i.e. max size required for I2C write is 34 = addr, command, 32 bytes data
@@ -292,7 +290,7 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		dev_err(dev, "%s() count < header size\n", __func__);
 		return -EIO;
 	}
-	for (retries = 0; retries < TPM_RETRY; retries++) {
+	for (retries = 0; retries < TPM_I2C_RETRIES; retries++) {
 		if (retries > 0) {
 			/* if this is not the first trial, set responseRetry */
 			i2c_nuvoton_write_status(client,
-- 
2.20.1

