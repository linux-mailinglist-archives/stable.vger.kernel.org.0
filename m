Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B62F1624BC
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbfGHPWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387886AbfGHPWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:22:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52F662166E;
        Mon,  8 Jul 2019 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599329;
        bh=JpG1ISpgMBrVAlKwifywtVV0D7zfPtJ94yrJOUJemE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U24NJgprkZOtYX9mhLRzhEdOfoTjWFps9KVnzulU40yAwVKgC/f94KNzE8LTQ2ETJ
         SmXRaPGC1Xvjx7oLjwwmygBc/uJ6xKTQB8JfEBDWjxEuLse7cLt8DbGkrZ4p8Pe85p
         l33YvhLC2c3hjCDD5IQGcE3trgcEPYqx2Jv2f0Kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christopher Li <sparse@chrisli.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.9 080/102] bug.h: work around GCC PR82365 in BUG()
Date:   Mon,  8 Jul 2019 17:13:13 +0200
Message-Id: <20190708150530.604533809@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 173a3efd3edb2ef6ef07471397c5f542a360e9c1 ]

Looking at functions with large stack frames across all architectures
led me discovering that BUG() suffers from the same problem as
fortify_panic(), which I've added a workaround for already.

In short, variables that go out of scope by calling a noreturn function
or __builtin_unreachable() keep using stack space in functions
afterwards.

A workaround that was identified is to insert an empty assembler
statement just before calling the function that doesn't return.  I'm
adding a macro "barrier_before_unreachable()" to document this, and
insert calls to that in all instances of BUG() that currently suffer
from this problem.

The files that saw the largest change from this had these frame sizes
before, and much less with my patch:

  fs/ext4/inode.c:82:1: warning: the frame size of 1672 bytes is larger than 800 bytes [-Wframe-larger-than=]
  fs/ext4/namei.c:434:1: warning: the frame size of 904 bytes is larger than 800 bytes [-Wframe-larger-than=]
  fs/ext4/super.c:2279:1: warning: the frame size of 1160 bytes is larger than 800 bytes [-Wframe-larger-than=]
  fs/ext4/xattr.c:146:1: warning: the frame size of 1168 bytes is larger than 800 bytes [-Wframe-larger-than=]
  fs/f2fs/inode.c:152:1: warning: the frame size of 1424 bytes is larger than 800 bytes [-Wframe-larger-than=]
  net/netfilter/ipvs/ip_vs_core.c:1195:1: warning: the frame size of 1068 bytes is larger than 800 bytes [-Wframe-larger-than=]
  net/netfilter/ipvs/ip_vs_core.c:395:1: warning: the frame size of 1084 bytes is larger than 800 bytes [-Wframe-larger-than=]
  net/netfilter/ipvs/ip_vs_ftp.c:298:1: warning: the frame size of 928 bytes is larger than 800 bytes [-Wframe-larger-than=]
  net/netfilter/ipvs/ip_vs_ftp.c:418:1: warning: the frame size of 908 bytes is larger than 800 bytes [-Wframe-larger-than=]
  net/netfilter/ipvs/ip_vs_lblcr.c:718:1: warning: the frame size of 960 bytes is larger than 800 bytes [-Wframe-larger-than=]
  drivers/net/xen-netback/netback.c:1500:1: warning: the frame size of 1088 bytes is larger than 800 bytes [-Wframe-larger-than=]

In case of ARC and CRIS, it turns out that the BUG() implementation
actually does return (or at least the compiler thinks it does),
resulting in lots of warnings about uninitialized variable use and
leaving noreturn functions, such as:

  block/cfq-iosched.c: In function 'cfq_async_queue_prio':
  block/cfq-iosched.c:3804:1: error: control reaches end of non-void function [-Werror=return-type]
  include/linux/dmaengine.h: In function 'dma_maxpq':
  include/linux/dmaengine.h:1123:1: error: control reaches end of non-void function [-Werror=return-type]

This makes them call __builtin_trap() instead, which should normally
dump the stack and kill the current process, like some of the other
architectures already do.

I tried adding barrier_before_unreachable() to panic() and
fortify_panic() as well, but that had very little effect, so I'm not
submitting that patch.

Vineet said:

