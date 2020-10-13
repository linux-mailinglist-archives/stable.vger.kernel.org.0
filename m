Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4EE28C5B5
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 02:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgJMA2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 20:28:44 -0400
Received: from mga05.intel.com ([192.55.52.43]:48095 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgJMA2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 20:28:43 -0400
IronPort-SDR: lqM/y9FL8MOod9/w0OIjhRHzpH0X8y3klyySfXP2+dTRZ0RahvNiaKbDNnr8CFdLdtvftmOFNs
 XQvJ/pdM9Rlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="250518563"
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="250518563"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 17:28:42 -0700
IronPort-SDR: 9wB8uvUl5YmPBYIIbizvh8JTxqZU+2JjQGkMcialqhA8ji0C9LIdoJ/2eNjYpJdJ8Tc/pDD6GL
 P89jA2732Lgw==
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="299438099"
Received: from lusin-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.81])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 17:28:38 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        kernel test robot <lkp@intel.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        keyrings@vger.kernel.org (open list:KEYS-TRUSTED),
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: [PATCH v3 3/3] KEYS: trusted: Reserve TPM for seal and unseal operations
Date:   Tue, 13 Oct 2020 03:28:15 +0300
Message-Id: <20201013002815.40256-4-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013002815.40256-1-jarkko.sakkinen@linux.intel.com>
References: <20201013002815.40256-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When TPM 2.0 trusted keys code was moved to the trusted keys subsystem,
the operations were unwrapped from tpm_try_get_ops() and tpm_put_ops(),
which are used to take temporarily the ownership of the TPM chip. The
ownership is only taken inside tpm_send(), but this is not sufficient,
as in the key load TPM2_CC_LOAD, TPM2_CC_UNSEAL and TPM2_FLUSH_CONTEXT
need to be done as a one single atom.

Fix this issue by introducting trusted_tpm_load() and trusted_tpm_new(),
which wrap these operations, and take the TPM chip ownership before
sending anything. Use tpm_transmit_cmd() to send TPM commands instead
of tpm_send(), reverting back to the old behaviour.

Fixes: 2e19e10131a0 ("KEYS: trusted: Move TPM2 trusted keys code")
Reported-by: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/char/tpm/tpm.h                    |  4 --
 include/linux/tpm.h                       | 17 ++++-
 security/keys/trusted-keys/trusted_tpm1.c | 78 +++++++++++++++--------
 security/keys/trusted-keys/trusted_tpm2.c |  6 +-
 4 files changed, 72 insertions(+), 33 deletions(-)

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
index 8f4ff39f51e7..f0ebce14d2f8 100644
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
@@ -410,7 +414,18 @@ static inline int tpm_is_tpm2(struct tpm_chip *chip)
 {
 	return -ENODEV;
 }
-
+static inline int tpm_try_get_ops(struct tpm_chip *chip)
+{
+	return -ENODEV;
+}
+static inline void tpm_put_ops(struct tpm_chip *chip)
+{
+}
+static inline ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
+				       size_t min_rsp_body_length, const char *desc)
+{
+	return -ENODEV;
+}
 static inline int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx,
 			       struct tpm_digest *digest)
 {
diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 7a937c3c5283..20ca18e17437 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -950,6 +950,51 @@ static struct trusted_key_payload *trusted_payload_alloc(struct key *key)
 	return p;
 }
 
+static int trusted_tpm_load(struct tpm_chip *chip,
+			    struct trusted_key_payload *payload,
+			    struct trusted_key_options *options)
+{
+	int ret;
+
+	if (tpm_is_tpm2(chip)) {
+		ret = tpm_try_get_ops(chip);
+		if (!ret) {
+			ret = tpm2_unseal_trusted(chip, payload, options);
+			tpm_put_ops(chip);
+		}
+	} else {
+		ret = key_unseal(payload, options);
+	}
+
+	return ret;
+}
+
+static int trusted_tpm_new(struct tpm_chip *chip,
+			   struct trusted_key_payload *payload,
+			   struct trusted_key_options *options)
+{
+	int ret;
+
+	ret = tpm_get_random(chip, payload->key, payload->key_len);
+	if (ret < 0)
+		return ret;
+
+	if (ret != payload->key_len)
+		return -EIO;
+
+	if (tpm_is_tpm2(chip)) {
+		ret = tpm_try_get_ops(chip);
+		if (!ret) {
+			ret = tpm2_seal_trusted(chip, payload, options);
+			tpm_put_ops(chip);
+		}
+	} else {
+		ret = key_seal(payload, options);
+	}
+
+	return ret;
+}
+
 /*
  * trusted_instantiate - create a new trusted key
  *
@@ -968,12 +1013,6 @@ static int trusted_instantiate(struct key *key,
 	char *datablob;
 	int ret = 0;
 	int key_cmd;
-	size_t key_len;
-	int tpm2;
-
-	tpm2 = tpm_is_tpm2(chip);
-	if (tpm2 < 0)
-		return tpm2;
 
 	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		return -EINVAL;
@@ -1011,32 +1050,21 @@ static int trusted_instantiate(struct key *key,
 
 	switch (key_cmd) {
 	case Opt_load:
-		if (tpm2)
-			ret = tpm2_unseal_trusted(chip, payload, options);
-		else
-			ret = key_unseal(payload, options);
+		ret = trusted_tpm_load(chip, payload, options);
+
 		dump_payload(payload);
 		dump_options(options);
+
 		if (ret < 0)
-			pr_info("trusted_key: key_unseal failed (%d)\n", ret);
+			pr_info("%s: load failed (%d)\n", __func__, ret);
+
 		break;
 	case Opt_new:
-		key_len = payload->key_len;
-		ret = tpm_get_random(chip, payload->key, key_len);
-		if (ret < 0)
-			goto out;
+		ret = trusted_tpm_new(chip, payload, options);
 
-		if (ret != key_len) {
-			pr_info("trusted_key: key_create failed (%d)\n", ret);
-			ret = -EIO;
-			goto out;
-		}
-		if (tpm2)
-			ret = tpm2_seal_trusted(chip, payload, options);
-		else
-			ret = key_seal(payload, options);
 		if (ret < 0)
-			pr_info("trusted_key: key_seal failed (%d)\n", ret);
+			pr_info("%s: new failed (%d)\n", __func__, ret);
+
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 08ec7f48f01d..effdb67fac6d 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -130,7 +130,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_send(chip, buf.data, tpm_buf_length(&buf));
+	rc = tpm_transmit_cmd(chip, &buf, 4, "sealing data");
 	if (rc)
 		goto out;
 
@@ -211,7 +211,7 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 		goto out;
 	}
 
-	rc = tpm_send(chip, buf.data, tpm_buf_length(&buf));
+	rc = tpm_transmit_cmd(chip, &buf, 4, "loading blob");
 	if (!rc)
 		*blob_handle = be32_to_cpup(
 			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
@@ -260,7 +260,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			     options->blobauth /* hmac */,
 			     TPM_DIGEST_SIZE);
 
-	rc = tpm_send(chip, buf.data, tpm_buf_length(&buf));
+	rc = tpm_transmit_cmd(chip, &buf, 6, "unsealing");
 	if (rc > 0)
 		rc = -EPERM;
 
-- 
2.25.1

