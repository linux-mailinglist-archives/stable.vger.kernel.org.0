Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6FF157904
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgBJMis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729222AbgBJMir (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:47 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A9020661;
        Mon, 10 Feb 2020 12:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338327;
        bh=FtFyVHKlsLuWjT3CeSFXUS0qvLrsuVqY0blbx8rra8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTuOLkVA8BD74TzJfoOCaLpLv5dPA3LZQql7erdbxVd+qZwNr5D7vW07diy9jOYdu
         wm9oGJZ25jx9WqSb2Jfh1EHYG2sGaRs48rN3h1mRBIV4VvmQyTA86bRY6qvoBfVsuO
         kQNXPnAWW20G8W/4EmKODopUuPWfqENptgvn4iA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Yerger <derek@djy.llc>,
        kernel@najdan.com, Wanpeng Li <wanpengli@tencent.com>,
        Thomas Lambertz <mail@thomaslambertz.de>,
        Rik van Riel <riel@surriel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 224/309] KVM: x86: Revert "KVM: X86: Fix fpu state crash in kvm guest"
Date:   Mon, 10 Feb 2020 04:33:00 -0800
Message-Id: <20200210122428.073853440@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 2620fe268e80d667a94553cd37a94ccaa2cb8c83 upstream.

Reload the current thread's FPU state, which contains the guest's FPU
state, to the CPU registers if necessary during vcpu_enter_guest().
TIF_NEED_FPU_LOAD can be set any time control is transferred out of KVM,
e.g. if I/O is triggered during a KVM call to get_user_pages() or if a
softirq occurs while KVM is scheduled in.

Moving the handling of TIF_NEED_FPU_LOAD from vcpu_enter_guest() to
kvm_arch_vcpu_load(), effectively kvm_sched_in(), papered over a bug
where kvm_put_guest_fpu() failed to account for TIF_NEED_FPU_LOAD.  The
easiest way to the kvm_put_guest_fpu() bug was to run with involuntary
preemption enable, thus handling TIF_NEED_FPU_LOAD during kvm_sched_in()
made the bug go away.  But, removing the handling in vcpu_enter_guest()
exposed KVM to the rare case of a softirq triggering kernel_fpu_begin()
between vcpu_load() and vcpu_enter_guest().

Now that kvm_{load,put}_guest_fpu() correctly handle TIF_NEED_FPU_LOAD,
revert the commit to both restore the vcpu_enter_guest() behavior and
eliminate the superfluous switch_fpu_return() in kvm_arch_vcpu_load().

Note, leaving the handling in kvm_arch_vcpu_load() isn't wrong per se,
but it is unnecessary, and most critically, makes it extremely difficult
to find bugs such as the kvm_put_guest_fpu() issue due to shrinking the
window where a softirq can corrupt state.

A sample trace triggered by warning if TIF_NEED_FPU_LOAD is set while
vcpu state is loaded:

 <IRQ>
  gcmaes_crypt_by_sg.constprop.12+0x26e/0x660
  ? 0xffffffffc024547d
  ? __qdisc_run+0x83/0x510
  ? __dev_queue_xmit+0x45e/0x990
  ? ip_finish_output2+0x1a8/0x570
  ? fib4_rule_action+0x61/0x70
  ? fib4_rule_action+0x70/0x70
  ? fib_rules_lookup+0x13f/0x1c0
  ? helper_rfc4106_decrypt+0x82/0xa0
  ? crypto_aead_decrypt+0x40/0x70
  ? crypto_aead_decrypt+0x40/0x70
  ? crypto_aead_decrypt+0x40/0x70
  ? esp_output_tail+0x8f4/0xa5a [esp4]
  ? skb_ext_add+0xd3/0x170
  ? xfrm_input+0x7a6/0x12c0
  ? xfrm4_rcv_encap+0xae/0xd0
  ? xfrm4_transport_finish+0x200/0x200
  ? udp_queue_rcv_one_skb+0x1ba/0x460
  ? udp_unicast_rcv_skb.isra.63+0x72/0x90
  ? __udp4_lib_rcv+0x51b/0xb00
  ? ip_protocol_deliver_rcu+0xd2/0x1c0
  ? ip_local_deliver_finish+0x44/0x50
  ? ip_local_deliver+0xe0/0xf0
  ? ip_protocol_deliver_rcu+0x1c0/0x1c0
  ? ip_rcv+0xbc/0xd0
  ? ip_rcv_finish_core.isra.19+0x380/0x380
  ? __netif_receive_skb_one_core+0x7e/0x90
  ? netif_receive_skb_internal+0x3d/0xb0
  ? napi_gro_receive+0xed/0x150
  ? 0xffffffffc0243c77
  ? net_rx_action+0x149/0x3b0
  ? __do_softirq+0xe4/0x2f8
  ? handle_irq_event_percpu+0x6a/0x80
  ? irq_exit+0xe6/0xf0
  ? do_IRQ+0x7f/0xd0
  ? common_interrupt+0xf/0xf
  </IRQ>
  ? irq_entries_start+0x20/0x660
  ? vmx_get_interrupt_shadow+0x2f0/0x710 [kvm_intel]
  ? kvm_set_msr_common+0xfc7/0x2380 [kvm]
  ? recalibrate_cpu_khz+0x10/0x10
  ? ktime_get+0x3a/0xa0
  ? kvm_arch_vcpu_ioctl_run+0x107/0x560 [kvm]
  ? kvm_init+0x6bf/0xd00 [kvm]
  ? __seccomp_filter+0x7a/0x680
  ? do_vfs_ioctl+0xa4/0x630
  ? security_file_ioctl+0x32/0x50
  ? ksys_ioctl+0x60/0x90
  ? __x64_sys_ioctl+0x16/0x20
  ? do_syscall_64+0x5f/0x1a0
  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
---[ end trace 9564a1ccad733a90 ]---

This reverts commit e751732486eb3f159089a64d1901992b1357e7cc.

Fixes: e751732486eb3 ("KVM: X86: Fix fpu state crash in kvm guest")
Reported-by: Derek Yerger <derek@djy.llc>
Reported-by: kernel@najdan.com
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Thomas Lambertz <mail@thomaslambertz.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3481,10 +3481,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
 
-	fpregs_assert_state_consistent();
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		switch_fpu_return();
-
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
@@ -8220,8 +8216,9 @@ static int vcpu_enter_guest(struct kvm_v
 	trace_kvm_entry(vcpu->vcpu_id);
 	guest_enter_irqoff();
 
-	/* The preempt notifier should have taken care of the FPU already.  */
-	WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
+	fpregs_assert_state_consistent();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
 
 	if (unlikely(vcpu->arch.switch_db_regs)) {
 		set_debugreg(0, 7);


