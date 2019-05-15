Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2B91ECF4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfEOLDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727336AbfEOLDj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 472F920881;
        Wed, 15 May 2019 11:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918218;
        bh=pI3Nrf7RMqFhLtRxtIesr5/VGQzifFxpPtHO/H0ku4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cH9XPaAr3eivUaqz69kRm0Dt+jh3dlamVbXxE15amWbBkJychFguX4cM4D1yVNlrE
         xBzO/Ig7BaZNHqPrQl3l0ClXqHT2zKI1YBoZwhtJaG7U0K6sX2c1fJbVK/bjUDXDQi
         KwmMqsDTg6B0jgyOfger0pQz/WrkJhLw22ieK9KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Craciun <diana.craciun@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 050/266] powerpc/fsl: Add barrier_nospec implementation for NXP PowerPC Book3E
Date:   Wed, 15 May 2019 12:52:37 +0200
Message-Id: <20190515090724.143101907@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Craciun <diana.craciun@nxp.com>

commit ebcd1bfc33c7a90df941df68a6e5d4018c022fba upstream.

Implement the barrier_nospec as a isync;sync instruction sequence.
The implementation uses the infrastructure built for BOOK3S 64.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
[mpe: Add PPC_INST_ISYNC for backport]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Kconfig                  |    2 +-
 arch/powerpc/include/asm/barrier.h    |    8 +++++++-
 arch/powerpc/include/asm/ppc-opcode.h |    1 +
 arch/powerpc/lib/feature-fixups.c     |   31 +++++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 2 deletions(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -165,7 +165,7 @@ config PPC
 config PPC_BARRIER_NOSPEC
     bool
     default y
-    depends on PPC_BOOK3S_64
+    depends on PPC_BOOK3S_64 || PPC_FSL_BOOK3E
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -92,12 +92,18 @@ do {									\
 #define smp_mb__after_atomic()      smp_mb()
 #define smp_mb__before_spinlock()   smp_mb()
 
+#ifdef CONFIG_PPC_BOOK3S_64
+#define NOSPEC_BARRIER_SLOT   nop
+#elif defined(CONFIG_PPC_FSL_BOOK3E)
+#define NOSPEC_BARRIER_SLOT   nop; nop
+#endif
+
 #ifdef CONFIG_PPC_BARRIER_NOSPEC
 /*
  * Prevent execution of subsequent instructions until preceding branches have
  * been fully resolved and are no longer executing speculatively.
  */
-#define barrier_nospec_asm NOSPEC_BARRIER_FIXUP_SECTION; nop
+#define barrier_nospec_asm NOSPEC_BARRIER_FIXUP_SECTION; NOSPEC_BARRIER_SLOT
 
 // This also acts as a compiler barrier due to the memory clobber.
 #define barrier_nospec() asm (stringify_in_c(barrier_nospec_asm) ::: "memory")
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -147,6 +147,7 @@
 #define PPC_INST_LWSYNC			0x7c2004ac
 #define PPC_INST_SYNC			0x7c0004ac
 #define PPC_INST_SYNC_MASK		0xfc0007fe
+#define PPC_INST_ISYNC			0x4c00012c
 #define PPC_INST_LXVD2X			0x7c000698
 #define PPC_INST_MCRXR			0x7c000400
 #define PPC_INST_MCRXR_MASK		0xfc0007fe
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -315,6 +315,37 @@ void do_barrier_nospec_fixups(bool enabl
 }
 #endif /* CONFIG_PPC_BARRIER_NOSPEC */
 
+#ifdef CONFIG_PPC_FSL_BOOK3E
+void do_barrier_nospec_fixups_range(bool enable, void *fixup_start, void *fixup_end)
+{
+	unsigned int instr[2], *dest;
+	long *start, *end;
+	int i;
+
+	start = fixup_start;
+	end = fixup_end;
+
+	instr[0] = PPC_INST_NOP;
+	instr[1] = PPC_INST_NOP;
+
+	if (enable) {
+		pr_info("barrier-nospec: using isync; sync as speculation barrier\n");
+		instr[0] = PPC_INST_ISYNC;
+		instr[1] = PPC_INST_SYNC;
+	}
+
+	for (i = 0; start < end; start++, i++) {
+		dest = (void *)start + *start;
+
+		pr_devel("patching dest %lx\n", (unsigned long)dest);
+		patch_instruction(dest, instr[0]);
+		patch_instruction(dest + 1, instr[1]);
+	}
+
+	printk(KERN_DEBUG "barrier-nospec: patched %d locations\n", i);
+}
+#endif /* CONFIG_PPC_FSL_BOOK3E */
+
 void do_lwsync_fixups(unsigned long value, void *fixup_start, void *fixup_end)
 {
 	long *start, *end;


