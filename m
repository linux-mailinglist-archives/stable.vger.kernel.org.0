Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385BC200EE0
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403887AbgFSPM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391809AbgFSPMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:12:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BF5621582;
        Fri, 19 Jun 2020 15:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579544;
        bh=1KwirvsDMHWLQ7Z0VvAxu46ShZwtJBxh6Ejs8zxlCsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrTrVEhDzuhdEITt06r09A58UUsGMe6ry7f4Tp1DshCoDlZYRU5OZ+H727/+hOMh0
         CQ1m/xICWP/MlzD1W/xdUpzv510c0WDaEsiKE8Gi8UQt8rGTpE5p9IWwizkN7NhCtc
         K32XU7EZH10zuFqj9thGxgogcBI4iUAkgA1vDnl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.4 175/261] ima: Switch to ima_hash_algo for boot aggregate
Date:   Fri, 19 Jun 2020 16:33:06 +0200
Message-Id: <20200619141658.307549570@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 6f1a1d103b48b1533a9c804e7a069e2c8e937ce7 upstream.

boot_aggregate is the first entry of IMA measurement list. Its purpose is
to link pre-boot measurements to IMA measurements. As IMA was designed to
work with a TPM 1.2, the SHA1 PCR bank was always selected even if a
TPM 2.0 with support for stronger hash algorithms is available.

This patch first tries to find a PCR bank with the IMA default hash
algorithm. If it does not find it, it selects the SHA256 PCR bank for
TPM 2.0 and SHA1 for TPM 1.2. Ultimately, it selects SHA1 also for TPM 2.0
if the SHA256 PCR bank is not found.

If none of the PCR banks above can be found, boot_aggregate file digest is
filled with zeros, as for TPM bypass, making it impossible to perform a
remote attestation of the system.

Cc: stable@vger.kernel.org # 5.1.x
Fixes: 879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_crypto.c |   47 +++++++++++++++++++++++++++++++-----
 security/integrity/ima/ima_init.c   |   20 ++++++++++++---
 2 files changed, 57 insertions(+), 10 deletions(-)

--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -655,18 +655,29 @@ static void __init ima_pcrread(u32 idx,
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
@@ -675,7 +686,8 @@ static int __init ima_calc_boot_aggregat
 	for (i = TPM_PCR0; i < TPM_PCR8; i++) {
 		ima_pcrread(i, &d);
 		/* now accumulate with current aggregate */
-		rc = crypto_shash_update(shash, d.digest, TPM_DIGEST_SIZE);
+		rc = crypto_shash_update(shash, d.digest,
+					 crypto_shash_digestsize(tfm));
 	}
 	if (!rc)
 		crypto_shash_final(shash, digest);
@@ -685,14 +697,37 @@ static int __init ima_calc_boot_aggregat
 int __init ima_calc_boot_aggregate(struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
-	int rc;
+	u16 crypto_id, alg_id;
+	int rc, i, bank_idx = -1;
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
+
+		if (bank_idx == -1 && crypto_id == HASH_ALGO_SHA1)
+			bank_idx = i;
+	}
+
+	if (bank_idx == -1) {
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
@@ -51,15 +51,27 @@ static int __init ima_add_boot_aggregate
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
+	iint->ima_hash->algo = ima_hash_algo;
+	iint->ima_hash->length = hash_digest_size[ima_hash_algo];
 
+	/*
+	 * With TPM 2.0 hash agility, TPM chips could support multiple TPM
+	 * PCR banks, allowing firmware to configure and enable different
+	 * banks.  The SHA1 bank is not necessarily enabled.
+	 *
+	 * Use the same hash algorithm for reading the TPM PCRs as for
+	 * calculating the boot aggregate digest.  Preference is given to
+	 * the configured IMA default hash algorithm.  Otherwise, use the
+	 * TCG required banks - SHA256 for TPM 2.0, SHA1 for TPM 1.2.
+	 * Ultimately select SHA1 also for TPM 2.0 if the SHA256 PCR bank
+	 * is not found.
+	 */
 	if (ima_tpm_chip) {
 		result = ima_calc_boot_aggregate(&hash.hdr);
 		if (result < 0) {


