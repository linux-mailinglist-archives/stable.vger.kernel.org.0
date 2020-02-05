Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39036152936
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 11:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgBEKet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 05:34:49 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2367 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727771AbgBEKet (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 05:34:49 -0500
Received: from lhreml702-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 5DC3C8ED0343F8C467BD;
        Wed,  5 Feb 2020 10:34:47 +0000 (GMT)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by smtpsuk.huawei.com (10.201.108.43) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 5 Feb 2020 10:34:39 +0000
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <James.Bottomley@HansenPartnership.com>,
        <jarkko.sakkinen@linux.intel.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 2/8] ima: Switch to ima_hash_algo for boot aggregate
Date:   Wed, 5 Feb 2020 11:33:11 +0100
Message-ID: <20200205103317.29356-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200205103317.29356-1-roberto.sassu@huawei.com>
References: <20200205103317.29356-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.160]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

boot_aggregate is the first entry of IMA measurement list. Its purpose is
to link pre-boot measurements to IMA measurements. As IMA was designed to
work with a TPM 1.2, the SHA1 PCR bank was always selected.

Currently, even if a TPM 2.0 is used, the SHA1 PCR bank is selected.
However, the assumption that the SHA1 PCR bank is always available is not
correct, as PCR banks can be selected with the PCR_Allocate() TPM command.

This patch tries to use ima_hash_algo as hash algorithm for boot_aggregate.
If no PCR bank uses that algorithm, the patch tries to find the SHA256 PCR
bank (which is mandatory in the TCG PC Client specification). If also this
bank is not found, the patch selects the first one. If the TPM algorithm
of that bank is not mapped to a crypto ID, boot_aggregate is set to zero.

Changelog

v1:
- add Mimi's comments
- if there is no PCR bank for the IMA default algorithm use SHA256 or the
  first bank (suggested by James Bottomley)

Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
---
 security/integrity/ima/ima_crypto.c | 45 +++++++++++++++++++++++++----
 security/integrity/ima/ima_init.c   | 22 ++++++++++----
 2 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 73044fc6a952..f2f41a2bc3d4 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -655,18 +655,29 @@ static void __init ima_pcrread(u32 idx, struct tpm_digest *d)
 }
 
 /*
- * Calculate the boot aggregate hash
+ * The boot_aggregate is a cumulative hash over TPM registers 0 - 7.  With
+ * TPM 1.2 the boot_aggregate was based on reading the SHA1 PCRs, but with
+ * TPM 2.0 hash agility, TPM chips could support multiple TPM PCR banks,
+ * allowing firmware to configure and enable different banks.
+ *
+ * Knowing which TPM bank is read to calculate the boot_aggregate digest
+ * needs to be conveyed to a verifier.  For this reason, use the same
+ * hash algorithm for reading the TPM PCRs as for calculating the boot
+ * aggregate digest as stored in the measurement list.
  */
-static int __init ima_calc_boot_aggregate_tfm(char *digest,
+static int __init ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
 					      struct crypto_shash *tfm)
 {
-	struct tpm_digest d = { .alg_id = TPM_ALG_SHA1, .digest = {0} };
+	struct tpm_digest d = { .alg_id = alg_id, .digest = {0} };
 	int rc;
 	u32 i;
 	SHASH_DESC_ON_STACK(shash, tfm);
 
 	shash->tfm = tfm;
 
+	pr_devel("calculating the boot-aggregate based on TPM bank: %04x\n",
+		 d.alg_id);
+
 	rc = crypto_shash_init(shash);
 	if (rc != 0)
 		return rc;
@@ -675,7 +686,8 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest,
 	for (i = TPM_PCR0; i < TPM_PCR8; i++) {
 		ima_pcrread(i, &d);
 		/* now accumulate with current aggregate */
-		rc = crypto_shash_update(shash, d.digest, TPM_DIGEST_SIZE);
+		rc = crypto_shash_update(shash, d.digest,
+					 crypto_shash_digestsize(tfm));
 	}
 	if (!rc)
 		crypto_shash_final(shash, digest);
@@ -685,14 +697,35 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest,
 int __init ima_calc_boot_aggregate(struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
-	int rc;
+	u16 crypto_id, alg_id;
+	int rc, i, bank_idx = 0;
+
+	for (i = 0; i < ima_tpm_chip->nr_allocated_banks; i++) {
+		crypto_id = ima_tpm_chip->allocated_banks[i].crypto_id;
+		if (crypto_id == hash->algo) {
+			bank_idx = i;
+			break;
+		}
+
+		if (crypto_id == HASH_ALGO_SHA256)
+			bank_idx = i;
+	}
+
+	if (bank_idx == 0 &&
+	    ima_tpm_chip->allocated_banks[0].crypto_id == HASH_ALGO__LAST) {
+		pr_err("No suitable TPM algorithm for boot aggregate\n");
+		return 0;
+	}
+
+	hash->algo = ima_tpm_chip->allocated_banks[bank_idx].crypto_id;
 
 	tfm = ima_alloc_tfm(hash->algo);
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
 	hash->length = crypto_shash_digestsize(tfm);
-	rc = ima_calc_boot_aggregate_tfm(hash->digest, tfm);
+	alg_id = ima_tpm_chip->allocated_banks[bank_idx].alg_id;
+	rc = ima_calc_boot_aggregate_tfm(hash->digest, alg_id, tfm);
 
 	ima_free_tfm(tfm);
 
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 5d55ade5f3b9..fbd7a8e28a6b 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -27,7 +27,7 @@ struct tpm_chip *ima_tpm_chip;
 /* Add the boot aggregate to the IMA measurement list and extend
  * the PCR register.
  *
- * Calculate the boot aggregate, a SHA1 over tpm registers 0-7,
+ * Calculate the boot aggregate, a hash over tpm registers 0-7,
  * assuming a TPM chip exists, and zeroes if the TPM chip does not
  * exist.  Add the boot aggregate measurement to the measurement
  * list and extend the PCR register.
@@ -51,15 +51,27 @@ static int __init ima_add_boot_aggregate(void)
 	int violation = 0;
 	struct {
 		struct ima_digest_data hdr;
-		char digest[TPM_DIGEST_SIZE];
+		char digest[TPM_MAX_DIGEST_SIZE];
 	} hash;
 
 	memset(iint, 0, sizeof(*iint));
 	memset(&hash, 0, sizeof(hash));
 	iint->ima_hash = &hash.hdr;
-	iint->ima_hash->algo = HASH_ALGO_SHA1;
-	iint->ima_hash->length = SHA1_DIGEST_SIZE;
-
+	iint->ima_hash->algo = ima_hash_algo;
+	iint->ima_hash->length = hash_digest_size[ima_hash_algo];
+
+	/*
+	 * With TPM 2.0 hash agility, TPM chips could support multiple TPM
+	 * PCR banks, allowing firmware to configure and enable different
+	 * banks.  The SHA1 bank is not necessarily enabled.
+	 *
+	 * Use the same hash algorithm for reading the TPM PCRs as for
+	 * calculating the boot aggregate digest.  Preference is given to
+	 * the configured IMA default hash algorithm.  Otherwise, use the
+	 * TPM required banks - SHA256 for TPM 2.0, SHA1 for TPM 1.2.  If
+	 * SHA256 is not available, use the first PCR bank and if that is
+	 * not mapped to a crypto ID, set boot_aggregate to zero.
+	 */
 	if (ima_tpm_chip) {
 		result = ima_calc_boot_aggregate(&hash.hdr);
 		if (result < 0) {
-- 
2.17.1

