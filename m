Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F387971D
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390571AbfG2Tx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390965AbfG2Tx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:53:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A54E217D9;
        Mon, 29 Jul 2019 19:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430037;
        bh=ioPk3YKw31K4vnQnSnYIMG2vIxDGN5pbFnq7unsj+BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1JcIuT/AmCWYu40H+EJzbCaKtAJqS0oZEUSrbbpemOcQ0lHO/wm+35jgoydfNBxq
         R/vMctuYdyosDNsERLDhWSGnhziq4Z3Q5zm+2Pp3AvP8R6d8M1QbyhrsPXonrsiw9N
         Hoqe9V7Im8T70XiwT77ODunkoV/IXL8kWc5aVUZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.2 176/215] KVM: PPC: Book3S HV: Save and restore guest visible PSSCR bits on pseries
Date:   Mon, 29 Jul 2019 21:22:52 +0200
Message-Id: <20190729190810.503988213@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

commit c8b4083db915dfe5a3b4a755ad2317e0509b43f1 upstream.

The Performance Stop Status and Control Register (PSSCR) is used to
control the power saving facilities of the processor. This register
has various fields, some of which can be modified only in hypervisor
state, and others which can be modified in both hypervisor and
privileged non-hypervisor state. The bits which can be modified in
privileged non-hypervisor state are referred to as guest visible.

Currently the L0 hypervisor saves and restores both it's own host
value as well as the guest value of the PSSCR when context switching
between the hypervisor and guest. However a nested hypervisor running
it's own nested guests (as indicated by kvmhv_on_pseries()) doesn't
context switch the PSSCR register. That means if a nested (L2) guest
modifies the PSSCR then the L1 guest hypervisor will run with that
modified value, and if the L1 guest hypervisor modifies the PSSCR and
then goes to run the nested (L2) guest again then the L2 PSSCR value
will be lost.

Fix this by having the (L1) nested hypervisor save and restore both
its host and the guest PSSCR value when entering and exiting a
nested (L2) guest. Note that only the guest visible parts of the PSSCR
are context switched since this is all the L1 nested hypervisor can
access, this is fine however as these are the only fields the L0
hypervisor provides guest control of anyway and so all other fields
are ignored.

This could also have been implemented by adding the PSSCR register to
the hv_regs passed to the L0 hypervisor as input to the H_ENTER_NESTED
hcall, however this would have meant updating the structure layout and
thus required modifications to both the L0 and L1 kernels. Whereas the
approach used doesn't require L0 kernel modifications while achieving
the same result.

Fixes: 95a6432ce903 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190703012022.15644-3-sjitindarsingh@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3569,9 +3569,18 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu
 	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
 
 	if (kvmhv_on_pseries()) {
+		/*
+		 * We need to save and restore the guest visible part of the
+		 * psscr (i.e. using SPRN_PSSCR_PR) since the hypervisor
+		 * doesn't do this for us. Note only required if pseries since
+		 * this is done in kvmhv_load_hv_regs_and_go() below otherwise.
+		 */
+		unsigned long host_psscr;
 		/* call our hypervisor to load up HV regs and go */
 		struct hv_guest_state hvregs;
 
+		host_psscr = mfspr(SPRN_PSSCR_PR);
+		mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
 		kvmhv_save_hv_regs(vcpu, &hvregs);
 		hvregs.lpcr = lpcr;
 		vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
@@ -3590,6 +3599,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu
 		vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
 		vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
 		vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
+		vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
+		mtspr(SPRN_PSSCR_PR, host_psscr);
 
 		/* H_CEDE has to be handled now, not later */
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&


