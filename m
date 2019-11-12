Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD35F84FD
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 01:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKLARI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 19:17:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:60862 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfKLARH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 19:17:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 16:17:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,294,1569308400"; 
   d="scan'208";a="202486945"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 11 Nov 2019 16:17:06 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.4 STABLE] kvm: mmu: Don't read PDPTEs when paging is not enabled
Date:   Mon, 11 Nov 2019 16:17:05 -0800
Message-Id: <20191112001705.5885-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

Upstream commit d35b34a9a70edae7ef923f100e51b8b5ae9fe899.

kvm should not attempt to read guest PDPTEs when CR0.PG = 0 and
CR4.PAE = 1.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b47fd3d4b8c..ad8e19fee71e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -575,7 +575,7 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int r;
 
-	if (is_long_mode(vcpu) || !is_pae(vcpu))
+	if (is_long_mode(vcpu) || !is_pae(vcpu) || !is_paging(vcpu))
 		return false;
 
 	if (!test_bit(VCPU_EXREG_PDPTR,
@@ -7168,7 +7168,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		kvm_update_cpuid(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (!is_long_mode(vcpu) && is_pae(vcpu)) {
+	if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		mmu_reset_needed = 1;
 	}
-- 
2.24.0

