Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822EA58DE8B
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345827AbiHISTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346728AbiHISRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:17:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7955727FE2;
        Tue,  9 Aug 2022 11:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ED7661001;
        Tue,  9 Aug 2022 18:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C584C43470;
        Tue,  9 Aug 2022 18:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068409;
        bh=lhDlPIwIg8u55QCmC20qTz4SHPQXU5/TWaQnXw4U9yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08eoEfF3BjtrNX6wskkugQjCB75MinXeXe0DgdWOu+zh97LNKAxd7ptcx+tCjSDhE
         Z/1u3KY9TKG1FJ5YG16hROgf7T1AkwH0s2/ziOJ1XW2qSmp6eMqTSPdX2lNFBIDrp1
         DTgEHE/Q7wRF1PjaqzhyOdqFKIaX8FJI372ItqKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 09/35] KVM: x86: do not set st->preempted when going back to user space
Date:   Tue,  9 Aug 2022 20:00:38 +0200
Message-Id: <20220809175515.412581840@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 54aa83c90198e68eee8b0850c749bc70efb548da ]

Similar to the Xen path, only change the vCPU's reported state if the vCPU
was actually preempted.  The reason for KVM's behavior is that for example
optimistic spinning might not be a good idea if the guest is doing repeated
exits to userspace; however, it is confusing and unlikely to make a difference,
because well-tuned guests will hardly ever exit KVM_RUN in the first place.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 26 ++++++++++++++------------
 arch/x86/kvm/xen.h |  6 ++++--
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df74ec51c7f3..91d887fd10ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4651,19 +4651,21 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
-	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
-		vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
+	if (vcpu->preempted) {
+		if (!vcpu->arch.guest_state_protected)
+			vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
 
-	/*
-	 * Take the srcu lock as memslots will be accessed to check the gfn
-	 * cache generation against the memslots generation.
-	 */
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (kvm_xen_msr_enabled(vcpu->kvm))
-		kvm_xen_runstate_set_preempted(vcpu);
-	else
-		kvm_steal_time_set_preempted(vcpu);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		/*
+		 * Take the srcu lock as memslots will be accessed to check the gfn
+		 * cache generation against the memslots generation.
+		 */
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		if (kvm_xen_msr_enabled(vcpu->kvm))
+			kvm_xen_runstate_set_preempted(vcpu);
+		else
+			kvm_steal_time_set_preempted(vcpu);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	}
 
 	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index adbcc9ed59db..fda1413f8af9 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -103,8 +103,10 @@ static inline void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu)
 	 * behalf of the vCPU. Only if the VMM does actually block
 	 * does it need to enter RUNSTATE_blocked.
 	 */
-	if (vcpu->preempted)
-		kvm_xen_update_runstate_guest(vcpu, RUNSTATE_runnable);
+	if (WARN_ON_ONCE(!vcpu->preempted))
+		return;
+
+	kvm_xen_update_runstate_guest(vcpu, RUNSTATE_runnable);
 }
 
 /* 32-bit compatibility definitions, also used natively in 32-bit build */
-- 
2.35.1