: For ARC, it is double win.
:
: 1. Fixes 3 -Wreturn-type warnings
:
: | ../net/core/ethtool.c:311:1: warning: control reaches end of non-void function
: [-Wreturn-type]
: | ../kernel/sched/core.c:3246:1: warning: control reaches end of non-void function
: [-Wreturn-type]
: | ../include/linux/sunrpc/svc_xprt.h:180:1: warning: control reaches end of
: non-void function [-Wreturn-type]
:
: 2.  bloat-o-meter reports code size improvements as gcc elides the
:    generated code for stack return.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82365
Link: http://lkml.kernel.org/r/20171219114112.939391-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Vineet Gupta <vgupta@synopsys.com>	[arch/arc]
Tested-by: Vineet Gupta <vgupta@synopsys.com>	[arch/arc]
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christopher Li <sparse@chrisli.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[removed cris chunks - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/include/asm/bug.h   |    3 ++-
 arch/ia64/include/asm/bug.h  |    6 +++++-
 arch/m68k/include/asm/bug.h  |    3 +++
 arch/sparc/include/asm/bug.h |    6 +++++-
 include/asm-generic/bug.h    |    1 +
 include/linux/compiler-gcc.h |   15 ++++++++++++++-
 include/linux/compiler.h     |    5 +++++
 7 files changed, 35 insertions(+), 4 deletions(-)

--- a/arch/arc/include/asm/bug.h
+++ b/arch/arc/include/asm/bug.h
@@ -23,7 +23,8 @@ void die(const char *str, struct pt_regs
 
 #define BUG()	do {								\
 	pr_warn("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
-	dump_stack();								\
+	barrier_before_unreachable();						\
+	__builtin_trap();							\
 } while (0)
 
 #define HAVE_ARCH_BUG
--- a/arch/ia64/include/asm/bug.h
+++ b/arch/ia64/include/asm/bug.h
@@ -3,7 +3,11 @@
 
 #ifdef CONFIG_BUG
 #define ia64_abort()	__builtin_trap()
-#define BUG() do { printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__); ia64_abort(); } while (0)
+#define BUG() do {						\
+	printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__);	\
+	barrier_before_unreachable();				\
+	ia64_abort();						\
+} while (0)
 
 /* should this BUG be made generic? */
 #define HAVE_ARCH_BUG
--- a/arch/m68k/include/asm/bug.h
+++ b/arch/m68k/include/asm/bug.h
@@ -7,16 +7,19 @@
 #ifndef CONFIG_SUN3
 #define BUG() do { \
 	printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__); \
+	barrier_before_unreachable(); \
 	__builtin_trap(); \
 } while (0)
 #else
 #define BUG() do { \
 	printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__); \
+	barrier_before_unreachable(); \
 	panic("BUG!"); \
 } while (0)
 #endif
 #else
 #define BUG() do { \
+	barrier_before_unreachable(); \
 	__builtin_trap(); \
 } while (0)
 #endif
--- a/arch/sparc/include/asm/bug.h
+++ b/arch/sparc/include/asm/bug.h
@@ -8,10 +8,14 @@
 void do_BUG(const char *file, int line);
 #define BUG() do {					\
 	do_BUG(__FILE__, __LINE__);			\
+	barrier_before_unreachable();			\
 	__builtin_trap();				\
 } while (0)
 #else
-#define BUG()		__builtin_trap()
+#define BUG() do {					\
+	barrier_before_unreachable();			\
+	__builtin_trap();				\
+} while (0)
 #endif
 
 #define HAVE_ARCH_BUG
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -47,6 +47,7 @@ struct bug_entry {
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
 	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
+	barrier_before_unreachable(); \
 	panic("BUG!"); \
 } while (0)
 #endif
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -234,6 +234,15 @@
 #endif
 
 /*
+ * calling noreturn functions, __builtin_unreachable() and __builtin_trap()
+ * confuse the stack allocation in gcc, leading to overly large stack
+ * frames, see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82365
+ *
+ * Adding an empty inline assembly before it works around the problem
+ */
+#define barrier_before_unreachable() asm volatile("")
+
+/*
  * Mark a position in code as unreachable.  This can be used to
  * suppress control flow warnings after asm blocks that transfer
  * control elsewhere.
@@ -243,7 +252,11 @@
  * unreleased.  Really, we need to have autoconf for the kernel.
  */
 #define unreachable() \
-	do { annotate_unreachable(); __builtin_unreachable(); } while (0)
+	do {					\
+		annotate_unreachable();		\
+		barrier_before_unreachable();	\
+		__builtin_unreachable();	\
+	} while (0)
 
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__, __optimize__("no-tracer")))
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -177,6 +177,11 @@ void ftrace_likely_update(struct ftrace_
 # define barrier_data(ptr) barrier()
 #endif
 
+/* workaround for GCC PR82365 if needed */
+#ifndef barrier_before_unreachable
+# define barrier_before_unreachable() do { } while (0)
+#endif
+
 /* Unreachable code */
 #ifndef unreachable
 # define unreachable() do { } while (1)


