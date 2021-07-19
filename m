Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0159B3CE113
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347550AbhGSPTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346087AbhGSPNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:13:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D35AB61289;
        Mon, 19 Jul 2021 15:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710009;
        bh=T49AR+kJ2q2WC2F3KtBXT8xCUovaXKymZ/JOmA72lmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLsoHjFqCEBPRqPg9FqOWyNJsZ1/rDrnBrYc4YCTuhZ15VJDYmDUQdMy0VfI65Zlc
         crynAUecooThsvIpJqAtc3+FurVv04kjg51FpP7jxUFciI+iHweb6RyIe5xrfwq4KA
         fmJYURtadveoqDEt7f3M+CxduD7KNKOeOLCGWEo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 006/243] KVM: nSVM: Check the value written to MSR_VM_HSAVE_PA
Date:   Mon, 19 Jul 2021 16:50:35 +0200
Message-Id: <20210719144941.127411233@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit fce7e152ffc8f89d02a80617b16c7aa1527847c8 upstream.

APM states that #GP is raised upon write to MSR_VM_HSAVE_PA when
the supplied address is not page-aligned or is outside of "maximum
supported physical address for this implementation".
page_address_valid() check seems suitable. Also, forcefully page-align
the address when it's written from VMM.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210628104425.391276-2-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
[Add comment about behavior for host-provided values. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2745,7 +2745,16 @@ static int svm_set_msr(struct kvm_vcpu *
 			svm_disable_lbrv(vcpu);
 		break;
 	case MSR_VM_HSAVE_PA:
-		svm->nested.hsave_msr = data;
+		/*
+		 * Old kernels did not validate the value written to
+		 * MSR_VM_HSAVE_PA.  Allow KVM_SET_MSR to set an invalid
+		 * value to allow live migrating buggy or malicious guests
+		 * originating from those kernels.
+		 */
+		if (!msr->host_initiated && !page_address_valid(vcpu, data))
+			return 1;
+
+		svm->nested.hsave_msr = data & PAGE_MASK;
 		break;
 	case MSR_VM_CR:
 		return svm_set_vm_cr(vcpu, data);


