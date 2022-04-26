Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB06E50F730
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346353AbiDZJLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346297AbiDZJH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:07:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4122C11176;
        Tue, 26 Apr 2022 01:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2151604F5;
        Tue, 26 Apr 2022 08:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72F9C385A4;
        Tue, 26 Apr 2022 08:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962921;
        bh=XRrWZe8jEXeAgtQjqoeBrjhqvlUkRqINnXM2XAnyVdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YQ1Tin7iYY3XNnfQzeziRbzEsIAR3rx4wN+9wTW/NKv9espTuzWiYlmff89czCZy
         FahcDAARxKIUt3osdRErUFRBLum4w3K9S+us1o9W293uIhAYdJbrpUParf6ZeYLQyu
         +Ftd41U6kPuIOSqRmFX6QdtEiO0bGsazODyMPmMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 132/146] KVM: SVM: Simplify and harden helper to flush SEV guest page(s)
Date:   Tue, 26 Apr 2022 10:22:07 +0200
Message-Id: <20220426081753.770379416@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 4bbef7e8eb8c2c7dabf57d97decfd2b4f48aaf02 upstream.

Rework sev_flush_guest_memory() to explicitly handle only a single page,
and harden it to fall back to WBINVD if VM_PAGE_FLUSH fails.  Per-page
flushing is currently used only to flush the VMSA, and in its current
form, the helper is completely broken with respect to flushing actual
guest memory, i.e. won't work correctly for an arbitrary memory range.

VM_PAGE_FLUSH takes a host virtual address, and is subject to normal page
walks, i.e. will fault if the address is not present in the host page
tables or does not have the correct permissions.  Current AMD CPUs also
do not honor SMAP overrides (undocumented in kernel versions of the APM),
so passing in a userspace address is completely out of the question.  In
other words, KVM would need to manually walk the host page tables to get
the pfn, ensure the pfn is stable, and then use the direct map to invoke
VM_PAGE_FLUSH.  And the latter might not even work, e.g. if userspace is
particularly evil/clever and backs the guest with Secret Memory (which
unmaps memory from the direct map).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Fixes: add5e2f04541 ("KVM: SVM: Add support for the SEV-ES VMSA")
Reported-by: Mingwei Zhang <mizhang@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Message-Id: <20220421031407.2516575-2-mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c |   54 ++++++++++++++++++-------------------------------
 1 file changed, 20 insertions(+), 34 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2204,9 +2204,18 @@ int sev_cpu_init(struct svm_cpu_data *sd
  * Pages used by hardware to hold guest encrypted state must be flushed before
  * returning them to the system.
  */
-static void sev_flush_guest_memory(struct vcpu_svm *svm, void *va,
-				   unsigned long len)
+static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 {
+	int asid = to_kvm_svm(vcpu->kvm)->sev_info.asid;
+
+	/*
+	 * Note!  The address must be a kernel address, as regular page walk
+	 * checks are performed by VM_PAGE_FLUSH, i.e. operating on a user
+	 * address is non-deterministic and unsafe.  This function deliberately
+	 * takes a pointer to deter passing in a user address.
+	 */
+	unsigned long addr = (unsigned long)va;
+
 	/*
 	 * If hardware enforced cache coherency for encrypted mappings of the
 	 * same physical page is supported, nothing to do.
@@ -2215,40 +2224,16 @@ static void sev_flush_guest_memory(struc
 		return;
 
 	/*
-	 * If the VM Page Flush MSR is supported, use it to flush the page
-	 * (using the page virtual address and the guest ASID).
+	 * VM Page Flush takes a host virtual address and a guest ASID.  Fall
+	 * back to WBINVD if this faults so as not to make any problems worse
+	 * by leaving stale encrypted data in the cache.
 	 */
-	if (boot_cpu_has(X86_FEATURE_VM_PAGE_FLUSH)) {
-		struct kvm_sev_info *sev;
-		unsigned long va_start;
-		u64 start, stop;
-
-		/* Align start and stop to page boundaries. */
-		va_start = (unsigned long)va;
-		start = (u64)va_start & PAGE_MASK;
-		stop = PAGE_ALIGN((u64)va_start + len);
-
-		if (start < stop) {
-			sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
-
-			while (start < stop) {
-				wrmsrl(MSR_AMD64_VM_PAGE_FLUSH,
-				       start | sev->asid);
-
-				start += PAGE_SIZE;
-			}
+	if (WARN_ON_ONCE(wrmsrl_safe(MSR_AMD64_VM_PAGE_FLUSH, addr | asid)))
+		goto do_wbinvd;
 
-			return;
-		}
+	return;
 
-		WARN(1, "Address overflow, using WBINVD\n");
-	}
-
-	/*
-	 * Hardware should always have one of the above features,
-	 * but if not, use WBINVD and issue a warning.
-	 */
-	WARN_ONCE(1, "Using WBINVD to flush guest memory\n");
+do_wbinvd:
 	wbinvd_on_all_cpus();
 }
 
@@ -2262,7 +2247,8 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu
 	svm = to_svm(vcpu);
 
 	if (vcpu->arch.guest_state_protected)
-		sev_flush_guest_memory(svm, svm->sev_es.vmsa, PAGE_SIZE);
+		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
+
 	__free_page(virt_to_page(svm->sev_es.vmsa));
 
 	if (svm->sev_es.ghcb_sa_free)


