Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FFB4418E7
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhKAJww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234431AbhKAJut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E9361506;
        Mon,  1 Nov 2021 09:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759124;
        bh=DLU0hoLPn9aOJSaWhDSMMKarff5wLgOVFaMK8lio7N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTKqX+Ek1SCkDwKUlknBZvpIIGpZeCzq+/uuLCXgRqnjR7pRNqAVwuD9OqZRuIPFV
         jH8vlUL8rQVgM+ivI+Bc6XSNuNtvva6s7H/Aujd/X211biF8aUGF1f2kcMV3hosbnZ
         a2xiol/3yqeRx/H/1qbKnvvahw8zyiWvJGEi8KRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 125/125] KVM: x86: Take srcu lock in post_kvm_run_save()
Date:   Mon,  1 Nov 2021 10:18:18 +0100
Message-Id: <20211101082556.682702250@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit f3d1436d4bf8ced1c9a62a045d193a65567e1fcc upstream.

The Xen interrupt injection for event channels relies on accessing the
guest's vcpu_info structure in __kvm_xen_has_interrupt(), through a
gfn_to_hva_cache.

This requires the srcu lock to be held, which is mostly the case except
for this code path:

[   11.822877] WARNING: suspicious RCU usage
[   11.822965] -----------------------------
[   11.823013] include/linux/kvm_host.h:664 suspicious rcu_dereference_check() usage!
[   11.823131]
[   11.823131] other info that might help us debug this:
[   11.823131]
[   11.823196]
[   11.823196] rcu_scheduler_active = 2, debug_locks = 1
[   11.823253] 1 lock held by dom:0/90:
[   11.823292]  #0: ffff998956ec8118 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x85/0x680
[   11.823379]
[   11.823379] stack backtrace:
[   11.823428] CPU: 2 PID: 90 Comm: dom:0 Kdump: loaded Not tainted 5.4.34+ #5
[   11.823496] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   11.823612] Call Trace:
[   11.823645]  dump_stack+0x7a/0xa5
[   11.823681]  lockdep_rcu_suspicious+0xc5/0x100
[   11.823726]  __kvm_xen_has_interrupt+0x179/0x190
[   11.823773]  kvm_cpu_has_extint+0x6d/0x90
[   11.823813]  kvm_cpu_accept_dm_intr+0xd/0x40
[   11.823853]  kvm_vcpu_ready_for_interrupt_injection+0x20/0x30
              < post_kvm_run_save() inlined here >
[   11.823906]  kvm_arch_vcpu_ioctl_run+0x135/0x6a0
[   11.823947]  kvm_vcpu_ioctl+0x263/0x680

Fixes: 40da8ccd724f ("KVM: x86/xen: Add event channel interrupt vector upcall")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
Message-Id: <606aaaf29fca3850a63aa4499826104e77a72346.camel@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8799,9 +8799,17 @@ static void post_kvm_run_save(struct kvm
 
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(vcpu);
+
+	/*
+	 * The call to kvm_ready_for_interrupt_injection() may end up in
+	 * kvm_xen_has_interrupt() which may require the srcu lock to be
+	 * held, to protect against changes in the vcpu_info address.
+	 */
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_run->ready_for_interrupt_injection =
 		pic_in_kernel(vcpu->kvm) ||
 		kvm_vcpu_ready_for_interrupt_injection(vcpu);
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 
 	if (is_smm(vcpu))
 		kvm_run->flags |= KVM_RUN_X86_SMM;


