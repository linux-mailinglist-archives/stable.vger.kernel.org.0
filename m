Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF91780C5
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387448AbgCCR6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:58:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387427AbgCCR6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:58:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC75E20870;
        Tue,  3 Mar 2020 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258321;
        bh=4fsMTC2zoau3tmshDp1FeSKoSeLg8PUslqdTX2Jfq60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vko2aedjErbloNX1dZA4zc3gs2oZ26+uGcW1wJqF0fI48lrzF+72YzQR347kSCCOx
         DfAAvUnITZqyzu8lMwNIa9r+OK3yHJO35+vDbrphiNSMr6b2Qdfbj/G1p26yhAU3BY
         hKA613N1unEu4WeXGnST9Qq5ftX454kpa+JEQKZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 136/152] KVM: x86: Remove spurious clearing of async #PF MSR
Date:   Tue,  3 Mar 2020 18:43:54 +0100
Message-Id: <20200303174318.268582741@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 208050dac5ef4de5cb83ffcafa78499c94d0b5ad upstream.

Remove a bogus clearing of apf.msr_val from kvm_arch_vcpu_destroy().

apf.msr_val is only set to a non-zero value by kvm_pv_enable_async_pf(),
which is only reachable by kvm_set_msr_common(), i.e. by writing
MSR_KVM_ASYNC_PF_EN.  KVM does not autonomously write said MSR, i.e.
can only be written via KVM_SET_MSRS or KVM_RUN.  Since KVM_SET_MSRS and
KVM_RUN are vcpu ioctls, they require a valid vcpu file descriptor.
kvm_arch_vcpu_destroy() is only called if KVM_CREATE_VCPU fails, and KVM
declares KVM_CREATE_VCPU successful once the vcpu fd is installed and
thus visible to userspace.  Ergo, apf.msr_val cannot be non-zero when
kvm_arch_vcpu_destroy() is called.

Fixes: 344d9588a9df0 ("KVM: Add PV MSR to enable asynchronous page faults delivery.")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9192,8 +9192,6 @@ void kvm_arch_vcpu_postcreate(struct kvm
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.apf.msr_val = 0;
-
 	kvm_arch_vcpu_free(vcpu);
 }
 


