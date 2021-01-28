Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5507D308229
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 00:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhA1X5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 18:57:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhA1X5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 18:57:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A91D164E01;
        Thu, 28 Jan 2021 23:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611878201;
        bh=pCg8FebbkyCbdo17dXGf3FV8b5El/fzjfwQHCFwObw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVkG5YboJScneWl7PuCuCn/CF0iM1A3JBMxbDrwEFdgPWZzR66Y2L1C9FVEIDgJCN
         MH7Snmhl3E78b8G30yh0VJ6fWBhGPbI9mw7C+ZwwxXgnivHYQBZKA27aG0e+B9ybcg
         MGt0hVyvkJ69oMYNkJ7CXpc4iVXoN3tW3738HBZxklpR2DgWUY9n4Sl2Wl6IrRBRb2
         jIdDgx7GeHcwctEecf/5GBaLVQ3jduLAqlpzehh9gu36T0a86HyehGGlZsnnVH+BsC
         vbDJ968UcHw4HNtO4eO6vmCCDkL19mz0jrPEqb47zMbxKDJSPmawzqsgqoBL+a8s51
         /960jrrA/IwaQ==
From:   jarkko@kernel.org
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: [PATCH v5 3/3] KEYS: trusted: Reserve TPM for seal and unseal operations
Date:   Fri, 29 Jan 2021 01:56:21 +0200
Message-Id: <20210128235621.127925-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210128235621.127925-1-jarkko@kernel.org>
References: <20210128235621.127925-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

When TPM 2.0 trusted keys code was moved to the trusted keys subsystem,
the operations were unwrapped from tpm_try_get_ops() and tpm_put_ops(),
which are used to take temporarily the ownership of the TPM chip. The
ownership is only taken inside tpm_send(), but this is not sufficient,
as in the key load TPM2_CC_LOAD, TPM2_CC_UNSEAL and TPM2_FLUSH_CONTEXT
need to be done as a one single atom.

Take the TPM chip ownership before sending anything with
tpm_try_get_ops() and tpm_put_ops(), and use tpm_transmit_cmd() to send
TPM commands instead of tpm_send(), reverting back to the old behaviour.

Fixes: 2e19e10131a0 ("KEYS: trusted: Move TPM2 trusted keys code")
Reported-by: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm.h                    |  4 ----
 include/linux/tpm.h                       |  5 ++++-
 security/keys/trusted-keys/trusted_tpm2.c | 24 ++++++++++++++++++-----
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 947d1db0a5cc..283f78211c3a 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -164,8 +164,6 @@ extern const struct file_operations tpmrm_fops;
 extern struct idr dev_nums_idr;
 
 ssize_t tpm_transmit(struct tpm_chip *chip, u8 *buf, size_t bufsiz);
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
-			 size_t min_rsp_body_length, const char *desc);
 int tpm_get_timeouts(struct tpm_chip *);
 int tpm_auto_startup(struct tpm_chip *chip);
 
@@ -194,8 +192,6 @@ static inline void tpm_msleep(unsigned int delay_msec)
 int tpm_chip_start(struct tpm_chip *chip);
 void tpm_chip_stop(struct tpm_chip *chip);
 struct tpm_chip *tpm_find_get_ops(struct tpm_chip *chip);
-__must_check int tpm_try_get_ops(struct tpm_chip *chip);
-void tpm_put_ops(struct tpm_chip *chip);
 
 struct tpm_chip *tpm_chip_alloc(struct device *dev,
 				const struct tpm_class_ops *ops);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index ae2482510f8c..543aa3b1dedc 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -404,6 +404,10 @@ static inline u32 tpm2_rc_value(u32 rc)
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_is_tpm2(struct tpm_chip *chip);
+extern __must_check int tpm_try_get_ops(struct tpm_chip *chip);
+extern void tpm_put_ops(struct tpm_chip *chip);
+extern ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
+				size_t min_rsp_body_length, const char *desc);
 extern int tpm_pcr_read(struct tpm_chip *chip, u32 pcr_idx,
 			struct tpm_digest *digest);
 extern int tpm_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
@@ -417,7 +421,6 @@ static inline int tpm_is_tpm2(struct tpm_chip *chip)
 {
 	return -ENODEV;
 }
-
 static inline int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx,
 			       struct tpm_digest *digest)
 {
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 08ec7f48f01d..c87c4df8703d 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -79,10 +79,16 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (i == ARRAY_SIZE(tpm2_hash_map))
 		return -EINVAL;
 
-	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
+	rc = tpm_try_get_ops(chip);
 	if (rc)
 		return rc;
 
+	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
+	if (rc) {
+		tpm_put_ops(chip);
+		return rc;
+	}
+
 	tpm_buf_append_u32(&buf, options->keyhandle);
 	tpm2_buf_append_auth(&buf, TPM2_RS_PW,
 			     NULL /* nonce */, 0,
@@ -130,7 +136,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_send(chip, buf.data, tpm_buf_length(&buf));
+	rc = tpm_transmit_cmd(chip, &buf, 4, "sealing data");
 	if (rc)
 		goto out;
 
@@ -157,6 +163,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 			rc = -EPERM;
 	}
 
+	tpm_put_ops(chip);
 	return rc;
 }
 
@@ -211,7 +218,7 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_send(chip, buf.data, tpm_buf_length(&buf));
+	rc = tpm_transmit_cmd(chip, &buf, 4, "loading blob");
 	if (!rc)
 		*blob_handle = be32_to_cpup(
 			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
@@ -260,7 +267,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			     options->blobauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-	rc = tpm_send(chip, buf.data, tpm_buf_length(&buf));
+	rc = tpm_transmit_cmd(chip, &buf, 6, "unsealing");
 	if (rc > 0)
 		rc = -EPERM;
 
@@ -304,12 +311,19 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
 	u32 blob_handle;
 	int rc;
 
-	rc = tpm2_load_cmd(chip, payload, options, &blob_handle);
+	rc = tpm_try_get_ops(chip);
 	if (rc)
 		return rc;
 
+	rc = tpm2_load_cmd(chip, payload, options, &blob_handle);
+	if (rc)
+		goto out;
+
 	rc = tpm2_unseal_cmd(chip, payload, options, blob_handle);
 	tpm2_flush_context(chip, blob_handle);
 
+out:
+	tpm_put_ops(chip);
+
 	return rc;
 }
-- 
2.30.0

