Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F4415F4BC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394834AbgBNSXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:23:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729847AbgBNPtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4B5B24684;
        Fri, 14 Feb 2020 15:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695356;
        bh=J1j4OCreJQkS7zD0uwA8aoWiIOqAgpvxOtjmXUV0ThQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1FOrJSFHK1fcrKCAqWyONa1z7M/tWLqmODPCdEwKKw39JFV5WyjS5bwI87zVXqaj
         kiJYXwKB/h0IbVaMu25Cm9t4KRsEBU4gEWU7c5jZ/ODfVe2aMvBuE7yMzUhkC7KiHZ
         XLVN7emu2Qra+z8EIavcCDYrtvDYkIib1uT9/RU8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 017/542] crypto: testmgr - don't try to decrypt uninitialized buffers
Date:   Fri, 14 Feb 2020 10:40:09 -0500
Message-Id: <20200214154854.6746-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit eb455dbd02cb1074b37872ffca30a81cb2a18eaa ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 82513b6b0abd0..2c96963b2e51e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2102,6 +2102,7 @@ static void generate_random_aead_testvec(struct aead_request *req,
 	 * If the key or authentication tag size couldn't be set, no need to
 	 * continue to encrypt.
 	 */
+	vec->crypt_error = 0;
 	if (vec->setkey_error || vec->setauthsize_error)
 		goto done;
 
@@ -2245,10 +2246,12 @@ static int test_aead_vs_generic_impl(const char *driver,
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
@@ -2678,6 +2681,15 @@ static void generate_random_cipher_testvec(struct skcipher_request *req,
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
-- 
2.20.1

