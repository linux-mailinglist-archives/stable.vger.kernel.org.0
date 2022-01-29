Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1874A2F90
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348923AbiA2Mwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347906AbiA2Mww (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:52:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A452AC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 04:52:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 432D460C09
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B08C340E5;
        Sat, 29 Jan 2022 12:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643460771;
        bh=mjgy2BHKIowhmTZNWwX4sDxXD3Xe+YbgrBjoD/4OChQ=;
        h=Subject:To:Cc:From:Date:From;
        b=HuEflgSfiViNSm+Njuyw19qPE603Bx8THUmA2Gp7rFJyQuo17OsAdRvf5T5Cc5SWG
         OWOdy3GqA20u+pwfBO3TLuEfAF+dHJ/Y35WuG9nF9VIC7tUiXZrxH2DEd6fNFXquuh
         QCnjEXu28mB14ujq/RFX+HL+PKYa7iY1mV6GuyZg=
Subject: FAILED: patch "[PATCH] KVM: LAPIC: Also cancel preemption timer during SET_LAPIC" failed to apply to 5.10-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 13:52:43 +0100
Message-ID: <1643460763231174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 35fe7cfbab2e81f1afb23fc4212210b1de6d9633 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Tue, 25 Jan 2022 01:17:00 -0800
Subject: [PATCH] KVM: LAPIC: Also cancel preemption timer during SET_LAPIC

The below warning is splatting during guest reboot.

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 1931 at arch/x86/kvm/x86.c:10322 kvm_arch_vcpu_ioctl_run+0x874/0x880 [kvm]
  CPU: 0 PID: 1931 Comm: qemu-system-x86 Tainted: G          I       5.17.0-rc1+ #5
  RIP: 0010:kvm_arch_vcpu_ioctl_run+0x874/0x880 [kvm]
  Call Trace:
   <TASK>
   kvm_vcpu_ioctl+0x279/0x710 [kvm]
   __x64_sys_ioctl+0x83/0xb0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x7fd39797350b

This can be triggered by not exposing tsc-deadline mode and doing a reboot in
the guest. The lapic_shutdown() function which is called in sys_reboot path
will not disarm the flying timer, it just masks LVTT. lapic_shutdown() clears
APIC state w/ LVT_MASKED and timer-mode bit is 0, this can trigger timer-mode
switch between tsc-deadline and oneshot/periodic, which can result in preemption
timer be cancelled in apic_update_lvtt(). However, We can't depend on this when
not exposing tsc-deadline mode and oneshot/periodic modes emulated by preemption
timer. Qemu will synchronise states around reset, let's cancel preemption timer
under KVM_SET_LAPIC.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1643102220-35667-1-git-send-email-wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index baca9fa37a91..4662469240bc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2629,7 +2629,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_apic_set_version(vcpu);
 
 	apic_update_ppr(apic);
-	hrtimer_cancel(&apic->lapic_timer.timer);
+	cancel_apic_timer(apic);
 	apic->lapic_timer.expired_tscdeadline = 0;
 	apic_update_lvtt(apic);
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));

