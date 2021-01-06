Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829492EBCBF
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 11:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbhAFKvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 05:51:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbhAFKvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 05:51:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609930224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4QxMA+cVz43np+3lUK6WKIRMH8Gubjyttk2lLsha7SA=;
        b=YUytsZWiY6NirIV80R+GgJkomH9jCJel+AErq9N09MGduPtMWsoVC6ChDGi+4ybOCbMgmk
        937fDNTJzaQhwg0tcFGjsSmDTh3BzWRu9wTfp/916JnuK3cdGNUUTWg5c7e6cNwqJWyo/h
        KwblgfLdRR4Rir0rk1W9XPW7wYyxEPg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-GVjCmVPJPA6CyTKXWIArfA-1; Wed, 06 Jan 2021 05:50:23 -0500
X-MC-Unique: GVjCmVPJPA6CyTKXWIArfA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41388800D55;
        Wed,  6 Jan 2021 10:50:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 630C1669FC;
        Wed,  6 Jan 2021 10:50:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 3/6] KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit
Date:   Wed,  6 Jan 2021 12:49:58 +0200
Message-Id: <20210106105001.449974-4-mlevitsk@redhat.com>
In-Reply-To: <20210106105001.449974-1-mlevitsk@redhat.com>
References: <20210106105001.449974-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is possible to exit the nested guest mode, entered by
svm_set_nested_state prior to first vm entry to it (e.g due to pending event)
if the nested run was not pending during the migration.

In this case we must not switch to the nested msr permission bitmap.
Also add a warning to catch similar cases in the future.

CC: stable@vger.kernel.org
Fixes: a7d5c7ce41ac1 ("KVM: nSVM: delay MSR permission processing to first nested VM run")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 18b71e73a9935..6208d3a5a3fdb 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -199,6 +199,10 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (WARN_ON_ONCE(!is_guest_mode(&svm->vcpu)))
+		return false;
+
 	if (!nested_svm_vmrun_msrpm(svm)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =
@@ -598,6 +602,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->nested.vmcb12_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
+
 	/* in case we halted in L2 */
 	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
-- 
2.26.2

