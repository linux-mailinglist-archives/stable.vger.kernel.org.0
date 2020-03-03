Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C768E17815C
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbgCCSCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:02:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388100AbgCCSCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A48BC215A4;
        Tue,  3 Mar 2020 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258520;
        bh=rICYxqChW/X52ERvK8ouqHguAYvz1NAQu0tJWYUktrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLufLLOB3olpOiPLvcPHXtOZbacxpOSbnjLD8IinqkCEmknOJHsXWQ2cife8BqmMv
         moI/fhIJ7JGyXu/6vlzDSZznEzpDo5Up80bKP0h9XKlLdn7KrGqEDnS4I0u1FUbRrU
         M+PBhI97qOJr9AOAqci1+Jd2yoT5/7alQJ7ClTXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 81/87] KVM: x86: Remove spurious clearing of async #PF MSR
Date:   Tue,  3 Mar 2020 18:44:12 +0100
Message-Id: <20200303174357.559615558@linuxfoundation.org>
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
@@ -8693,8 +8693,6 @@ void kvm_arch_vcpu_postcreate(struct kvm
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.apf.msr_val = 0;
-
 	kvm_arch_vcpu_free(vcpu);
 }
 


