Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D09415C2F0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbgBMPig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729674AbgBMP3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:12 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B30D1206DB;
        Thu, 13 Feb 2020 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607751;
        bh=u6ru0ReBZHKSYmSZDd7iySDmnsFxSlS+65fv0zpmsVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7qAMYCx64WewFDRM9jw2/XJlv9Hn2nEv5z4umCx4fqJrjm2b4HDExGFlY0edBvvJ
         h7BNAl8QCBsbruWrTe0aGahAVcTEprbLNuWsAZMez+ugFCdeJDV2MFIZYi3UdK0GUQ
         gL+fJiX7+BR9i/uZD2MOzfx6whlrm0SYS4oGyUDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 095/120] crypto: testmgr - dont try to decrypt uninitialized buffers
Date:   Thu, 13 Feb 2020 07:21:31 -0800
Message-Id: <20200213151933.012427541@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit eb455dbd02cb1074b37872ffca30a81cb2a18eaa upstream.

Currently if the comparison fuzz tests encounter an encryption error
when generating an skcipher or AEAD test vector, they will still test
the decryption side (passing it the uninitialized ciphertext buffer)
and expect it to fail with the same error.

This is sort of broken because it's not well-defined usage of the API to
pass an uninitialized buffer, and furthermore in the AEAD case it's
acceptable for the decryption error to be EBADMSG (meaning "inauthentic
input") even if the encryption error was something else like EINVAL.

Fix this for skcipher by explicitly initializing the ciphertext buffer
on error, and for AEAD by skipping the decryption test on error.

Reported-by: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against their generic implementation")
Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/testmgr.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2102,6 +2102,7 @@ static void generate_random_aead_testvec
 	 * If the key or authentication tag size couldn't be set, no need to
 	 * continue to encrypt.
 	 */
+	vec->crypt_error = 0;
 	if (vec->setkey_error || vec->setauthsize_error)
 		goto done;
 
@@ -2245,10 +2246,12 @@ static int test_aead_vs_generic_impl(con
 					req, tsgls);
 		if (err)
 			goto out;
-		err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name, cfg,
-					req, tsgls);
-		if (err)
-			goto out;
+		if (vec.crypt_error == 0) {
+			err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name,
+						cfg, req, tsgls);
+			if (err)
+				goto out;
+		}
 		cond_resched();
 	}
 	err = 0;
@@ -2678,6 +2681,15 @@ static void generate_random_cipher_testv
 	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
 	skcipher_request_set_crypt(req, &src, &dst, vec->len, iv);
 	vec->crypt_error = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	if (vec->crypt_error != 0) {
+		/*
+		 * The only acceptable error here is for an invalid length, so
+		 * skcipher decryption should fail with the same error too.
+		 * We'll test for this.  But to keep the API usage well-defined,
+		 * explicitly initialize the ciphertext buffer too.
+		 */
+		memset((u8 *)vec->ctext, 0, vec->len);
+	}
 done:
 	snprintf(name, max_namelen, "\"random: len=%u klen=%u\"",
 		 vec->len, vec->klen);


