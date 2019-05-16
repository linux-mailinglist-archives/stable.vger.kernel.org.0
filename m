Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB45820C4B
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfEPQDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:03:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42568 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbfEPP6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:43 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006yp-5s; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001N3-J7; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        mpe@ellerman.id.au, mgorman@suse.de,
        "Ingo Molnar" <mingo@kernel.org>, catalin.marinas@arm.com,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, paulus@samba.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, mmarek@suse.cz,
        davem@davemloft.net, will.deacon@arm.com, benh@kernel.crashing.org,
        "Anton Blanchard" <anton@samba.org>, schwidefsky@de.ibm.com,
        ralf@linux-mips.org, linux@arm.linux.org.uk, jbaron@akamai.com,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        heiko.carstens@de.ibm.com, linuxppc-dev@lists.ozlabs.org,
        rostedt@goodmis.org, liuj97@gmail.com
Date:   Thu, 16 May 2019 16:55:32 +0100
Message-ID: <lsq.1558022132.38146636@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 09/86] jump_label: Allow jump labels to be used in
 assembly
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit c0ccf6f99e3a43b87980c9df7da48427885206d0 upstream.

To use jump labels in assembly we need the HAVE_JUMP_LABEL
define, so we select a fallback version if the toolchain does
not support them.

Modify linux/jump_label.h so it can be included by assembly
files. We also need to add -DCC_HAVE_ASM_GOTO to KBUILD_AFLAGS.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: benh@kernel.crashing.org
Cc: catalin.marinas@arm.com
Cc: davem@davemloft.net
Cc: heiko.carstens@de.ibm.com
Cc: jbaron@akamai.com
Cc: linux@arm.linux.org.uk
Cc: linuxppc-dev@lists.ozlabs.org
Cc: liuj97@gmail.com
Cc: mgorman@suse.de
Cc: mmarek@suse.cz
Cc: mpe@ellerman.id.au
Cc: paulus@samba.org
Cc: ralf@linux-mips.org
Cc: rostedt@goodmis.org
Cc: schwidefsky@de.ibm.com
Cc: will.deacon@arm.com
Link: http://lkml.kernel.org/r/1428551492-21977-2-git-send-email-anton@samba.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Makefile                   |  1 +
 include/linux/jump_label.h | 21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -761,6 +761,7 @@ KBUILD_ARFLAGS := $(call ar-option,D)
 # check for 'asm goto'
 ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
+	KBUILD_AFLAGS += -DCC_HAVE_ASM_GOTO
 endif
 
 include $(srctree)/scripts/Makefile.extrawarn
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -45,6 +45,12 @@
  * same as using STATIC_KEY_INIT_FALSE.
  */
 
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+# define HAVE_JUMP_LABEL
+#endif
+
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/bug.h>
@@ -55,7 +61,7 @@ extern bool static_key_initialized;
 				    "%s used before call to jump_label_init", \
 				    __func__)
 
-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+#ifdef HAVE_JUMP_LABEL
 
 struct static_key {
 	atomic_t enabled;
@@ -66,13 +72,18 @@ struct static_key {
 #endif
 };
 
-# include <asm/jump_label.h>
-# define HAVE_JUMP_LABEL
 #else
 struct static_key {
 	atomic_t enabled;
 };
-#endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
+#endif	/* HAVE_JUMP_LABEL */
+#endif /* __ASSEMBLY__ */
+
+#ifdef HAVE_JUMP_LABEL
+#include <asm/jump_label.h>
+#endif
+
+#ifndef __ASSEMBLY__
 
 enum jump_label_type {
 	JUMP_LABEL_DISABLE = 0,
@@ -223,3 +234,5 @@ static inline void static_key_disable(st
 }
 
 #endif	/* _LINUX_JUMP_LABEL_H */
+
+#endif /* __ASSEMBLY__ */

