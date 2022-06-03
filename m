Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D5353CFC7
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345724AbiFCR4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346058AbiFCRzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:55:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A17562C0;
        Fri,  3 Jun 2022 10:53:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A43FB612DA;
        Fri,  3 Jun 2022 17:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6155CC385A9;
        Fri,  3 Jun 2022 17:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278811;
        bh=/eMut8KRqjz6hw7B+wNoTdvbDTPFtvbpZT8C4Ofec78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLZb4f6i3zZNIFg4n4MhFpeujIau/iTmQ1g9jYgaQ43Uz0/lQaX7LoSU61Untd7fh
         Y5I+qj44la9GQ7gJSlkvAZgaR5qH8qwp6SlzzoyEiJg2m/3M1rWEsC0YIc8HvhYX6q
         GHVMK0PtPekb/PuN7BmZlKHzPgyhX7fICLWHSSb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 35/75] KVM: x86: avoid loading a vCPU after .vm_destroy was called
Date:   Fri,  3 Jun 2022 19:43:19 +0200
Message-Id: <20220603173822.741407952@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 6fcee03df6a1a3101a77344be37bb85c6142d56c upstream.

This can cause various unexpected issues, since VM is partially
destroyed at that point.

For example when AVIC is enabled, this causes avic_vcpu_load to
access physical id page entry which is already freed by .vm_destroy.

Fixes: 8221c1370056 ("svm: Manage vcpu load/unload when enable AVIC")
Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220322172449.235575-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11655,20 +11655,15 @@ static void kvm_unload_vcpu_mmu(struct k
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
@@ -11774,11 +11769,12 @@ void kvm_arch_destroy_vm(struct kvm *kvm
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


