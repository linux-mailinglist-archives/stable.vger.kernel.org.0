Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02F4A8E1A
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733100AbfIDR4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733140AbfIDR4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:56:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C36F222CF5;
        Wed,  4 Sep 2019 17:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619764;
        bh=8nokAcEZWirdKxEw7pYP5GzdcUxq8+du0AvoEqwM5rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8DBvQhoyChp5SqQ0ZBA+mh2kDd3GbqrbknGa717JH+dn4HLFPaePEBkPI9agwyxW
         qIy6FlIIeTSWhTTG8gaOQCsZhwE++QBXSYDAkWE2K3LR0VmPWJS13UZQb3A7PVdRE9
         TnWblPiHvqWmVsdqtDEGXsiUMGCpXsXrl0oh8G04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.4 26/77] x86/retpoline: Dont clobber RFLAGS during CALL_NOSPEC on i386
Date:   Wed,  4 Sep 2019 19:53:13 +0200
Message-Id: <20190904175306.033475295@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit b63f20a778c88b6a04458ed6ffc69da953d3a109 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/nospec-branch.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -151,7 +151,7 @@
 	"    	lfence;\n"					\
 	"       jmp    902b;\n"					\
 	"       .align 16\n"					\
-	"903:	addl   $4, %%esp;\n"				\
+	"903:	lea    4(%%esp), %%esp;\n"			\
 	"       pushl  %[thunk_target];\n"			\
 	"       ret;\n"						\
 	"       .align 16\n"					\


