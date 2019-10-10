Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79451D22F1
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387526AbfJJIiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387519AbfJJIiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:38:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52B2520B7C;
        Thu, 10 Oct 2019 08:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696685;
        bh=m5bKekGyG+UJ+dgiw3Tg31ttRSjqcr2cZTnp/STQPfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sD00p9FjVKZSVqeQJgoyP1kuMvVcY0uot8AmINvy1djisEs+Pu86pyM9gXxAe/NsG
         rso+utBxhmmKbGJILt33hm5KGUtH4+jXRBrBk8zvuicVMF7cR5i7uSliByoZxn1TZd
         MpO/Y6hlP1mg004VlAf8bWLcW1QAX5JAxvRqU5VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.3 016/148] KVM: X86: Fix userspace set invalid CR4
Date:   Thu, 10 Oct 2019 10:34:37 +0200
Message-Id: <20191010083612.099185303@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 3ca94192278ca8de169d78c085396c424be123b3 upstream.

Reported by syzkaller:

	WARNING: CPU: 0 PID: 6544 at /home/kernel/data/kvm/arch/x86/kvm//vmx/vmx.c:4689 handle_desc+0x37/0x40 [kvm_intel]
	CPU: 0 PID: 6544 Comm: a.out Tainted: G           OE     5.3.0-rc4+ #4
	RIP: 0010:handle_desc+0x37/0x40 [kvm_intel]
	Call Trace:
	 vmx_handle_exit+0xbe/0x6b0 [kvm_intel]
	 vcpu_enter_guest+0x4dc/0x18d0 [kvm]
	 kvm_arch_vcpu_ioctl_run+0x407/0x660 [kvm]
	 kvm_vcpu_ioctl+0x3ad/0x690 [kvm]
	 do_vfs_ioctl+0xa2/0x690
	 ksys_ioctl+0x6d/0x80
	 __x64_sys_ioctl+0x1a/0x20
	 do_syscall_64+0x74/0x720
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe

When CR4.UMIP is set, guest should have UMIP cpuid flag. Current
kvm set_sregs function doesn't have such check when userspace inputs
sregs values. SECONDARY_EXEC_DESC is enabled on writes to CR4.UMIP
in vmx_set_cr4 though guest doesn't have UMIP cpuid flag. The testcast
triggers handle_desc warning when executing ltr instruction since
guest architectural CR4 doesn't set UMIP. This patch fixes it by
adding valid CR4 and CPUID combination checking in __set_sregs.

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=138efb99600000

Reported-by: syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -884,34 +884,42 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u
 }
 EXPORT_SYMBOL_GPL(kvm_set_xcr);
 
-int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	unsigned long old_cr4 = kvm_read_cr4(vcpu);
-	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
-				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
-
 	if (cr4 & CR4_RESERVED_BITS)
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) && (cr4 & X86_CR4_OSXSAVE))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SMEP) && (cr4 & X86_CR4_SMEP))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SMAP) && (cr4 & X86_CR4_SMAP))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_FSGSBASE) && (cr4 & X86_CR4_FSGSBASE))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_PKU) && (cr4 & X86_CR4_PKE))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_LA57) && (cr4 & X86_CR4_LA57))
-		return 1;
+		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_UMIP) && (cr4 & X86_CR4_UMIP))
+		return -EINVAL;
+
+	return 0;
+}
+
+int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	unsigned long old_cr4 = kvm_read_cr4(vcpu);
+	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
+				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
+
+	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
 
 	if (is_long_mode(vcpu)) {
@@ -8598,10 +8606,6 @@ EXPORT_SYMBOL_GPL(kvm_task_switch);
 
 static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
-			(sregs->cr4 & X86_CR4_OSXSAVE))
-		return  -EINVAL;
-
 	if ((sregs->efer & EFER_LME) && (sregs->cr0 & X86_CR0_PG)) {
 		/*
 		 * When EFER.LME and CR0.PG are set, the processor is in
@@ -8620,7 +8624,7 @@ static int kvm_valid_sregs(struct kvm_vc
 			return -EINVAL;
 	}
 
-	return 0;
+	return kvm_valid_cr4(vcpu, sregs->cr4);
 }
 
 static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)


