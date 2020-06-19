Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E21201177
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391186AbgFSP2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404589AbgFSP2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B129221D80;
        Fri, 19 Jun 2020 15:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580529;
        bh=u/SGjul9L8yvIwQLf0aUzCJ7rcHYtEU3h8ZQ5UY7iUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0XFYB8BQEEthTtWE5GfWO0E1N6/R5LiiafbOfebwtv+5gpM7m53OWRSEccPnijhY
         DFtUEDGNrN1WKCypEFrMcf/Hq6vl1BBI8YzQ1a8VdtoS7bJQglHtd4bBA9TOOQlnnG
         qDTcaMcplfdVkDBOWgkW6RyNMTYxmIm2MPR/ZL2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.7 277/376] ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()
Date:   Fri, 19 Jun 2020 16:33:15 +0200
Message-Id: <20200619141723.446976459@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 6cc7c266e5b47d3cd2b5bb7fd3aac4e6bb2dd1d2 upstream.

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
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima.h              |    3 ++-
 security/integrity/ima/ima_crypto.c       |    6 +++---
 security/integrity/ima/ima_init.c         |    2 +-
 security/integrity/ima/ima_template_lib.c |   18 ++++++++++++++++++
 4 files changed, 24 insertions(+), 5 deletions(-)

--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -52,6 +52,7 @@ extern int ima_policy_flag;
 extern int ima_hash_algo;
 extern int ima_appraise;
 extern struct tpm_chip *ima_tpm_chip;
+extern const char boot_aggregate_name[];
 
 /* IMA event related data */
 struct ima_event_data {
@@ -140,7 +141,7 @@ int ima_calc_buffer_hash(const void *buf
 int ima_calc_field_array_hash(struct ima_field_data *field_data,
 			      struct ima_template_desc *desc, int num_fields,
 			      struct ima_digest_data *hash);
-int __init ima_calc_boot_aggregate(struct ima_digest_data *hash);
+int ima_calc_boot_aggregate(struct ima_digest_data *hash);
 void ima_add_violation(struct file *file, const unsigned char *filename,
 		       struct integrity_iint_cache *iint,
 		       const char *op, const char *cause);
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -665,8 +665,8 @@ static void __init ima_pcrread(u32 idx,
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
@@ -694,7 +694,7 @@ static int __init ima_calc_boot_aggregat
 	return rc;
 }
 
-int __init ima_calc_boot_aggregate(struct ima_digest_data *hash)
+int ima_calc_boot_aggregate(struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
 	u16 crypto_id, alg_id;
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -19,7 +19,7 @@
 #include "ima.h"
 
 /* name for boot aggregate entry */
-static const char boot_aggregate_name[] = "boot_aggregate";
+const char boot_aggregate_name[] = "boot_aggregate";
 struct tpm_chip *ima_tpm_chip;
 
 /* Add the boot aggregate to the IMA measurement list and extend
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -286,6 +286,24 @@ int ima_eventdigest_init(struct ima_even
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
 


