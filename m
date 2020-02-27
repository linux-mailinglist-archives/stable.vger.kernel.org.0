Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F651720FE
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgB0NpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:45:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbgB0NpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:45:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDB2320578;
        Thu, 27 Feb 2020 13:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811115;
        bh=3rdEB6lUQ6pPyyCbptbrR7bjgdT1cCzygJYV84n2H3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKZjZAT2yNqeqyHhZAhHYZzf0f785LvLAnbtkVawSnsJtQqoV0vlDXvKTSmE9K7x3
         ig0xzCn6xh9jJUD3gQffg4vim/HG/D2JoxksVU4/4UTEggXFEUymqy6d4n6CKAosmo
         MxskEvvZQYxRiLRpPhN2kUbnCWnUECRw67qzLI2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 001/165] x86/vdso: Use RDPID in preference to LSL when available
Date:   Thu, 27 Feb 2020 14:34:35 +0100
Message-Id: <20200227132231.080872298@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit a582c540ac1b10f0a7d37415e04c4af42409fd08 upstream.

RDPID is a new instruction that reads MSR_TSC_AUX quickly.  This
should be considerably faster than reading the GDT.  Add a
cpufeature for it and use it from __vdso_getcpu() when available.

Tested-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/4f6c3a22012d10f1c65b9ca15800e01b42c7d39d.1479320367.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/include/asm/vgtod.h       |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -305,6 +305,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ecx), word 16 */
 #define X86_FEATURE_PKU		(16*32+ 3) /* Protection Keys for Userspace */
 #define X86_FEATURE_OSPKE	(16*32+ 4) /* OS Protection Keys Enable */
+#define X86_FEATURE_RDPID	(16*32+ 22) /* RDPID instruction */
 
 /* AMD-defined CPU features, CPUID level 0x80000007 (ebx), word 17 */
 #define X86_FEATURE_OVERFLOW_RECOV (17*32+0) /* MCA overflow recovery support */
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -89,8 +89,13 @@ static inline unsigned int __getcpu(void
 	 * works on all CPUs.  This is volatile so that it orders
 	 * correctly wrt barrier() and to keep gcc from cleverly
 	 * hoisting it out of the calling function.
+	 *
+	 * If RDPID is available, use it.
 	 */
-	asm volatile ("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+	alternative_io ("lsl %[p],%[seg]",
+			".byte 0xf3,0x0f,0xc7,0xf8", /* RDPID %eax/rax */
+			X86_FEATURE_RDPID,
+			[p] "=a" (p), [seg] "r" (__PER_CPU_SEG));
 
 	return p;
 }


