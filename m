Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE8811B0DD
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732981AbfLKP0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:26:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733151AbfLKP0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:26:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5839F2173E;
        Wed, 11 Dec 2019 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077999;
        bh=7HNuNUXEtkvELhgCo62JxHZPL/MBx2gnOhva4AopJsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRioxFq2XilQDqXdV/H6SPVTIWY82w+dFaftfI6OSRCfOV9BsRagma0gP3ywz946u
         uMCVS/blaHxyQwGdUeTcBdAKHrM9LCOuZ/p+qiG8Ns8gxQzFwpUW5Da6DP8PnEIHSY
         vKhZemfcsADdK1a6u7A4FEwIpN8J2jJoO8M12f4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 228/243] KVM: x86: Grab KVMs srcu lock when setting nested state
Date:   Wed, 11 Dec 2019 16:06:30 +0100
Message-Id: <20191211150354.726820634@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit ad5996d9a0e8019c3ae5151e687939369acfe044 upstream.

Acquire kvm->srcu for the duration of ->set_nested_state() to fix a bug
where nVMX derefences ->memslots without holding ->srcu or ->slots_lock.

The other half of nested migration, ->get_nested_state(), does not need
to acquire ->srcu as it is a purely a dump of internal KVM (and CPU)
state to userspace.

Detected as an RCU lockdep splat that is 100% reproducible by running
KVM's state_test selftest with CONFIG_PROVE_LOCKING=y.  Note that the
failing function, kvm_is_visible_gfn(), is only checking the validity of
a gfn, it's not actually accessing guest memory (which is more or less
unsupported during vmx_set_nested_state() due to incorrect MMU state),
i.e. vmx_set_nested_state() itself isn't fundamentally broken.  In any
case, setting nested state isn't a fast path so there's no reason to go
out of our way to avoid taking ->srcu.

  =============================
  WARNING: suspicious RCU usage
  5.4.0-rc7+ #94 Not tainted
  -----------------------------
  include/linux/kvm_host.h:626 suspicious rcu_dereference_check() usage!

               other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by evmcs_test/10939:
   #0: ffff88826ffcb800 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x85/0x630 [kvm]

  stack backtrace:
  CPU: 1 PID: 10939 Comm: evmcs_test Not tainted 5.4.0-rc7+ #94
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   dump_stack+0x68/0x9b
   kvm_is_visible_gfn+0x179/0x180 [kvm]
   mmu_check_root+0x11/0x30 [kvm]
   fast_cr3_switch+0x40/0x120 [kvm]
   kvm_mmu_new_cr3+0x34/0x60 [kvm]
   nested_vmx_load_cr3+0xbd/0x1f0 [kvm_intel]
   nested_vmx_enter_non_root_mode+0xab8/0x1d60 [kvm_intel]
   vmx_set_nested_state+0x256/0x340 [kvm_intel]
   kvm_arch_vcpu_ioctl+0x491/0x11a0 [kvm]
   kvm_vcpu_ioctl+0xde/0x630 [kvm]
   do_vfs_ioctl+0xa2/0x6c0
   ksys_ioctl+0x66/0x70
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x54/0x200
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7f59a2b95f47

Fixes: 8fcc4b5923af5 ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4117,6 +4117,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 	case KVM_SET_NESTED_STATE: {
 		struct kvm_nested_state __user *user_kvm_nested_state = argp;
 		struct kvm_nested_state kvm_state;
+		int idx;
 
 		r = -EINVAL;
 		if (!kvm_x86_ops->set_nested_state)
@@ -4138,7 +4139,9 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		if (kvm_state.flags == KVM_STATE_NESTED_RUN_PENDING)
 			break;
 
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
 		r = kvm_x86_ops->set_nested_state(vcpu, user_kvm_nested_state, &kvm_state);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
 	default:


