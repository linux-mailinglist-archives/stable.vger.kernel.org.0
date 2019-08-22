Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1BE599A62
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391072AbfHVRMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390641AbfHVRJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:04 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB78723406;
        Thu, 22 Aug 2019 17:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493743;
        bh=OH/rAetBAQwRVBiv9x4rHjv5FcgOgcVHMsUgQT8RD6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0eFP+WquYQeMMJdHz79WY9kmaGtqWShl+u8BHOLC2I1W6huAFEHD8WKHQ78HGp1L
         u3gcsHgKRf5NtQoxqiBFExPBWwwiX+1LuuuxwDJi3FgLIIK8iL+3RmLOSyol1G0k7n
         lFzaHU/EPP7IYx/1c4BteJ89TN05oQcFMEEkS5kg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bill Wendling <morbo@google.com>,
        James Y Knight <jyknight@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 089/135] asm-generic: fix -Wtype-limits compiler warnings
Date:   Thu, 22 Aug 2019 13:07:25 -0400
Message-Id: <20190822170811.13303-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit cbedfe11347fe418621bd188d58a206beb676218 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/getorder.h | 50 ++++++++++++++--------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/include/asm-generic/getorder.h b/include/asm-generic/getorder.h
index c64bea7a52beb..e9f20b813a699 100644
--- a/include/asm-generic/getorder.h
+++ b/include/asm-generic/getorder.h
@@ -7,24 +7,6 @@
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
@@ -43,19 +25,27 @@ int __get_order(unsigned long size)
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
 
-- 
2.20.1

