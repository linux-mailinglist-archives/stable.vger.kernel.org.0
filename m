Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C25EF338B6
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 21:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfFCTAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 15:00:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33426 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFCTAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 15:00:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id x15so1340302pfq.0
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 12:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJydvHHmVApy/UAL8v+eiS2YlquaI/jcenUaE6uj4lU=;
        b=CvZLxQiLQraF+JFJwgjZMA04EuzF6NCDYcK27XCA9rNsxDNAtjWXWoLXjWsOtdlFOC
         oHrOehm0a3ye5AtC+yEjL1bDXMX8Dpyk3UzjFf6jlPYqHIHIVc/ZnoCTW+L8RM626yhS
         kEAF0bnnV9ihtk466C803uWK6z8SmGUK0mn3k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJydvHHmVApy/UAL8v+eiS2YlquaI/jcenUaE6uj4lU=;
        b=LZIAkRDkM50YG0LeuIJnxcp36rHzPVjVXV2yY2ZHnaFHTJJLg76tdLsTmjyDrI9uqh
         HOEI/Poy6obIE84lGYv/cz+MOpWdYni5voi/LLMrpl8sPaTa0r/IgtRZklEcfLtwivTO
         eLMVYXHpxlPphyq7ntYQ2kagVTOULS7xtzuic8emTopPAdsoWUoQBwAd+Q7KtakzqZy6
         /ay9Dh8s3tNSp4Nm0aDyhnCByY/Pn9kgWtK8hASsiaEd1uO2Ochw9tjXoF04fO8HmcbK
         sLFtC+HhNbrPp6b0k+cw7S9lpJ2pDkKpUjtM2yok+D6KliJr0+vYgs7kgp2dxTXHlqoU
         A3oQ==
X-Gm-Message-State: APjAAAV9UJ7UcogvXAOgdiciyCWYb6PmmsLus28fdvTyqF7Zko0E0Lzm
        iRvwT527SLfljk85sc9gdy3QuA==
X-Google-Smtp-Source: APXvYqyP2QLc+C9Fbg0COjWM+uOgdSps+5KjOkZuHcfZsn6rTYEiZ7pz6D93o8/8Up0xc26t+jFTtw==
X-Received: by 2002:a17:90a:9f93:: with SMTP id o19mr32571206pjp.70.1559588428986;
        Mon, 03 Jun 2019 12:00:28 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id f11sm465813pjg.1.2019.06.03.12.00.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 12:00:28 -0700 (PDT)
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
Subject: [PATCH 4.4] include/linux/bitops.h: sanitize rotate primitives
Date:   Mon,  3 Jun 2019 12:00:16 -0700
Message-Id: <20190603190016.49951-1-mka@chromium.org>
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

Please pick this patch for 4.4. Issues were observed on arm32 with
newer kernels built with clang for rotations with a shift count of
zero.

(sorry for the spam, the patch applied cleanly to all kernel versions,
in retrospect I probably should have just sent it once ...)

Thanks

Matthias
---
 include/linux/bitops.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index e76d03f44c80..83edade218fa 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -68,7 +68,7 @@ static __always_inline unsigned long hweight_long(unsigned long w)
  */
 static inline __u64 rol64(__u64 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (64 - shift));
+	return (word << (shift & 63)) | (word >> ((-shift) & 63));
 }
 
 /**
@@ -78,7 +78,7 @@ static inline __u64 rol64(__u64 word, unsigned int shift)
  */
 static inline __u64 ror64(__u64 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (64 - shift));
+	return (word >> (shift & 63)) | (word << ((-shift) & 63));
 }
 
 /**
@@ -88,7 +88,7 @@ static inline __u64 ror64(__u64 word, unsigned int shift)
  */
 static inline __u32 rol32(__u32 word, unsigned int shift)
 {
-	return (word << shift) | (word >> ((-shift) & 31));
+	return (word << (shift & 31)) | (word >> ((-shift) & 31));
 }
 
 /**
@@ -98,7 +98,7 @@ static inline __u32 rol32(__u32 word, unsigned int shift)
  */
 static inline __u32 ror32(__u32 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (32 - shift));
+	return (word >> (shift & 31)) | (word << ((-shift) & 31));
 }
 
 /**
@@ -108,7 +108,7 @@ static inline __u32 ror32(__u32 word, unsigned int shift)
  */
 static inline __u16 rol16(__u16 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (16 - shift));
+	return (word << (shift & 15)) | (word >> ((-shift) & 15));
 }
 
 /**
@@ -118,7 +118,7 @@ static inline __u16 rol16(__u16 word, unsigned int shift)
  */
 static inline __u16 ror16(__u16 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (16 - shift));
+	return (word >> (shift & 15)) | (word << ((-shift) & 15));
 }
 
 /**
@@ -128,7 +128,7 @@ static inline __u16 ror16(__u16 word, unsigned int shift)
  */
 static inline __u8 rol8(__u8 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (8 - shift));
+	return (word << (shift & 7)) | (word >> ((-shift) & 7));
 }
 
 /**
@@ -138,7 +138,7 @@ static inline __u8 rol8(__u8 word, unsigned int shift)
  */
 static inline __u8 ror8(__u8 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (8 - shift));
+	return (word >> (shift & 7)) | (word << ((-shift) & 7));
 }
 
 /**
-- 
2.22.0.rc1.311.g5d7573a151-goog

