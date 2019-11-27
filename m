Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCA210BD61
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfK0U5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:57:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbfK0U5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:57:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 599A7215F1;
        Wed, 27 Nov 2019 20:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888261;
        bh=4pjRnt43T7oxkxooyEGC5aYHKmsP7mDySN8xX2uQA1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBS77VIA6ZVf6MQbD6g+N0jaGVQdGaUjVgV5r5SV2E+bELEoqwJaDVdIiEa5pQakL
         KKx5ZT/r0CETTTX9RGn8GPl80zDtWrLTiFjrYxEl6LUA6F5DySCo3OyexZbi031OMj
         1KCt/tb652Pcb1IyKnXeLIlEsx25zuORlGfRlV4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs() call to nested_vmx_enter_non_root_mode()
Date:   Wed, 27 Nov 2019 21:28:37 +0100
Message-Id: <20191127203119.676489279@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit 7671ce21b13b9596163a29f4712cb2451a9b97dc ]

In preparation of supporting checkpoint/restore for nested state,
commit ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run()")
modified check_vmentry_postreqs() to only perform the guest EFER
consistency checks when nested_run_pending is true.  But, in the
normal nested VMEntry flow, nested_run_pending is only set after
check_vmentry_postreqs(), i.e. the consistency check is being skipped.

Alternatively, nested_run_pending could be set prior to calling
check_vmentry_postreqs() in nested_vmx_run(), but placing the
consistency checks in nested_vmx_enter_non_root_mode() allows us
to split prepare_vmcs02() and interleave the preparation with
the consistency checks without having to change the call sites
of nested_vmx_enter_non_root_mode().  In other words, the rest
of the consistency check code in nested_vmx_run() will be joining
the postreqs checks in future patches.

Fixes: ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run()")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Jim Mattson <jmattson@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fe7fdd666f091..bdf019f322117 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -12694,6 +12694,9 @@ static int enter_vmx_non_root_mode(struct kvm_vcpu *vcpu, u32 *exit_qual)
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
 
+	if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, exit_qual))
+		return EXIT_REASON_INVALID_STATE;
+
 	enter_guest_mode(vcpu);
 
 	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
@@ -12836,13 +12839,6 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 */
 	skip_emulated_instruction(vcpu);
 
-	ret = check_vmentry_postreqs(vcpu, vmcs12, &exit_qual);
-	if (ret) {
-		nested_vmx_entry_failure(vcpu, vmcs12,
-					 EXIT_REASON_INVALID_STATE, exit_qual);
-		return 1;
-	}
-
 	/*
 	 * We're finally done with prerequisite checking, and can start with
 	 * the nested entry.
-- 
2.20.1



