Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5731A5164
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgDKMYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbgDKMRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:17:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46B0620644;
        Sat, 11 Apr 2020 12:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607433;
        bh=gEa7ZsGQJJwe1Lbv3f9ZrcIEEZjZ69oRQJWfv5TR+Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1fGL2WnZnibXWio8e0Wbrh6bgus/9t2bwotv21ZifeyuO3CxpJgQ9A13et2ctqVIQ
         dCGnErq9Gv4Lbh6R8OAPmW+EQtPbo3SkaqA9UV1reIuXqTitHKwGPkeNVXRyv3stKZ
         8UcXFQ+Tl8h1cgfhMI6VHEyxNMAErgzKn9TcZYxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 18/41] uapi: rename ext2_swab() to swab() and share globally in swab.h
Date:   Sat, 11 Apr 2020 14:09:27 +0200
Message-Id: <20200411115505.337339823@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>

commit d5767057c9a76a29f073dad66b7fa12a90e8c748 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/swab.h      |    1 +
 include/uapi/linux/swab.h |   10 ++++++++++
 lib/find_bit.c            |   16 ++--------------
 3 files changed, 13 insertions(+), 14 deletions(-)

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
--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <asm/bitsperlong.h>
 #include <asm/swab.h>
 
 /*
@@ -132,6 +133,15 @@ static inline __attribute_const__ __u32
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
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -149,18 +149,6 @@ EXPORT_SYMBOL(find_last_bit);
 
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
 static inline unsigned long _find_next_bit_le(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
@@ -177,7 +165,7 @@ static inline unsigned long _find_next_b
 	tmp ^= invert;
 
 	/* Handle 1st word. */
-	tmp &= ext2_swab(BITMAP_FIRST_WORD_MASK(start));
+	tmp &= swab(BITMAP_FIRST_WORD_MASK(start));
 	start = round_down(start, BITS_PER_LONG);
 
 	while (!tmp) {
@@ -191,7 +179,7 @@ static inline unsigned long _find_next_b
 		tmp ^= invert;
 	}
 
-	return min(start + __ffs(ext2_swab(tmp)), nbits);
+	return min(start + __ffs(swab(tmp)), nbits);
 }
 #endif
 


