Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160CD4F0814
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 08:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbiDCGlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 02:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiDCGlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 02:41:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7AF36B4D
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 23:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17914B80B98
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 06:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EE5C340ED;
        Sun,  3 Apr 2022 06:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648967956;
        bh=7w9/kTgyHS8jH7yPbZX4QscrGTQ3aig25r3XzLQ5ock=;
        h=Subject:To:Cc:From:Date:From;
        b=qBxvwmkt17ZZ4fqNX8yZTyVFYIoB65z9C4jvix0sZoMF9P0SSqVKsD06vQ4sA7P2m
         r3FI+dOAnMnWgrmxh9Rg1jrhTUFOnzkBz8GV8BFeEAe8ZFpPQWGLkvgcv4xmNEziuX
         QfUyqlbiqO5ITfcYCwvgPdgfkRjw4vo7OdT/KL+s=
Subject: FAILED: patch "[PATCH] KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC" failed to apply to 5.4-stable tree
To:     vkuznets@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 08:39:13 +0200
Message-ID: <1648967953124148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b1e34d325397a33d97d845e312d7cf2a8b646b44 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Fri, 25 Mar 2022 14:21:40 +0100
Subject: [PATCH] KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC
 wasn't activated

Setting non-zero values to SYNIC/STIMER MSRs activates certain features,
this should not happen when KVM_CAP_HYPERV_SYNIC{,2} was not activated.

Note, it would've been better to forbid writing anything to SYNIC/STIMER
MSRs, including zeroes, however, at least QEMU tries clearing
HV_X64_MSR_STIMER0_CONFIG without SynIC. HV_X64_MSR_EOM MSR is somewhat
'special' as writing zero there triggers an action, this also should not
happen when SynIC wasn't activated.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220325132140.25650-4-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f715b5a2b0e4..4177c17a26bf 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -239,7 +239,7 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	int ret;
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || data))
 		return 1;
 
 	trace_kvm_hv_synic_set_msr(vcpu->vcpu_id, msr, data, host);
@@ -285,6 +285,9 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	case HV_X64_MSR_EOM: {
 		int i;
 
+		if (!synic->active)
+			break;
+
 		for (i = 0; i < ARRAY_SIZE(synic->sint); i++)
 			kvm_hv_notify_acked_sint(vcpu, i);
 		break;
@@ -664,7 +667,7 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || config))
 		return 1;
 
 	if (unlikely(!host && hv_vcpu->enforce_cpuid && new_config.direct_mode &&
@@ -693,7 +696,7 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || count))
 		return 1;
 
 	trace_kvm_hv_stimer_set_count(hv_stimer_to_vcpu(stimer)->vcpu_id,

