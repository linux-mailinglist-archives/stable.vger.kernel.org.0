Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CDA4AC499
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 17:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbiBGP7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 10:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378844AbiBGPzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 10:55:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17F0BC0401D1
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 07:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644249311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EQ3ltiA1zD8GMi+gBPOuvalM+7bzpftE5TYI4/s1Kfw=;
        b=asbIsE73BWKAuEWfASPwQhe8QdYbJJ++4CYIWqnGS6bT6nEUyJ6yQWuG2+L7CQIYntP2xC
        tWhVPACuqoFxbe/HxL9fGSIP1H+lOsUYO0NYX6atHVE1o3+lFD9HPNsjQVB6mDq+eWryKT
        gK/rwuH+DKekm0S/lGuxFo5m5UQ61LE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-6tc-WsGFNY-HT2UZY1tsFQ-1; Mon, 07 Feb 2022 10:55:08 -0500
X-MC-Unique: 6tc-WsGFNY-HT2UZY1tsFQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8E0593923;
        Mon,  7 Feb 2022 15:55:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DE7E7DE5F;
        Mon,  7 Feb 2022 15:54:57 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        David Airlie <airlied@linux.ie>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org
Subject: [PATCH RESEND 01/30] KVM: x86: SVM: don't passthrough SMAP/SMEP/PKE bits in !NPT && !gCR0.PG case
Date:   Mon,  7 Feb 2022 17:54:18 +0200
Message-Id: <20220207155447.840194-2-mlevitsk@redhat.com>
In-Reply-To: <20220207155447.840194-1-mlevitsk@redhat.com>
References: <20220207155447.840194-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the guest doesn't enable paging, and NPT/EPT is disabled, we
use guest't paging CR3's as KVM's shadow paging pointer and
we are technically in direct mode as if we were to use NPT/EPT.

In direct mode we create SPTEs with user mode permissions
because usually in the direct mode the NPT/EPT doesn't
need to restrict access based on guest CPL
(there are MBE/GMET extenstions for that but KVM doesn't use them).

In this special "use guest paging as direct" mode however,
and if CR4.SMAP/CR4.SMEP are enabled, that will make the CPU
fault on each access and KVM will enter endless loop of page faults.

Since page protection doesn't have any meaning in !PG case,
just don't passthrough these bits.

The fix is the same as was done for VMX in commit:
commit 656ec4a4928a ("KVM: VMX: fix SMEP and SMAP without EPT")

This fixes the boot of windows 10 without NPT for good.
(Without this patch, BSP boots, but APs were stuck in endless
loop of page faults, causing the VM boot with 1 CPU)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/svm/svm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 975be872cd1a3..995c203a62fd9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1596,6 +1596,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 hcr0 = cr0;
+	bool old_paging = is_paging(vcpu);
 
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
@@ -1612,8 +1613,11 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 #endif
 	vcpu->arch.cr0 = cr0;
 
-	if (!npt_enabled)
+	if (!npt_enabled) {
 		hcr0 |= X86_CR0_PG | X86_CR0_WP;
+		if (old_paging != is_paging(vcpu))
+			svm_set_cr4(vcpu, kvm_read_cr4(vcpu));
+	}
 
 	/*
 	 * re-enable caching here because the QEMU bios
@@ -1657,8 +1661,12 @@ void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		svm_flush_tlb_current(vcpu);
 
 	vcpu->arch.cr4 = cr4;
-	if (!npt_enabled)
+	if (!npt_enabled) {
 		cr4 |= X86_CR4_PAE;
+
+		if (!is_paging(vcpu))
+			cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
+	}
 	cr4 |= host_cr4_mce;
 	to_svm(vcpu)->vmcb->save.cr4 = cr4;
 	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
-- 
2.26.3

