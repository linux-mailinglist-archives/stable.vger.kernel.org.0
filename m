Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990AD9B3B8
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 17:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405921AbfHWPoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 11:44:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36025 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405914AbfHWPod (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 11:44:33 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1i1Bjn-0005MO-Bu; Fri, 23 Aug 2019 17:44:27 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id E85AF1C04F3;
        Fri, 23 Aug 2019 17:44:26 +0200 (CEST)
Date:   Fri, 23 Aug 2019 15:44:26 -0000
From:   tip-bot2 for Sean Christopherson <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/retpoline: Don't clobber RFLAGS during
 CALL_NOSPEC on i386
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra (Intel) <peterz@infradead.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20190822211122.27579-1-sean.j.christopherson@intel.com>
References: <20190822211122.27579-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Message-ID: <156657506681.13327.12784359764644509478.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     b63f20a778c88b6a04458ed6ffc69da953d3a109
Gitweb:        https://git.kernel.org/tip/b63f20a778c88b6a04458ed6ffc69da953d3a109
Author:        Sean Christopherson <sean.j.christopherson@intel.com>
AuthorDate:    Thu, 22 Aug 2019 14:11:22 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 23 Aug 2019 17:38:13 +02:00

x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386

Use 'lea' instead of 'add' when adjusting %rsp in CALL_NOSPEC so as to
avoid clobbering flags.

KVM's emulator makes indirect calls into a jump table of sorts, where
the destination of the CALL_NOSPEC is a small blob of code that performs
fast emulation by executing the target instruction with fixed operands.

  adcb_al_dl:
     0x000339f8 <+0>:   adc    %dl,%al
     0x000339fa <+2>:   ret

A major motiviation for doing fast emulation is to leverage the CPU to
handle consumption and manipulation of arithmetic flags, i.e. RFLAGS is
both an input and output to the target of CALL_NOSPEC.  Clobbering flags
results in all sorts of incorrect emulation, e.g. Jcc instructions often
take the wrong path.  Sans the nops...

  asm("push %[flags]; popf; " CALL_NOSPEC " ; pushf; pop %[flags]\n"
     0x0003595a <+58>:  mov    0xc0(%ebx),%eax
     0x00035960 <+64>:  mov    0x60(%ebx),%edx
     0x00035963 <+67>:  mov    0x90(%ebx),%ecx
     0x00035969 <+73>:  push   %edi
     0x0003596a <+74>:  popf
     0x0003596b <+75>:  call   *%esi
     0x000359a0 <+128>: pushf
     0x000359a1 <+129>: pop    %edi
     0x000359a2 <+130>: mov    %eax,0xc0(%ebx)
     0x000359b1 <+145>: mov    %edx,0x60(%ebx)

  ctxt->eflags = (ctxt->eflags & ~EFLAGS_MASK) | (flags & EFLAGS_MASK);
     0x000359a8 <+136>: mov    -0x10(%ebp),%eax
     0x000359ab <+139>: and    $0x8d5,%edi
     0x000359b4 <+148>: and    $0xfffff72a,%eax
     0x000359b9 <+153>: or     %eax,%edi
     0x000359bd <+157>: mov    %edi,0x4(%ebx)

For the most part this has gone unnoticed as emulation of guest code
that can trigger fast emulation is effectively limited to MMIO when
running on modern hardware, and MMIO is rarely, if ever, accessed by
instructions that affect or consume flags.

Breakage is almost instantaneous when running with unrestricted guest
disabled, in which case KVM must emulate all instructions when the guest
has invalid state, e.g. when the guest is in Big Real Mode during early
BIOS.

Fixes: 776b043848fd2 ("x86/retpoline: Add initial retpoline support")
Fixes: 1a29b5b7f347a ("KVM: x86: Make indirect calls in emulator speculation safe")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190822211122.27579-1-sean.j.christopherson@intel.com

---
 arch/x86/include/asm/nospec-branch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 109f974..80bc209 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -192,7 +192,7 @@
 	"    	lfence;\n"					\
 	"       jmp    902b;\n"					\
 	"       .align 16\n"					\
-	"903:	addl   $4, %%esp;\n"				\
+	"903:	lea    4(%%esp), %%esp;\n"			\
 	"       pushl  %[thunk_target];\n"			\
 	"       ret;\n"						\
 	"       .align 16\n"					\
