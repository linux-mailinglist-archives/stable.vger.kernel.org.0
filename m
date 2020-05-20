Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9383A1DB668
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgETOYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:24:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33196 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727076AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-00036r-Mb; Wed, 20 May 2020 15:22:21 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-007DT0-Uj; Wed, 20 May 2020 15:22:19 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>
Date:   Wed, 20 May 2020 15:14:26 +0100
Message-ID: <lsq.1589984008.288512231@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 58/99] KVM: x86: Don't let userspace set
 host-reserved cr4 bits
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit b11306b53b2540c6ba068c4deddb6a17d9f8d95b upstream.

Calculate the host-reserved cr4 bits at runtime based on the system's
capabilities (using logic similar to __do_cpuid_func()), and use the
dynamically generated mask for the reserved bit check in kvm_set_cr4()
instead using of the static CR4_RESERVED_BITS define.  This prevents
userspace from "enabling" features in cr4 that are not supported by the
system, e.g. by ignoring KVM_GET_SUPPORTED_CPUID and specifying a bogus
CPUID for the vCPU.

Allowing userspace to set unsupported bits in cr4 can lead to a variety
of undesirable behavior, e.g. failed VM-Enter, and in general increases
KVM's attack surface.  A crafty userspace can even abuse CR4.LA57 to
induce an unchecked #GP on a WRMSR.

On a platform without LA57 support:

  KVM_SET_CPUID2 // CPUID_7_0_ECX.LA57 = 1
  KVM_SET_SREGS  // CR4.LA57 = 1
  KVM_SET_MSRS   // KERNEL_GS_BASE = 0x0004000000000000
  KVM_RUN

leads to a #GP when writing KERNEL_GS_BASE into hardware:

  unchecked MSR access error: WRMSR to 0xc0000102 (tried to write 0x0004000000000000)
  at rIP: 0xffffffffa00f239a (vmx_prepare_switch_to_guest+0x10a/0x1d0 [kvm_intel])
  Call Trace:
   kvm_arch_vcpu_ioctl_run+0x671/0x1c70 [kvm]
   kvm_vcpu_ioctl+0x36b/0x5d0 [kvm]
   do_vfs_ioctl+0xa1/0x620
   ksys_ioctl+0x66/0x70
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x4c/0x170
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7fc08133bf47

Note, the above sequence fails VM-Enter due to invalid guest state.
Userspace can allow VM-Enter to succeed (after the WRMSR #GP) by adding
a KVM_SET_SREGS w/ CR4.LA57=0 after KVM_SET_MSRS, in which case KVM will
technically leak the host's KERNEL_GS_BASE into the guest.  But, as
KERNEL_GS_BASE is a userspace-defined value/address, the leak is largely
benign as a malicious userspace would simply be exposing its own data to
the guest, and attacking a benevolent userspace would require multiple
bugs in the userspace VMM.

Cc: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.16:
 - PKE, LA57, and UMIP are totally unsupported and already included in
   CR4_RESERVED_BITS
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -82,6 +82,8 @@ u64 __read_mostly efer_reserved_bits = ~
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
+static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
+
 #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
 #define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
 
@@ -660,13 +662,32 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u
 }
 EXPORT_SYMBOL_GPL(kvm_set_xcr);
 
+static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
+{
+	u64 reserved_bits = CR4_RESERVED_BITS;
+
+	if (!cpu_has(c, X86_FEATURE_XSAVE))
+		reserved_bits |= X86_CR4_OSXSAVE;
+
+	if (!cpu_has(c, X86_FEATURE_SMEP))
+		reserved_bits |= X86_CR4_SMEP;
+
+	if (!cpu_has(c, X86_FEATURE_SMAP))
+		reserved_bits |= X86_CR4_SMAP;
+
+	if (!cpu_has(c, X86_FEATURE_FSGSBASE))
+		reserved_bits |= X86_CR4_FSGSBASE;
+
+	return reserved_bits;
+}
+
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
 				   X86_CR4_SMEP | X86_CR4_SMAP;
 
-	if (cr4 & CR4_RESERVED_BITS)
+	if (cr4 & cr4_reserved_bits)
 		return 1;
 
 	if (!guest_cpuid_has_xsave(vcpu) && (cr4 & X86_CR4_OSXSAVE))
@@ -7220,6 +7241,8 @@ int kvm_arch_hardware_setup(void)
 	if (r != 0)
 		return r;
 
+	cr4_reserved_bits = kvm_host_cr4_reserved_bits(&boot_cpu_data);
+
 	kvm_init_msr_list();
 	return 0;
 }

