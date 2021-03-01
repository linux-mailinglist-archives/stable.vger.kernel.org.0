Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3C5329167
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242045AbhCAUZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:25:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243215AbhCAUS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:18:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F38BE653EB;
        Mon,  1 Mar 2021 18:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621841;
        bh=gIrkr9f+g407ocE3V1plKh5srxdKOJERSnGXU0ad9DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjfNpAjeZH+65DuhcTy9HE23AvG7nCVPF7ULFP6IgSX7QAbh8Y0fQeskegwdKWRvB
         YlyIxa8qhf+MP1vWj79av3/1yQDYrQYsCBbLZxoCIn8XRU3eOXvM6AhiKVLw1ql1ch
         G7NK2ZKx5rLOXcUzamY0w5ikU3wa0kffJdXmiK40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.11 633/775] KEYS: trusted: Reserve TPM for seal and unseal operations
Date:   Mon,  1 Mar 2021 17:13:21 +0100
Message-Id: <20210301161232.678209694@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 8c657a0590de585b1115847c17b34a58025f2f4b upstream.

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
Acked-by Sumit Garg <sumit.garg@linaro.org>
Tested-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm.h                    |    4 ----
 include/linux/tpm.h                       |    5 ++++-
 security/keys/trusted-keys/trusted_tpm2.c |   22 ++++++++++++++++++----
 3 files changed, 22 insertions(+), 9 deletions(-)

--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -164,8 +164,6 @@ extern const struct file_operations tpmr
 extern struct idr dev_nums_idr;
 
 ssize_t tpm_transmit(struct tpm_chip *chip, u8 *buf, size_t bufsiz);
-ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
-			 size_t min_rsp_body_length, const char *desc);
 int tpm_get_timeouts(struct tpm_chip *);
 int tpm_auto_startup(struct tpm_chip *chip);
 
@@ -194,8 +192,6 @@ static inline void tpm_msleep(unsigned i
 int tpm_chip_start(struct tpm_chip *chip);
 void tpm_chip_stop(struct tpm_chip *chip);
 struct tpm_chip *tpm_find_get_ops(struct tpm_chip *chip);
-__must_check int tpm_try_get_ops(struct tpm_chip *chip);
-void tpm_put_ops(struct tpm_chip *chip);
 
 struct tpm_chip *tpm_chip_alloc(struct device *dev,
 				const struct tpm_class_ops *ops);
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -397,6 +397,10 @@ static inline u32 tpm2_rc_value(u32 rc)
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_is_tpm2(struct tpm_chip *chip);
+extern __must_check int tpm_try_get_ops(struct tpm_chip *chip);
+extern void tpm_put_ops(struct tpm_chip *chip);
+extern ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
+				size_t min_rsp_body_length, const char *desc);
 extern int tpm_pcr_read(struct tpm_chip *chip, u32 pcr_idx,
 			struct tpm_digest *digest);
 extern int tpm_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
@@ -410,7 +414,6 @@ static inline int tpm_is_tpm2(struct tpm
 {
 	return -ENODEV;
 }
-
 static inline int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx,
 			       struct tpm_digest *digest)
 {
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -83,6 +83,12 @@ int tpm2_seal_trusted(struct tpm_chip *c
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
@@ -130,7 +136,7 @@ int tpm2_seal_trusted(struct tpm_chip *c
 		goto out;
 	}
 
-	rc = tpm_send(chip, buf.data, tpm_buf_length(&buf));
+	rc = tpm_transmit_cmd(chip, &buf, 4, "sealing data");
 	if (rc)
 		goto out;
 
@@ -157,6 +163,7 @@ out:
 			rc = -EPERM;
 	}
 
+	tpm_put_ops(chip);
 	return rc;
 }
 
@@ -211,7 +218,7 @@ static int tpm2_load_cmd(struct tpm_chip
 		goto out;
 	}
 
-	rc = tpm_send(chip, buf.data, tpm_buf_length(&buf));
+	rc = tpm_transmit_cmd(chip, &buf, 4, "loading blob");
 	if (!rc)
 		*blob_handle = be32_to_cpup(
 			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
@@ -260,7 +267,7 @@ static int tpm2_unseal_cmd(struct tpm_ch
 			     options->blobauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-	rc = tpm_send(chip, buf.data, tpm_buf_length(&buf));
+	rc = tpm_transmit_cmd(chip, &buf, 6, "unsealing");
 	if (rc > 0)
 		rc = -EPERM;
 
@@ -304,12 +311,19 @@ int tpm2_unseal_trusted(struct tpm_chip
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


