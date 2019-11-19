Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED299101566
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbfKSFnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730769AbfKSFno (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:43:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C77C4208C3;
        Tue, 19 Nov 2019 05:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142223;
        bh=uFYtVesS3MC9XWROJCmhlCYgG2yMpnMYd8ym5gj7WUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUzLzreLS7vhiW1HkXsKSzvU19Zo9fSGS8w7Sl4wD/y8ZnL2mjJlgy8bSPIVbhV5N
         ZMlZ1AKqeGNqPrRNs5gcyrbo8AK/NppCRlwOg+UboQGc5oguMPTXOcViHE+7RkANi9
         bf8CZE7GxGcy2NSQH6lnb5tFXvFCiBVsItsQ5E+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 001/239] kvm: mmu: Dont read PDPTEs when paging is not enabled
Date:   Tue, 19 Nov 2019 06:16:41 +0100
Message-Id: <20191119051256.186094158@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

[ Upstream commit d35b34a9a70edae7ef923f100e51b8b5ae9fe899 ]

kvm should not attempt to read guest PDPTEs when CR0.PG = 0 and
CR4.PAE = 1.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dcee3282112dc..dc1b6d5bb16d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -620,7 +620,7 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int r;
 
-	if (is_long_mode(vcpu) || !is_pae(vcpu))
+	if (is_long_mode(vcpu) || !is_pae(vcpu) || !is_paging(vcpu))
 		return false;
 
 	if (!test_bit(VCPU_EXREG_PDPTR,
@@ -7787,7 +7787,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		kvm_update_cpuid(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (!is_long_mode(vcpu) && is_pae(vcpu)) {
+	if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		mmu_reset_needed = 1;
 	}
-- 
2.20.1



