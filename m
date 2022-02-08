Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F8D4AD0F0
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 06:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiBHFdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 00:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbiBHF1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 00:27:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5959AC0401ED;
        Mon,  7 Feb 2022 21:27:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C2DBB8184D;
        Tue,  8 Feb 2022 05:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B2EC340EE;
        Tue,  8 Feb 2022 05:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644298049;
        bh=nySwKR/PHIBHwyTLPaSdVAxC7gXi5UWq5MF9bzSt6xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPjXv23JFaSD8bLVgcMfzH+kQ30b6Jj5vVgrSi1yurD1Xq8KidYa7sPMMiuIBwkU4
         t5Ers/gUj5ODos4GDROBJbc3qExRMewqsgwh4OBdL6Ug7BN/JusjojmeqMy/5w9GGW
         SH+RT0ShbZCzD1RXbEM7lmKuS4ilB2SO3JUpm5dXWxhDjEWebWiQvIfr2YPYk9stIb
         4m44ZT852SXDx7lK5fxjGnBMOnsiY0ONZbHD8pZ1Ngle75WBkgINCVPx0TEAZEfJic
         hWuO8vzM0pWEqZ9vRgkxwGNFUKJ/kyt98LaRovgDjXx5+8Fw08E5rPCc4Lvr1iNkIM
         dAE5I+Kh9MLLg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>
Cc:     linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] KEYS: asymmetric: enforce that sig algo matches key algo
Date:   Mon,  7 Feb 2022 21:24:47 -0800
Message-Id: <20220208052448.409152-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208052448.409152-1-ebiggers@kernel.org>
References: <20220208052448.409152-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Most callers of public_key_verify_signature(), including most indirect
callers via verify_signature() as well as pkcs7_verify_sig_chain(),
don't check that public_key_signature::pkey_algo matches
public_key::pkey_algo.  These should always match.  However, a malicious
signature could intentionally declare an unintended algorithm.  It is
essential that such signatures be rejected outright, or that the
algorithm of the *key* be used -- not the algorithm of the signature as
that would allow attackers to choose the algorithm used.

Currently, public_key_verify_signature() correctly uses the key's
algorithm when deciding which akcipher to allocate.  That's good.
However, it uses the signature's algorithm when deciding whether to do
the first step of SM2, which is incorrect.  Also, v4.19 and older
kernels used the signature's algorithm for the entire process.

Prevent such errors by making public_key_verify_signature() enforce that
the signature's algorithm (if given) matches the key's algorithm.

Also remove two checks of this done by callers, which are now redundant.

Cc: stable@vger.kernel.org
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Tested-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c    |  6 ------
 crypto/asymmetric_keys/public_key.c      | 15 +++++++++++++++
 crypto/asymmetric_keys/x509_public_key.c |  6 ------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 0b4d07aa8811..f94a1d1ad3a6 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -174,12 +174,6 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 		pr_devel("Sig %u: Found cert serial match X.509[%u]\n",
 			 sinfo->index, certix);
 
-		if (strcmp(x509->pub->pkey_algo, sinfo->sig->pkey_algo) != 0) {
-			pr_warn("Sig %u: X.509 algo and PKCS#7 sig algo don't match\n",
-				sinfo->index);
-			continue;
-		}
-
 		sinfo->signer = x509;
 		return 0;
 	}
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 4fefb219bfdc..e36213945686 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -325,6 +325,21 @@ int public_key_verify_signature(const struct public_key *pkey,
 	BUG_ON(!sig);
 	BUG_ON(!sig->s);
 
+	/*
+	 * If the signature specifies a public key algorithm, it *must* match
+	 * the key's actual public key algorithm.
+	 *
+	 * Small exception: ECDSA signatures don't specify the curve, but ECDSA
+	 * keys do.  So the strings can mismatch slightly in that case:
+	 * "ecdsa-nist-*" for the key, but "ecdsa" for the signature.
+	 */
+	if (sig->pkey_algo) {
+		if (strcmp(pkey->pkey_algo, sig->pkey_algo) != 0 &&
+		    (strncmp(pkey->pkey_algo, "ecdsa-", 6) != 0 ||
+		     strcmp(sig->pkey_algo, "ecdsa") != 0))
+			return -EKEYREJECTED;
+	}
+
 	ret = software_key_determine_akcipher(sig->encoding,
 					      sig->hash_algo,
 					      pkey, alg_name);
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index fe14cae115b5..71cc1738fbfd 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -128,12 +128,6 @@ int x509_check_for_self_signed(struct x509_certificate *cert)
 			goto out;
 	}
 
-	ret = -EKEYREJECTED;
-	if (strcmp(cert->pub->pkey_algo, cert->sig->pkey_algo) != 0 &&
-	    (strncmp(cert->pub->pkey_algo, "ecdsa-", 6) != 0 ||
-	     strcmp(cert->sig->pkey_algo, "ecdsa") != 0))
-		goto out;
-
 	ret = public_key_verify_signature(cert->pub, cert->sig);
 	if (ret < 0) {
 		if (ret == -ENOPKG) {
-- 
2.35.1

