Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C82553D041
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346101AbiFCSBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346748AbiFCSAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:00:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886512BFD;
        Fri,  3 Jun 2022 10:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E857615E3;
        Fri,  3 Jun 2022 17:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208C8C385A9;
        Fri,  3 Jun 2022 17:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279012;
        bh=SF7E+IPj5PcsCtp+gwrO4WkiOXIbDQbJq8FCHx19T88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rbx6Hs9J+Foht+GZaZ9aX3Y72ntjVkNkZLiEAYbrMOkreie+z0TLXbrfdkeXKgTmV
         7vpCzgaL1i5GRx0jx/zxK0oWhBib4KJJ7N1Q/up1khlXHqhMWmcYSG+FGOhgRxF9Ff
         iOELkUfywVK/UMrpJrECe+KyKA7HUKp9sBR5AyYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 24/67] KVM: x86: avoid loading a vCPU after .vm_destroy was called
Date:   Fri,  3 Jun 2022 19:43:25 +0200
Message-Id: <20220603173821.422587327@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
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
@@ -11747,20 +11747,15 @@ static void kvm_unload_vcpu_mmu(struct k
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
@@ -11866,11 +11861,12 @@ void kvm_arch_destroy_vm(struct kvm *kvm
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


