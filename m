Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54C86CECA2
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 17:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjC2PR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 11:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjC2PRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 11:17:55 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E41D3C26
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 08:17:53 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id h11so13708123lfu.8
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 08:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680103071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UNmFvgrAdCajFRIpt45plktjvRtUsWCMCvtd+JVhsYc=;
        b=Ewq8u5E9Bmp8HxucWtSxN/ywJhD+EFahfVH8pTqWAIOnHaI059A3GMgXy2M0ZHoFej
         SafOfq56AiijatCuZZNbUqP7gXo4SDp2rXw9YYJi8+YMjjCsxBFkQIz+bySOit6jhHM+
         pEWEvcldXQTxCaG9epFXxphbJDOzqd7IFm1r6PWLU2SvEvv8R5uwe5KXYEnhtljK/EA+
         tcIy4I3lX4Ig+8DGlHGkC0B/9xRcJ6dGItsugo45spqwQtEmdN5TJOqHYi1sHGxGzSrn
         t9KgsEC2XZIZMGeBfITXk9VFg5sYhjxZCK8vN+/oAiiBNr6xbVS1FPj77rx0oWgiRjoz
         eJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680103071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UNmFvgrAdCajFRIpt45plktjvRtUsWCMCvtd+JVhsYc=;
        b=uEQhQ9jG6qtZkHayciPtgatNpG15g1vAhkrBt/J0i2d7wB7B/aAel3B782rt9yBVYW
         +n79NRZ29lpygPVrOSITb6O2RA7ZfdQRrLpHmNQlQUTbzscRbhId7TCrlmxRjFQFtauq
         rcHJirp8q5U6/0tiomDipimRvpjOPCcggnEnYN5SQXJheOB4DtdJv/nNGo1UJaOXm3ya
         chbA1K0ADs/BHzNcg12FceJNBPhNuuqtduKMAcNl7cNbcTJO8U/rAlEPzdf3IIIYCLiV
         VWZoQQaLDPywJpH9/94LZbDGHiwCkrgZ5fEO5lWg2VhBZGImDBbuFyoksgc3EdZ7TQ8U
         3feQ==
X-Gm-Message-State: AAQBX9cUU3rd5wMs0u3aLFre9Trm4Hx06cRWewIC/h7U3LE6+cD9/H2F
        uItuwHF+miUXWdFhmse1zF2S9eU5lczy6BSZUZw=
X-Google-Smtp-Source: AKy350ZtOTePUtjglUWcg65EpZDmsq6Fr/54/nVmblKVhOODBPZShIBg5AnJS2B0kL5vQlQzvOPKSQ==
X-Received: by 2002:ac2:4834:0:b0:4dd:985a:1dd3 with SMTP id 20-20020ac24834000000b004dd985a1dd3mr5072648lft.15.1680103071521;
        Wed, 29 Mar 2023 08:17:51 -0700 (PDT)
Received: from ta1.c.googlers.com.com (61.215.228.35.bc.googleusercontent.com. [35.228.215.61])
        by smtp.gmail.com with ESMTPSA id m18-20020a195212000000b004e95f53adc7sm5510692lfb.27.2023.03.29.08.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 08:17:51 -0700 (PDT)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     pbonzini@redhat.com, stable@vger.kernel.org, seanjc@google.com,
        joro@8bytes.org
Cc:     vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        suravee.suthikulpanit@amd.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mlevitsk@redhat.com, joneslee@google.com,
        syzbot+b6a74be92b5063a0f1ff@syzkaller.appspotmail.com,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH][for stable/linux-5.15.y] KVM: VMX: Move preemption timer <=> hrtimer dance to common x86
Date:   Wed, 29 Mar 2023 15:17:47 +0000
Message-Id: <20230329151747.2938509-1-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 98c25ead5eda5e9d41abe57839ad3e8caf19500c upstream.

Handle the switch to/from the hypervisor/software timer when a vCPU is
blocking in common x86 instead of in VMX.  Even though VMX is the only
user of a hypervisor timer, the logic and all functions involved are
generic x86 (unless future CPUs do something completely different and
implement a hypervisor timer that runs regardless of mode).

Handling the switch in common x86 will allow for the elimination of the
pre/post_blocks hooks, and also lets KVM switch back to the hypervisor
timer if and only if it was in use (without additional params).  Add a
comment explaining why the switch cannot be deferred to kvm_sched_out()
or kvm_vcpu_block().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20211208015236.1616697-8-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ta: Fix conflicts in vmx_pre_block and vmx_post_block as per Paolo's
suggestion. Add Reported-by and Link tags.]
Reported-by: syzbot+b6a74be92b5063a0f1ff@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=489beb3d76ef14cc6cd18125782dc6f86051a605
Tested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 arch/x86/kvm/vmx/vmx.c |  6 ------
 arch/x86/kvm/x86.c     | 21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9ce45554d637..c95c3675e8d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7597,17 +7597,11 @@ static int vmx_pre_block(struct kvm_vcpu *vcpu)
 	if (pi_pre_block(vcpu))
 		return 1;
 
-	if (kvm_lapic_hv_timer_in_use(vcpu))
-		kvm_lapic_switch_to_sw_timer(vcpu);
-
 	return 0;
 }
 
 static void vmx_post_block(struct kvm_vcpu *vcpu)
 {
-	if (kvm_x86_ops.set_hv_timer)
-		kvm_lapic_switch_to_hv_timer(vcpu);
-
 	pi_post_block(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0622256cd768..5cb4af42ba64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10043,12 +10043,28 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
+	bool hv_timer;
+
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
 	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
+		/*
+		 * Switch to the software timer before halt-polling/blocking as
+		 * the guest's timer may be a break event for the vCPU, and the
+		 * hypervisor timer runs only when the CPU is in guest mode.
+		 * Switch before halt-polling so that KVM recognizes an expired
+		 * timer before blocking.
+		 */
+		hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
+		if (hv_timer)
+			kvm_lapic_switch_to_sw_timer(vcpu);
+
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 		kvm_vcpu_block(vcpu);
 		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 
+		if (hv_timer)
+			kvm_lapic_switch_to_hv_timer(vcpu);
+
 		if (kvm_x86_ops.post_block)
 			static_call(kvm_x86_post_block)(vcpu);
 
@@ -10287,6 +10303,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = -EINTR;
 			goto out;
 		}
+		/*
+		 * It should be impossible for the hypervisor timer to be in
+		 * use before KVM has ever run the vCPU.
+		 */
+		WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
 		kvm_vcpu_block(vcpu);
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
-- 
2.40.0.348.gf938b09366-goog

