Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F6B4093C3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344681AbhIMOXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346236AbhIMOVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C880C61B28;
        Mon, 13 Sep 2021 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540832;
        bh=zIUtON/Uqq4kJRp4uO9Wg8c/S2FX7ZCkao2ZJwC0mG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxe7XTB+28aioH+738HYVkVlAwMOP+9vc1aVAni6P/vpKmSlZ1MsvcKTk10z0pQT+
         /VK3pxPCXgRQE9dA/X6BEksGsSFYUy1lvRxrCkAlIO10JogSjz9SzSTxC86si3Hg6G
         pQd254HfoR4+42OyRZoCwGQRhqFQELJVrkEG/JCs=
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
Subject: [PATCH 5.14 052/334] crypto: ecc - handle unaligned input buffer in ecc_swap_digits
Date:   Mon, 13 Sep 2021 15:11:46 +0200
Message-Id: <20210913131115.183848128@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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



