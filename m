Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70352308223
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 00:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhA1X5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 18:57:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhA1X5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 18:57:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91BEC64DFF;
        Thu, 28 Jan 2021 23:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611878192;
        bh=wP+Nl3jUZAq7xkUZsNf6xweQEVJK89APxRPIbA2w5io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGHJX1TlKVUnsL/qT5K44crE4XuWmKk6+KzBRnjQGUU2OgM0XfTQ62bzVlZTcs2Wt
         gh88uWFjEGevpaVY4T3dxN418TU0rnxu9ZHvysE7eSvw6ZghjxN6ASK/WXkLljrBQA
         B/0VzBDRYyQ6f3dycLmyO1eyQ28hf9PO7anBTStmzx4ND4I+25yb7jAt3jXL0GRIS1
         P1mNb0f8J4Oi52L1n20EFhuTiy04LJuDTevdvCZHIav/DVMEprXMOp7Yk0W5HslWsf
         EgDOnRKMXxXfwNZE4FOEEPaS7oM4px0ySHjOB0jphBhDhO943+nnV2ap1SAJ0wMAl9
         nmfbUgCQiOwlw==
From:   jarkko@kernel.org
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        David Howells <dhowells@redhat.com>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Safford <safford@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v5 1/3] KEYS: trusted: Fix incorrect handling of tpm_get_random()
Date:   Fri, 29 Jan 2021 01:56:19 +0200
Message-Id: <20210128235621.127925-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210128235621.127925-1-jarkko@kernel.org>
References: <20210128235621.127925-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

When tpm_get_random() was introduced, it defined the following API for the
return value:

1. A positive value tells how many bytes of random data was generated.
2. A negative value on error.

However, in the call sites the API was used incorrectly, i.e. as it would
only return negative values and otherwise zero. Returning he positive read
counts to the user space does not make any possible sense.

Fix this by returning -EIO when tpm_get_random() returns a positive value.

Fixes: 41ab999c80f1 ("tpm: Move tpm_get_random api into the TPM device driver")
Cc: stable@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm1.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 74d82093cbaa..204826b734ac 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -403,9 +403,12 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
 	int ret;
 
 	ret = tpm_get_random(chip, ononce, TPM_NONCE_SIZE);
-	if (ret != TPM_NONCE_SIZE)
+	if (ret < 0)
 		return ret;
 
+	if (ret != TPM_NONCE_SIZE)
+		return -EIO;
+
 	tpm_buf_reset(tb, TPM_TAG_RQU_COMMAND, TPM_ORD_OSAP);
 	tpm_buf_append_u16(tb, type);
 	tpm_buf_append_u32(tb, handle);
@@ -496,8 +499,12 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 		goto out;
 
 	ret = tpm_get_random(chip, td->nonceodd, TPM_NONCE_SIZE);
+	if (ret < 0)
+		return ret;
+
 	if (ret != TPM_NONCE_SIZE)
-		goto out;
+		return -EIO;
+
 	ordinal = htonl(TPM_ORD_SEAL);
 	datsize = htonl(datalen);
 	pcrsize = htonl(pcrinfosize);
@@ -601,9 +608,12 @@ static int tpm_unseal(struct tpm_buf *tb,
 
 	ordinal = htonl(TPM_ORD_UNSEAL);
 	ret = tpm_get_random(chip, nonceodd, TPM_NONCE_SIZE);
+	if (ret < 0)
+		return ret;
+
 	if (ret != TPM_NONCE_SIZE) {
 		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
-		return ret;
+		return -EIO;
 	}
 	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
 			   enonce1, nonceodd, cont, sizeof(uint32_t),
@@ -1013,8 +1023,12 @@ static int trusted_instantiate(struct key *key,
 	case Opt_new:
 		key_len = payload->key_len;
 		ret = tpm_get_random(chip, payload->key, key_len);
+		if (ret < 0)
+			goto out;
+
 		if (ret != key_len) {
 			pr_info("trusted_key: key_create failed (%d)\n", ret);
+			ret = -EIO;
 			goto out;
 		}
 		if (tpm2)
-- 
2.30.0

