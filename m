Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E889617EA1
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 14:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiKCN7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 09:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiKCN7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 09:59:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0AB167D6
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 06:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667483881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/YfhlfHGgnctluMl7Qrmit8OONQl7OJvXkn7jff4wDA=;
        b=Pk8uoKiIrHzGdo5dhucg8E+U6+q9ZcEJhZvyKOhFLRMQH9nTsVI5/Iw0CEgPbxeXdC2hSU
        GI9KWY8chI0OZyqzJ8gZOb5KpTweHmeWmewvOPVE8QrJkR41hfRahN2VUPfZvW8l4DsFVA
        W451+2Ui8JnehVr4b/XsG0LVCNvS/bI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-kIsNtGYQNQSJL-Arnu4H7w-1; Thu, 03 Nov 2022 09:57:57 -0400
X-MC-Unique: kIsNtGYQNQSJL-Arnu4H7w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FA198027F5;
        Thu,  3 Nov 2022 13:57:56 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D89740C83AD;
        Thu,  3 Nov 2022 13:57:53 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 4/9] KVM: x86: forcibly leave nested mode on vCPU reset
Date:   Thu,  3 Nov 2022 15:57:31 +0200
Message-Id: <20221103135736.42295-5-mlevitsk@redhat.com>
In-Reply-To: <20221103135736.42295-1-mlevitsk@redhat.com>
References: <20221103135736.42295-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

If one of the above conditions happen, KVM will	continue to use vmcb02 while
not having in the guest mode.

Later the IA32_EFER will be cleared which will lead to freeing of the nested
guest state which will (correctly) free the vmcb02, but since KVM still
uses it (incorrectly) this will lead to a use after free and kernel crash.

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

