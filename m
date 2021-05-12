Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3022537CBAE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhELQhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241738AbhELQ16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D69E61459;
        Wed, 12 May 2021 15:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834949;
        bh=OqZpSmvOBPcn+1Skjs33YecdaP7JSk04kEM55XneYD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2D/azikEoPPNPLj10Qfe9VCmlUMy7ESp5PYC4f8Hh+2zxNt/lfmwsD0yw15Ka8PzO
         Xxb3RNH/+ZwN9gnSw0o6rN7nEiafXgIlQKTOfB1g2T70jfhViMdfTQkPwjQbs2K/bT
         qDNiJXazJAA/rVKOscxV1gWR8tEpfwjjp7oytr40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 113/677] KVM: SVM: Dont strip the C-bit from CR2 on #PF interception
Date:   Wed, 12 May 2021 16:42:39 +0200
Message-Id: <20210512144840.969654167@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
@@ -1898,7 +1898,7 @@ static void svm_set_dr7(struct kvm_vcpu
 
 static int pf_interception(struct vcpu_svm *svm)
 {
-	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
+	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	return kvm_handle_page_fault(&svm->vcpu, error_code, fault_address,


