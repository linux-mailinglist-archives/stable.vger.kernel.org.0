Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DA51063B9
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbfKVF4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729068AbfKVF4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 616132068F;
        Fri, 22 Nov 2019 05:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402175;
        bh=iWavPtoQLOSSTlzUivcfOo7w+HA+x4lZreoVizmD2gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JN03wTXroQtv/e4whKvDsLurZU2/B2cg5tSdVU+KaeJR24lLS1N0Mgc2/xWuiXCdx
         uoQNjW+u+GKwwGzpXuwbPtX8ymtVwIIXFnCupyeAp6ixcPYtZgbEBxseEhX6gz1Tzu
         lFw7YUnf35ggYmzj+Srf36nrzVtAXy4fy/KnjPvM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 027/127] kvm: vmx: Set IA32_TSC_AUX for legacy mode guests
Date:   Fri, 22 Nov 2019 00:54:05 -0500
Message-Id: <20191122055544.3299-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 0023ef39dc35c773c436eaa46ca539a26b308b55 ]

RDTSCP is supported in legacy mode as well as long mode. The
IA32_TSC_AUX MSR should be set to the correct guest value before
entering any guest that supports RDTSCP.

Fixes: 4e47c7a6d714 ("KVM: VMX: Add instruction rdtscp support for guest")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index cd5a8e888eb6b..df37901f4a435 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2818,9 +2818,6 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		index = __find_msr_index(vmx, MSR_CSTAR);
 		if (index >= 0)
 			move_msr_up(vmx, index, save_nmsrs++);
-		index = __find_msr_index(vmx, MSR_TSC_AUX);
-		if (index >= 0 && guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
-			move_msr_up(vmx, index, save_nmsrs++);
 		/*
 		 * MSR_STAR is only needed on long mode guests, and only
 		 * if efer.sce is enabled.
@@ -2833,6 +2830,9 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	index = __find_msr_index(vmx, MSR_EFER);
 	if (index >= 0 && update_transition_efer(vmx, index))
 		move_msr_up(vmx, index, save_nmsrs++);
+	index = __find_msr_index(vmx, MSR_TSC_AUX);
+	if (index >= 0 && guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
+		move_msr_up(vmx, index, save_nmsrs++);
 
 	vmx->save_nmsrs = save_nmsrs;
 
-- 
2.20.1

