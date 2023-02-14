Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB688696AE0
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 18:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbjBNRKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 12:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjBNRKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 12:10:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B587F5266
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 09:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676394603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6+4BnefgRVa4jV59o3mbvN+Lf8hy8JnYG74mcUJdqM=;
        b=BB99PbfCOsNnc7PUXaH/8GyTkTY2DgyMn9epi4LchBYM+yNjEj8dlWGp5M3SapgxzzW77V
        rhgQcFryAOKepDcd7qpcygO1ljAZcFRmEJD/IL9x90M6ZHRqXOnBrhnWzU6EChhXvZ8VXS
        L3Vw4xTsJjUnIvsTF2NS6CQS2xEz0jI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-anHQYkVQO6qUAqUI2FNfvQ-1; Tue, 14 Feb 2023 12:10:01 -0500
X-MC-Unique: anHQYkVQO6qUAqUI2FNfvQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DA1B281722E;
        Tue, 14 Feb 2023 17:09:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BA541121318;
        Tue, 14 Feb 2023 17:09:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, thomas.lendacky@amd.com
Subject: [PATCH for-5.15 2/3] KVM: x86: Mitigate the cross-thread return address predictions bug
Date:   Tue, 14 Feb 2023 12:09:55 -0500
Message-Id: <20230214170956.1297309-3-pbonzini@redhat.com>
In-Reply-To: <20230214170956.1297309-1-pbonzini@redhat.com>
References: <20230214170956.1297309-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

By default, KVM/SVM will intercept attempts by the guest to transition
out of C0. However, the KVM_CAP_X86_DISABLE_EXITS capability can be used
by a VMM to change this behavior. To mitigate the cross-thread return
address predictions bug (X86_BUG_SMT_RSB), a VMM must not be allowed to
override the default behavior to intercept C0 transitions.

Use a module parameter to control the mitigation on processors that are
vulnerable to X86_BUG_SMT_RSB. If the processor is vulnerable to the
X86_BUG_SMT_RSB bug and the module parameter is set to mitigate the bug,
KVM will not allow the disabling of the HLT, MWAIT and CSTATE exits.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <4019348b5e07148eb4d593380a5f6713b93c9a16.1675956146.git.thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fcfa3fedf84f..45a3d11bb70d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -184,6 +184,10 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+/* Enable/disable SMT_RSB bug mitigation */
+bool __read_mostly mitigate_smt_rsb;
+module_param(mitigate_smt_rsb, bool, 0444);
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -4164,10 +4168,15 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_CLOCK_TSC_STABLE;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
-		      KVM_X86_DISABLE_EXITS_CSTATE;
-		if(kvm_can_mwait_in_guest())
-			r |= KVM_X86_DISABLE_EXITS_MWAIT;
+		r = KVM_X86_DISABLE_EXITS_PAUSE;
+
+		if (!mitigate_smt_rsb) {
+			r |= KVM_X86_DISABLE_EXITS_HLT |
+			     KVM_X86_DISABLE_EXITS_CSTATE;
+
+			if (kvm_can_mwait_in_guest())
+				r |= KVM_X86_DISABLE_EXITS_MWAIT;
+		}
 		break;
 	case KVM_CAP_X86_SMM:
 		/* SMBASE is usually relocated above 1M on modern chipsets,
@@ -5746,15 +5755,26 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
 			break;
 
-		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
-			kvm_can_mwait_in_guest())
-			kvm->arch.mwait_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-			kvm->arch.hlt_in_guest = true;
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
 			kvm->arch.pause_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-			kvm->arch.cstate_in_guest = true;
+
+#define SMT_RSB_MSG "This processor is affected by the Cross-Thread Return Predictions vulnerability. " \
+		    "KVM_CAP_X86_DISABLE_EXITS should only be used with SMT disabled or trusted guests."
+
+		if (!mitigate_smt_rsb) {
+			if (boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible() &&
+			    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
+				pr_warn_once(SMT_RSB_MSG);
+
+			if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
+			    kvm_can_mwait_in_guest())
+				kvm->arch.mwait_in_guest = true;
+			if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
+				kvm->arch.hlt_in_guest = true;
+			if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
+				kvm->arch.cstate_in_guest = true;
+		}
+
 		r = 0;
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
@@ -12796,6 +12816,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
 static int __init kvm_x86_init(void)
 {
 	kvm_mmu_x86_module_init();
+	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
 	return 0;
 }
 module_init(kvm_x86_init);
-- 
2.39.1


