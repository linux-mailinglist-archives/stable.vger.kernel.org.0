Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D3A3137EC
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhBHPdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233034AbhBHP3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:29:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9248964F2A;
        Mon,  8 Feb 2021 15:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797394;
        bh=9aN0FJX0jOlDuAPMqXBlCxY3IMNfEnOHwsCbfDjUC5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rq8d4nOwQ2UOalSPBkgBhum/LSzYY8aRcBLPtpxGW08kKLd5zmmN3nyy7QUYDfvjw
         Tu1aFHI1JLfqHhzAta5GRqbo8XXOTEUZF6kyZ7ugBd7e9vsZ39jvLrVy05ue2RNTXN
         TpdHw8vX7l+jjPiF39foU3Q2kxItuLTPHEHPRlag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 093/120] KVM: x86: Set so called reserved CR3 bits in LM mask at vCPU reset
Date:   Mon,  8 Feb 2021 16:01:20 +0100
Message-Id: <20210208145822.104891461@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 031b91a5fe6f1ce61b7617614ddde9ed61e252be upstream.

Set cr3_lm_rsvd_bits, which is effectively an invalid GPA mask, at vCPU
reset.  The reserved bits check needs to be done even if userspace never
configures the guest's CPUID model.

Cc: stable@vger.kernel.org
Fixes: 0107973a80ad ("KVM: x86: Introduce cr3_lm_rsvd_bits in kvm_vcpu_arch")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210204000117.3303214-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9915,6 +9915,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
+	vcpu->arch.cr3_lm_rsvd_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 


