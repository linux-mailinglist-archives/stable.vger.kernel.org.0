Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9975C420F76
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbhJDNfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236310AbhJDNbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:31:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62ED861BA1;
        Mon,  4 Oct 2021 13:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353251;
        bh=2aou1H1vNQtAw5M/ECqOLD9IIJ4Ygl4rIiudc0l9X2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNslxUpXffNUhhhbfjMIa+PQd/ZcqwwW2xq9zj1dVdsEyVnENx0H60VvZ1olKOBLW
         +WdkE/RhP/DZaLuTEn/XerySn/MowP9jA9NJkU0s+5SUiukv5GjzG9mZs13PjELWtB
         za7fqke9XuvjDZeen7/hK320HVvA660qDxH0Ldh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 053/172] KVM: x86: Swap order of CPUID entry "index" vs. "significant flag" checks
Date:   Mon,  4 Oct 2021 14:51:43 +0200
Message-Id: <20211004125046.707413951@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit e8a747d0884e554a8c1872da6c8f680a4f893c6d upstream.

Check whether a CPUID entry's index is significant before checking for a
matching index to hack-a-fix an undefined behavior bug due to consuming
uninitialized data.  RESET/INIT emulation uses kvm_cpuid() to retrieve
CPUID.0x1, which does _not_ have a significant index, and fails to
initialize the dummy variable that doubles as EBX/ECX/EDX output _and_
ECX, a.k.a. index, input.

Practically speaking, it's _extremely_  unlikely any compiler will yield
code that causes problems, as the compiler would need to inline the
kvm_cpuid() call to detect the uninitialized data, and intentionally hose
the kernel, e.g. insert ud2, instead of simply ignoring the result of
the index comparison.

Although the sketchy "dummy" pattern was introduced in SVM by commit
66f7b72e1171 ("KVM: x86: Make register state after reset conform to
specification"), it wasn't actually broken until commit 7ff6c0350315
("KVM: x86: Remove stateful CPUID handling") arbitrarily swapped the
order of operations such that "index" was checked before the significant
flag.

Avoid consuming uninitialized data by reverting to checking the flag
before the index purely so that the fix can be easily backported; the
offending RESET/INIT code has been refactored, moved, and consolidated
from vendor code to common x86 since the bug was introduced.  A future
patch will directly address the bad RESET/INIT behavior.

The undefined behavior was detected by syzbot + KernelMemorySanitizer.

  BUG: KMSAN: uninit-value in cpuid_entry2_find arch/x86/kvm/cpuid.c:68
  BUG: KMSAN: uninit-value in kvm_find_cpuid_entry arch/x86/kvm/cpuid.c:1103
  BUG: KMSAN: uninit-value in kvm_cpuid+0x456/0x28f0 arch/x86/kvm/cpuid.c:1183
   cpuid_entry2_find arch/x86/kvm/cpuid.c:68 [inline]
   kvm_find_cpuid_entry arch/x86/kvm/cpuid.c:1103 [inline]
   kvm_cpuid+0x456/0x28f0 arch/x86/kvm/cpuid.c:1183
   kvm_vcpu_reset+0x13fb/0x1c20 arch/x86/kvm/x86.c:10885
   kvm_apic_accept_events+0x58f/0x8c0 arch/x86/kvm/lapic.c:2923
   vcpu_enter_guest+0xfd2/0x6d80 arch/x86/kvm/x86.c:9534
   vcpu_run+0x7f5/0x18d0 arch/x86/kvm/x86.c:9788
   kvm_arch_vcpu_ioctl_run+0x245b/0x2d10 arch/x86/kvm/x86.c:10020

  Local variable ----dummy@kvm_vcpu_reset created at:
   kvm_vcpu_reset+0x1fb/0x1c20 arch/x86/kvm/x86.c:10812
   kvm_apic_accept_events+0x58f/0x8c0 arch/x86/kvm/lapic.c:2923

Reported-by: syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com
Reported-by: Alexander Potapenko <glider@google.com>
Fixes: 2a24be79b6b7 ("KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping")
Fixes: 7ff6c0350315 ("KVM: x86: Remove stateful CPUID handling")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Message-Id: <20210929222426.1855730-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -65,8 +65,8 @@ static inline struct kvm_cpuid_entry2 *c
 	for (i = 0; i < nent; i++) {
 		e = &entries[i];
 
-		if (e->function == function && (e->index == index ||
-		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
+		if (e->function == function &&
+		    (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index))
 			return e;
 	}
 


