Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3882D03F2
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgLFLlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbgLFLlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:41:47 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/39] ima: extend boot_aggregate with kernel measurements
Date:   Sun,  6 Dec 2020 12:17:17 +0100
Message-Id: <20201206111555.310303768@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Drocco <maurizio.drocco@ibm.com>

[ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c ]

Registers 8-9 are used to store measurements of the kernel and its
command line (e.g., grub2 bootloader with tpm module enabled). IMA
should include them in the boot aggregate. Registers 8-9 should be
only included in non-SHA1 digests to avoid ambiguity.

Signed-off-by: Maurizio Drocco <maurizio.drocco@ibm.com>
Reviewed-by: Bruno Meneguele <bmeneg@redhat.com>
Tested-by: Bruno Meneguele <bmeneg@redhat.com>  (TPM 1.2, TPM 2.0)
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima.h        |  2 +-
 security/integrity/ima/ima_crypto.c | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 8173982e00ab5..5fae6cfe8d910 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -30,7 +30,7 @@
 
 enum ima_show_type { IMA_SHOW_BINARY, IMA_SHOW_BINARY_NO_FIELD_LEN,
 		     IMA_SHOW_BINARY_OLD_STRING_FMT, IMA_SHOW_ASCII };
-enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
+enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8, TPM_PCR10 = 10 };
 
 /* digest size for IMA, fits SHA1 or MD5 */
 #define IMA_DIGEST_SIZE		SHA1_DIGEST_SIZE
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index d86825261b515..b06baf5d3cd32 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -682,7 +682,7 @@ static int ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
 	if (rc != 0)
 		return rc;
 
-	/* cumulative sha1 over tpm registers 0-7 */
+	/* cumulative digest over TPM registers 0-7 */
 	for (i = TPM_PCR0; i < TPM_PCR8; i++) {
 		ima_pcrread(i, &d);
 		/* now accumulate with current aggregate */
@@ -691,6 +691,19 @@ static int ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
 		if (rc != 0)
 			return rc;
 	}
+	/*
+	 * Extend cumulative digest over TPM registers 8-9, which contain
+	 * measurement for the kernel command line (reg. 8) and image (reg. 9)
+	 * in a typical PCR allocation. Registers 8-9 are only included in
+	 * non-SHA1 boot_aggregate digests to avoid ambiguity.
+	 */
+	if (alg_id != TPM_ALG_SHA1) {
+		for (i = TPM_PCR8; i < TPM_PCR10; i++) {
+			ima_pcrread(i, &d);
+			rc = crypto_shash_update(shash, d.digest,
+						crypto_shash_digestsize(tfm));
+		}
+	}
 	if (!rc)
 		crypto_shash_final(shash, digest);
 	return rc;
-- 
2.27.0



