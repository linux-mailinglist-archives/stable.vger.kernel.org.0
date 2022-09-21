Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F6B5C033B
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiIUQA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiIUP6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:58:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15F6A1D06;
        Wed, 21 Sep 2022 08:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B1B66314F;
        Wed, 21 Sep 2022 15:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A50BC433C1;
        Wed, 21 Sep 2022 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775476;
        bh=RWKCvOLRLjCO5BEUwePjalDi/C7pkfXgg4HX66/i7G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNMYFHY+jqzYlwztD+thNltd+pbdrOLiiImcxxt8JQeD754tXzb8nnwhHZgb6z3ij
         qDeqqAXyuuz/C+YqXcpYIO9gZ0nhQCcuf6ISz5Q4SuJWig0wYgu72y5cDeSwLJRYmC
         jKs8FaG8pzUgeka1fDEy+fVQXoty/sj8sRwKsCD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/39] KVM: PPC: Tick accounting should defer vtime accounting til after IRQ handling
Date:   Wed, 21 Sep 2022 17:46:07 +0200
Message-Id: <20220921153645.774343053@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit 235cee162459d96153d63651ce7ff51752528c96 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 30 ++++++++++++++++++++++++++++--
 arch/powerpc/kvm/booke.c     | 16 +++++++++++++++-
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d6c4e27f7ed9..1d2593238995 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3399,7 +3399,20 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 
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
 
@@ -4236,7 +4249,20 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
 
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index b1abcb816439..75381beb7514 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1016,7 +1016,21 @@ int kvmppc_handle_exit(struct kvm_vcpu *vcpu, unsigned int exit_nr)
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
 
-- 
2.35.1



