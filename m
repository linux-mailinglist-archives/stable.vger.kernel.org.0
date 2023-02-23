Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0086A09AB
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbjBWNJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjBWNJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:09:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D89D498BF
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:08:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 86CB4CE202A
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DE8C433D2;
        Thu, 23 Feb 2023 13:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157732;
        bh=uO9Daz8XjO6zfQruuDD6Q51b/INB1wVoUlSRy4KYdKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kufSLmDcadAgSp7hd2Ije1GVzKp5cXRJLHuVhLM9EDQCVCOyy0e3WjPgfQUaD215C
         wFjDDPISVQwZczKCt2xzozjZX8GhETyP1lParm1+HwWFsWAszaAR0j3ffaaMjOZiEP
         I7LiGHolQgqDnQr3FBNzGQWFJxMjem35zD4KpRJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/46] KVM: SVM: Skip WRMSR fastpath on VM-Exit if next RIP isnt valid
Date:   Thu, 23 Feb 2023 14:06:25 +0100
Message-Id: <20230223130432.392066140@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 5c30e8101e8d5d020b1d7119117889756a6ed713 ]

Skip the WRMSR fastpath in SVM's VM-Exit handler if the next RIP isn't
valid, e.g. because KVM is running with nrips=false.  SVM must decode and
emulate to skip the WRMSR if the CPU doesn't provide the next RIP.
Getting the instruction bytes to decode the WRMSR requires reading guest
memory, which in turn means dereferencing memslots, and that isn't safe
because KVM doesn't hold SRCU when the fastpath runs.

Don't bother trying to enable the fastpath for this case, e.g. by doing
only the WRMSR and leaving the "skip" until later.  NRIPS is supported on
all modern CPUs (KVM has considered making it mandatory), and the next
RIP will be valid the vast, vast majority of the time.

  =============================
  WARNING: suspicious RCU usage
  6.0.0-smp--4e557fcd3d80-skip #13 Tainted: G           O
  -----------------------------
  include/linux/kvm_host.h:954 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by stable/206475:
   #0: ffff9d9dfebcc0f0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x8b/0x620 [kvm]

  stack backtrace:
  CPU: 152 PID: 206475 Comm: stable Tainted: G           O       6.0.0-smp--4e557fcd3d80-skip #13
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 10.48.0 01/27/2022
  Call Trace:
   <TASK>
   dump_stack_lvl+0x69/0xaa
   dump_stack+0x10/0x12
   lockdep_rcu_suspicious+0x11e/0x130
   kvm_vcpu_gfn_to_memslot+0x155/0x190 [kvm]
   kvm_vcpu_gfn_to_hva_prot+0x18/0x80 [kvm]
   paging64_walk_addr_generic+0x183/0x450 [kvm]
   paging64_gva_to_gpa+0x63/0xd0 [kvm]
   kvm_fetch_guest_virt+0x53/0xc0 [kvm]
   __do_insn_fetch_bytes+0x18b/0x1c0 [kvm]
   x86_decode_insn+0xf0/0xef0 [kvm]
   x86_emulate_instruction+0xba/0x790 [kvm]
   kvm_emulate_instruction+0x17/0x20 [kvm]
   __svm_skip_emulated_instruction+0x85/0x100 [kvm_amd]
   svm_skip_emulated_instruction+0x13/0x20 [kvm_amd]
   handle_fastpath_set_msr_irqoff+0xae/0x180 [kvm]
   svm_vcpu_run+0x4b8/0x5a0 [kvm_amd]
   vcpu_enter_guest+0x16ca/0x22f0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x39d/0x900 [kvm]
   kvm_vcpu_ioctl+0x538/0x620 [kvm]
   __se_sys_ioctl+0x77/0xc0
   __x64_sys_ioctl+0x1d/0x20
   do_syscall_64+0x3d/0x80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 404d5d7bff0d ("KVM: X86: Introduce more exit_fastpath_completion enum values")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20220930234031.1732249-1-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce362e88a5676..0434bb7b456bd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3889,8 +3889,14 @@ static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
-	    to_svm(vcpu)->vmcb->control.exit_info_1)
+	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
+
+	/*
+	 * Note, the next RIP must be provided as SRCU isn't held, i.e. KVM
+	 * can't read guest memory (dereference memslots) to decode the WRMSR.
+	 */
+	if (control->exit_code == SVM_EXIT_MSR && control->exit_info_1 &&
+	    nrips && control->next_rip)
 		return handle_fastpath_set_msr_irqoff(vcpu);
 
 	return EXIT_FASTPATH_NONE;
-- 
2.39.0



