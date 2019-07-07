Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD886173A
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfGGTqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:46:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57018 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727503AbfGGTiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:04 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz2-0006eG-JV; Sun, 07 Jul 2019 20:38:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz1-0005YC-2a; Sun, 07 Jul 2019 20:37:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "David Howells" <dhowells@redhat.com>,
        "Eric Biggers" <ebiggers@google.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.238506517@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 024/129] crypto: pcbc - remove bogus memcpy()s with
 src == dest
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit 251b7aea34ba3c4d4fdfa9447695642eb8b8b098 upstream.

The memcpy()s in the PCBC implementation use walk->iv as both the source
and destination, which has undefined behavior.  These memcpy()'s are
actually unneeded, because walk->iv is already used to hold the previous
plaintext block XOR'd with the previous ciphertext block.  Thus,
walk->iv is already updated to its final value.

So remove the broken and unnecessary memcpy()s.

Fixes: 91652be5d1b9 ("[CRYPTO] pcbc: Add Propagated CBC template")
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/pcbc.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -52,7 +52,7 @@ static int crypto_pcbc_encrypt_segment(s
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
-	u8 *iv = walk->iv;
+	u8 * const iv = walk->iv;
 
 	do {
 		crypto_xor(iv, src, bsize);
@@ -76,7 +76,7 @@ static int crypto_pcbc_encrypt_inplace(s
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
-	u8 *iv = walk->iv;
+	u8 * const iv = walk->iv;
 	u8 tmpbuf[bsize];
 
 	do {
@@ -89,8 +89,6 @@ static int crypto_pcbc_encrypt_inplace(s
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
-	memcpy(walk->iv, iv, bsize);
-
 	return nbytes;
 }
 
@@ -130,7 +128,7 @@ static int crypto_pcbc_decrypt_segment(s
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
-	u8 *iv = walk->iv;
+	u8 * const iv = walk->iv;
 
 	do {
 		fn(crypto_cipher_tfm(tfm), dst, src);
@@ -142,8 +140,6 @@ static int crypto_pcbc_decrypt_segment(s
 		dst += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
-	memcpy(walk->iv, iv, bsize);
-
 	return nbytes;
 }
 
@@ -156,7 +152,7 @@ static int crypto_pcbc_decrypt_inplace(s
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
-	u8 *iv = walk->iv;
+	u8 * const iv = walk->iv;
 	u8 tmpbuf[bsize];
 
 	do {
@@ -169,8 +165,6 @@ static int crypto_pcbc_decrypt_inplace(s
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
-	memcpy(walk->iv, iv, bsize);
-
 	return nbytes;
 }
 

