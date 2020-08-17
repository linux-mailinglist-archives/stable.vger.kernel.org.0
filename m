Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED77E247517
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgHQPhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730557AbgHQPhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:37:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EC5D22C9F;
        Mon, 17 Aug 2020 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678653;
        bh=nW21AHRpNbXFTr0vxcK4B0tYx33N8hK0p9KvN3PsyP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2vi4CbicMVuh4ObbTf8fFLNsJq5yDwEVraSiLnNSL4BuL0m22SEl5HF35dOlpcXL
         HR8HhIXtmmAm40IjgsZYGLl89vmQvrkVwWXWTUiQ0UcsDxoZebeM9yp0VXijwuIuKh
         llh/HfxnB1R+hUg3Yl+SZHk9ny1FN4rPf+VXPgsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.8 408/464] tpm: Unify the mismatching TPM space buffer sizes
Date:   Mon, 17 Aug 2020 17:16:01 +0200
Message-Id: <20200817143853.324115626@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

commit 6c4e79d99e6f42b79040f1a33cd4018f5425030b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm-chip.c   |    9 ++-------
 drivers/char/tpm/tpm.h        |    5 ++++-
 drivers/char/tpm/tpm2-space.c |   26 ++++++++++++++++----------
 drivers/char/tpm/tpmrm-dev.c  |    2 +-
 include/linux/tpm.h           |    1 +
 5 files changed, 24 insertions(+), 19 deletions(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -386,13 +386,8 @@ struct tpm_chip *tpm_chip_alloc(struct d
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
@@ -228,7 +231,7 @@ unsigned long tpm2_calc_ordinal_duration
 int tpm2_probe(struct tpm_chip *chip);
 int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip);
 int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
-int tpm2_init_space(struct tpm_space *space);
+int tpm2_init_space(struct tpm_space *space, unsigned int buf_size);
 void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space);
 void tpm2_flush_space(struct tpm_chip *chip);
 int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -38,18 +38,21 @@ static void tpm2_flush_sessions(struct t
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
 
@@ -311,8 +314,10 @@ int tpm2_prepare_space(struct tpm_chip *
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
@@ -492,7 +497,7 @@ static int tpm2_save_space(struct tpm_ch
 			continue;
 
 		rc = tpm2_save_context(chip, space->context_tbl[i],
-				       space->context_buf, PAGE_SIZE,
+				       space->context_buf, space->buf_size,
 				       &offset);
 		if (rc == -ENOENT) {
 			space->context_tbl[i] = 0;
@@ -509,9 +514,8 @@ static int tpm2_save_space(struct tpm_ch
 			continue;
 
 		rc = tpm2_save_context(chip, space->session_tbl[i],
-				       space->session_buf, PAGE_SIZE,
+				       space->session_buf, space->buf_size,
 				       &offset);
-
 		if (rc == -ENOENT) {
 			/* handle error saving session, just forget it */
 			space->session_tbl[i] = 0;
@@ -557,8 +561,10 @@ int tpm2_commit_space(struct tpm_chip *c
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
--- a/drivers/char/tpm/tpmrm-dev.c
+++ b/drivers/char/tpm/tpmrm-dev.c
@@ -21,7 +21,7 @@ static int tpmrm_open(struct inode *inod
 	if (priv == NULL)
 		return -ENOMEM;
 
-	rc = tpm2_init_space(&priv->space);
+	rc = tpm2_init_space(&priv->space, TPM2_SPACE_BUFFER_SIZE);
 	if (rc) {
 		kfree(priv);
 		return -ENOMEM;
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -96,6 +96,7 @@ struct tpm_space {
 	u8 *context_buf;
 	u32 session_tbl[3];
 	u8 *session_buf;
+	u32 buf_size;
 };
 
 struct tpm_bios_log {


