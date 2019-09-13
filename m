Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442A5B2038
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390227AbfIMNSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389668AbfIMNS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:18:29 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D5C4214D8;
        Fri, 13 Sep 2019 13:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380709;
        bh=2e90/tcQz7eJT9CjO98M7fmzHTLNXw6+JDINlewjzLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prmKolxo7fFJkwZ65xQe9WCvoKl54q/QoqwmENc32oqVKEgp5iWeYPz6j+sb7htfl
         aNLkXmIUr+b8U3p5D5eSu7dh2ob4uQMJVpthowGKVvF8h5JtipUvnXJuVZ1MQHH56l
         Nq5iTO/tyrqzq8gSAodjm9knTOM5qjmlUQ7b0T0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 152/190] KVM: x86: optimize check for valid PAT value
Date:   Fri, 13 Sep 2019 14:06:47 +0100
Message-Id: <20190913130612.062736272@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 674ea351cdeb01d2740edce31db7f2d79ce6095d ]

This check will soon be done on every nested vmentry and vmexit,
"parallelize" it using bitwise operations.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mtrr.c | 10 +---------
 arch/x86/kvm/vmx.c  |  2 +-
 arch/x86/kvm/x86.h  | 10 ++++++++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index e9ea2d45ae66b..9f72cc427158e 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -48,11 +48,6 @@ static bool msr_mtrr_valid(unsigned msr)
 	return false;
 }
 
-static bool valid_pat_type(unsigned t)
-{
-	return t < 8 && (1 << t) & 0xf3; /* 0, 1, 4, 5, 6, 7 */
-}
-
 static bool valid_mtrr_type(unsigned t)
 {
 	return t < 8 && (1 << t) & 0x73; /* 0, 1, 4, 5, 6 */
@@ -67,10 +62,7 @@ bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		return false;
 
 	if (msr == MSR_IA32_CR_PAT) {
-		for (i = 0; i < 8; i++)
-			if (!valid_pat_type((data >> (i * 8)) & 0xff))
-				return false;
-		return true;
+		return kvm_pat_valid(data);
 	} else if (msr == MSR_MTRRdefType) {
 		if (data & ~0xcff)
 			return false;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ee9ff20da3902..feff7ed44a2bb 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4266,7 +4266,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_CR_PAT:
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
-			if (!kvm_mtrr_valid(vcpu, MSR_IA32_CR_PAT, data))
+			if (!kvm_pat_valid(data))
 				return 1;
 			vmcs_write64(GUEST_IA32_PAT, data);
 			vcpu->arch.pat = data;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 8889e0c029a70..3a91ea760f073 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -345,6 +345,16 @@ static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 	__this_cpu_write(current_vcpu, NULL);
 }
 
+
+static inline bool kvm_pat_valid(u64 data)
+{
+	if (data & 0xF8F8F8F8F8F8F8F8ull)
+		return false;
+	/* 0, 1, 4, 5, 6, 7 are valid values.  */
+	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
+}
+
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
+
 #endif
-- 
2.20.1



