Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51CE1FBAAB
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731865AbgFPQNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731828AbgFPPni (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:43:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD3B7208D5;
        Tue, 16 Jun 2020 15:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322218;
        bh=nuyPltg19qoaXdjqgPcOi6VSiHkbYcLdjaks4P/9Jog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hi2xCFpBKor3JJJLUdnMC2UmmQUVezPSrn5KasSffr9OGZ/U6yF388ir+86/7Ppjd
         0kmjHhSy2bSZZPsA0mZGe9jU7QS1qdNzkUbwb9EJzhtyNa6JHkiXJcPDVQyL6QqFcI
         gtvabtGDJO1ywLPHNHsIAysPD29G3Q2bn6PsZbk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 5.7 046/163] KVM: VMX: enable X86_FEATURE_WAITPKG in KVM capabilities
Date:   Tue, 16 Jun 2020 17:33:40 +0200
Message-Id: <20200616153109.065725641@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 0abcc8f65cc23b65bc8d1614cc64b02b1641ed7c upstream.

Even though we might not allow the guest to use WAITPKG's new
instructions, we should tell KVM that the feature is supported by the
host CPU.

Note that vmx_waitpkg_supported checks that WAITPKG _can_ be set in
secondary execution controls as specified by VMX capability MSR, rather
that we actually enable it for a guest.

Cc: stable@vger.kernel.org
Fixes: e69e72faa3a0 ("KVM: x86: Add support for user wait instructions")
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20200523161455.3940-2-mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/vmx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7138,6 +7138,9 @@ static __init void vmx_set_cpu_caps(void
 	/* CPUID 0x80000001 */
 	if (!cpu_has_vmx_rdtscp())
 		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
+
+	if (vmx_waitpkg_supported())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)


