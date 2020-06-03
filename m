Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323961ED312
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 17:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgFCPLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 11:11:53 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2273 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbgFCPLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 11:11:53 -0400
Received: from lhreml738-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 02C85582F77A874555B4;
        Wed,  3 Jun 2020 16:11:51 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml738-chm.china.huawei.com (10.201.108.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 3 Jun 2020 16:11:50 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 3 Jun 2020 17:11:49 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <tiwai@suse.de>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/2] ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()
Date:   Wed, 3 Jun 2020 17:08:21 +0200
Message-ID: <20200603150821.8607-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200603150821.8607-1-roberto.sassu@huawei.com>
References: <20200603150821.8607-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.160]
X-ClientProxiedBy: lhreml719-chm.china.huawei.com (10.201.108.70) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the template field 'd' is chosen and the digest to be added to the
measurement entry was not calculated with SHA1 or MD5, it is
recalculated with SHA1, by using the passed file descriptor. However, this
cannot be done for boot_aggregate, because there is no file descriptor.

This patch adds a call to ima_calc_boot_aggregate() in
ima_eventdigest_init(), so that the digest can be recalculated also for the
boot_aggregate entry.

Cc: stable@vger.kernel.org # 3.13.x
Fixes: 3ce1217d6cd5d ("ima: define template fields library and new helpers")
Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima.h              |  3 ++-
 security/integrity/ima/ima_crypto.c       |  6 +++---
 security/integrity/ima/ima_init.c         |  2 +-
 security/integrity/ima/ima_template_lib.c | 18 ++++++++++++++++++
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 02796473238b..df93ac258e01 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -57,6 +57,7 @@ extern int ima_hash_algo_idx __ro_after_init;
 extern int ima_extra_slots __ro_after_init;
 extern int ima_appraise;
 extern struct tpm_chip *ima_tpm_chip;
+extern const char boot_aggregate_name[];
 
 /* IMA event related data */
 struct ima_event_data {
@@ -144,7 +145,7 @@ int ima_calc_buffer_hash(const void *buf, loff_t len,
 			 struct ima_digest_data *hash);
 int ima_calc_field_array_hash(struct ima_field_data *field_data,
 			      struct ima_template_entry *entry);
-int __init ima_calc_boot_aggregate(struct ima_digest_data *hash);
+int ima_calc_boot_aggregate(struct ima_digest_data *hash);
 void ima_add_violation(struct file *file, const unsigned char *filename,
 		       struct integrity_iint_cache *iint,
 		       const char *op, const char *cause);
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index f3a7f4eb1fc1..ba5cc3264240 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -806,8 +806,8 @@ static void __init ima_pcrread(u32 idx, struct tpm_digest *d)
  * hash algorithm for reading the TPM PCRs as for calculating the boot
  * aggregate digest as stored in the measurement list.
  */
-static int __init ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
-					      struct crypto_shash *tfm)
+static int ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
+				       struct crypto_shash *tfm)
 {
 	struct tpm_digest d = { .alg_id = alg_id, .digest = {0} };
 	int rc;
@@ -835,7 +835,7 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
 	return rc;
 }
 
-int __init ima_calc_boot_aggregate(struct ima_digest_data *hash)
+int ima_calc_boot_aggregate(struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
 	u16 crypto_id, alg_id;
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index fc1e1002b48d..4902fe7bd570 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -19,7 +19,7 @@
 #include "ima.h"
 
 /* name for boot aggregate entry */
-static const char boot_aggregate_name[] = "boot_aggregate";
+const char boot_aggregate_name[] = "boot_aggregate";
 struct tpm_chip *ima_tpm_chip;
 
 /* Add the boot aggregate to the IMA measurement list and extend
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 9cd1e50f3ccc..635c6ac05050 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -286,6 +286,24 @@ int ima_eventdigest_init(struct ima_event_data *event_data,
 		goto out;
 	}
 
+	if ((const char *)event_data->filename == boot_aggregate_name) {
+		if (ima_tpm_chip) {
+			hash.hdr.algo = HASH_ALGO_SHA1;
+			result = ima_calc_boot_aggregate(&hash.hdr);
+
+			/* algo can change depending on available PCR banks */
+			if (!result && hash.hdr.algo != HASH_ALGO_SHA1)
+				result = -EINVAL;
+
+			if (result < 0)
+				memset(&hash, 0, sizeof(hash));
+		}
+
+		cur_digest = hash.hdr.digest;
+		cur_digestsize = hash_digest_size[HASH_ALGO_SHA1];
+		goto out;
+	}
+
 	if (!event_data->file)	/* missing info to re-calculate the digest */
 		return -EINVAL;
 
-- 
2.17.1

