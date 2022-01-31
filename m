Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD294A423B
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349086AbiAaLLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54076 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376275AbiAaLIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:08:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAE3EB82A4D;
        Mon, 31 Jan 2022 11:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEA3C340E8;
        Mon, 31 Jan 2022 11:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627283;
        bh=k70UCGaKdelyUX4hLZO2WfvpGsnNzGI95PXnQiEeiXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwthVCYnQi3B/4v7UcZV21m4/wx8jfuGtoMLJ0ByLWfBo5eVLYQhcsAAh3cAPkEZW
         iaC5hlpnwYjJxMXqbbRG7cGwmHJ3JV8kvgqlRRNC2U5qrpja+jYbrT+WZbux3beDfV
         +R8GnXadS6lI7lVkXCvMJJfA9df+Tkg2dLpwQDYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 034/171] KVM: LAPIC: Also cancel preemption timer during SET_LAPIC
Date:   Mon, 31 Jan 2022 11:54:59 +0100
Message-Id: <20220131105231.168825677@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 35fe7cfbab2e81f1afb23fc4212210b1de6d9633 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2623,7 +2623,7 @@ int kvm_apic_set_state(struct kvm_vcpu *
 	kvm_apic_set_version(vcpu);
 
 	apic_update_ppr(apic);
-	hrtimer_cancel(&apic->lapic_timer.timer);
+	cancel_apic_timer(apic);
 	apic->lapic_timer.expired_tscdeadline = 0;
 	apic_update_lvtt(apic);
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));


