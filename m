Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7D637C358
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbhELPS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234356AbhELPQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 603FA61958;
        Wed, 12 May 2021 15:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831984;
        bh=swWjcGHxHBfsgF9qsbV9bir1xyrptSbVxG4/u95uxiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbTLilYSQuJctDBpxJKMmZ29Nnx33aLFRc8ovrsqLfIUfCVPLRx8LqZZLq2daR5DE
         +6/OFc9DaEaSn6Ivxnx3LEYdxfeB6kgIM+NyQbxfzfIh2ds0p43k5QhBL1YMkeJqXp
         A7oCx8+qJT+hsGoREwKODR5tru9eknKRzheI57s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 094/530] KVM: SVM: Dont strip the C-bit from CR2 on #PF interception
Date:   Wed, 12 May 2021 16:43:24 +0200
Message-Id: <20210512144822.895020635@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 6d1b867d045699d6ce0dfa0ef35d1b87dd36db56 upstream.

Don't strip the C-bit from the faulting address on an intercepted #PF,
the address is a virtual address, not a physical address.

Fixes: 0ede79e13224 ("KVM: SVM: Clear C-bit from the page fault address")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-13-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1805,7 +1805,7 @@ static void svm_set_dr7(struct kvm_vcpu
 
 static int pf_interception(struct vcpu_svm *svm)
 {
-	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
+	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	return kvm_handle_page_fault(&svm->vcpu, error_code, fault_address,


