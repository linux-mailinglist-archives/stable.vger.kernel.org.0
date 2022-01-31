Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9395B4A424B
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348478AbiAaLLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56826 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376522AbiAaLIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:08:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6FF4B82A59;
        Mon, 31 Jan 2022 11:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D96CC340EF;
        Mon, 31 Jan 2022 11:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627313;
        bh=E9EIDomCPCgL962F5vKhUfJoH4Jp6t+QuYTdmvDJ98A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqIWf6BWGplTr+UWozLXA66lRxlJGwuJiga0gzNLrzdxvgCcGqNVp5bfQCONaEkHx
         MfhIZib4swzvq2dIpeF0UjCECg0z12cmKRal/uERfH2QrltONG3wF70N8T3DG/V2eV
         YXjJvbcAvPJLtF9TJG2m2YJuHlyGcF569Jf+C+3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Merwick <liam.merwick@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 026/171] Revert "KVM: SVM: avoid infinite loop on NPF from bad address"
Date:   Mon, 31 Jan 2022 11:54:51 +0100
Message-Id: <20220131105230.912100778@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 31c25585695abdf03d6160aa6d829e855b256329 upstream.

Revert a completely broken check on an "invalid" RIP in SVM's workaround
for the DecodeAssists SMAP errata.  kvm_vcpu_gfn_to_memslot() obviously
expects a gfn, i.e. operates in the guest physical address space, whereas
RIP is a virtual (not even linear) address.  The "fix" worked for the
problematic KVM selftest because the test identity mapped RIP.

Fully revert the hack instead of trying to translate RIP to a GPA, as the
non-SEV case is now handled earlier, and KVM cannot access guest page
tables to translate RIP.

This reverts commit e72436bc3a5206f95bb384e741154166ddb3202e.

Fixes: e72436bc3a52 ("KVM: SVM: avoid infinite loop on NPF from bad address")
Reported-by: Liam Merwick <liam.merwick@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Message-Id: <20220120010719.711476-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    7 -------
 virt/kvm/kvm_main.c    |    1 -
 2 files changed, 8 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4456,13 +4456,6 @@ static bool svm_can_emulate_instruction(
 	if (likely(!insn || insn_len))
 		return true;
 
-	/*
-	 * If RIP is invalid, go ahead with emulation which will cause an
-	 * internal error exit.
-	 */
-	if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
-		return true;
-
 	cr4 = kvm_read_cr4(vcpu);
 	smep = cr4 & X86_CR4_SMEP;
 	smap = cr4 & X86_CR4_SMAP;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2104,7 +2104,6 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {


