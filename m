Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAE71AE261
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 18:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgDQQjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 12:39:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22752 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726377AbgDQQis (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 12:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587141527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=J7/+hu9xA4V/kb8irjtGYa6Qo9G4EJkKAhc6pSJfI0o=;
        b=UeaX/l/20GO3JBwzsoQIi8onTZ+diuiktMtOtbfHrMJ7O6KCyUtL7hbH4K/0jYba9P9I2+
        r5hWcAb7RKeYk3vyfjcGxRjVAtr62wnJ+I38mUcqJdat3+K8zfjRXlZIAra17Tx7hgFtyb
        p/nunvavmPec9WpdzyEl4z1jrLcReCg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-wpnn2rtMOUa9iepu47f1rA-1; Fri, 17 Apr 2020 12:38:45 -0400
X-MC-Unique: wpnn2rtMOUa9iepu47f1rA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84C2E8024E2;
        Fri, 17 Apr 2020 16:38:44 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1846C5DA84;
        Fri, 17 Apr 2020 16:38:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
Date:   Fri, 17 Apr 2020 12:38:42 -0400
Message-Id: <20200417163843.71624-2-pbonzini@redhat.com>
In-Reply-To: <20200417163843.71624-1-pbonzini@redhat.com>
References: <20200417163843.71624-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a nested page fault is taken from an address that does not have
a memslot associated to it, kvm_mmu_do_page_fault returns RET_PF_EMULATE
(via mmu_set_spte) and kvm_mmu_page_fault then invokes svm_need_emulation_on_page_fault.

The default answer there is to return false, but in this case this just
causes the page fault to be retried ad libitum.  Since this is not a
fast path, and the only other case where it is taken is an erratum,
just stick a kvm_vcpu_gfn_to_memslot check in there to detect the
common case where the erratum is not happening.

This fixes an infinite loop in the new set_memory_region_test.

Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++++
 virt/kvm/kvm_main.c    | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a91e397d6750..c86f7278509b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3837,6 +3837,13 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	bool smap = cr4 & X86_CR4_SMAP;
 	bool is_user = svm_get_cpl(vcpu) == 3;
 
+	/*
+	 * If RIP is invalid, go ahead with emulation which will cause an
+	 * internal error exit.
+	 */
+	if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
+		return true;
+
 	/*
 	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
 	 *
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e2f60e313c87..e7436d054305 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1602,6 +1602,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 {
 	return __gfn_to_memslot(kvm_vcpu_memslots(vcpu), gfn);
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.18.2


