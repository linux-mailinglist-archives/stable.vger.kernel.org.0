Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299A71DB68B
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgETOZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:25:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33086 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbz-00037W-Ji; Wed, 20 May 2020 15:22:23 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-007DVO-6a; Wed, 20 May 2020 15:22:21 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Chen Yucong" <slaoub@gmail.com>
Date:   Wed, 20 May 2020 15:14:49 +0100
Message-ID: <lsq.1589984009.998060719@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 81/99] kvm: x86: use macros to compute bank MSRs
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yucong <slaoub@gmail.com>

commit 81760dccf8d1fe5b128b58736fe3f56a566133cb upstream.

Avoid open coded calculations for bank MSRs by using well-defined
macros that hide the index of higher bank MSRs.

No semantic changes.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/x86.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1915,7 +1915,7 @@ static int set_msr_mce(struct kvm_vcpu *
 		break;
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
-		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
+		    msr < MSR_IA32_MCx_CTL(bank_num)) {
 			u32 offset = msr - MSR_IA32_MC0_CTL;
 			/* only 0 or all 1s can be written to IA32_MCi_CTL
 			 * some Linux kernels though clear bit 10 in bank 4 to
@@ -2276,7 +2276,7 @@ int kvm_set_msr_common(struct kvm_vcpu *
 
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
-	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
 		return set_msr_mce(vcpu, msr, data);
 
 	/* Performance counters are not protected by a CPUID bit,
@@ -2442,7 +2442,7 @@ static int get_msr_mce(struct kvm_vcpu *
 		break;
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
-		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
+		    msr < MSR_IA32_MCx_CTL(bank_num)) {
 			u32 offset = msr - MSR_IA32_MC0_CTL;
 			data = vcpu->arch.mce_banks[offset];
 			break;
@@ -2628,7 +2628,7 @@ int kvm_get_msr_common(struct kvm_vcpu *
 	case MSR_IA32_MCG_CAP:
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
-	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
 		return get_msr_mce(vcpu, msr_info->index, &msr_info->data);
 	case MSR_K7_CLK_CTL:
 		/*

