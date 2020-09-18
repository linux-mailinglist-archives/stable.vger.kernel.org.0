Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D2326F372
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgIRDGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbgIRCEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C1923119;
        Fri, 18 Sep 2020 02:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394635;
        bh=VJ+NpByuRPvGBy7K8JrJKWOYPZ68d024/fZB79FpuK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbJugaNJFIzPMfzqDrbzO9KPMYQvd2Ia9nqp7rxbnXabEsvO4uvYHI9Ki22zC38rP
         Dg+6n2aOpBUuVZXx0VHfbQ5V/E/P+1/0ifXh2o2rsjHQT905/l1kkio0i0RNa/S6w/
         8gxVsNV2d9WgfreO47DqpKXO3+3z1v/ay76ZaWtI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wanpeng li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 135/330] KVM: nVMX: Hold KVM's srcu lock when syncing vmcs12->shadow
Date:   Thu, 17 Sep 2020 21:57:55 -0400
Message-Id: <20200918020110.2063155-135-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wanpeng li <wanpengli@tencent.com>

[ Upstream commit c9dfd3fb08352d439f0399b6fabe697681d2638c ]

For the duration of mapping eVMCS, it derefences ->memslots without holding
->srcu or ->slots_lock when accessing hv assist page. This patch fixes it by
moving nested_sync_vmcs12_to_shadow to prepare_guest_switch, where the SRCU
is already taken.

It can be reproduced by running kvm's evmcs_test selftest.

  =============================
  warning: suspicious rcu usage
  5.6.0-rc1+ #53 tainted: g        w ioe
  -----------------------------
  ./include/linux/kvm_host.h:623 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

   rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by evmcs_test/8507:
   #0: ffff9ddd156d00d0 (&vcpu->mutex){+.+.}, at:
kvm_vcpu_ioctl+0x85/0x680 [kvm]

  stack backtrace:
  cpu: 6 pid: 8507 comm: evmcs_test tainted: g        w ioe     5.6.0-rc1+ #53
  hardware name: dell inc. optiplex 7040/0jctf8, bios 1.4.9 09/12/2016
  call trace:
   dump_stack+0x68/0x9b
   kvm_read_guest_cached+0x11d/0x150 [kvm]
   kvm_hv_get_assist_page+0x33/0x40 [kvm]
   nested_enlightened_vmentry+0x2c/0x60 [kvm_intel]
   nested_vmx_handle_enlightened_vmptrld.part.52+0x32/0x1c0 [kvm_intel]
   nested_sync_vmcs12_to_shadow+0x439/0x680 [kvm_intel]
   vmx_vcpu_run+0x67a/0xe60 [kvm_intel]
   vcpu_enter_guest+0x35e/0x1bc0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x40b/0x670 [kvm]
   kvm_vcpu_ioctl+0x370/0x680 [kvm]
   ksys_ioctl+0x235/0x850
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x77/0x780
   entry_syscall_64_after_hwframe+0x49/0xbe

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3be65495aeb8a..a071eab3bab74 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1130,6 +1130,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 					   vmx->guest_msrs[i].mask);
 
 	}
+
+    	if (vmx->nested.need_vmcs12_to_shadow_sync)
+		nested_sync_vmcs12_to_shadow(vcpu);
+
 	if (vmx->guest_state_loaded)
 		return;
 
@@ -6485,8 +6489,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmcs_write32(PLE_WINDOW, vmx->ple_window);
 	}
 
-	if (vmx->nested.need_vmcs12_to_shadow_sync)
-		nested_sync_vmcs12_to_shadow(vcpu);
+	/*
+	 * We did this in prepare_switch_to_guest, because it needs to
+	 * be within srcu_read_lock.
+	 */
+	WARN_ON_ONCE(vmx->nested.need_vmcs12_to_shadow_sync);
 
 	if (test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty))
 		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
-- 
2.25.1

