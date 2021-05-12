Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7436A37C35C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhELPS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234369AbhELPQi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 362766197F;
        Wed, 12 May 2021 15:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831989;
        bh=aKbZE3fedz4sA3b54nyP8h+UcrUdBSKv9ojwgJ99yCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVxLtmn6yNTgKHrjrkqonPgEaMZlg3wZUMParaSo4EU+Z3fCzvA8V06hbjr2Wmc6M
         166jhRBrXX96PepfPFIkLHd7Jqr/u/pEwnfRr8UQRJUSq7nd8KJMsS9e7JfbZKFcKY
         gn7STXm/2Z6aJf5hFgH1kAabKdWpWvx90lSsoiK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 096/530] KVM: SVM: Inject #GP on guest MSR_TSC_AUX accesses if RDTSCP unsupported
Date:   Wed, 12 May 2021 16:43:26 +0200
Message-Id: <20210512144822.960368766@linuxfoundation.org>
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

commit 6f2b296aa6432d8274e258cc3220047ca04f5de0 upstream.

Inject #GP on guest accesses to MSR_TSC_AUX if RDTSCP is unsupported in
the guest's CPUID model.

Fixes: 46896c73c1a4 ("KVM: svm: add support for RDTSCP")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210423223404.3860547-2-seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2519,6 +2519,9 @@ static int svm_get_msr(struct kvm_vcpu *
 	case MSR_TSC_AUX:
 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
 			return 1;
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+			return 1;
 		msr_info->data = svm->tsc_aux;
 		break;
 	/*
@@ -2713,6 +2716,10 @@ static int svm_set_msr(struct kvm_vcpu *
 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
 			return 1;
 
+		if (!msr->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+			return 1;
+
 		/*
 		 * This is rare, so we update the MSR here instead of using
 		 * direct_access_msrs.  Doing that would require a rdmsr in


