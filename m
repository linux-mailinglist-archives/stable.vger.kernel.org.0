Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1BD54A6EC
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355917AbiFNCcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357115AbiFNCbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:31:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986BF457A1;
        Mon, 13 Jun 2022 19:12:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18F70B81698;
        Tue, 14 Jun 2022 02:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C89BC3411E;
        Tue, 14 Jun 2022 02:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172710;
        bh=vdxcTw6H2fUlXn2a0YkRzG2Z3F/7Uql4vw13phIhCVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aleUPwvqiEKQAppXIfwmOW4Fdu0As41kU++ZlCbWa2UD3NsRaCByMiykDKpwpGL9L
         Cnf2brWhNSayMW1XMKPQfKLhPGYkh5pyFpn4gsTtzKPRPcTgZNovaZPJHtJv186hsY
         nlWAyuGReSBbj/Ej3p2Nh7SJAe3n3jt8tAB7pGPA2LFs1kiJovK769KcSB+6Ctos2S
         beTiNLMPID0mkdID/1yDaYp8l9kg8GFRuDkZi5L9yr+uG0yp8iMnrCHHUxC0DDh3de
         GylP/jBzfLzjOt1C5HtpdoIsvhMHYbblqpV98rdgG3HqL11BX9FIGe7Xtw69kmu2Io
         mikP0lNY9G7Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 2/4] KVM: x86: do not set st->preempted when going back to user space
Date:   Mon, 13 Jun 2022 22:11:38 -0400
Message-Id: <20220614021141.1101486-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614021141.1101486-1-sashal@kernel.org>
References: <20220614021141.1101486-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index fbf10fa99507..16c1c5403b52 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4412,19 +4412,21 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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
index cc0cf5f37450..a7693a286e40 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -97,8 +97,10 @@ static inline void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu)
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

