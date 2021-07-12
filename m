Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1673C4D59
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242276AbhGLHMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244188AbhGLHK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F536613D0;
        Mon, 12 Jul 2021 07:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073615;
        bh=T6NX1U575lJXClTcLuQEFii2Y/SyCBgpuluINec1QjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2mLG8PzSIINJyZ0mGC0qQBQJOlXnn0OKnniB/70Y+WrhEBG6d9QiCuGzN7mbA1I3
         9ImEEn9CfNJJqlj8azlmsA846pGTp4Kq2OARovaocbaZ2HJhYgPyUDIxUhdtjqsmmZ
         EThHspo93UwrC9NRX5WQJeK1Q8hz/1nxGHzdrKoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 299/700] KVM: nVMX: Dont clobber nested MMUs A/D status on EPTP switch
Date:   Mon, 12 Jul 2021 08:06:22 +0200
Message-Id: <20210712061008.175289683@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 272b0a998d084e7667284bdd2d0c675c6a2d11de ]

Drop bogus logic that incorrectly clobbers the accessed/dirty enabling
status of the nested MMU on an EPTP switch.  When nested EPT is enabled,
walk_mmu points at L2's _legacy_ page tables, not L1's EPT for L2.

This is likely a benign bug, as mmu->ept_ad is never consumed (since the
MMU is not a nested EPT MMU), and stuffing mmu_role.base.ad_disabled will
never propagate into future shadow pages since the nested MMU isn't used
to map anything, just to walk L2's page tables.

Note, KVM also does a full MMU reload, i.e. the guest_mmu will be
recreated using the new EPTP, and thus any change in A/D enabling will be
properly recognized in the relevant MMU.

Fixes: 41ab93727467 ("KVM: nVMX: Emulate EPTP switching for the L1 hypervisor")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210609234235.1244004-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d3774d79916d..618dcf11d688 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5472,8 +5472,6 @@ static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 {
 	u32 index = kvm_rcx_read(vcpu);
 	u64 new_eptp;
-	bool accessed_dirty;
-	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
 	if (!nested_cpu_has_eptp_switching(vmcs12) ||
 	    !nested_cpu_has_ept(vmcs12))
@@ -5482,13 +5480,10 @@ static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 	if (index >= VMFUNC_EPTP_ENTRIES)
 		return 1;
 
-
 	if (kvm_vcpu_read_guest_page(vcpu, vmcs12->eptp_list_address >> PAGE_SHIFT,
 				     &new_eptp, index * 8, 8))
 		return 1;
 
-	accessed_dirty = !!(new_eptp & VMX_EPTP_AD_ENABLE_BIT);
-
 	/*
 	 * If the (L2) guest does a vmfunc to the currently
 	 * active ept pointer, we don't have to do anything else
@@ -5497,8 +5492,6 @@ static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 		if (!nested_vmx_check_eptp(vcpu, new_eptp))
 			return 1;
 
-		mmu->ept_ad = accessed_dirty;
-		mmu->mmu_role.base.ad_disabled = !accessed_dirty;
 		vmcs12->ept_pointer = new_eptp;
 
 		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
-- 
2.30.2



