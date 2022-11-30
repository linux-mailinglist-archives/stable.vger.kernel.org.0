Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7737C63D56B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiK3MUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiK3MUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:20:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2F06F825
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:20:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3059CE18C7
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFA5C433C1;
        Wed, 30 Nov 2022 12:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669810837;
        bh=NM2eemxOi7LSqjBTdUiQhDsRq4hPL7uPuxcLBMwv4Y0=;
        h=Subject:To:Cc:From:Date:From;
        b=phYADW/h9er5pH04ld+aRQLiGGfc3eXP/k6FOu6k8Ss4TtOukbs3YdS1GAPTVJyzd
         3/VwfQUnWFtcodublbaSF0Co6jlxXMmVbygGxlwZ7wVg2pHJZ294mohNg20IJeV4PW
         cQqFtmw/p0c9XjViVz3Kd/VNbO3pOr6uu4o9jiv0=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Fix race condition in direct_page_fault" failed to apply to 5.15-stable tree
To:     takiguchi.kazuki171@gmail.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:20:35 +0100
Message-ID: <16698108357942@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

47b0c2e4c220 ("KVM: x86/mmu: Fix race condition in direct_page_fault")
a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by memslot update")
e710c5f6be0e ("KVM: x86/mmu: Pass the memslot around via struct kvm_page_fault")
73a3c659478a ("KVM: MMU: change kvm_mmu_hugepage_adjust() arguments to kvm_page_fault")
3c8ad5a675d9 ("KVM: MMU: change fast_page_fault() arguments to kvm_page_fault")
cdc47767a039 ("KVM: MMU: change tdp_mmu_map_handle_target_level() arguments to kvm_page_fault")
2f6305dd5676 ("KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault")
9c03b1821a89 ("KVM: MMU: change FNAME(fetch)() arguments to kvm_page_fault")
43b74355ef8b ("KVM: MMU: change __direct_map() arguments to kvm_page_fault")
3a13f4fea3c1 ("KVM: MMU: change handle_abnormal_pfn() arguments to kvm_page_fault")
3647cd04b7d0 ("KVM: MMU: change kvm_faultin_pfn() arguments to kvm_page_fault")
b8a5d5511515 ("KVM: MMU: change page_fault_handle_page_track() arguments to kvm_page_fault")
4326e57ef40a ("KVM: MMU: change direct_page_fault() arguments to kvm_page_fault")
c501040abc42 ("KVM: MMU: change mmu->page_fault() arguments to kvm_page_fault")
6defd9bb178c ("KVM: MMU: Introduce struct kvm_page_fault")
d055f028a533 ("KVM: MMU: pass unadulterated gpa to direct_page_fault")
f1c4a88c41ea ("KVM: X86: Don't unsync pagetables when speculative")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 47b0c2e4c220f2251fd8dcfbb44479819c715e15 Mon Sep 17 00:00:00 2001
From: Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>
Date: Wed, 23 Nov 2022 14:36:00 -0500
Subject: [PATCH] KVM: x86/mmu: Fix race condition in direct_page_fault

make_mmu_pages_available() must be called with mmu_lock held for write.
However, if the TDP MMU is used, it will be called with mmu_lock held for
read.
This function does nothing unless shadow pages are used, so there is no
race unless nested TDP is used.
Since nested TDP uses shadow pages, old shadow pages may be zapped by this
function even when the TDP MMU is enabled.
Since shadow pages are never allocated by kvm_tdp_mmu_map(), a race
condition can be avoided by not calling make_mmu_pages_available() if the
TDP MMU is currently in use.

I encountered this when repeatedly starting and stopping nested VM.
It can be artificially caused by allocating a large number of nested TDP
SPTEs.

For example, the following BUG and general protection fault are caused in
the host kernel.

pte_list_remove: 00000000cd54fc10 many->many
------------[ cut here ]------------
kernel BUG at arch/x86/kvm/mmu/mmu.c:963!
invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:pte_list_remove.cold+0x16/0x48 [kvm]
Call Trace:
 <TASK>
 drop_spte+0xe0/0x180 [kvm]
 mmu_page_zap_pte+0x4f/0x140 [kvm]
 __kvm_mmu_prepare_zap_page+0x62/0x3e0 [kvm]
 kvm_mmu_zap_oldest_mmu_pages+0x7d/0xf0 [kvm]
 direct_page_fault+0x3cb/0x9b0 [kvm]
 kvm_tdp_page_fault+0x2c/0xa0 [kvm]
 kvm_mmu_page_fault+0x207/0x930 [kvm]
 npf_interception+0x47/0xb0 [kvm_amd]
 svm_invoke_exit_handler+0x13c/0x1a0 [kvm_amd]
 svm_handle_exit+0xfc/0x2c0 [kvm_amd]
 kvm_arch_vcpu_ioctl_run+0xa79/0x1780 [kvm]
 kvm_vcpu_ioctl+0x29b/0x6f0 [kvm]
 __x64_sys_ioctl+0x95/0xd0
 do_syscall_64+0x5c/0x90

general protection fault, probably for non-canonical address
0xdead000000000122: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:kvm_mmu_commit_zap_page.part.0+0x4b/0xe0 [kvm]
Call Trace:
 <TASK>
 kvm_mmu_zap_oldest_mmu_pages+0xae/0xf0 [kvm]
 direct_page_fault+0x3cb/0x9b0 [kvm]
 kvm_tdp_page_fault+0x2c/0xa0 [kvm]
 kvm_mmu_page_fault+0x207/0x930 [kvm]
 npf_interception+0x47/0xb0 [kvm_amd]

CVE: CVE-2022-45869
Fixes: a2855afc7ee8 ("KVM: x86/mmu: Allow parallel page faults for the TDP MMU")
Signed-off-by: Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ccb769f62af..b6f96d47e596 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2443,6 +2443,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 {
 	bool list_unstable, zapped_root = false;
 
+	lockdep_assert_held_write(&kvm->mmu_lock);
 	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
@@ -4262,14 +4263,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;
 
-	r = make_mmu_pages_available(vcpu);
-	if (r)
-		goto out_unlock;
-
-	if (is_tdp_mmu_fault)
+	if (is_tdp_mmu_fault) {
 		r = kvm_tdp_mmu_map(vcpu, fault);
-	else
+	} else {
+		r = make_mmu_pages_available(vcpu);
+		if (r)
+			goto out_unlock;
 		r = __direct_map(vcpu, fault);
+	}
 
 out_unlock:
 	if (is_tdp_mmu_fault)

