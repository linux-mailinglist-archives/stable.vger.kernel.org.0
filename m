Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38FC425570
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 16:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242085AbhJGObD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 10:31:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242073AbhJGObB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 10:31:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633616947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UF3re4UnbtUqtYZZTivLh2H8ZzAeAte+9PT67KP/GWA=;
        b=G0qKmuiixrhEhiUWbeFJDqt0Rln4FNjkbgbZG5imqF+xwO2OGaO2wCCzn0fg3GRowUeRam
        PwQOQAW7uIA6IvUB9gv80Pq44ZzUVqmEjGPGJ8Re1PAtXqBwh37swGYKciQ6oZ8DIUflIN
        yU1XfZmHxcvUeVMFL5uRrGWqOhOKCZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-ufrnTYxeO4KxQJKz_zDHRg-1; Thu, 07 Oct 2021 10:29:04 -0400
X-MC-Unique: ufrnTYxeO4KxQJKz_zDHRg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DB281007301;
        Thu,  7 Oct 2021 14:29:01 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.39.192.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B300626572;
        Thu,  7 Oct 2021 14:28:57 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>, Greg Kurz <groug@kaod.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] KVM: PPC: Defer vtime accounting 'til after IRQ handling
Date:   Thu,  7 Oct 2021 16:28:56 +0200
Message-Id: <20211007142856.41205-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 112665286d08 moved guest_exit() in the interrupt protected
area to avoid wrong context warning (or worse), but the tick counter
cannot be updated and the guest time is accounted to the system time.

To fix the problem port to POWER the x86 fix
160457140187 ("Defer vtime accounting 'til after IRQ handling"):

"Defer the call to account guest time until after servicing any IRQ(s)
 that happened in the guest or immediately after VM-Exit.  Tick-based
 accounting of vCPU time relies on PF_VCPU being set when the tick IRQ
 handler runs, and IRQs are blocked throughout the main sequence of
 vcpu_enter_guest(), including the call into vendor code to actually
 enter and exit the guest."

Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs")
Cc: npiggin@gmail.com
Cc: <stable@vger.kernel.org> # 5.12
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---

Notes:
    v2: remove reference to commit 61bd0f66ff92
        cc stable 5.12
        add the same comment in the code as for x86

 arch/powerpc/kvm/book3s_hv.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2acb1c96cfaf..a694d1a8f6ce 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3695,6 +3695,8 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 
 	srcu_read_unlock(&vc->kvm->srcu, srcu_idx);
 
+	context_tracking_guest_exit();
+
 	set_irq_happened(trap);
 
 	spin_lock(&vc->lock);
@@ -3726,9 +3728,15 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 
 	kvmppc_set_host_core(pcpu);
 
-	guest_exit_irqoff();
-
 	local_irq_enable();
+	/*
+	 * Wait until after servicing IRQs to account guest time so that any
+	 * ticks that occurred while running the guest are properly accounted
+	 * to the guest.  Waiting until IRQs are enabled degrades the accuracy
+	 * of accounting via context tracking, but the loss of accuracy is
+	 * acceptable for all known use cases.
+	 */
+	vtime_account_guest_exit();
 
 	/* Let secondaries go back to the offline loop */
 	for (i = 0; i < controlled_threads; ++i) {
@@ -4506,13 +4514,21 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 
+	context_tracking_guest_exit();
+
 	set_irq_happened(trap);
 
 	kvmppc_set_host_core(pcpu);
 
-	guest_exit_irqoff();
-
 	local_irq_enable();
+	/*
+	 * Wait until after servicing IRQs to account guest time so that any
+	 * ticks that occurred while running the guest are properly accounted
+	 * to the guest.  Waiting until IRQs are enabled degrades the accuracy
+	 * of accounting via context tracking, but the loss of accuracy is
+	 * acceptable for all known use cases.
+	 */
+	vtime_account_guest_exit();
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
 
-- 
2.31.1

