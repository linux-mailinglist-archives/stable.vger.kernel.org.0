Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14AC157B97
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgBJMgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgBJMgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:03 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDF3224650;
        Mon, 10 Feb 2020 12:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338163;
        bh=6ClqLHcqhhdt+5npdSzwg4V0t/ZRGRRby3mfvP+T1lE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxJRkjKO+b5AiyKJKSSDQxOveN77GnZhCslmbyuOh/1cWYlZYwnGIqSxxYLauO4yn
         yQ214GDhI3UyMVQhPkXOhX4cPdWdeG5I0Uzkz/qV7QGEc+eBM5W0iO7YwgolQx9nUC
         YZRjhHbyY53KoNoFbMEkvTS+TEqMCyeqUIXOdkPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Nakajima <jun.nakajima@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 139/195] KVM: x86: Dont let userspace set host-reserved cr4 bits
Date:   Mon, 10 Feb 2020 04:33:17 -0800
Message-Id: <20200210122318.872139130@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Cc: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -92,6 +92,8 @@ u64 __read_mostly efer_reserved_bits = ~
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
+static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
+
 #define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
 #define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
 
@@ -793,9 +795,38 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u
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
+	if (!cpu_has(c, X86_FEATURE_PKU))
+		reserved_bits |= X86_CR4_PKE;
+
+	if (!cpu_has(c, X86_FEATURE_LA57) &&
+	    !(cpuid_ecx(0x7) & bit(X86_FEATURE_LA57)))
+		reserved_bits |= X86_CR4_LA57;
+
+	if (!cpu_has(c, X86_FEATURE_UMIP) && !kvm_x86_ops->umip_emulated())
+		reserved_bits |= X86_CR4_UMIP;
+
+	return reserved_bits;
+}
+
 static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	if (cr4 & CR4_RESERVED_BITS)
+	if (cr4 & cr4_reserved_bits)
 		return -EINVAL;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) && (cr4 & X86_CR4_OSXSAVE))
@@ -8864,6 +8895,8 @@ int kvm_arch_hardware_setup(void)
 	if (r != 0)
 		return r;
 
+	cr4_reserved_bits = kvm_host_cr4_reserved_bits(&boot_cpu_data);
+
 	if (kvm_has_tsc_control) {
 		/*
 		 * Make sure the user can only configure tsc_khz values that


