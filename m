Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735ED2DA96E
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 09:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgLOIr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 03:47:28 -0500
Received: from spam01.hygon.cn ([110.188.70.11]:18261 "EHLO spam2.hygon.cn"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726985AbgLOIrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 03:47:20 -0500
X-Greylist: delayed 939 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2020 03:47:11 EST
Received: from spam2.hygon.cn (localhost [127.0.0.2] (may be forged))
        by spam2.hygon.cn with ESMTP id 0BF8VVRI097405
        for <stable@vger.kernel.org>; Tue, 15 Dec 2020 16:31:31 +0800 (GMT-8)
        (envelope-from chenshan@hygon.cn)
Received: from MK-FE.hygon.cn ([172.23.18.61])
        by spam2.hygon.cn with ESMTP id 0BF8UBpB097314;
        Tue, 15 Dec 2020 16:30:11 +0800 (GMT-8)
        (envelope-from chenshan@hygon.cn)
Received: from cncheex01.Hygon.cn ([172.23.18.10])
        by MK-FE.hygon.cn with ESMTP id 0BF8U9Oh054455;
        Tue, 15 Dec 2020 16:30:09 +0800 (GMT-8)
        (envelope-from chenshan@hygon.cn)
Received: from CS-AMD.hygon.cn (172.23.18.44) by cncheex01.Hygon.cn
 (172.23.18.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Tue, 15 Dec
 2020 16:30:03 +0800
From:   Shan <chenshan@hygon.cn>
To:     <alikernel-developer@linux.alibaba.com>
CC:     Roberto Sassu <roberto.sassu@huawei.com>, <mayuanchen@hygon.cn>,
        <fenghao@hygon.cn>, <yingzhiwei@hygon.cn>,
        <stable@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Shan <chenshan@hygon.cn>
Subject: [PATCH AliOS 4.19 v3 12/15] KEYS: trusted: correctly initialize digests and fix locking issue
Date:   Tue, 15 Dec 2020 16:29:19 +0800
Message-ID: <34a809986164765254d16d4acafd5eaa4e1e7f68.1608019826.git.chenshan@hygon.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608019826.git.chenshan@hygon.cn>
References: <cover.1608019826.git.chenshan@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.23.18.44]
X-ClientProxiedBy: cncheex01.Hygon.cn (172.23.18.10) To cncheex01.Hygon.cn
 (172.23.18.10)
X-MAIL: spam2.hygon.cn 0BF8UBpB097314
X-DNSRBL: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 9f75c82246313d4c2a6bc77e947b45655b3b5ad5 upstream.

Commit 0b6cf6b97b7e ("tpm: pass an array of tpm_extend_digest structures to
tpm_pcr_extend()") modifies tpm_pcr_extend() to accept a digest for each
PCR bank. After modification, tpm_pcr_extend() expects that digests are
passed in the same order as the algorithms set in chip->allocated_banks.

This patch fixes two issues introduced in the last iterations of the patch
set: missing initialization of the TPM algorithm ID in the tpm_digest
structures passed to tpm_pcr_extend() by the trusted key module, and
unreleased locks in the TPM driver due to returning from tpm_pcr_extend()
without calling tpm_put_ops().

Cc: stable@vger.kernel.org
Fixes: 0b6cf6b97b7e ("tpm: pass an array of tpm_extend_digest structures to tpm_pcr_extend()")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Signed-off-by: mayuanchen <mayuanchen@hygon.cn>
Change-Id: If1f7d414bcf2d8189d07623fea04d0b5db7060d8
Signed-off-by: Shan <chenshan@hygon.cn>
---
 drivers/char/tpm/tpm-interface.c | 14 +++++++++-----
 security/keys/trusted.c          |  5 +++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 46e0882d6..d0303d298 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1057,18 +1057,22 @@ int tpm_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
 	if (!chip)
 		return -ENODEV;
 
-	for (i = 0; i < chip->nr_allocated_banks; i++)
-		if (digests[i].alg_id != chip->allocated_banks[i].alg_id)
-			return -EINVAL;
+	for (i = 0; i < chip->nr_allocated_banks; i++) {
+		if (digests[i].alg_id != chip->allocated_banks[i].alg_id) {
+			rc = EINVAL;
+			goto out;
+		}
+	}
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		rc = tpm2_pcr_extend(chip, pcr_idx, digests);
-		tpm_put_ops(chip);
-		return rc;
+		goto out;
 	}
 
 	rc = tpm1_pcr_extend(chip, pcr_idx, digests[0].digest,
 			     "attempting extend a PCR value");
+
+out:
 	tpm_put_ops(chip);
 	return rc;
 }
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index b03525d0f..536970168 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -1216,11 +1216,16 @@ static int __init trusted_shash_alloc(void)
 
 static int __init init_digests(void)
 {
+	int i;
+
 	digests = kcalloc(chip->nr_allocated_banks, sizeof(*digests),
 					  GFP_KERNEL);
 	if (!digests)
 		return -ENOMEM;
 
+	for (i = 0; i < chip->nr_allocated_banks; i++)
+		digests[i].alg_id = chip->allocated_banks[i].alg_id;
+
 	return 0;
 }
 
-- 
2.17.1

