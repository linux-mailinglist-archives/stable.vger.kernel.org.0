Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1DDBF76B
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 19:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfIZRQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 13:16:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:63648 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbfIZRQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Sep 2019 13:16:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 10:16:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="219475012"
Received: from schneian-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.39.17])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2019 10:16:12 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        keyrings@vger.kernel.org (open list:ASYMMETRIC KEYS),
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Date:   Thu, 26 Sep 2019 20:16:01 +0300
Message-Id: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only the kernel random pool should be used for generating random numbers.
TPM contributes to that pool among the other sources of entropy. In here it
is not, agreed, absolutely critical because TPM is what is trusted anyway
but in order to remove tpm_get_random() we need to first remove all the
call sites.

Cc: stable@vger.kernel.org
Fixes: 0c36264aa1d5 ("KEYS: asym_tpm: Add loadkey2 and flushspecific [ver #2]")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 crypto/asymmetric_keys/asym_tpm.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
index 76d2ce3a1b5b..c14b8d186e93 100644
--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/seq_file.h>
 #include <linux/scatterlist.h>
+#include <linux/random.h>
 #include <linux/tpm.h>
 #include <linux/tpm_command.h>
 #include <crypto/akcipher.h>
@@ -54,11 +55,7 @@ static int tpm_loadkey2(struct tpm_buf *tb,
 	}
 
 	/* generate odd nonce */
-	ret = tpm_get_random(NULL, nonceodd, TPM_NONCE_SIZE);
-	if (ret < 0) {
-		pr_info("tpm_get_random failed (%d)\n", ret);
-		return ret;
-	}
+	get_random_bytes(nonceodd, TPM_NONCE_SIZE);
 
 	/* calculate authorization HMAC value */
 	ret = TSS_authhmac(authdata, keyauth, SHA1_DIGEST_SIZE, enonce,
-- 
2.20.1

