Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA2A1065E6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfKVFuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:50:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727641AbfKVFuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AC032071F;
        Fri, 22 Nov 2019 05:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401822;
        bh=aIreNybQBUOhPhlkhTivozD7PYWy/npCatGkOK+9Qts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ew6YzckOKUir05Fd/7CbZiZtz3PGIb1sRz3aac4KJDMGasJa6r2uB1JcLPbuqR9L6
         On/ziIcFYJQd4MjOFEWLElRveQAPQCHGhKt7C2IPqYvLC47GXHa8aLWhOttjYWpBrl
         fAd8Y6BS3t0Ou9CPr2NXMm/OucnNBqiS3TwxY2zc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 065/219] kvm: vmx: Set IA32_TSC_AUX for legacy mode guests
Date:   Fri, 22 Nov 2019 00:46:37 -0500
Message-Id: <20191122054911.1750-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
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
index 4eda2a9c234a6..b892f345f6317 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3404,9 +3404,6 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		index = __find_msr_index(vmx, MSR_CSTAR);
 		if (index >= 0)
 			move_msr_up(vmx, index, save_nmsrs++);
-		index = __find_msr_index(vmx, MSR_TSC_AUX);
-		if (index >= 0 && guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
-			move_msr_up(vmx, index, save_nmsrs++);
 		/*
 		 * MSR_STAR is only needed on long mode guests, and only
 		 * if efer.sce is enabled.
@@ -3419,6 +3416,9 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	index = __find_msr_index(vmx, MSR_EFER);
 	if (index >= 0 && update_transition_efer(vmx, index))
 		move_msr_up(vmx, index, save_nmsrs++);
+	index = __find_msr_index(vmx, MSR_TSC_AUX);
+	if (index >= 0 && guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
+		move_msr_up(vmx, index, save_nmsrs++);
 
 	vmx->save_nmsrs = save_nmsrs;
 	vmx->guest_msrs_dirty = true;
-- 
2.20.1

