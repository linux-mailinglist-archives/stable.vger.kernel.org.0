Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B84103F94
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbfKTPpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:45:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52620 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729743AbfKTPkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:17 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004ag-7y; Wed, 20 Nov 2019 15:40:12 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004HB-BG; Wed, 20 Nov 2019 15:40:11 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        "James Y Knight" <jyknight@google.com>,
        "Nathan Chancellor" <natechancellor@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Bill Wendling" <morbo@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jakub Jelinek" <jakub@redhat.com>,
        "David Howells" <dhowells@redhat.com>, "Qian Cai" <cai@lca.pw>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 20 Nov 2019 15:37:32 +0000
Message-ID: <lsq.1574264230.399102358@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 22/83] asm-generic: fix -Wtype-limits compiler warnings
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Qian Cai <cai@lca.pw>

commit cbedfe11347fe418621bd188d58a206beb676218 upstream.

Commit d66acc39c7ce ("bitops: Optimise get_order()") introduced a
compilation warning because "rx_frag_size" is an "ushort" while
PAGE_SHIFT here is 16.

The commit changed the get_order() to be a multi-line macro where
compilers insist to check all statements in the macro even when
__builtin_constant_p(rx_frag_size) will return false as "rx_frag_size"
is a module parameter.

In file included from ./arch/powerpc/include/asm/page_64.h:107,
                 from ./arch/powerpc/include/asm/page.h:242,
                 from ./arch/powerpc/include/asm/mmu.h:132,
                 from ./arch/powerpc/include/asm/lppaca.h:47,
                 from ./arch/powerpc/include/asm/paca.h:17,
                 from ./arch/powerpc/include/asm/current.h:13,
                 from ./include/linux/thread_info.h:21,
                 from ./arch/powerpc/include/asm/processor.h:39,
                 from ./include/linux/prefetch.h:15,
                 from drivers/net/ethernet/emulex/benet/be_main.c:14:
drivers/net/ethernet/emulex/benet/be_main.c: In function 'be_rx_cqs_create':
./include/asm-generic/getorder.h:54:9: warning: comparison is always
true due to limited range of data type [-Wtype-limits]
   (((n) < (1UL << PAGE_SHIFT)) ? 0 :  \
         ^
drivers/net/ethernet/emulex/benet/be_main.c:3138:33: note: in expansion
of macro 'get_order'
  adapter->big_page_size = (1 << get_order(rx_frag_size)) * PAGE_SIZE;
                                 ^~~~~~~~~

Fix it by moving all of this multi-line macro into a proper function,
and killing __get_order() off.

[akpm@linux-foundation.org: remove __get_order() altogether]
[cai@lca.pw: v2]
  Link: http://lkml.kernel.org/r/1564000166-31428-1-git-send-email-cai@lca.pw
Link: http://lkml.kernel.org/r/1563914986-26502-1-git-send-email-cai@lca.pw
Fixes: d66acc39c7ce ("bitops: Optimise get_order()")
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: James Y Knight <jyknight@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/asm-generic/getorder.h | 50 ++++++++++++++--------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

--- a/include/asm-generic/getorder.h
+++ b/include/asm-generic/getorder.h
@@ -6,24 +6,6 @@
 #include <linux/compiler.h>
 #include <linux/log2.h>
 
-/*
- * Runtime evaluation of get_order()
- */
-static inline __attribute_const__
-int __get_order(unsigned long size)
-{
-	int order;
-
-	size--;
-	size >>= PAGE_SHIFT;
-#if BITS_PER_LONG == 32
-	order = fls(size);
-#else
-	order = fls64(size);
-#endif
-	return order;
-}
-
 /**
  * get_order - Determine the allocation order of a memory size
  * @size: The size for which to get the order
@@ -42,19 +24,27 @@ int __get_order(unsigned long size)
  * to hold an object of the specified size.
  *
  * The result is undefined if the size is 0.
- *
- * This function may be used to initialise variables with compile time
- * evaluations of constants.
  */
-#define get_order(n)						\
-(								\
-	__builtin_constant_p(n) ? (				\
-		((n) == 0UL) ? BITS_PER_LONG - PAGE_SHIFT :	\
-		(((n) < (1UL << PAGE_SHIFT)) ? 0 :		\
-		 ilog2((n) - 1) - PAGE_SHIFT + 1)		\
-	) :							\
-	__get_order(n)						\
-)
+static inline __attribute_const__ int get_order(unsigned long size)
+{
+	if (__builtin_constant_p(size)) {
+		if (!size)
+			return BITS_PER_LONG - PAGE_SHIFT;
+
+		if (size < (1UL << PAGE_SHIFT))
+			return 0;
+
+		return ilog2((size) - 1) - PAGE_SHIFT + 1;
+	}
+
+	size--;
+	size >>= PAGE_SHIFT;
+#if BITS_PER_LONG == 32
+	return fls(size);
+#else
+	return fls64(size);
+#endif
+}
 
 #endif	/* __ASSEMBLY__ */
 

