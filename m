Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D99760CC02
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 14:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiJYMh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 08:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbiJYMh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 08:37:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7951870BF
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 05:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666701475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=boAr6JkR73ssS+S6gWh1SUDS3IyoLaLW/9nsvQotYJ4=;
        b=buIvF6Wdj4Z3TWvMsVWhhbcdeit14okTC/DgKZwYjIJQUgNAvhu9IaWBWM4jGtZKxt0ri7
        J8vU3l3L5mI/+5ho+8Kqw4E5XJwBHBrFQW3IJcWJx4Udeq3YfmxAhLVgaBtHq8DuoWeWyd
        0+5xZqqgww+TfPL+cvWUPUsuTg4C6E0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-QTzcfl6kMFSkPo91IvFfWQ-1; Tue, 25 Oct 2022 08:37:52 -0400
X-MC-Unique: QTzcfl6kMFSkPo91IvFfWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE10D380671E;
        Tue, 25 Oct 2022 12:37:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 737352166B2A;
        Tue, 25 Oct 2022 12:37:51 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Bandan Das <bsd@redhat.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] KVM: vmx/nested: avoid blindly setting SECONDARY_EXEC_ENCLS_EXITING when sgx is enabled
Date:   Tue, 25 Oct 2022 08:37:49 -0400
Message-Id: <20221025123749.2201649-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently vmx enables SECONDARY_EXEC_ENCLS_EXITING even when sgx
is not set in the host MSR.

When booting a guest, KVM checks that the cpuid bit is actually set
in vmx.c, and if not, it does not enable the feature.

However, in nesting this control bit is blindly set, and will be
propagated to VMCS12 and VMCS02. Therefore, when L1 tries to boot
the guest, the host will try to execute VMLOAD with VMCS02 containing
a feature that the hardware does not support, making it fail with
hardware error 0x7.

According to section "Secondary Processor-Based VM-Execution Controls"
in the Intel SDM, software should *always* check the value in the
actual MSR_IA32_VMX_PROCBASED_CTLS2 before enabling this bit.

Not updating enable_sgx is responsible for a second bug:
vmx_set_cpu_caps() doesn't clear the SGX bits when hardware support is
unavailable.  This is a much less problematic bug as it only pops up
if SGX is soft-disabled (the case being handled by cpu_has_sgx()) or if
SGX is supported for bare metal but not in the VMCS (will never happen
when running on bare metal, but can theoertically happen when running in
a VM).

Last but not least, KVM should ideally have module params reflect KVM's
actual configuration.

RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2127128

Fixes: 72add915fbd5 ("KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC")
Cc: stable@vger.kernel.org

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dba04b6b019..ea0c65d3c08a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8263,6 +8263,11 @@ static __init int hardware_setup(void)
 	if (!cpu_has_virtual_nmis())
 		enable_vnmi = 0;
 
+	#ifdef CONFIG_X86_SGX_KVM
+		if (!cpu_has_vmx_encls_vmexit())
+			enable_sgx = false;
+	#endif
+
 	/*
 	 * set_apic_access_page_addr() is used to reload apic access
 	 * page upon invalidation.  No need to do anything if not
-- 
2.31.1

