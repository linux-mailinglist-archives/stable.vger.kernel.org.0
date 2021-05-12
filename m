Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B282337C7D1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhELQCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237826AbhELP40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 349CA61A46;
        Wed, 12 May 2021 15:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833316;
        bh=P/QaBq8t1m55nTsYH2jMmhNCNl80guSkd6XnRdh561Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVxsTJQ6xQXpyTrBGzw+IXEfuKjVPNjS6BWwPkr/MujNC/D/bknweP9+w3hRVxWbo
         7hwQji2OF6lpKf4iG+gWwVTlhb6KGncXG2ILPVygPGP9QYbiX/plHWQ0iwKOSQJWQE
         MOarqwFlRnDoKd/sNWsoNeA2x9qJBpljGDtXcukA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 100/601] KVM: SVM: Dont strip the C-bit from CR2 on #PF interception
Date:   Wed, 12 May 2021 16:42:57 +0200
Message-Id: <20210512144831.131474621@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
@@ -1888,7 +1888,7 @@ static void svm_set_dr7(struct kvm_vcpu
 
 static int pf_interception(struct vcpu_svm *svm)
 {
-	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
+	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	return kvm_handle_page_fault(&svm->vcpu, error_code, fault_address,


