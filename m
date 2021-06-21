Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826683AEEF2
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhFUQdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232117AbhFUQbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:31:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0099D61412;
        Mon, 21 Jun 2021 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292746;
        bh=GahaMZMu8OMGd26OVy+r4DhbnTN2eDxYErlkGPJh+do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9VvNMaW4evDd3oqvCmuUuXcsz2O1Ay0DRYvjgY+Ki5sR3L8RW6ZmNHqwr5BVpX1t
         0drqx9rhfkEEMla9eraqLaOf6CxiY5PTXqjKzOCrbt4cG4Ri0tJqDrVcHwzDq1VgCI
         uSB6nbV3VU4lMCFStfEyiEg9b8m7qNr6dl3mVj4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 113/146] KVM: x86/mmu: Calculate and check "full" mmu_role for nested MMU
Date:   Mon, 21 Jun 2021 18:15:43 +0200
Message-Id: <20210621154918.549660366@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 654430efde27248be563df9a88631204b5fe2df2 upstream.

Calculate and check the full mmu_role when initializing the MMU context
for the nested MMU, where "full" means the bits and pieces of the role
that aren't handled by kvm_calc_mmu_role_common().  While the nested MMU
isn't used for shadow paging, things like the number of levels in the
guest's page tables are surprisingly important when walking the guest
page tables.  Failure to reinitialize the nested MMU context if L2's
paging mode changes can result in unexpected and/or missed page faults,
and likely other explosions.

E.g. if an L1 vCPU is running both a 32-bit PAE L2 and a 64-bit L2, the
"common" role calculation will yield the same role for both L2s.  If the
64-bit L2 is run after the 32-bit PAE L2, L0 will fail to reinitialize
the nested MMU context, ultimately resulting in a bad walk of L2's page
tables as the MMU will still have a guest root_level of PT32E_ROOT_LEVEL.

  WARNING: CPU: 4 PID: 167334 at arch/x86/kvm/vmx/vmx.c:3075 ept_save_pdptrs+0x15/0xe0 [kvm_intel]
  Modules linked in: kvm_intel]
  CPU: 4 PID: 167334 Comm: CPU 3/KVM Not tainted 5.13.0-rc1-d849817d5673-reqs #185
  Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
  RIP: 0010:ept_save_pdptrs+0x15/0xe0 [kvm_intel]
  Code: <0f> 0b c3 f6 87 d8 02 00f
  RSP: 0018:ffffbba702dbba00 EFLAGS: 00010202
  RAX: 0000000000000011 RBX: 0000000000000002 RCX: ffffffff810a2c08
  RDX: ffff91d7bc30acc0 RSI: 0000000000000011 RDI: ffff91d7bc30a600
  RBP: ffff91d7bc30a600 R08: 0000000000000010 R09: 0000000000000007
  R10: 0000000000000000 R11: 0000000000000000 R12: ffff91d7bc30a600
  R13: ffff91d7bc30acc0 R14: ffff91d67c123460 R15: 0000000115d7e005
  FS:  00007fe8e9ffb700(0000) GS:ffff91d90fb00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 000000029f15a001 CR4: 00000000001726e0
  Call Trace:
   kvm_pdptr_read+0x3a/0x40 [kvm]
   paging64_walk_addr_generic+0x327/0x6a0 [kvm]
   paging64_gva_to_gpa_nested+0x3f/0xb0 [kvm]
   kvm_fetch_guest_virt+0x4c/0xb0 [kvm]
   __do_insn_fetch_bytes+0x11a/0x1f0 [kvm]
   x86_decode_insn+0x787/0x1490 [kvm]
   x86_decode_emulated_instruction+0x58/0x1e0 [kvm]
   x86_emulate_instruction+0x122/0x4f0 [kvm]
   vmx_handle_exit+0x120/0x660 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0xe25/0x1cb0 [kvm]
   kvm_vcpu_ioctl+0x211/0x5a0 [kvm]
   __x64_sys_ioctl+0x83/0xb0
   do_syscall_64+0x40/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Fixes: bf627a928837 ("x86/kvm/mmu: check if MMU reconfiguration is needed in init_kvm_nested_mmu()")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210610220026.1364486-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4705,9 +4705,33 @@ static void init_kvm_softmmu(struct kvm_
 	context->inject_page_fault = kvm_inject_page_fault;
 }
 
+static union kvm_mmu_role kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu)
+{
+	union kvm_mmu_role role = kvm_calc_shadow_root_page_role_common(vcpu, false);
+
+	/*
+	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
+	 * shadow pages of their own and so "direct" has no meaning.   Set it
+	 * to "true" to try to detect bogus usage of the nested MMU.
+	 */
+	role.base.direct = true;
+
+	if (!is_paging(vcpu))
+		role.base.level = 0;
+	else if (is_long_mode(vcpu))
+		role.base.level = is_la57_mode(vcpu) ? PT64_ROOT_5LEVEL :
+						       PT64_ROOT_4LEVEL;
+	else if (is_pae(vcpu))
+		role.base.level = PT32E_ROOT_LEVEL;
+	else
+		role.base.level = PT32_ROOT_LEVEL;
+
+	return role;
+}
+
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 {
-	union kvm_mmu_role new_role = kvm_calc_mmu_role_common(vcpu, false);
+	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_role.as_u64 == g_context->mmu_role.as_u64)


