Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4B145C5D5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353347AbhKXOA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355803AbhKXN65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:58:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31011613AB;
        Wed, 24 Nov 2021 13:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759325;
        bh=yAoW40fgFSaLMHrdBe+6h1ZKYfTzu9mFPsdFnDrJjmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dw8+8zSWbh/3UPPBZHKTtlyK3kE/96OCF87mQPG96tpRYPiAyid2IEE/tr0WbUQnB
         DqX5njjyFuvBq9Aqskax7oOdptuSy+aLtkGW/E7s/2IqOKzFvDRCyr3UAr0X4VvyIz
         +xLzI1HFB7/0S2RafTrEIwPm5HrUp+xWRsX6XoK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 204/279] KVM: x86: Assume a 64-bit hypercall for guests with protected state
Date:   Wed, 24 Nov 2021 12:58:11 +0100
Message-Id: <20211124115725.798925368@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit b5aead0064f33ae5e693a364e3204fe1c0ac9af2 upstream.

When processing a hypercall for a guest with protected state, currently
SEV-ES guests, the guest CS segment register can't be checked to
determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
expected that communication between the guest and the hypervisor is
performed to shared memory using the GHCB. In order to use the GHCB, the
guest must have been in long mode, otherwise writes by the guest to the
GHCB would be encrypted and not be able to be comprehended by the
hypervisor.

Create a new helper function, is_64_bit_hypercall(), that assumes the
guest is in 64-bit mode when the guest has protected state, and returns
true, otherwise invoking is_64_bit_mode() to determine the mode. Update
the hypercall related routines to use is_64_bit_hypercall() instead of
is_64_bit_mode().

Add a WARN_ON_ONCE() to is_64_bit_mode() to catch occurences of calls to
this helper function for a guest running with protected state.

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <e0b20c770c9d0d1403f23d83e785385104211f74.1621878537.git.thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    4 ++--
 arch/x86/kvm/x86.c    |    2 +-
 arch/x86/kvm/x86.h    |   12 ++++++++++++
 arch/x86/kvm/xen.c    |    2 +-
 4 files changed, 16 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2022,7 +2022,7 @@ static void kvm_hv_hypercall_set_result(
 {
 	bool longmode;
 
-	longmode = is_64_bit_mode(vcpu);
+	longmode = is_64_bit_hypercall(vcpu);
 	if (longmode)
 		kvm_rax_write(vcpu, result);
 	else {
@@ -2171,7 +2171,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vc
 	}
 
 #ifdef CONFIG_X86_64
-	if (is_64_bit_mode(vcpu)) {
+	if (is_64_bit_hypercall(vcpu)) {
 		hc.param = kvm_rcx_read(vcpu);
 		hc.ingpa = kvm_rdx_read(vcpu);
 		hc.outgpa = kvm_r8_read(vcpu);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8737,7 +8737,7 @@ int kvm_emulate_hypercall(struct kvm_vcp
 
 	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
-	op_64_bit = is_64_bit_mode(vcpu);
+	op_64_bit = is_64_bit_hypercall(vcpu);
 	if (!op_64_bit) {
 		nr &= 0xFFFFFFFF;
 		a0 &= 0xFFFFFFFF;
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -153,12 +153,24 @@ static inline bool is_64_bit_mode(struct
 {
 	int cs_db, cs_l;
 
+	WARN_ON_ONCE(vcpu->arch.guest_state_protected);
+
 	if (!is_long_mode(vcpu))
 		return false;
 	static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
 	return cs_l;
 }
 
+static inline bool is_64_bit_hypercall(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If running with protected guest state, the CS register is not
+	 * accessible. The hypercall register values will have had to been
+	 * provided in 64-bit mode, so assume the guest is in 64-bit.
+	 */
+	return vcpu->arch.guest_state_protected || is_64_bit_mode(vcpu);
+}
+
 static inline bool x86_exception_has_error_code(unsigned int vector)
 {
 	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -698,7 +698,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *v
 	    kvm_hv_hypercall_enabled(vcpu))
 		return kvm_hv_hypercall(vcpu);
 
-	longmode = is_64_bit_mode(vcpu);
+	longmode = is_64_bit_hypercall(vcpu);
 	if (!longmode) {
 		params[0] = (u32)kvm_rbx_read(vcpu);
 		params[1] = (u32)kvm_rcx_read(vcpu);


