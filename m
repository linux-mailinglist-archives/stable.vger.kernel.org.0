Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB4829C71C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752927AbgJ0N5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752925AbgJ0N5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:57:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC7ED2068D;
        Tue, 27 Oct 2020 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807061;
        bh=LCumXXTkjflgXPLc//C6IVax3GR9mLvWZH5iIaXZROM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGsveU3lNB+rH+od6nY5zHnFM/fwY8fMmIZngUcJpsYXx5MdwPLN5nV2d4BK9zL3i
         KFqSY2NekyO2mVCaNJDVVJdSWpw/GqM3aA+1KgzAj/Wnpnb+kJtFvrP7Jmn/lQwa3Y
         OfrTWOB0Ix/PEjTAobi5ebdKnkX5bOKFcr52Vhwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 006/112] mm/kasan: print name of mem[set,cpy,move]() caller in report
Date:   Tue, 27 Oct 2020 14:48:36 +0100
Message-Id: <20201027134900.841952859@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit 936bb4bbbb832f81055328b84e5afe1fc7246a8d upstream.

When bogus memory access happens in mem[set,cpy,move]() it's usually
caller's fault.  So don't blame mem[set,cpy,move]() in bug report, blame
the caller instead.

Before:
  BUG: KASAN: out-of-bounds access in memset+0x23/0x40 at <address>
After:
  BUG: KASAN: out-of-bounds access in <memset_caller> at <address>

Link: http://lkml.kernel.org/r/1462538722-1574-2-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/kasan.c |   64 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -252,32 +252,36 @@ static __always_inline bool memory_is_po
 	return memory_is_poisoned_n(addr, size);
 }
 
-
-static __always_inline void check_memory_region(unsigned long addr,
-						size_t size, bool write)
+static __always_inline void check_memory_region_inline(unsigned long addr,
+						size_t size, bool write,
+						unsigned long ret_ip)
 {
 	if (unlikely(size == 0))
 		return;
 
 	if (unlikely((void *)addr <
 		kasan_shadow_to_mem((void *)KASAN_SHADOW_START))) {
-		kasan_report(addr, size, write, _RET_IP_);
+		kasan_report(addr, size, write, ret_ip);
 		return;
 	}
 
 	if (likely(!memory_is_poisoned(addr, size)))
 		return;
 
-	kasan_report(addr, size, write, _RET_IP_);
+	kasan_report(addr, size, write, ret_ip);
 }
 
-void __asan_loadN(unsigned long addr, size_t size);
-void __asan_storeN(unsigned long addr, size_t size);
+static void check_memory_region(unsigned long addr,
+				size_t size, bool write,
+				unsigned long ret_ip)
+{
+	check_memory_region_inline(addr, size, write, ret_ip);
+}
 
 #undef memset
 void *memset(void *addr, int c, size_t len)
 {
-	__asan_storeN((unsigned long)addr, len);
+	check_memory_region((unsigned long)addr, len, true, _RET_IP_);
 
 	return __memset(addr, c, len);
 }
@@ -285,8 +289,8 @@ void *memset(void *addr, int c, size_t l
 #undef memmove
 void *memmove(void *dest, const void *src, size_t len)
 {
-	__asan_loadN((unsigned long)src, len);
-	__asan_storeN((unsigned long)dest, len);
+	check_memory_region((unsigned long)src, len, false, _RET_IP_);
+	check_memory_region((unsigned long)dest, len, true, _RET_IP_);
 
 	return __memmove(dest, src, len);
 }
@@ -294,8 +298,8 @@ void *memmove(void *dest, const void *sr
 #undef memcpy
 void *memcpy(void *dest, const void *src, size_t len)
 {
-	__asan_loadN((unsigned long)src, len);
-	__asan_storeN((unsigned long)dest, len);
+	check_memory_region((unsigned long)src, len, false, _RET_IP_);
+	check_memory_region((unsigned long)dest, len, true, _RET_IP_);
 
 	return __memcpy(dest, src, len);
 }
@@ -484,22 +488,22 @@ void __asan_unregister_globals(struct ka
 }
 EXPORT_SYMBOL(__asan_unregister_globals);
 
-#define DEFINE_ASAN_LOAD_STORE(size)				\
-	void __asan_load##size(unsigned long addr)		\
-	{							\
-		check_memory_region(addr, size, false);		\
-	}							\
-	EXPORT_SYMBOL(__asan_load##size);			\
-	__alias(__asan_load##size)				\
-	void __asan_load##size##_noabort(unsigned long);	\
-	EXPORT_SYMBOL(__asan_load##size##_noabort);		\
-	void __asan_store##size(unsigned long addr)		\
-	{							\
-		check_memory_region(addr, size, true);		\
-	}							\
-	EXPORT_SYMBOL(__asan_store##size);			\
-	__alias(__asan_store##size)				\
-	void __asan_store##size##_noabort(unsigned long);	\
+#define DEFINE_ASAN_LOAD_STORE(size)					\
+	void __asan_load##size(unsigned long addr)			\
+	{								\
+		check_memory_region_inline(addr, size, false, _RET_IP_);\
+	}								\
+	EXPORT_SYMBOL(__asan_load##size);				\
+	__alias(__asan_load##size)					\
+	void __asan_load##size##_noabort(unsigned long);		\
+	EXPORT_SYMBOL(__asan_load##size##_noabort);			\
+	void __asan_store##size(unsigned long addr)			\
+	{								\
+		check_memory_region_inline(addr, size, true, _RET_IP_);	\
+	}								\
+	EXPORT_SYMBOL(__asan_store##size);				\
+	__alias(__asan_store##size)					\
+	void __asan_store##size##_noabort(unsigned long);		\
 	EXPORT_SYMBOL(__asan_store##size##_noabort)
 
 DEFINE_ASAN_LOAD_STORE(1);
@@ -510,7 +514,7 @@ DEFINE_ASAN_LOAD_STORE(16);
 
 void __asan_loadN(unsigned long addr, size_t size)
 {
-	check_memory_region(addr, size, false);
+	check_memory_region(addr, size, false, _RET_IP_);
 }
 EXPORT_SYMBOL(__asan_loadN);
 
@@ -520,7 +524,7 @@ EXPORT_SYMBOL(__asan_loadN_noabort);
 
 void __asan_storeN(unsigned long addr, size_t size)
 {
-	check_memory_region(addr, size, true);
+	check_memory_region(addr, size, true, _RET_IP_);
 }
 EXPORT_SYMBOL(__asan_storeN);
 


