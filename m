Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFBFD24E0
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390094AbfJJIv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390103AbfJJIv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:51:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 308E52190F;
        Thu, 10 Oct 2019 08:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697487;
        bh=Y23TjM0hjddnmgQIVXC+pSQ1rOsnJxop3LEWD+le870=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAIlGujK9TzKLuEw25xGc4QGJYTXXTe7zTwG4aGr2fKJs1XYmSVOrN5yBlcCs6KBg
         6H746Z6LU5u2wmf/4I9bwULD7dtVWZM+BKpfzaTLA8JO/e1VLrXjar6QcdKTGza0fg
         UAJ77LpNI8d0fc2D29SViiqwbue+qd5z6okxQqF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 45/61] KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before disabling the VP
Date:   Thu, 10 Oct 2019 10:37:10 +0200
Message-Id: <20191010083517.850678947@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

[ Upstream commit 237aed48c642328ff0ab19b63423634340224a06 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_xive.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 3c75eee45edf9..46f99fc1901c8 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1001,20 +1001,22 @@ void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
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
-- 
2.20.1



