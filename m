Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8B1451304
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244743AbhKOToO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245287AbhKOTT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F6B563523;
        Mon, 15 Nov 2021 18:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001113;
        bh=PrzPOdFYz+ISlQPL8ZcLER8B9widGhVVJcOcpOyfrEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Boi5NBkEqBTTR0dSgzDEfiKRw6byb9mfugr+pdkslCItC/KSGWXH9olNvuuNq1aw
         QSTqCFxbwUBTZvtG7MFv5Wd5eokYjocge+E/viK2GSMzadV0KOfCr/9q2uMcrKzXQo
         xsr7Cd6x+plA+5NOgkAob/zS5p4CxnAfkTgw0QnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 067/917] KVM: PPC: Tick accounting should defer vtime accounting til after IRQ handling
Date:   Mon, 15 Nov 2021 17:52:42 +0100
Message-Id: <20211115165431.041194249@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Vivier <lvivier@redhat.com>

commit 235cee162459d96153d63651ce7ff51752528c96 upstream.

Commit 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest
context before enabling irqs") moved guest_exit() into the interrupt
protected area to avoid wrong context warning (or worse). The problem is
that tick-based time accounting has not yet been updated at this point
(because it depends on the timer interrupt firing), so the guest time
gets incorrectly accounted to system time.

To fix the problem, follow the x86 fix in commit 160457140187 ("Defer
vtime accounting 'til after IRQ handling"), and allow host IRQs to run
before accounting the guest exit time.

In the case vtime accounting is enabled, this is not required because TB
is used directly for accounting.

Before this patch, with CONFIG_TICK_CPU_ACCOUNTING=y in the host and a
guest running a kernel compile, the 'guest' fields of /proc/stat are
stuck at zero. With the patch they can be observed increasing roughly as
expected.

Fixes: e233d54d4d97 ("KVM: booke: use __kvm_guest_exit")
Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs")
Cc: stable@vger.kernel.org # 5.12+
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
[np: only required for tick accounting, add Book3E fix, tweak changelog]
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211027142150.3711582-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv.c |   30 ++++++++++++++++++++++++++++--
 arch/powerpc/kvm/booke.c     |   16 +++++++++++++++-
 2 files changed, 43 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3726,7 +3726,20 @@ static noinline void kvmppc_run_core(str
 
 	kvmppc_set_host_core(pcpu);
 
-	guest_exit_irqoff();
+	context_tracking_guest_exit();
+	if (!vtime_accounting_enabled_this_cpu()) {
+		local_irq_enable();
+		/*
+		 * Service IRQs here before vtime_account_guest_exit() so any
+		 * ticks that occurred while running the guest are accounted to
+		 * the guest. If vtime accounting is enabled, accounting uses
+		 * TB rather than ticks, so it can be done without enabling
+		 * interrupts here, which has the problem that it accounts
+		 * interrupt processing overhead to the host.
+		 */
+		local_irq_disable();
+	}
+	vtime_account_guest_exit();
 
 	local_irq_enable();
 
@@ -4510,7 +4523,20 @@ int kvmhv_run_single_vcpu(struct kvm_vcp
 
 	kvmppc_set_host_core(pcpu);
 
-	guest_exit_irqoff();
+	context_tracking_guest_exit();
+	if (!vtime_accounting_enabled_this_cpu()) {
+		local_irq_enable();
+		/*
+		 * Service IRQs here before vtime_account_guest_exit() so any
+		 * ticks that occurred while running the guest are accounted to
+		 * the guest. If vtime accounting is enabled, accounting uses
+		 * TB rather than ticks, so it can be done without enabling
+		 * interrupts here, which has the problem that it accounts
+		 * interrupt processing overhead to the host.
+		 */
+		local_irq_disable();
+	}
+	vtime_account_guest_exit();
 
 	local_irq_enable();
 
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1042,7 +1042,21 @@ int kvmppc_handle_exit(struct kvm_vcpu *
 	}
 
 	trace_kvm_exit(exit_nr, vcpu);
-	guest_exit_irqoff();
+
+	context_tracking_guest_exit();
+	if (!vtime_accounting_enabled_this_cpu()) {
+		local_irq_enable();
+		/*
+		 * Service IRQs here before vtime_account_guest_exit() so any
+		 * ticks that occurred while running the guest are accounted to
+		 * the guest. If vtime accounting is enabled, accounting uses
+		 * TB rather than ticks, so it can be done without enabling
+		 * interrupts here, which has the problem that it accounts
+		 * interrupt processing overhead to the host.
+		 */
+		local_irq_disable();
+	}
+	vtime_account_guest_exit();
 
 	local_irq_enable();
 


