Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED1F617F27
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 15:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiKCOPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 10:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiKCOPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 10:15:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C5F11A10
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 07:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667484859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Rmr0NPOPytRRHk5QfeeqyFTJ7brcQ8/Uu01aFjhZlA=;
        b=Vj6l8cBcT6em2KK7PJvEdDDu0Crq62NyTLJxD0R6Xcw9gr7zEVFlTgZEY/PjFV4kB21BKP
        s5+4Gul9Y/vacJjTE+dhxlhzf9MDdHWXC33Q2msX3opmT/ymp1aHQgQ7GKnIWeaLEZycn2
        B62htQMaxBsrr4yfn3Q+P4dd58atQFg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-8QSbxQGbMy2_stjOx5gJeA-1; Thu, 03 Nov 2022 10:14:14 -0400
X-MC-Unique: 8QSbxQGbMy2_stjOx5gJeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBBFD1C08780;
        Thu,  3 Nov 2022 14:14:12 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48C6B40C6EC3;
        Thu,  3 Nov 2022 14:14:08 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Borislav Petkov <bp@alien8.de>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kselftest@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Subject: [PATCH v2 4/9] KVM: x86: forcibly leave nested mode on vCPU reset
Date:   Thu,  3 Nov 2022 16:13:46 +0200
Message-Id: <20221103141351.50662-5-mlevitsk@redhat.com>
In-Reply-To: <20221103141351.50662-1-mlevitsk@redhat.com>
References: <20221103141351.50662-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While not obivous, kvm_vcpu_reset() leaves the nested mode by clearing
'vcpu->arch.hflags' but it does so without all the required housekeeping.

On SVM,	it is possible to have a vCPU reset while in guest mode because
unlike VMX, on SVM, INIT's are not latched in SVM non root mode and in
addition to that L1 doesn't have to intercept triple fault, which should
also trigger L1's reset if happens in L2 while L1 didn't intercept it.

If one of the above conditions happen, KVM will	continue to use vmcb02
while not having in the guest mode.

Later the IA32_EFER will be cleared which will lead to freeing of the
nested guest state which will (correctly) free the vmcb02, but since
KVM still uses it (incorrectly) this will lead to a use after free
and kernel crash.

This issue is assigned CVE-2022-3344

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 316ab1d5317f92..3fd900504e683b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11694,8 +11694,18 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	WARN_ON_ONCE(!init_event &&
 		     (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));
 
+	/*
+	 * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
+	 * possible to INIT the vCPU while L2 is active.  Force the vCPU back
+	 * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
+	 * bits), i.e. virtualization is disabled.
+	 */
+	if (is_guest_mode(vcpu))
+		kvm_leave_nested(vcpu);
+
 	kvm_lapic_reset(vcpu, init_event);
 
+	WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
 	vcpu->arch.hflags = 0;
 
 	vcpu->arch.smi_pending = 0;
-- 
2.34.3

