Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4111660DC09
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 09:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiJZHXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 03:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiJZHXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 03:23:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6E7B0B01
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 00:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666769030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/57zO14tKIKGiNB71iEufewLL5Xzf0HGWHVNOYYvEjw=;
        b=XCcoAZug2vieLz6h+70bbuFudRcm3uu9D32qV+Fhh30xxi6O/bXI0P27v/b6tX38CIgHEK
        ydn82OoeAn+gDzclPPWkhhpjf0jtfD9NhTYRYGBOwtckoy+uPpDO1Uab0oZHJehBo+ee/O
        5n7LAedVM3XXAWjap+psJzKq2hJqY4s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-ZNgQvMONPnewK8x-4MJpNg-1; Wed, 26 Oct 2022 03:23:44 -0400
X-MC-Unique: ZNgQvMONPnewK8x-4MJpNg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43FDC185A7AF;
        Wed, 26 Oct 2022 07:23:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7BB9111F3B6;
        Wed, 26 Oct 2022 07:23:32 +0000 (UTC)
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
Subject: [PATCH v3] KVM: nVMX: Advertise ENCLS_EXITING to L1 iff SGX is fully supported
Date:   Wed, 26 Oct 2022 03:23:30 -0400
Message-Id: <20221026072330.2248336-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clear enable_sgx if ENCLS-exiting is not supported, i.e. if SGX cannot be
virtualized.  This fixes a bug where KVM would advertise ENCLS-exiting to
L1 and propagate the control from vmcs12 to vmcs02 even if ENCLS-exiting
isn't supported in secondary execution controls, e.g. because SGX isn't
fully enabled, and thus induce an unexpected VM-Fail in L1.

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

