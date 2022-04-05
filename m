Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105B34F32EE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343680AbiDEI53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiDEIjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:39:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D066B78;
        Tue,  5 Apr 2022 01:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40016B81B13;
        Tue,  5 Apr 2022 08:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A297EC385A0;
        Tue,  5 Apr 2022 08:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147614;
        bh=S5JSbPs7QsysBWhnR3G8MjqokpkFfZdd3XOVDP5puGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slGYqOvdnKruYiWPeixrrGS+PuHkCNfh5kbjRCh3p8AZ/c/swW+yIogg5mBE17d/K
         saAnNsbWa2mDl0esMmTaW00ppi20hbKEc+e1GWylshKGEpuP+1xHgAS4+CWyWv23/t
         gZ/G1/c/aIfdOJ3bFiCJZ1e+mAEAOYmBWmR0hUtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Eric Biggers <ebiggers@google.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.16 0058/1017] KEYS: asymmetric: enforce that sig algo matches key algo
Date:   Tue,  5 Apr 2022 09:16:11 +0200
Message-Id: <20220405070355.907534859@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit 2abc9c246e0548e52985b10440c9ea3e9f65f793 upstream.

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
Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/pkcs7_verify.c    |    6 ------
 crypto/asymmetric_keys/public_key.c      |   15 +++++++++++++++
 crypto/asymmetric_keys/x509_public_key.c |    6 ------
 3 files changed, 15 insertions(+), 12 deletions(-)

--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -174,12 +174,6 @@ static int pkcs7_find_key(struct pkcs7_m
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
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -325,6 +325,21 @@ int public_key_verify_signature(const st
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
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -128,12 +128,6 @@ int x509_check_for_self_signed(struct x5
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


