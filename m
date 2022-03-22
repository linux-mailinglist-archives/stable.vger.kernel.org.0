Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076FA4E4512
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 18:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239623AbiCVR0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239621AbiCVR0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 13:26:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6401D4665E
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 10:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nPvfKTaEqxJ+Ae0wIaDYiuGLu21nzq7TNDCzPfa276A=;
        b=Ft6qpuBtm6bS8Q88hVkTin1/C4Y7/Brozk/bMZAyKY1t1mCNwbNWC6S25UVDbIqrqe0juD
        06xMhyFI83n1LzbZmhxurTaausRcQDnhYxe1+J5TG3+psYlmjrbpSQw9xdNfMq0ji7QMUD
        6/O8LRIRta9mq8nC7mUaFP/1A5q7j1c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-dMvdYKRwMIy3qG8JG2fyEQ-1; Tue, 22 Mar 2022 13:25:03 -0400
X-MC-Unique: dMvdYKRwMIy3qG8JG2fyEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78CAF185A79C;
        Tue, 22 Mar 2022 17:25:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9A822166B2D;
        Tue, 22 Mar 2022 17:24:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/8] KVM: x86: avoid loading a vCPU after .vm_destroy was called
Date:   Tue, 22 Mar 2022 19:24:42 +0200
Message-Id: <20220322172449.235575-2-mlevitsk@redhat.com>
In-Reply-To: <20220322172449.235575-1-mlevitsk@redhat.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This can cause various unexpected issues, since VM is partially
destroyed at that point.

For example when AVIC is enabled, this causes avic_vcpu_load to
access physical id page entry which is already freed by .vm_destroy.

Fixes: 8221c1370056 ("svm: Manage vcpu load/unload when enable AVIC")
Cc: stable@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3a9ce07a565..ba920e537ddf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11759,20 +11759,15 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 }
 
-static void kvm_free_vcpus(struct kvm *kvm)
+static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 {
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
 
-	/*
-	 * Unpin any mmu pages first.
-	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_unload_vcpu_mmu(vcpu);
 	}
-
-	kvm_destroy_vcpus(kvm);
 }
 
 void kvm_arch_sync_events(struct kvm *kvm)
@@ -11878,11 +11873,12 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
+	kvm_unload_vcpu_mmus(kvm);
 	static_call_cond(kvm_x86_vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
-	kvm_free_vcpus(kvm);
+	kvm_destroy_vcpus(kvm);
 	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
 	kvm_mmu_uninit_vm(kvm);
-- 
2.26.3

