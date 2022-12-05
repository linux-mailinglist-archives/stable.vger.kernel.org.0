Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83516433D7
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiLETkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiLETjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:39:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB81E2610A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:36:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 337C261321
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48309C433C1;
        Mon,  5 Dec 2022 19:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269012;
        bh=HVkUZ2rzMh5VWpmjVtcJU2bR6kgvZg2agUNk+Nzz+HE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzAptOXy4nJ6wO0gAlhvA8Q3DL+ccA3dIzeFaIyVohKcK/NI2BWaiU5asFlOZD+WB
         WsskOCXPJNKxzerSBaKmtCMldgAG84/kiSjKK9X67vIYPx0NqB2BSpaPEALL1N8/uU
         V3PrrRfQMgRiGuOVk6nvjkpGddnf1Wy2X6YLa9Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 093/120] KVM: x86/mmu: Fix race condition in direct_page_fault
Date:   Mon,  5 Dec 2022 20:10:33 +0100
Message-Id: <20221205190809.364947544@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>

commit 47b0c2e4c220f2251fd8dcfbb44479819c715e15 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2357,6 +2357,7 @@ static bool __kvm_mmu_prepare_zap_page(s
 {
 	bool list_unstable;
 
+	lockdep_assert_held_write(&kvm->mmu_lock);
 	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
@@ -4007,16 +4008,17 @@ static int direct_page_fault(struct kvm_
 
 	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
 		goto out_unlock;
-	r = make_mmu_pages_available(vcpu);
-	if (r)
-		goto out_unlock;
 
-	if (is_tdp_mmu_fault)
+	if (is_tdp_mmu_fault) {
 		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
 				    pfn, prefault);
-	else
+	} else {
+		r = make_mmu_pages_available(vcpu);
+		if (r)
+			goto out_unlock;
 		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
 				 prefault, is_tdp);
+	}
 
 out_unlock:
 	if (is_tdp_mmu_fault)


