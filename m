Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EED73E8C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389831AbfGXTjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389063AbfGXTi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:38:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01170217D4;
        Wed, 24 Jul 2019 19:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997139;
        bh=7aBdbD0pAZ7cT7Z1XWB4rwLOq1yj8nUthLML5JV9tDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QR3Fr5E5MiA/fy0FLI+SuGS9S7ruhBsMmHbLYWGhROtSK41M0cxbjQ/xLzRBoxGEk
         TLC1tnHjdDheggylgiK9Ym2K6l0rm+QQ2RezmQOankdLSNxuQyBSrYeDURlhfjL8j4
         +9vx1NrumRofinFqDKb4bsNQ+BHxKJ6BafaQwU08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.2 333/413] KVM: PPC: Book3S HV: Clear pending decrementer exceptions on nested guest entry
Date:   Wed, 24 Jul 2019 21:20:24 +0200
Message-Id: <20190724191759.646814518@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

commit 3c25ab35fbc8526ac0c9b298e8a78e7ad7a55479 upstream.

If we enter an L1 guest with a pending decrementer exception then this
is cleared on guest exit if the guest has writtien a positive value
into the decrementer (indicating that it handled the decrementer
exception) since there is no other way to detect that the guest has
handled the pending exception and that it should be dequeued. In the
event that the L1 guest tries to run a nested (L2) guest immediately
after this and the L2 guest decrementer is negative (which is loaded
by L1 before making the H_ENTER_NESTED hcall), then the pending
decrementer exception isn't cleared and the L2 entry is blocked since
L1 has a pending exception, even though L1 may have already handled
the exception and written a positive value for it's decrementer. This
results in a loop of L1 trying to enter the L2 guest and L0 blocking
the entry since L1 has an interrupt pending with the outcome being
that L2 never gets to run and hangs.

Fix this by clearing any pending decrementer exceptions when L1 makes
the H_ENTER_NESTED hcall since it won't do this if it's decrementer
has gone negative, and anyway it's decrementer has been communicated
to L0 in the hdec_expires field and L0 will return control to L1 when
this goes negative by delivering an H_DECREMENTER exception.

Fixes: 95a6432ce903 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4124,8 +4124,15 @@ int kvmhv_run_single_vcpu(struct kvm_run
 
 	preempt_enable();
 
-	/* cancel pending decrementer exception if DEC is now positive */
-	if (get_tb() < vcpu->arch.dec_expires && kvmppc_core_pending_dec(vcpu))
+	/*
+	 * cancel pending decrementer exception if DEC is now positive, or if
+	 * entering a nested guest in which case the decrementer is now owned
+	 * by L2 and the L1 decrementer is provided in hdec_expires
+	 */
+	if (kvmppc_core_pending_dec(vcpu) &&
+			((get_tb() < vcpu->arch.dec_expires) ||
+			 (trap == BOOK3S_INTERRUPT_SYSCALL &&
+			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
 		kvmppc_core_dequeue_dec(vcpu);
 
 	trace_kvm_guest_exit(vcpu);


