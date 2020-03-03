Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9904177F7F
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731948AbgCCRvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731945AbgCCRvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:51:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9BA206D5;
        Tue,  3 Mar 2020 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257868;
        bh=dw5guOOn+gkkfTtyZ94+LanBzo9k9WiOrWQ7DTpDNwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVG7h+R/D8g6T0hoYwxEekQjqKy3GxKDjETa560ig38v429QlrzJfNH1+UCQSKZFp
         ArPJp+ucDS4wyBJsUuL8ITDBAsM2vyl59G20XyovJMQ5O1q+LZ/zd0IgMLudhBkp5J
         Jy2J/lPerH0cZ4bEQkF7o1QpAYovk7haGptTASO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 159/176] KVM: x86: Remove spurious clearing of async #PF MSR
Date:   Tue,  3 Mar 2020 18:43:43 +0100
Message-Id: <20200303174322.757276478@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
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
@@ -9227,8 +9227,6 @@ void kvm_arch_vcpu_postcreate(struct kvm
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.apf.msr_val = 0;
-
 	kvm_arch_vcpu_free(vcpu);
 }
 


