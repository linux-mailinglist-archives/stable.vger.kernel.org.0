Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FF6329185
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242238AbhCAU1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242890AbhCAUVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:21:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F089653F1;
        Mon,  1 Mar 2021 18:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621861;
        bh=kMryugSAitGT+mUC9SjbCvQXq1N8L83kLgmmbMJwOh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8doOIVWWY6P4r0Q0xKeS3SB1FgaZyNIcJZ5xj/4MS7QpFCSiFBBBmyVkc87nFuMs
         KhKalTLpp2trUBR/D8cm2ZQFcqs0x2zmb7SlWis4T46thY2jY6Ft3k2ZCYwoFSRzGA
         aE3rW1cU1KKoXjytNqGNN+m1fkJ4tTtL/FATgVwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David P. Reed" <dpreed@deepplum.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 671/775] x86/virt: Eat faults on VMXOFF in reboot flows
Date:   Mon,  1 Mar 2021 17:13:59 +0100
Message-Id: <20210301161234.540204125@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit aec511ad153556640fb1de38bfe00c69464f997f upstream.

Silently ignore all faults on VMXOFF in the reboot flows as such faults
are all but guaranteed to be due to the CPU not being in VMX root.
Because (a) VMXOFF may be executed in NMI context, e.g. after VMXOFF but
before CR4.VMXE is cleared, (b) there's no way to query the CPU's VMX
state without faulting, and (c) the whole point is to get out of VMX
root, eating faults is the simplest way to achieve the desired behaior.

Technically, VMXOFF can fault (or fail) for other reasons, but all other
fault and failure scenarios are mode related, i.e. the kernel would have
to magically end up in RM, V86, compat mode, at CPL>0, or running with
the SMI Transfer Monitor active.  The kernel is beyond hosed if any of
those scenarios are encountered; trying to do something fancy in the
error path to handle them cleanly is pointless.

Fixes: 1e9931146c74 ("x86: asm/virtext.h: add cpu_vmxoff() inline function")
Reported-by: David P. Reed <dpreed@deepplum.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20201231002702.2223707-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/virtext.h |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -30,15 +30,22 @@ static inline int cpu_has_vmx(void)
 }
 
 
-/** Disable VMX on the current CPU
+/**
+ * cpu_vmxoff() - Disable VMX on the current CPU
  *
- * vmxoff causes a undefined-opcode exception if vmxon was not run
- * on the CPU previously. Only call this function if you know VMX
- * is enabled.
+ * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
+ *
+ * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
+ * atomically track post-VMXON state, e.g. this may be called in NMI context.
+ * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
+ * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
+ * magically in RM, VM86, compat mode, or at CPL>0.
  */
 static inline void cpu_vmxoff(void)
 {
-	asm volatile ("vmxoff");
+	asm_volatile_goto("1: vmxoff\n\t"
+			  _ASM_EXTABLE(1b, %l[fault]) :::: fault);
+fault:
 	cr4_clear_bits(X86_CR4_VMXE);
 }
 


