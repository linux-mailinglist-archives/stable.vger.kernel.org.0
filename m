Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D88D25C5
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733300AbfJJIhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733242AbfJJIhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:37:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1CF220B7C;
        Thu, 10 Oct 2019 08:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696672;
        bh=fT56qIs8PSkC21iYNoO3OOpHT7+AczEdjACor5C7SJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVoxdXcaqtVTBBGqF4MXFilVXLwm9dQmlnG4eWc7gbg9oU7Scw0niKe+2EqiLQSxV
         R9JuyKl/EiQP0a3eb+8MftDYy5/ZoJGRQ1t0zJCuBQob2Mi6mpSzJkLrmAr/vdrZC9
         TNRqM3Vc6jCveJDzsQYZikQ4+JTp8cYeb3A88cEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 011/148] KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before disabling the VP
Date:   Thu, 10 Oct 2019 10:34:32 +0200
Message-Id: <20191010083611.769257929@linuxfoundation.org>
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

From: Cédric Le Goater <clg@kaod.org>

commit 237aed48c642328ff0ab19b63423634340224a06 upstream.

When a vCPU is brought done, the XIVE VP (Virtual Processor) is first
disabled and then the event notification queues are freed. When freeing
the queues, we check for possible escalation interrupts and free them
also.

But when a XIVE VP is disabled, the underlying XIVE ENDs also are
disabled in OPAL. When an END (Event Notification Descriptor) is
disabled, its ESB pages (ESn and ESe) are disabled and loads return all
1s. Which means that any access on the ESB page of the escalation
interrupt will return invalid values.

When an interrupt is freed, the shutdown handler computes a 'saved_p'
field from the value returned by a load in xive_do_source_set_mask().
This value is incorrect for escalation interrupts for the reason
described above.

This has no impact on Linux/KVM today because we don't make use of it
but we will introduce in future changes a xive_get_irqchip_state()
handler. This handler will use the 'saved_p' field to return the state
of an interrupt and 'saved_p' being incorrect, softlockup will occur.

Fix the vCPU cleanup sequence by first freeing the escalation interrupts
if any, then disable the XIVE VP and last free the queues.

Fixes: 90c73795afa2 ("KVM: PPC: Book3S HV: Add a new KVM device for the XIVE native exploitation mode")
Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")
Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190806172538.5087-1-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_xive.c        |   18 ++++++++++--------
 arch/powerpc/kvm/book3s_xive_native.c |   12 +++++++-----
 2 files changed, 17 insertions(+), 13 deletions(-)

--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1134,20 +1134,22 @@ void kvmppc_xive_cleanup_vcpu(struct kvm
 	/* Mask the VP IPI */
 	xive_vm_esb_load(&xc->vp_ipi_data, XIVE_ESB_SET_PQ_01);
 
-	/* Disable the VP */
-	xive_native_disable_vp(xc->vp_id);
-
-	/* Free the queues & associated interrupts */
+	/* Free escalations */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
-		struct xive_q *q = &xc->queues[i];
-
-		/* Free the escalation irq */
 		if (xc->esc_virq[i]) {
 			free_irq(xc->esc_virq[i], vcpu);
 			irq_dispose_mapping(xc->esc_virq[i]);
 			kfree(xc->esc_virq_names[i]);
 		}
-		/* Free the queue */
+	}
+
+	/* Disable the VP */
+	xive_native_disable_vp(xc->vp_id);
+
+	/* Free the queues */
+	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
+		struct xive_q *q = &xc->queues[i];
+
 		xive_native_disable_queue(xc->vp_id, q, i);
 		if (q->qpage) {
 			free_pages((unsigned long)q->qpage,
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -67,10 +67,7 @@ void kvmppc_xive_native_cleanup_vcpu(str
 	xc->valid = false;
 	kvmppc_xive_disable_vcpu_interrupts(vcpu);
 
-	/* Disable the VP */
-	xive_native_disable_vp(xc->vp_id);
-
-	/* Free the queues & associated interrupts */
+	/* Free escalations */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		/* Free the escalation irq */
 		if (xc->esc_virq[i]) {
@@ -79,8 +76,13 @@ void kvmppc_xive_native_cleanup_vcpu(str
 			kfree(xc->esc_virq_names[i]);
 			xc->esc_virq[i] = 0;
 		}
+	}
 
-		/* Free the queue */
+	/* Disable the VP */
+	xive_native_disable_vp(xc->vp_id);
+
+	/* Free the queues */
+	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		kvmppc_xive_native_cleanup_queue(vcpu, i);
 	}
 


