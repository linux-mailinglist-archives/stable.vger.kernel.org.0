Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A1927B0F4
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 17:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgI1Pbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 11:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgI1Pbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 11:31:38 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A2121548;
        Mon, 28 Sep 2020 15:31:36 +0000 (UTC)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] KEYS: trusted: Reserve TPM for seal and unseal operations
Date:   Mon, 28 Sep 2020 18:31:33 +0300
Message-Id: <20200928153133.114953-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200928153133.114953-1-jarkko.sakkinen@linux.intel.com>
References: <20200928153133.114953-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When TPM 2.0 trusted keys code was moved to the trusted keys subsystem,
the operations were unwrapped from tpm_try_get_ops() and tpm_put_ops(),
which are used to take temporarily the ownership of the TPM chip.

Fix this issue by introducting trusted_tpm_load() and trusted_tpm_new(),
which wrap these operations.

Fixes: 2e19e10131a0 ("KEYS: trusted: Move TPM2 trusted keys code")
Reported-by: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm.h                    |  2 -
 include/linux/tpm.h                       | 10 ++-
 security/keys/trusted-keys/trusted_tpm1.c | 78 +++++++++++++++--------
 3 files changed, 62 insertions(+), 28 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 947d1db0a5cc..4338573a8d48 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -194,8 +194,6 @@ static inline void tpm_msleep(unsigned int delay_msec)
 int tpm_chip_start(struct tpm_chip *chip);
 void tpm_chip_stop(struct tpm_chip *chip);
 struct tpm_chip *tpm_find_get_ops(struct tpm_chip *chip);
-__must_check int tpm_try_get_ops(struct tpm_chip *chip);
-void tpm_put_ops(struct tpm_chip *chip);
 
 struct tpm_chip *tpm_chip_alloc(struct device *dev,
 				const struct tpm_class_ops *ops);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 8f4ff39f51e7..0fe1cb5517ea 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -397,6 +397,8 @@ static inline u32 tpm2_rc_value(u32 rc)
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_is_tpm2(struct tpm_chip *chip);
+extern __must_check int tpm_try_get_ops(struct tpm_chip *chip);
+extern void tpm_put_ops(struct tpm_chip *chip);
 extern int tpm_pcr_read(struct tpm_chip *chip, u32 pcr_idx,
 			struct tpm_digest *digest);
 extern int tpm_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
@@ -410,7 +412,13 @@ static inline int tpm_is_tpm2(struct tpm_chip *chip)
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
 static inline int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx,
 			       struct tpm_digest *digest)
 {
diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index c7b1701cdac5..c1dfc32c780b 100644
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
-- 
2.25.1

