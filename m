Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC37217815A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388103AbgCCSB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388100AbgCCSB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E28F20866;
        Tue,  3 Mar 2020 18:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258517;
        bh=thZk40I7Hn4qEUK8h9Expb/raHha+dGzZtgNhoDyxbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UT6Vsa/s+kUkJocSygKXKdRV6BnAaf3Wv5SBEdZr5Mp4p7/maaE+5IRP7WUmbCkq7
         72cHTt2IsrGenonXOvaPWE6KM1fdhvQWdJ+15SqxEVnfO59hj2YnRfMstR+E8yrqWo
         6+EpVOjmcF7u7duy4//dmzy/ctWl6LrpUL4N05Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 80/87] KVM: x86: Remove spurious kvm_mmu_unload() from vcpu destruction path
Date:   Tue,  3 Mar 2020 18:44:11 +0100
Message-Id: <20200303174357.452893316@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 9d979c7e6ff43ca3200ffcb74f57415fd633a2da upstream.

x86 does not load its MMU until KVM_RUN, which cannot be invoked until
after vCPU creation succeeds.  Given that kvm_arch_vcpu_destroy() is
called if and only if vCPU creation fails, it is impossible for the MMU
to be loaded.

Note, the bogus kvm_mmu_unload() call was added during an unrelated
refactoring of vCPU allocation, i.e. was presumably added as an
opportunstic "fix" for a perceived leak.

Fixes: fb3f0f51d92d1 ("KVM: Dynamically allocate vcpus")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8695,10 +8695,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vc
 {
 	vcpu->arch.apf.msr_val = 0;
 
-	vcpu_load(vcpu);
-	kvm_mmu_unload(vcpu);
-	vcpu_put(vcpu);
-
 	kvm_arch_vcpu_free(vcpu);
 }
 


