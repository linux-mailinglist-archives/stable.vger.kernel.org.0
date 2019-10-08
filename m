Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 999E8CF39E
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbfJHHVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:21:15 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:35005 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730167AbfJHHVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:21:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id ECD2031F;
        Tue,  8 Oct 2019 03:21:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:21:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NZEOtG
        IpkZydIqrt3VjjIuLak+6B9AchMcHTmFrehF0=; b=dsTMIC6xm/a0ACSnwJ9XH9
        zqg86q63fS56Oj0XywNttVFyW15GpiiIqeqr/RNyQsLmGO9ZSMuji7afleHZ1FzF
        Asmb9rq0sddRl2lsIA+uRK6CK9hWqALfukqxnmAiPbXeM4072hht4qUP2oI7Uc9P
        ONWR/1lXWmsQFMuz0idkb+cun2C8rwN58Ycv/2zJh5YZL4c/si907FjzrcgLzUZY
        cjLwe219KZ1sHffv/YBiaeaFT1kfNPudWXtF6DO1exY71dPi53iVp9YcrKUV1bjo
        s0MMq+9hAK5Nra2oWG/InViCho3f3ajC5djmN588kB7tZraKQx5HBq7tkEFKYICg
        ==
X-ME-Sender: <xms:6TicXS-CxIZ_qvi6eZ1egEiDY7zsoH9xoGhscqX7QJT-49sxWL8Ehw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6TicXd7l9IMdEilAMTpVZj8q4-1H8pDi1QvdfhNYhxMLYGDFWinsYw>
    <xmx:6TicXb3Rq97Aa2JNSgNGJ9WxGFyym2TPq9_FpY2Ecw8gSOICZO3Hpg>
    <xmx:6TicXUwhgUxDGvkVqmRlVPpDxF_Mu0uWJccm06yEqnNCeM5Wb0HMNw>
    <xmx:6TicXZ16ehRToyBeWpBz2ZzAzHR3Fs4vPb_lSpR_-tFJ1XEU8yUM0Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 37366D6005A;
        Tue,  8 Oct 2019 03:21:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: PPC: Book3S HV: Check for MMU ready on piggybacked" failed to apply to 4.14-stable tree
To:     paulus@ozlabs.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:21:11 +0200
Message-ID: <1570519271221165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d28eafc5a64045c78136162af9d4ba42f8230080 Mon Sep 17 00:00:00 2001
From: Paul Mackerras <paulus@ozlabs.org>
Date: Tue, 27 Aug 2019 11:31:37 +1000
Subject: [PATCH] KVM: PPC: Book3S HV: Check for MMU ready on piggybacked
 virtual cores

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

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index cde3f5a4b3e4..36d72e9faddf 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2860,7 +2860,7 @@ static void collect_piggybacks(struct core_info *cip, int target_threads)
 		if (!spin_trylock(&pvc->lock))
 			continue;
 		prepare_threads(pvc);
-		if (!pvc->n_runnable) {
+		if (!pvc->n_runnable || !pvc->kvm->arch.mmu_ready) {
 			list_del_init(&pvc->preempt_list);
 			if (pvc->runner == NULL) {
 				pvc->vcore_state = VCORE_INACTIVE;
@@ -2881,15 +2881,20 @@ static void collect_piggybacks(struct core_info *cip, int target_threads)
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
 
@@ -3119,7 +3124,7 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	local_irq_disable();
 	hard_irq_disable();
 	if (lazy_irq_pending() || need_resched() ||
-	    recheck_signals(&core_info) || !vc->kvm->arch.mmu_ready) {
+	    recheck_signals_and_mmu(&core_info)) {
 		local_irq_enable();
 		vc->vcore_state = VCORE_INACTIVE;
 		/* Unlock all except the primary vcore */

