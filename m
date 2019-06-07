Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8113B38FFC
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbfFGPrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731614AbfFGPrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:47:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6031420840;
        Fri,  7 Jun 2019 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922455;
        bh=Pi5yHasHMgeu2QvWr7VaMKhy6jin9E6VyDbRwY+jviU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQLylgvjMBMbIjaQtaRNUMQWQIAcT48SKDk0Ritw6XHZGL2Cf0eu+Ersfuy7LgwbX
         ky7G822PQYWlW1uV1j+dRwyDTlOsBhvPEG0i9v+9Fd4TAa54a0fOAjet8wicr9/GiD
         nVzPrKDXVcF7CJTmp4h5Mo9RRq/LkqQ0Kw4QdHJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ido Schimmel <idosch@mellanox.com>,
        Will Deacon <will.deacon@arm.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 02/85] include/linux/bitops.h: sanitize rotate primitives
Date:   Fri,  7 Jun 2019 17:38:47 +0200
Message-Id: <20190607153849.392582074@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit ef4d6f6b275c498f8e5626c99dbeefdc5027f843 upstream.

The ror32 implementation (word >> shift) | (word << (32 - shift) has
undefined behaviour if shift is outside the [1, 31] range.  Similarly
for the 64 bit variants.  Most callers pass a compile-time constant
(naturally in that range), but there's an UBSAN report that these may
actually be called with a shift count of 0.

Instead of special-casing that, we can make them DTRT for all values of
shift while also avoiding UB.  For some reason, this was already partly
done for rol32 (which was well-defined for [0, 31]).  gcc 8 recognizes
these patterns as rotates, so for example

  __u32 rol32(__u32 word, unsigned int shift)
  {
	return (word << (shift & 31)) | (word >> ((-shift) & 31));
  }

compiles to

0000000000000020 <rol32>:
  20:   89 f8                   mov    %edi,%eax
  22:   89 f1                   mov    %esi,%ecx
  24:   d3 c0                   rol    %cl,%eax
  26:   c3                      retq

Older compilers unfortunately do not do as well, but this only affects
the small minority of users that don't pass constants.

Due to integer promotions, ro[lr]8 were already well-defined for shifts
in [0, 8], and ro[lr]16 were mostly well-defined for shifts in [0, 16]
(only mostly - u16 gets promoted to _signed_ int, so if bit 15 is set,
word << 16 is undefined).  For consistency, update those as well.

Link: http://lkml.kernel.org/r/20190410211906.2190-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Cc: Vadim Pasternak <vadimp@mellanox.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/bitops.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -60,7 +60,7 @@ static __always_inline unsigned long hwe
  */
 static inline __u64 rol64(__u64 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (64 - shift));
+	return (word << (shift & 63)) | (word >> ((-shift) & 63));
 }
 
 /**
@@ -70,7 +70,7 @@ static inline __u64 rol64(__u64 word, un
  */
 static inline __u64 ror64(__u64 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (64 - shift));
+	return (word >> (shift & 63)) | (word << ((-shift) & 63));
 }
 
 /**
@@ -80,7 +80,7 @@ static inline __u64 ror64(__u64 word, un
  */
 static inline __u32 rol32(__u32 word, unsigned int shift)
 {
-	return (word << shift) | (word >> ((-shift) & 31));
+	return (word << (shift & 31)) | (word >> ((-shift) & 31));
 }
 
 /**
@@ -90,7 +90,7 @@ static inline __u32 rol32(__u32 word, un
  */
 static inline __u32 ror32(__u32 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (32 - shift));
+	return (word >> (shift & 31)) | (word << ((-shift) & 31));
 }
 
 /**
@@ -100,7 +100,7 @@ static inline __u32 ror32(__u32 word, un
  */
 static inline __u16 rol16(__u16 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (16 - shift));
+	return (word << (shift & 15)) | (word >> ((-shift) & 15));
 }
 
 /**
@@ -110,7 +110,7 @@ static inline __u16 rol16(__u16 word, un
  */
 static inline __u16 ror16(__u16 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (16 - shift));
+	return (word >> (shift & 15)) | (word << ((-shift) & 15));
 }
 
 /**
@@ -120,7 +120,7 @@ static inline __u16 ror16(__u16 word, un
  */
 static inline __u8 rol8(__u8 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (8 - shift));
+	return (word << (shift & 7)) | (word >> ((-shift) & 7));
 }
 
 /**
@@ -130,7 +130,7 @@ static inline __u8 rol8(__u8 word, unsig
  */
 static inline __u8 ror8(__u8 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (8 - shift));
+	return (word >> (shift & 7)) | (word << ((-shift) & 7));
 }
 
 /**


