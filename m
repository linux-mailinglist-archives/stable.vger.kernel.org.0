Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4359E524FB
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 09:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfFYHjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 03:39:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40899 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfFYHjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 03:39:48 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hfg3N-0007UW-3m; Tue, 25 Jun 2019 09:39:45 +0200
Date:   Tue, 25 Jun 2019 09:39:45 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH] x86/uaccess: Introduce user_access_{save,restore}()
Message-ID: <20190625073944.b7wnwuihhz5st67g@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please backport commit e74deb11931ff682b59d5b9d387f7115f689698e to
stable _or_ revert the backport of commit 4a6c91fbdef84 ("x86/uaccess,
ftrace: Fix ftrace_likely_update() vs. SMAP"). It uses
user_access_{save|restore}() which has been introduced in the following
commit.

I stumbled upon it in latest v5.0 tree and verified that v5.1.15 is also
affected. For reference, the commit I'm asking to backport.

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream change e74deb11931ff682b59d5b9d387f7115f689698e ]

Introduce common helpers for when we need to safely suspend a
uaccess section; for instance to generate a {KA,UB}SAN report.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/smap.h    | 20 ++++++++++++++++++++
 arch/x86/include/asm/uaccess.h |  3 +++
 include/linux/uaccess.h        |  2 ++
 3 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
index db333300bd4be..6cfe431710203 100644
--- a/arch/x86/include/asm/smap.h
+++ b/arch/x86/include/asm/smap.h
@@ -58,6 +58,23 @@ static __always_inline void stac(void)
 	alternative("", __stringify(__ASM_STAC), X86_FEATURE_SMAP);
 }
 
+static __always_inline unsigned long smap_save(void)
+{
+	unsigned long flags;
+
+	asm volatile (ALTERNATIVE("", "pushf; pop %0; " __stringify(__ASM_CLAC),
+				  X86_FEATURE_SMAP)
+		      : "=rm" (flags) : : "memory", "cc");
+
+	return flags;
+}
+
+static __always_inline void smap_restore(unsigned long flags)
+{
+	asm volatile (ALTERNATIVE("", "push %0; popf", X86_FEATURE_SMAP)
+		      : : "g" (flags) : "memory", "cc");
+}
+
 /* These macros can be used in asm() statements */
 #define ASM_CLAC \
 	ALTERNATIVE("", __stringify(__ASM_CLAC), X86_FEATURE_SMAP)
@@ -69,6 +86,9 @@ static __always_inline void stac(void)
 static inline void clac(void) { }
 static inline void stac(void) { }
 
+static inline unsigned long smap_save(void) { return 0; }
+static inline void smap_restore(unsigned long flags) { }
+
 #define ASM_CLAC
 #define ASM_STAC
 
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 3822cc8ac9d6d..e34cd97cb9a01 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -716,6 +716,9 @@ static __must_check inline bool user_access_begin(const void __user *ptr, size_t
 #define user_access_begin(a,b)	user_access_begin(a,b)
 #define user_access_end()	__uaccess_end()
 
+#define user_access_save()	smap_save()
+#define user_access_restore(x)	smap_restore(x)
+
 #define unsafe_put_user(x, ptr, label)	\
 	__put_user_size((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)), label)
 
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 37b226e8df13f..2b70130af5857 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -268,6 +268,8 @@ extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 #define user_access_end() do { } while (0)
 #define unsafe_get_user(x, ptr, err) do { if (unlikely(__get_user(x, ptr))) goto err; } while (0)
 #define unsafe_put_user(x, ptr, err) do { if (unlikely(__put_user(x, ptr))) goto err; } while (0)
+static inline unsigned long user_access_save(void) { return 0UL; }
+static inline void user_access_restore(unsigned long flags) { }
 #endif
 
 #ifdef CONFIG_HARDENED_USERCOPY
-- 
2.20.1

