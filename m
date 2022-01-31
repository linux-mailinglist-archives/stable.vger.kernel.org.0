Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA254A4248
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358592AbiAaLLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56764 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376451AbiAaLIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:08:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E30CBB82A5F;
        Mon, 31 Jan 2022 11:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330A0C340EF;
        Mon, 31 Jan 2022 11:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627307;
        bh=I2vpxdTzHoTigqEtBiKo4GOPjxCVeueE+HHjONE84zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOPErTdyC7Z0NWgzIZoLW3HyUEulx0jw/B2gGyeUtyfO6hghA/gE9U7+OVK87lzM1
         Wf60tabem6UwFSkSLZLNero3cywI64pcT+zsi4ldt8PWnWsb7hP/zD1aksKNJhDdUo
         Q9ktWwt4CtkVx0uzUGhsyu6F91hyfzmPm4wi4nSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 042/171] KVM: PPC: Book3S HV Nested: Fix nested HFSCR being clobbered with multiple vCPUs
Date:   Mon, 31 Jan 2022 11:55:07 +0100
Message-Id: <20220131105231.447529036@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

commit 22f7ff0dea9491e90b6fe808ed40c30bd791e5c2 upstream.

The L0 is storing HFSCR requested by the L1 for the L2 in struct
kvm_nested_guest when the L1 requests a vCPU enter L2. kvm_nested_guest
is not a per-vCPU structure. Hilarity ensues.

Fix it by moving the nested hfscr into the vCPU structure together with
the other per-vCPU nested fields.

Fixes: 8b210a880b35 ("KVM: PPC: Book3S HV Nested: Make nested HFSCR state accessible")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220122105530.3477250-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/kvm_book3s_64.h |    1 -
 arch/powerpc/include/asm/kvm_host.h      |    1 +
 arch/powerpc/kvm/book3s_hv.c             |    3 +--
 arch/powerpc/kvm/book3s_hv_nested.c      |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -39,7 +39,6 @@ struct kvm_nested_guest {
 	pgd_t *shadow_pgtable;		/* our page table for this guest */
 	u64 l1_gr_to_hr;		/* L1's addr of part'n-scoped table */
 	u64 process_table;		/* process table entry for this guest */
-	u64 hfscr;			/* HFSCR that the L1 requested for this nested guest */
 	long refcnt;			/* number of pointers to this struct */
 	struct mutex tlb_lock;		/* serialize page faults and tlbies */
 	struct kvm_nested_guest *next;
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -814,6 +814,7 @@ struct kvm_vcpu_arch {
 
 	/* For support of nested guests */
 	struct kvm_nested_guest *nested;
+	u64 nested_hfscr;	/* HFSCR that the L1 requested for the nested guest */
 	u32 nested_vcpu_id;
 	gpa_t nested_io_gpr;
 #endif
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1731,7 +1731,6 @@ static int kvmppc_handle_exit_hv(struct
 
 static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 {
-	struct kvm_nested_guest *nested = vcpu->arch.nested;
 	int r;
 	int srcu_idx;
 
@@ -1831,7 +1830,7 @@ static int kvmppc_handle_nested_exit(str
 		 * it into a HEAI.
 		 */
 		if (!(vcpu->arch.hfscr_permitted & (1UL << cause)) ||
-					(nested->hfscr & (1UL << cause))) {
+				(vcpu->arch.nested_hfscr & (1UL << cause))) {
 			vcpu->arch.trap = BOOK3S_INTERRUPT_H_EMUL_ASSIST;
 
 			/*
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -362,7 +362,7 @@ long kvmhv_enter_nested_guest(struct kvm
 	/* set L1 state to L2 state */
 	vcpu->arch.nested = l2;
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
-	l2->hfscr = l2_hv.hfscr;
+	vcpu->arch.nested_hfscr = l2_hv.hfscr;
 	vcpu->arch.regs = l2_regs;
 
 	/* Guest must always run with ME enabled, HV disabled. */


