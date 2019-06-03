Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BBF33898
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 20:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfFCSxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 14:53:11 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38050 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFCSxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 14:53:11 -0400
Received: by mail-pg1-f196.google.com with SMTP id v11so8790531pgl.5
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 11:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rjr6iROiguEZRxbhpv14nKbI9j4PxTCmpWNmvKjVO8k=;
        b=Qwl5BEDP1LeVWofFhcxUETb6g1+M56Oh5KWHHTDsx1yk3/pqkfyhYT/oBU3+mCKZV3
         lnv9Bj/t398PQaaGHswBhkm/ZuqhjVfPF53Pip3NjIlB0Rd3IEZO9TPfJ+TLS++UxoZt
         PF8MyA9QFXyl8Vn/Hd81q+vTE8Gc2mjE0jfmk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rjr6iROiguEZRxbhpv14nKbI9j4PxTCmpWNmvKjVO8k=;
        b=p9Dex9SPF7Lv8AN7W/UbHI89lu2/cXRAMVpdwULUlY3G6NzKmUdegmuOwjXVeBiD4f
         s76vEamI3jafVXIqwKTMeTmtY5EBHQhEPEbB63GWerX5B2L5ESsFsKAq9UtqL4exoe6x
         SokhPAt6pGrNEvPpr4CRJUju75nO86IaFTRYm6ERC/+Us8vCMse6Kn8QUtI94HYfve40
         0ZyGfVdqnJn0pGQJ7YbPq7FVZ8YWJGmIjccxGWm3vjGXwnSvBGBqCiAYcN4YWeUy10kg
         3VEIiHyCoYMOpUL4qsEH95IR3UoygmdBUAOagTxHHxtl8DgaYeBvLV81L7Wn2ai7xsFe
         h/2A==
X-Gm-Message-State: APjAAAWGlhMqSu6qMfAGiF6QPSxh0lR4faOxuItSvA5YwgNL1qK2dGRQ
        1fWdv7ezgH2GnEwhW033+MuUog==
X-Google-Smtp-Source: APXvYqwNYXEE6HbvoyNmXU+/4o7J4D0yvcmE2ughCY22FzWnonxmDGE75Y+MKyO9eHCPqxnGjUTaKQ==
X-Received: by 2002:aa7:8491:: with SMTP id u17mr20641855pfn.93.1559587990026;
        Mon, 03 Jun 2019 11:53:10 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id e127sm12460286pfe.98.2019.06.03.11.53.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 11:53:09 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ido Schimmel <idosch@mellanox.com>,
        Will Deacon <will.deacon@arm.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH 4.9] include/linux/bitops.h: sanitize rotate primitives
Date:   Mon,  3 Jun 2019 11:53:06 -0700
Message-Id: <20190603185306.45994-1-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
MIME-Version: 1.0
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
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Hi Greg and Sasha,

Please pick this patch for 4.9. Issues were observed on arm32 with
newer kernels built with clang for rotations with a shift count of
zero.

Thanks

Matthias

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 include/linux/bitops.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a83c822c35c2..4b61c71048ed 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -77,7 +77,7 @@ static __always_inline unsigned long hweight_long(unsigned long w)
  */
 static inline __u64 rol64(__u64 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (64 - shift));
+	return (word << (shift & 63)) | (word >> ((-shift) & 63));
 }
 
 /**
@@ -87,7 +87,7 @@ static inline __u64 rol64(__u64 word, unsigned int shift)
  */
 static inline __u64 ror64(__u64 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (64 - shift));
+	return (word >> (shift & 63)) | (word << ((-shift) & 63));
 }
 
 /**
@@ -97,7 +97,7 @@ static inline __u64 ror64(__u64 word, unsigned int shift)
  */
 static inline __u32 rol32(__u32 word, unsigned int shift)
 {
-	return (word << shift) | (word >> ((-shift) & 31));
+	return (word << (shift & 31)) | (word >> ((-shift) & 31));
 }
 
 /**
@@ -107,7 +107,7 @@ static inline __u32 rol32(__u32 word, unsigned int shift)
  */
 static inline __u32 ror32(__u32 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (32 - shift));
+	return (word >> (shift & 31)) | (word << ((-shift) & 31));
 }
 
 /**
@@ -117,7 +117,7 @@ static inline __u32 ror32(__u32 word, unsigned int shift)
  */
 static inline __u16 rol16(__u16 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (16 - shift));
+	return (word << (shift & 15)) | (word >> ((-shift) & 15));
 }
 
 /**
@@ -127,7 +127,7 @@ static inline __u16 rol16(__u16 word, unsigned int shift)
  */
 static inline __u16 ror16(__u16 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (16 - shift));
+	return (word >> (shift & 15)) | (word << ((-shift) & 15));
 }
 
 /**
@@ -137,7 +137,7 @@ static inline __u16 ror16(__u16 word, unsigned int shift)
  */
 static inline __u8 rol8(__u8 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (8 - shift));
+	return (word << (shift & 7)) | (word >> ((-shift) & 7));
 }
 
 /**
@@ -147,7 +147,7 @@ static inline __u8 rol8(__u8 word, unsigned int shift)
  */
 static inline __u8 ror8(__u8 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (8 - shift));
+	return (word >> (shift & 7)) | (word << ((-shift) & 7));
 }
 
 /**
-- 
2.22.0.rc1.311.g5d7573a151-goog

