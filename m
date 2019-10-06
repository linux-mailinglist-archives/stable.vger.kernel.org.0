Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41D8CD861
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfJFSDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 14:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbfJFRZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:25:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 287EE2077B;
        Sun,  6 Oct 2019 17:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382703;
        bh=N+J1JOiT3RQJX4iI4oitW5psWbsSuic/cVu2aPWEJ1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DE25HR3YeGNlgtuS5IU+/CxvXAPNuq0ZK783O5KY0Vzvmt4bWB7KIUDB6KNeGQsnU
         C6ZbRXt2nKIw3+HstaT3MAIA771D5DRzSWvegnjLlsnpfDu8FNmm5+T7Vfc+f/xCyQ
         EZHgHIanIvJ10MOHK8sZG6dbe2u63ZCFCOh3Bt5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/68] tpm: migrate pubek_show to struct tpm_buf
Date:   Sun,  6 Oct 2019 19:20:37 +0200
Message-Id: <20191006171108.940143373@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

commit da379f3c1db0c9a1fd27b11d24c9894b5edc7c75 upstream

Migrated pubek_show to struct tpm_buf and cleaned up its implementation.
Previously the output parameter structure was declared but left
completely unused. Now it is used to refer different fields of the
output. We can move it to tpm-sysfs.c as it does not have any use
outside of that file.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-sysfs.c | 87 ++++++++++++++++++++----------------
 drivers/char/tpm/tpm.h       | 13 ------
 2 files changed, 48 insertions(+), 52 deletions(-)

diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 86f38d239476a..83a77a4455380 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -20,44 +20,48 @@
 #include <linux/device.h>
 #include "tpm.h"
 
-#define READ_PUBEK_RESULT_SIZE 314
+struct tpm_readpubek_out {
+	u8 algorithm[4];
+	u8 encscheme[2];
+	u8 sigscheme[2];
+	__be32 paramsize;
+	u8 parameters[12];
+	__be32 keysize;
+	u8 modulus[256];
+	u8 checksum[20];
+} __packed;
+
 #define READ_PUBEK_RESULT_MIN_BODY_SIZE (28 + 256)
 #define TPM_ORD_READPUBEK 124
-static const struct tpm_input_header tpm_readpubek_header = {
-	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
-	.length = cpu_to_be32(30),
-	.ordinal = cpu_to_be32(TPM_ORD_READPUBEK)
-};
+
 static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	u8 *data;
-	struct tpm_cmd_t tpm_cmd;
-	ssize_t err;
-	int i, rc;
+	struct tpm_buf tpm_buf;
+	struct tpm_readpubek_out *out;
+	ssize_t rc;
+	int i;
 	char *str = buf;
 	struct tpm_chip *chip = to_tpm_chip(dev);
+	char anti_replay[20];
 
-	memset(&tpm_cmd, 0, sizeof(tpm_cmd));
-
-	tpm_cmd.header.in = tpm_readpubek_header;
-	err = tpm_transmit_cmd(chip, NULL, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
-			       READ_PUBEK_RESULT_MIN_BODY_SIZE, 0,
-			       "attempting to read the PUBEK");
-	if (err)
-		goto out;
-
-	/*
-	   ignore header 10 bytes
-	   algorithm 32 bits (1 == RSA )
-	   encscheme 16 bits
-	   sigscheme 16 bits
-	   parameters (RSA 12->bytes: keybit, #primes, expbit)
-	   keylenbytes 32 bits
-	   256 byte modulus
-	   ignore checksum 20 bytes
-	 */
-	data = tpm_cmd.params.readpubek_out_buffer;
+	memset(&anti_replay, 0, sizeof(anti_replay));
+
+	rc = tpm_buf_init(&tpm_buf, TPM_TAG_RQU_COMMAND, TPM_ORD_READPUBEK);
+	if (rc)
+		return rc;
+
+	tpm_buf_append(&tpm_buf, anti_replay, sizeof(anti_replay));
+
+	rc = tpm_transmit_cmd(chip, NULL, tpm_buf.data, PAGE_SIZE,
+			      READ_PUBEK_RESULT_MIN_BODY_SIZE, 0,
+			      "attempting to read the PUBEK");
+	if (rc) {
+		tpm_buf_destroy(&tpm_buf);
+		return 0;
+	}
+
+	out = (struct tpm_readpubek_out *)&tpm_buf.data[10];
 	str +=
 	    sprintf(str,
 		    "Algorithm: %02X %02X %02X %02X\n"
@@ -68,21 +72,26 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 		    "%02X %02X %02X %02X\n"
 		    "Modulus length: %d\n"
 		    "Modulus:\n",
-		    data[0], data[1], data[2], data[3],
-		    data[4], data[5],
-		    data[6], data[7],
-		    data[12], data[13], data[14], data[15],
-		    data[16], data[17], data[18], data[19],
-		    data[20], data[21], data[22], data[23],
-		    be32_to_cpu(*((__be32 *) (data + 24))));
+		    out->algorithm[0], out->algorithm[1], out->algorithm[2],
+		    out->algorithm[3],
+		    out->encscheme[0], out->encscheme[1],
+		    out->sigscheme[0], out->sigscheme[1],
+		    out->parameters[0], out->parameters[1],
+		    out->parameters[2], out->parameters[3],
+		    out->parameters[4], out->parameters[5],
+		    out->parameters[6], out->parameters[7],
+		    out->parameters[8], out->parameters[9],
+		    out->parameters[10], out->parameters[11],
+		    be32_to_cpu(out->keysize));
 
 	for (i = 0; i < 256; i++) {
-		str += sprintf(str, "%02X ", data[i + 28]);
+		str += sprintf(str, "%02X ", out->modulus[i]);
 		if ((i + 1) % 16 == 0)
 			str += sprintf(str, "\n");
 	}
-out:
+
 	rc = str - buf;
+	tpm_buf_destroy(&tpm_buf);
 	return rc;
 }
 static DEVICE_ATTR_RO(pubek);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4bb9b4aa9b49c..d53d12f3df6d6 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -351,17 +351,6 @@ enum tpm_sub_capabilities {
 	TPM_CAP_PROP_TIS_DURATION = 0x120,
 };
 
-struct	tpm_readpubek_params_out {
-	u8	algorithm[4];
-	u8	encscheme[2];
-	u8	sigscheme[2];
-	__be32	paramsize;
-	u8	parameters[12]; /*assuming RSA*/
-	__be32	keysize;
-	u8	modulus[256];
-	u8	checksum[20];
-} __packed;
-
 typedef union {
 	struct	tpm_input_header in;
 	struct	tpm_output_header out;
@@ -391,8 +380,6 @@ struct tpm_getrandom_in {
 } __packed;
 
 typedef union {
-	struct	tpm_readpubek_params_out readpubek_out;
-	u8	readpubek_out_buffer[sizeof(struct tpm_readpubek_params_out)];
 	struct	tpm_pcrread_in	pcrread_in;
 	struct	tpm_pcrread_out	pcrread_out;
 	struct	tpm_getrandom_in getrandom_in;
-- 
2.20.1



