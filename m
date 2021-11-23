Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F1245A81A
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhKWQjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:39:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhKWQjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:39:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D62460F5B;
        Tue, 23 Nov 2021 16:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685393;
        bh=1R0zsu4H5A+ZuUIKxOYTw4swgSvG7ut4s6Ae6qoVmk8=;
        h=From:To:Cc:Subject:Date:From;
        b=WzA5Cz2183rs9ybhXice3LaJR8BnXjhYm0I2SO8K2Exk5fmsFSS82K0iL5N2N/XX0
         PTLrtbyy6pVYOj8MmRa+6D02LhxbrMR9/9rMMCQWxe/X0WG5zkKr/XM2hgegwKEOWE
         IzDNrsMhNop5bwX4OBuU+hUU8ehSF17YhLaWrgzBW6/UMEfFb3bchLVkVl3TuV0IVm
         lXV6DhqgwRcbujzFBqPpUD0yhoIIXsAvBzBMwhEbxAFIRgK9xkbPRK9E/eAQVb9AR3
         iMFY6jLVk6jv3IoOsTmuf988H3uqD0kozlDSM7LQoMsPXOwa93MITtkLnaObog8WfR
         6SeTKwyBFyysQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 1/8] KVM: X86: Fix tlb flush for tdp in kvm_invalidate_pcid()
Date:   Tue, 23 Nov 2021 11:36:23 -0500
Message-Id: <20211123163630.289306-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit e45e9e3998f0001079b09555db5bb3b4257f6746 ]

The KVM doesn't know whether any TLB for a specific pcid is cached in
the CPU when tdp is enabled.  So it is better to flush all the guest
TLB when invalidating any single PCID context.

The case is very rare or even impossible since KVM generally doesn't
intercept CR3 write or INVPCID instructions when tdp is enabled, so the
fix is mostly for the sake of overall robustness.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20211019110154.4091-2-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c48e2b5729c5d..0644f429f848c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1091,6 +1091,18 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 	unsigned long roots_to_free = 0;
 	int i;
 
+	/*
+	 * MOV CR3 and INVPCID are usually not intercepted when using TDP, but
+	 * this is reachable when running EPT=1 and unrestricted_guest=0,  and
+	 * also via the emulator.  KVM's TDP page tables are not in the scope of
+	 * the invalidation, but the guest's TLB entries need to be flushed as
+	 * the CPU may have cached entries in its TLB for the target PCID.
+	 */
+	if (unlikely(tdp_enabled)) {
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+		return;
+	}
+
 	/*
 	 * If neither the current CR3 nor any of the prev_roots use the given
 	 * PCID, then nothing needs to be done here because a resync will
-- 
2.33.0

