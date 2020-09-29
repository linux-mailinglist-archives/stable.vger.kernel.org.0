Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE19C27C797
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgI2Lo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbgI2Lox (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:44:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B31520848;
        Tue, 29 Sep 2020 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379892;
        bh=QKWN6eEUdnGboyRwpunwS/G7k1RbvwEE0JzI58gN0zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u48nIqtnXyIP7kbrkpjOyQPRpZJVTzGj24NRjTaoBWt0U2LAwxdpTr9tqmP09vBIC
         5mbOpmDEjhwxmiXBmNnyp1CeSnu0Ug8mPAF9zLifm2tX6U6sEKcz2F+kFMSLlcKYgA
         ARaQruGRwwkN66H25hCKO1UuPCyOBSuRNpiq/sSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 364/388] KVM: x86: Reset MMU context if guest toggles CR4.SMAP or CR4.PKE
Date:   Tue, 29 Sep 2020 13:01:35 +0200
Message-Id: <20200929110028.089026312@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit 8d214c481611b29458a57913bd786f0ac06f0605 ]

Reset the MMU context during kvm_set_cr4() if SMAP or PKE is toggled.
Recent commits to (correctly) not reload PDPTRs when SMAP/PKE are
toggled inadvertantly skipped the MMU context reset due to the mask
of bits that triggers PDPTR loads also being used to trigger MMU context
resets.

Fixes: 427890aff855 ("kvm: x86: Toggling CR4.SMAP does not load PDPTEs in PAE mode")
Fixes: cb957adb4ea4 ("kvm: x86: Toggling CR4.PKE does not load PDPTEs in PAE mode")
Cc: Jim Mattson <jmattson@google.com>
Cc: Peter Shier <pshier@google.com>
Cc: Oliver Upton <oupton@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200923215352.17756-1-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 67ad417a29ca4..12e83297ea020 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -973,6 +973,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
 				   X86_CR4_SMEP;
+	unsigned long mmu_role_bits = pdptr_bits | X86_CR4_SMAP | X86_CR4_PKE;
 
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
@@ -1000,7 +1001,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (kvm_x86_ops->set_cr4(vcpu, cr4))
 		return 1;
 
-	if (((cr4 ^ old_cr4) & pdptr_bits) ||
+	if (((cr4 ^ old_cr4) & mmu_role_bits) ||
 	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
 		kvm_mmu_reset_context(vcpu);
 
-- 
2.25.1



