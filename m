Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA540212FB5
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 00:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgGBW4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 18:56:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:52877 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgGBW4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 18:56:13 -0400
IronPort-SDR: a+1uYMjfxWyx/8MngEQh/h6ENcQ5I9vuTYAQG160PicKWaH7mClLlI9jWcI9CRBmenScir7peG
 5zFLaeRZ7KuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="212070437"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="212070437"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 15:56:12 -0700
IronPort-SDR: TzjlWg0ORkTgQ63IQfi80JF8/WO0qJeq+9NRWr/2K+URbn+1GHTrlJ60lO0LjtW5x++WXSt+jx
 FGTpmRfJhB+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="455684823"
Received: from chadjitt-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.125])
  by orsmga005.jf.intel.com with ESMTP; 02 Jul 2020 15:56:06 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stefan Berger <stefanb@linux.ibm.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alexey Klimov <aklimov@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tpm: Define TPM2_SPACE_BUFFER_SIZE to replace the use of PAGE_SIZE
Date:   Fri,  3 Jul 2020 01:55:59 +0300
Message-Id: <20200702225603.293122-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The size of the buffers for storing context's and sessions can vary from
arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
enough for most use with three handles (that is how many we allow at the
moment). Parametrize the buffer size while doing this, so that it is easier
to revisit this later on if required.

Reported-by: Stefan Berger <stefanb@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
v2: Also use the new buffer size for chip->work_buffer (reported by stefanb)
 drivers/char/tpm/tpm-chip.c   |  9 ++-------
 drivers/char/tpm/tpm.h        |  5 ++++-
 drivers/char/tpm/tpm2-space.c | 26 ++++++++++++++++----------
 drivers/char/tpm/tpmrm-dev.c  |  2 +-
 include/linux/tpm.h           |  5 +++--
 5 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 8c77e88012e9..ddaeceb7e109 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -386,13 +386,8 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->cdev.owner = THIS_MODULE;
 	chip->cdevs.owner = THIS_MODULE;
 
-	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!chip->work_space.context_buf) {
-		rc = -ENOMEM;
-		goto out;
-	}
-	chip->work_space.session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!chip->work_space.session_buf) {
+	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
+	if (rc) {
 		rc = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 0fbcede241ea..947d1db0a5cc 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -59,6 +59,9 @@ enum tpm_addr {
 
 #define TPM_TAG_RQU_COMMAND 193
 
+/* TPM2 specific constants. */
+#define TPM2_SPACE_BUFFER_SIZE		16384 /* 16 kB */
+
 struct	stclear_flags_t {
 	__be16	tag;
 	u8	deactivated;
@@ -228,7 +231,7 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
 int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip);
 int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
-int tpm2_init_space(struct tpm_space *space);
+int tpm2_init_space(struct tpm_space *space, unsigned int buf_size);
 void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space);
 void tpm2_flush_space(struct tpm_chip *chip);
 int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index 982d341d8837..784b8b3cb903 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -38,18 +38,21 @@ static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
 	}
 }
 
-int tpm2_init_space(struct tpm_space *space)
+int tpm2_init_space(struct tpm_space *space, unsigned int buf_size)
 {
-	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	space->context_buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!space->context_buf)
 		return -ENOMEM;
 
-	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	space->session_buf = kzalloc(buf_size, GFP_KERNEL);
 	if (space->session_buf == NULL) {
 		kfree(space->context_buf);
+		/* Prevent caller getting a dangling pointer. */
+		space->context_buf = NULL;
 		return -ENOMEM;
 	}
 
+	space->buf_size = buf_size;
 	return 0;
 }
 
@@ -311,8 +314,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
 	       sizeof(space->context_tbl));
 	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
 	       sizeof(space->session_tbl));
-	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
-	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
+	memcpy(chip->work_space.context_buf, space->context_buf,
+	       space->buf_size);
+	memcpy(chip->work_space.session_buf, space->session_buf,
+	       space->buf_size);
 
 	rc = tpm2_load_space(chip);
 	if (rc) {
@@ -492,7 +497,7 @@ static int tpm2_save_space(struct tpm_chip *chip)
 			continue;
 
 		rc = tpm2_save_context(chip, space->context_tbl[i],
-				       space->context_buf, PAGE_SIZE,
+				       space->context_buf, space->buf_size,
 				       &offset);
 		if (rc == -ENOENT) {
 			space->context_tbl[i] = 0;
@@ -509,9 +514,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
 			continue;
 
 		rc = tpm2_save_context(chip, space->session_tbl[i],
-				       space->session_buf, PAGE_SIZE,
+				       space->session_buf, space->buf_size,
 				       &offset);
-
 		if (rc == -ENOENT) {
 			/* handle error saving session, just forget it */
 			space->session_tbl[i] = 0;
@@ -557,8 +561,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 	       sizeof(space->context_tbl));
 	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
 	       sizeof(space->session_tbl));
-	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
-	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
+	memcpy(space->context_buf, chip->work_space.context_buf,
+	       space->buf_size);
+	memcpy(space->session_buf, chip->work_space.session_buf,
+	       space->buf_size);
 
 	return 0;
 out:
diff --git a/drivers/char/tpm/tpmrm-dev.c b/drivers/char/tpm/tpmrm-dev.c
index 7a0a7051a06f..eef0fb06ea83 100644
--- a/drivers/char/tpm/tpmrm-dev.c
+++ b/drivers/char/tpm/tpmrm-dev.c
@@ -21,7 +21,7 @@ static int tpmrm_open(struct inode *inode, struct file *file)
 	if (priv == NULL)
 		return -ENOMEM;
 
-	rc = tpm2_init_space(&priv->space);
+	rc = tpm2_init_space(&priv->space, TPM2_SPACE_BUFFER_SIZE);
 	if (rc) {
 		kfree(priv);
 		return -ENOMEM;
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 03e9b184411b..d501156fedda 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -93,9 +93,10 @@ enum tpm_duration {
 
 struct tpm_space {
 	u32 context_tbl[3];
-	u8 *context_buf;
+	u8  *context_buf;
 	u32 session_tbl[3];
-	u8 *session_buf;
+	u8  *session_buf;
+	u32 buf_size;
 };
 
 struct tpm_bios_log {
-- 
2.25.1

