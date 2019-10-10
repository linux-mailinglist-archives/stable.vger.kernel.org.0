Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F72BD23CC
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388522AbfJJIp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388533AbfJJIp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:45:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8D022064A;
        Thu, 10 Oct 2019 08:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697157;
        bh=YjZS4138O8AQQGbJuVTLVInle2sdwhFjSQ4SBwSHri8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auXHbZVQ2DeyGI7aSmlzpwd2gti5TFMZBpMkKqzydR2VxydkOZ4TXAaGY2vJJhoov
         0+g5sNB6b48ZUYj836SV/ePC/KfINlE+cYAtGdddKVnq5k9WMfAXUHbxsOa7X23HMv
         iGQYE9Aoo/DDwmRiFIgu0o5498TGxrRxZ3OYv+8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH 4.19 006/114] KVM: PPC: Book3S HV: Check for MMU ready on piggybacked virtual cores
Date:   Thu, 10 Oct 2019 10:35:13 +0200
Message-Id: <20191010083547.134529109@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Mackerras <paulus@ozlabs.org>

commit d28eafc5a64045c78136162af9d4ba42f8230080 upstream.

When we are running multiple vcores on the same physical core, they
could be from different VMs and so it is possible that one of the
VMs could have its arch.mmu_ready flag cleared (for example by a
concurrent HPT resize) when we go to run it on a physical core.
We currently check the arch.mmu_ready flag for the primary vcore
but not the flags for the other vcores that will be run alongside
it.  This adds that check, and also a check when we select the
secondary vcores from the preempted vcores list.

Cc: stable@vger.kernel.org # v4.14+
Fixes: 38c53af85306 ("KVM: PPC: Book3S HV: Fix exclusion between HPT resizing and other HPT updates")
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2550,7 +2550,7 @@ static void collect_piggybacks(struct co
 		if (!spin_trylock(&pvc->lock))
 			continue;
 		prepare_threads(pvc);
-		if (!pvc->n_runnable) {
+		if (!pvc->n_runnable || !pvc->kvm->arch.mmu_ready) {
 			list_del_init(&pvc->preempt_list);
 			if (pvc->runner == NULL) {
 				pvc->vcore_state = VCORE_INACTIVE;
@@ -2571,15 +2571,20 @@ static void collect_piggybacks(struct co
 	spin_unlock(&lp->lock);
 }
 
-static bool recheck_signals(struct core_info *cip)
+static bool recheck_signals_and_mmu(struct core_info *cip)
 {
 	int sub, i;
 	struct kvm_vcpu *vcpu;
+	struct kvmppc_vcore *vc;
 
-	for (sub = 0; sub < cip->n_subcores; ++sub)
-		for_each_runnable_thread(i, vcpu, cip->vc[sub])
+	for (sub = 0; sub < cip->n_subcores; ++sub) {
+		vc = cip->vc[sub];
+		if (!vc->kvm->arch.mmu_ready)
+			return true;
+		for_each_runnable_thread(i, vcpu, vc)
 			if (signal_pending(vcpu->arch.run_task))
 				return true;
+	}
 	return false;
 }
 
@@ -2800,7 +2805,7 @@ static noinline void kvmppc_run_core(str
 	local_irq_disable();
 	hard_irq_disable();
 	if (lazy_irq_pending() || need_resched() ||
-	    recheck_signals(&core_info) || !vc->kvm->arch.mmu_ready) {
+	    recheck_signals_and_mmu(&core_info)) {
 		local_irq_enable();
 		vc->vcore_state = VCORE_INACTIVE;
 		/* Unlock all except the primary vcore */


