Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE07CD25C8
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbfJJIiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733242AbfJJIh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:37:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2536A2196E;
        Thu, 10 Oct 2019 08:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696677;
        bh=raS58zjEO0d4OUgosOAfUEsip1VV7XjzrU5IMfwIKJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcaN9G/wn+4qTSn9QB8wfdVCuAKY18HPFNMtE59UAl5TRTRXgn99OOKUCjeDoA+uV
         ybo+RpMHSIQAyjm+OlwGUR07aQA8NIyJApXyoqXS53gcN06Xjy18CpgPqYIJUquXB/
         0t7y6N0eqxP0tfGRkCTadIARbbGGB38T9D1V4O4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 013/148] KVM: PPC: Book3S HV: Fix race in re-enabling XIVE escalation interrupts
Date:   Thu, 10 Oct 2019 10:34:34 +0200
Message-Id: <20191010083611.908464353@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Mackerras <paulus@ozlabs.org>

commit 959c5d5134786b4988b6fdd08e444aa67d1667ed upstream.

Escalation interrupts are interrupts sent to the host by the XIVE
hardware when it has an interrupt to deliver to a guest VCPU but that
VCPU is not running anywhere in the system.  Hence we disable the
escalation interrupt for the VCPU being run when we enter the guest
and re-enable it when the guest does an H_CEDE hypercall indicating
it is idle.

It is possible that an escalation interrupt gets generated just as we
are entering the guest.  In that case the escalation interrupt may be
using a queue entry in one of the interrupt queues, and that queue
entry may not have been processed when the guest exits with an H_CEDE.
The existing entry code detects this situation and does not clear the
vcpu->arch.xive_esc_on flag as an indication that there is a pending
queue entry (if the queue entry gets processed, xive_esc_irq() will
clear the flag).  There is a comment in the code saying that if the
flag is still set on H_CEDE, we have to abort the cede rather than
re-enabling the escalation interrupt, lest we end up with two
occurrences of the escalation interrupt in the interrupt queue.

However, the exit code doesn't do that; it aborts the cede in the sense
that vcpu->arch.ceded gets cleared, but it still enables the escalation
interrupt by setting the source's PQ bits to 00.  Instead we need to
set the PQ bits to 10, indicating that an interrupt has been triggered.
We also need to avoid setting vcpu->arch.xive_esc_on in this case
(i.e. vcpu->arch.xive_esc_on seen to be set on H_CEDE) because
xive_esc_irq() will run at some point and clear it, and if we race with
that we may end up with an incorrect result (i.e. xive_esc_on set when
the escalation interrupt has just been handled).

It is extremely unlikely that having two queue entries would cause
observable problems; theoretically it could cause queue overflow, but
the CPU would have to have thousands of interrupts targetted to it for
that to be possible.  However, this fix will also make it possible to
determine accurately whether there is an unhandled escalation
interrupt in the queue, which will be needed by the following patch.

Fixes: 9b9b13a6d153 ("KVM: PPC: Book3S HV: Keep XIVE escalation interrupt masked unless ceded")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190813100349.GD9567@blackberry
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |   36 ++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2833,29 +2833,39 @@ kvm_cede_prodded:
 kvm_cede_exit:
 	ld	r9, HSTATE_KVM_VCPU(r13)
 #ifdef CONFIG_KVM_XICS
-	/* Abort if we still have a pending escalation */
+	/* are we using XIVE with single escalation? */
+	ld	r10, VCPU_XIVE_ESC_VADDR(r9)
+	cmpdi	r10, 0
+	beq	3f
+	li	r6, XIVE_ESB_SET_PQ_00
+	/*
+	 * If we still have a pending escalation, abort the cede,
+	 * and we must set PQ to 10 rather than 00 so that we don't
+	 * potentially end up with two entries for the escalation
+	 * interrupt in the XIVE interrupt queue.  In that case
+	 * we also don't want to set xive_esc_on to 1 here in
+	 * case we race with xive_esc_irq().
+	 */
 	lbz	r5, VCPU_XIVE_ESC_ON(r9)
 	cmpwi	r5, 0
-	beq	1f
+	beq	4f
 	li	r0, 0
 	stb	r0, VCPU_CEDED(r9)
-1:	/* Enable XIVE escalation */
-	li	r5, XIVE_ESB_SET_PQ_00
+	li	r6, XIVE_ESB_SET_PQ_10
+	b	5f
+4:	li	r0, 1
+	stb	r0, VCPU_XIVE_ESC_ON(r9)
+	/* make sure store to xive_esc_on is seen before xive_esc_irq runs */
+	sync
+5:	/* Enable XIVE escalation */
 	mfmsr	r0
 	andi.	r0, r0, MSR_DR		/* in real mode? */
 	beq	1f
-	ld	r10, VCPU_XIVE_ESC_VADDR(r9)
-	cmpdi	r10, 0
-	beq	3f
-	ldx	r0, r10, r5
+	ldx	r0, r10, r6
 	b	2f
 1:	ld	r10, VCPU_XIVE_ESC_RADDR(r9)
-	cmpdi	r10, 0
-	beq	3f
-	ldcix	r0, r10, r5
+	ldcix	r0, r10, r6
 2:	sync
-	li	r0, 1
-	stb	r0, VCPU_XIVE_ESC_ON(r9)
 #endif /* CONFIG_KVM_XICS */
 3:	b	guest_exit_cont
 


