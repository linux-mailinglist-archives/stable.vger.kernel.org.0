Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6E61B3CD5
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgDVKJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbgDVKJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:09:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A16E420575;
        Wed, 22 Apr 2020 10:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550148;
        bh=tmiSw4QrLdNYLOt8h7We+WoCE+44hydsGgrXYbzf7Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XU/CSONDXook00mgTeW1LR1rE9+fd+acHvQ/0nA7pYKwVpY5CtYxn/ip1KtdrgTh5
         SBGJyPoQ/rNtirLh7x0ZZ9Gii7bR/HTVZNToMtFlOoKwJxLeAiPcjwfTk2VJ+egp6C
         8xmuW2fbnexJSc/LTOPqgK/SElBzuvVedUsT16Mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 029/199] uapi: rename ext2_swab() to swab() and share globally in swab.h
Date:   Wed, 22 Apr 2020 11:55:55 +0200
Message-Id: <20200422095100.993677564@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>

[ Upstream commit d5767057c9a76a29f073dad66b7fa12a90e8c748 ]

ext2_swab() is defined locally in lib/find_bit.c However it is not
specific to ext2, neither to bitmaps.

There are many potential users of it, so rename it to just swab() and
move to include/uapi/linux/swab.h

ABI guarantees that size of unsigned long corresponds to BITS_PER_LONG,
therefore drop unneeded cast.

Link: http://lkml.kernel.org/r/20200103202846.21616-1-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/swab.h      |  1 +
 include/uapi/linux/swab.h | 10 ++++++++++
 lib/find_bit.c            | 16 ++--------------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/linux/swab.h b/include/linux/swab.h
index e466fd159c857..bcff5149861a9 100644
--- a/include/linux/swab.h
+++ b/include/linux/swab.h
@@ -7,6 +7,7 @@
 # define swab16 __swab16
 # define swab32 __swab32
 # define swab64 __swab64
+# define swab __swab
 # define swahw32 __swahw32
 # define swahb32 __swahb32
 # define swab16p __swab16p
diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
index 23cd84868cc3b..fa7f97da5b768 100644
--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <asm/bitsperlong.h>
 #include <asm/swab.h>
 
 /*
@@ -132,6 +133,15 @@ static inline __attribute_const__ __u32 __fswahb32(__u32 val)
 	__fswab64(x))
 #endif
 
+static __always_inline unsigned long __swab(const unsigned long y)
+{
+#if BITS_PER_LONG == 64
+	return __swab64(y);
+#else /* BITS_PER_LONG == 32 */
+	return __swab32(y);
+#endif
+}
+
 /**
  * __swahw32 - return a word-swapped 32-bit value
  * @x: value to wordswap
diff --git a/lib/find_bit.c b/lib/find_bit.c
index 6ed74f78380ce..883ef3755a1cb 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -133,18 +133,6 @@ EXPORT_SYMBOL(find_last_bit);
 
 #ifdef __BIG_ENDIAN
 
-/* include/linux/byteorder does not support "unsigned long" type */
-static inline unsigned long ext2_swab(const unsigned long y)
-{
-#if BITS_PER_LONG == 64
-	return (unsigned long) __swab64((u64) y);
-#elif BITS_PER_LONG == 32
-	return (unsigned long) __swab32((u32) y);
-#else
-#error BITS_PER_LONG not defined
-#endif
-}
-
 #if !defined(find_next_bit_le) || !defined(find_next_zero_bit_le)
 static unsigned long _find_next_bit_le(const unsigned long *addr,
 		unsigned long nbits, unsigned long start, unsigned long invert)
@@ -157,7 +145,7 @@ static unsigned long _find_next_bit_le(const unsigned long *addr,
 	tmp = addr[start / BITS_PER_LONG] ^ invert;
 
 	/* Handle 1st word. */
-	tmp &= ext2_swab(BITMAP_FIRST_WORD_MASK(start));
+	tmp &= swab(BITMAP_FIRST_WORD_MASK(start));
 	start = round_down(start, BITS_PER_LONG);
 
 	while (!tmp) {
@@ -168,7 +156,7 @@ static unsigned long _find_next_bit_le(const unsigned long *addr,
 		tmp = addr[start / BITS_PER_LONG] ^ invert;
 	}
 
-	return min(start + __ffs(ext2_swab(tmp)), nbits);
+	return min(start + __ffs(swab(tmp)), nbits);
 }
 #endif
 
-- 
2.20.1



