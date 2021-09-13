Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E438A4090D7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242779AbhIMNz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244726AbhIMNxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 596C161107;
        Mon, 13 Sep 2021 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540103;
        bh=zIUtON/Uqq4kJRp4uO9Wg8c/S2FX7ZCkao2ZJwC0mG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzOlRFvxLojK6p4u9RzaEvblwli8Y/op+i5ZSE75lqmgBkP1fEYEdRCZzhssbSUVX
         onQ8sBDn0qGJxN3JssG0yOOostcmOb5wB3KhUPxAS1R+Ju1t6Amavs7dEM4SfJ4Nem
         a2whKzfw967xQmpOdtKxo8tu6QXyq6p39+MeaPNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Gardet <guillaume.gardet@arm.com>,
        Takashi Iwai <tiwai@suse.de>,
        Mian Yousaf Kaukab <ykaukab@suse.de>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 051/300] crypto: ecc - handle unaligned input buffer in ecc_swap_digits
Date:   Mon, 13 Sep 2021 15:11:52 +0200
Message-Id: <20210913131111.079957249@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>

[ Upstream commit 0469dede0eeeefe12a9a2fd76078f4a266513457 ]

ecdsa_set_pub_key() makes an u64 pointer at 1 byte offset of the key.
This results in an unaligned u64 pointer. This pointer is passed to
ecc_swap_digits() which assumes natural alignment.

This causes a kernel crash on an armv7 platform:
[    0.409022] Unhandled fault: alignment exception (0x001) at 0xc2a0a6a9
...
[    0.416982] PC is at ecdsa_set_pub_key+0xdc/0x120
...
[    0.491492] Backtrace:
[    0.492059] [<c07c266c>] (ecdsa_set_pub_key) from [<c07c75d4>] (test_akcipher_one+0xf4/0x6c0)

Handle unaligned input buffer in ecc_swap_digits() by replacing
be64_to_cpu() to get_unaligned_be64(). Change type of in pointer to
void to reflect it doesn’t necessarily need to be aligned.

Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
Reported-by: Guillaume Gardet <guillaume.gardet@arm.com>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecc.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/ecc.h b/crypto/ecc.h
index a006132646a4..1350e8eb6ac2 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -27,6 +27,7 @@
 #define _CRYPTO_ECC_H
 
 #include <crypto/ecc_curve.h>
+#include <asm/unaligned.h>
 
 /* One digit is u64 qword. */
 #define ECC_CURVE_NIST_P192_DIGITS  3
@@ -46,13 +47,13 @@
  * @out:      Output array
  * @ndigits:  Number of digits to copy
  */
-static inline void ecc_swap_digits(const u64 *in, u64 *out, unsigned int ndigits)
+static inline void ecc_swap_digits(const void *in, u64 *out, unsigned int ndigits)
 {
 	const __be64 *src = (__force __be64 *)in;
 	int i;
 
 	for (i = 0; i < ndigits; i++)
-		out[i] = be64_to_cpu(src[ndigits - 1 - i]);
+		out[i] = get_unaligned_be64(&src[ndigits - 1 - i]);
 }
 
 /**
-- 
2.30.2



