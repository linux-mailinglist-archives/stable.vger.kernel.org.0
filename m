Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198DB4A417F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358482AbiAaLEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358487AbiAaLDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:03:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F344BC061798;
        Mon, 31 Jan 2022 03:02:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98F51B82A65;
        Mon, 31 Jan 2022 11:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BD1C340E8;
        Mon, 31 Jan 2022 11:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626921;
        bh=WJAyjRlIq6yYjRUW4AIyL7je5n2DEvtWV5A4PMP9ps0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deT2zEYNn17cKGdLAml8ktNL+7+SI8VE7PSXV0SJNovI9uytAOPjAH9w9qd2rtm2I
         KeriN+Fq3Mhslz5tZdRzd/tcj8ZIoFMZPpZ3u08lKtJsFA6pRfkVZU34tvWTV9461c
         z2rNrBNHOPxmC26l+h9iVfNmesewk7Eu+FQheqto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Merwick <liam.merwick@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 018/100] Revert "KVM: SVM: avoid infinite loop on NPF from bad address"
Date:   Mon, 31 Jan 2022 11:55:39 +0100
Message-Id: <20220131105221.075834982@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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
@@ -4146,13 +4146,6 @@ static bool svm_can_emulate_instruction(
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
@@ -1691,7 +1691,6 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_
 {
 	return __gfn_to_memslot(kvm_vcpu_memslots(vcpu), gfn);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {


