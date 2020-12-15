Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FECF2DA971
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 09:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgLOIs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 03:48:26 -0500
Received: from spam01.hygon.cn ([110.188.70.11]:57884 "EHLO spam2.hygon.cn"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727189AbgLOIsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 03:48:21 -0500
Received: from spam2.hygon.cn (localhost [127.0.0.2] (may be forged))
        by spam2.hygon.cn with ESMTP id 0BF8WTRL097445
        for <stable@vger.kernel.org>; Tue, 15 Dec 2020 16:32:29 +0800 (GMT-8)
        (envelope-from chenshan@hygon.cn)
Received: from MK-DB.hygon.cn ([172.23.18.60])
        by spam2.hygon.cn with ESMTP id 0BF8UABh097305;
        Tue, 15 Dec 2020 16:30:10 +0800 (GMT-8)
        (envelope-from chenshan@hygon.cn)
Received: from cncheex01.Hygon.cn ([172.23.18.10])
        by MK-DB.hygon.cn with ESMTP id 0BF8U3Nh019638;
        Tue, 15 Dec 2020 16:30:03 +0800 (GMT-8)
        (envelope-from chenshan@hygon.cn)
Received: from CS-AMD.hygon.cn (172.23.18.44) by cncheex01.Hygon.cn
 (172.23.18.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Tue, 15 Dec
 2020 16:29:59 +0800
From:   Shan <chenshan@hygon.cn>
To:     <alikernel-developer@linux.alibaba.com>
CC:     Roberto Sassu <roberto.sassu@huawei.com>, <mayuanchen@hygon.cn>,
        <fenghao@hygon.cn>, <yingzhiwei@hygon.cn>,
        <stable@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Shan <chenshan@hygon.cn>
Subject: [PATCH AliOS 4.19 v3 11/15] KEYS: trusted: allow module init if TPM is inactive or deactivated
Date:   Tue, 15 Dec 2020 16:29:18 +0800
Message-ID: <a28cb67324fee8afabc7912f5045788e74e0aff9.1608019826.git.chenshan@hygon.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608019826.git.chenshan@hygon.cn>
References: <cover.1608019826.git.chenshan@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.23.18.44]
X-ClientProxiedBy: cncheex01.Hygon.cn (172.23.18.10) To cncheex01.Hygon.cn
 (172.23.18.10)
X-MAIL: spam2.hygon.cn 0BF8UABh097305
X-DNSRBL: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 2d6c25215ab26bb009de3575faab7b685f138e92 upstream.

Commit c78719203fc6 ("KEYS: trusted: allow trusted.ko to initialize w/o a
TPM") allows the trusted module to be loaded even if a TPM is not found, to
avoid module dependency problems.

However, trusted module initialization can still fail if the TPM is
inactive or deactivated. tpm_get_random() returns an error.

This patch removes the call to tpm_get_random() and instead extends the PCR
specified by the user with zeros. The security of this alternative is
equivalent to the previous one, as either option prevents with a PCR update
unsealing and misuse of sealed data by a user space process.

Even if a PCR is extended with zeros, instead of random data, it is still
computationally infeasible to find a value as input for a new PCR extend
operation, to obtain again the PCR value that would allow unsealing.

Cc: stable@vger.kernel.org
Fixes: 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure...")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Signed-off-by: mayuanchen <mayuanchen@hygon.cn>
Change-Id: Iada0e052c2ab4a0fbc2db4ac2690da3115d985c6
Signed-off-by: Shan <chenshan@hygon.cn>
---
 security/keys/trusted.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 5e983eb9a..b03525d0f 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -1216,24 +1216,11 @@ static int __init trusted_shash_alloc(void)
 
 static int __init init_digests(void)
 {
-	u8 digest[TPM_MAX_DIGEST_SIZE];
-	int ret;
-	int i;
-
-	ret = tpm_get_random(chip, digest, TPM_MAX_DIGEST_SIZE);
-	if (ret < 0)
-		return ret;
-	if (ret < TPM_MAX_DIGEST_SIZE)
-		return -EFAULT;
-
 	digests = kcalloc(chip->nr_allocated_banks, sizeof(*digests),
 					  GFP_KERNEL);
 	if (!digests)
 		return -ENOMEM;
 
-	for (i = 0; i < chip->nr_allocated_banks; i++)
-		memcpy(digests[i].digest, digest, TPM_MAX_DIGEST_SIZE);
-
 	return 0;
 }
 
-- 
2.17.1

