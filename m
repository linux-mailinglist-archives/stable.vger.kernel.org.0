Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6199259B5F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbgIARA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729659AbgIAPVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:21:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D60A8207D3;
        Tue,  1 Sep 2020 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973664;
        bh=2297YQ72wvSHkelr4UDDIjRp6NGKDdCCeUUwzrLGmA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6PsFihDt8h6j5lFrwp4+OEQVpc84X2YeZgD5hWFJl62FzBXHuC08QrByoTH7dJra
         LDQyTE7SD/caLO8kgobKxxklMS2U7bCtoG/CF92h2xD6MnkUq50E5tZLKh5oFIeNh3
         ssWjXIBuLbwjROSd/R4mE8/mhuQPUJLCyQmu+0no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 89/91] tpm: Unify the mismatching TPM space buffer sizes
Date:   Tue,  1 Sep 2020 17:11:03 +0200
Message-Id: <20200901150932.595852342@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

[ Upstream commit 6c4e79d99e6f42b79040f1a33cd4018f5425030b ]

The size of the buffers for storing context's and sessions can vary from
arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
enough for most use with three handles (that is how many we allow at the
moment). Parametrize the buffer size while doing this, so that it is easier
to revisit this later on if required.

Cc: stable@vger.kernel.org
Reported-by: Stefan Berger <stefanb@linux.ibm.com>
Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-chip.c   |  9 ++-------
 drivers/char/tpm/tpm.h        |  6 +++++-
 drivers/char/tpm/tpm2-space.c | 26 ++++++++++++++++----------
 drivers/char/tpm/tpmrm-dev.c  |  2 +-
 4 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index dcf5bb1534955..11ec5c2715a9e 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -247,13 +247,8 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
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
index d53d12f3df6d6..019fe80fedd83 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -174,6 +174,7 @@ struct tpm_space {
 	u8 *context_buf;
 	u32 session_tbl[3];
 	u8 *session_buf;
+	u32 buf_size;
 };
 
 enum tpm_chip_flags {
@@ -261,6 +262,9 @@ struct tpm_output_header {
 
 #define TPM_TAG_RQU_COMMAND 193
 
+/* TPM2 specific constants. */
+#define TPM2_SPACE_BUFFER_SIZE		16384 /* 16 kB */
+
 struct	stclear_flags_t {
 	__be16	tag;
 	u8	deactivated;
@@ -583,7 +587,7 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
 int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
-int tpm2_init_space(struct tpm_space *space);
+int tpm2_init_space(struct tpm_space *space, unsigned int buf_size);
 void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space);
 int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 		       u8 *cmd);
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index dabb2ae4e779a..115f0fb32179f 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -44,18 +44,21 @@ static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
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
 
@@ -278,8 +281,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
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
@@ -459,7 +464,7 @@ static int tpm2_save_space(struct tpm_chip *chip)
 			continue;
 
 		rc = tpm2_save_context(chip, space->context_tbl[i],
-				       space->context_buf, PAGE_SIZE,
+				       space->context_buf, space->buf_size,
 				       &offset);
 		if (rc == -ENOENT) {
 			space->context_tbl[i] = 0;
@@ -478,9 +483,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
 			continue;
 
 		rc = tpm2_save_context(chip, space->session_tbl[i],
-				       space->session_buf, PAGE_SIZE,
+				       space->session_buf, space->buf_size,
 				       &offset);
-
 		if (rc == -ENOENT) {
 			/* handle error saving session, just forget it */
 			space->session_tbl[i] = 0;
@@ -526,8 +530,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
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
 }
diff --git a/drivers/char/tpm/tpmrm-dev.c b/drivers/char/tpm/tpmrm-dev.c
index 1a0e97a5da5a4..162fb16243d03 100644
--- a/drivers/char/tpm/tpmrm-dev.c
+++ b/drivers/char/tpm/tpmrm-dev.c
@@ -22,7 +22,7 @@ static int tpmrm_open(struct inode *inode, struct file *file)
 	if (priv == NULL)
 		return -ENOMEM;
 
-	rc = tpm2_init_space(&priv->space);
+	rc = tpm2_init_space(&priv->space, TPM2_SPACE_BUFFER_SIZE);
 	if (rc) {
 		kfree(priv);
 		return -ENOMEM;
-- 
2.25.1



