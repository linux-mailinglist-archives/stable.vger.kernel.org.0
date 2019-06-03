Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2128333857
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 20:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfFCSj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 14:39:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34336 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfFCSj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 14:39:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id c85so2316581pfc.1
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 11:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4U0hxfB4PaGbxb7P92vWpltm8YXBkybIs5ZlT1AwoBs=;
        b=Mi/y0Q9Vq0xSU6SIz3IVscv4sx4Gr3S3MaEj+cbaUtVHgwTT8m4NOuApKrxOO4ZzOc
         2Kcx5uOkvs3515bImAYmgve0InOPcaHY++iWBbXI3M6+W/olJ47Yq0GJznO/TOPZd2tl
         TOb9xU9I57OCIVBDjozRi7nMOEDSgq/rGoeI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4U0hxfB4PaGbxb7P92vWpltm8YXBkybIs5ZlT1AwoBs=;
        b=WpGh6Lwc28m0Bs55YTrnJf+FZHtotOqIkaHV1vnm2772NbmXVSxS3DHXhMvWyX4I9i
         yZVFyNBPj6PkY4qgg8X1mILAmOVqWqsiDklp3LFltA5CxrGLfoM8Q4PPLn2IO1QuKZQF
         ReuekFWD5ow5OsY2BNoVtBbJykLQcifRdRlseBM/0ssvKy7AhJB5suAtyIm+6qAETENj
         ub3WwpCpVELMSpYuMo8HedMMpWuzsTe4QW/muzz3RYLvBLwCo/sFDZx4cC5iWKEwvAoz
         KY9HlYUxCiZsP2J3XK2JAYQl6mDfZbApYtHBvfTtUup+uSjpz7GbrpR3SSib6qyJOyJ3
         Untw==
X-Gm-Message-State: APjAAAWCbB6+W3wje6l9EEkTbmY8CHO3EtaEMy9bGMl9ERGghBvuxis8
        Ao2QlzqwtjMtU12M+mL+nd9Z4A==
X-Google-Smtp-Source: APXvYqzC7DHXO6QBzfgSXh85/TAbCTuUluHK8ieC90wqv+cM4bnFeuvIaGzEvGB25QwihV185kwYHA==
X-Received: by 2002:a05:6a00:c9:: with SMTP id e9mr31797820pfj.99.1559587197571;
        Mon, 03 Jun 2019 11:39:57 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id j186sm13537048pfg.66.2019.06.03.11.39.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 11:39:57 -0700 (PDT)
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
Subject: [PATCH] include/linux/bitops.h: sanitize rotate primitives
Date:   Mon,  3 Jun 2019 11:39:46 -0700
Message-Id: <20190603183946.42233-1-mka@chromium.org>
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

Please pick this patch for 4.19. It fixes (at least) crashes due
to undefined instructions in BPF code on arm32 when building with
clang:

[    4.271668] Internal error: Oops - undefined instruction: 0 [#1] PREEMPT SMP ARM
    [    4.271675] Modules linked in:
    [    4.284143]  joydev
    [    4.284155] CPU: 2 PID: 279 Comm: udevd Not tainted 4.19.44 #95
    [    4.284157] Hardware name: Rockchip (Device Tree)
    [    4.284167] PC is at 0xbf017de8
    [    4.284176] LR is at sk_filter_trim_cap+0xfc/0x244
    [    4.284181] pc : [<bf017de8>]    lr : [<c0890c34>]    psr: 60070013
    [    4.323863] sp : ed36fcd8  ip : 00000000  fp : ed36fd28
    [    4.329698] r10: c100b608  r9 : 00000000  r8 : ed2d6600
    [    4.335531] r7 : 00000000  r6 : 00000071  r5 : 00000000  r4 : ed59c180
    [    4.342812] r3 : 00000000  r2 : ed59c180  r1 : 00000000  r0 : 2a1884a1
    [    4.350105] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
    [    4.358075] Control: 30c5387d  Table: 2d22b880  DAC: 44541fd3
    [    4.364495] Process udevd (pid: 279, stack limit = 0xb5b8ffdf)
    [    4.371009] Stack: (0xed36fcd8 to 0xed370000)
    [    4.375864] fcc0:                                                       bf017a9c 60070013
    [    4.385001] fce0: 00000000 00000000 ed36fcd8 00000000 00000089 00000000 ed2d6600 00000000
    [    4.394137] fd00: 00000000 00000000 ed59c180 f0c12000 00000000 ed289000 ed59c1a0 00000001
    [    4.403274] fd20: 00000071 00000000 ed59c180 f0c12000 00000000 ed289000 ed59c1a0 00000001
    ...
    [    4.613384] [<c0890c34>] (sk_filter_trim_cap) from [<00000001>] (0x1)
    [    4.620580] Code: aa000002 e0200000 e3a01000 ea000045 (f7e6c179)

Thanks

Matthias
---
 include/linux/bitops.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 7ddb1349394d..7ac2e46112b7 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -60,7 +60,7 @@ static __always_inline unsigned long hweight_long(unsigned long w)
  */
 static inline __u64 rol64(__u64 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (64 - shift));
+	return (word << (shift & 63)) | (word >> ((-shift) & 63));
 }
 
 /**
@@ -70,7 +70,7 @@ static inline __u64 rol64(__u64 word, unsigned int shift)
  */
 static inline __u64 ror64(__u64 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (64 - shift));
+	return (word >> (shift & 63)) | (word << ((-shift) & 63));
 }
 
 /**
@@ -80,7 +80,7 @@ static inline __u64 ror64(__u64 word, unsigned int shift)
  */
 static inline __u32 rol32(__u32 word, unsigned int shift)
 {
-	return (word << shift) | (word >> ((-shift) & 31));
+	return (word << (shift & 31)) | (word >> ((-shift) & 31));
 }
 
 /**
@@ -90,7 +90,7 @@ static inline __u32 rol32(__u32 word, unsigned int shift)
  */
 static inline __u32 ror32(__u32 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (32 - shift));
+	return (word >> (shift & 31)) | (word << ((-shift) & 31));
 }
 
 /**
@@ -100,7 +100,7 @@ static inline __u32 ror32(__u32 word, unsigned int shift)
  */
 static inline __u16 rol16(__u16 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (16 - shift));
+	return (word << (shift & 15)) | (word >> ((-shift) & 15));
 }
 
 /**
@@ -110,7 +110,7 @@ static inline __u16 rol16(__u16 word, unsigned int shift)
  */
 static inline __u16 ror16(__u16 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (16 - shift));
+	return (word >> (shift & 15)) | (word << ((-shift) & 15));
 }
 
 /**
@@ -120,7 +120,7 @@ static inline __u16 ror16(__u16 word, unsigned int shift)
  */
 static inline __u8 rol8(__u8 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (8 - shift));
+	return (word << (shift & 7)) | (word >> ((-shift) & 7));
 }
 
 /**
@@ -130,7 +130,7 @@ static inline __u8 rol8(__u8 word, unsigned int shift)
  */
 static inline __u8 ror8(__u8 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (8 - shift));
+	return (word >> (shift & 7)) | (word << ((-shift) & 7));
 }
 
 /**
-- 
2.22.0.rc1.311.g5d7573a151-goog

