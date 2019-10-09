Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AD1D167F
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732136AbfJIRYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732123AbfJIRYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:07 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5138121D56;
        Wed,  9 Oct 2019 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641846;
        bh=HAqjkv96qKv96CwQ5QSUQj+MIDryYPeFAPctadqPLWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOxDhkKVnj3odCphIalpV3WZkRRMqBTYo9k1d7WW1zMLBlNKvrm2h0WRdothKD550
         oNXZg1AXyI/QNL/ICXK7m0HjgyFp1gZLsViCpskzqWGHPrpIPLshDw0yDE/lVy9hYh
         OmYzCNJ7P9VEy6y+SL5oafeYz1t7K1Z/lMxgf1OE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/26] kvm: x86: Use AMD CPUID semantics for AMD vCPUs
Date:   Wed,  9 Oct 2019 13:05:41 -0400
Message-Id: <20191009170558.32517-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 5f41a37b151f6459e0b650a2f4d1d59b6c02d1ab ]

When the guest CPUID information represents an AMD vCPU, return all
zeroes for queries of undefined CPUID leaves, whether or not they are
in range.

Signed-off-by: Jim Mattson <jmattson@google.com>
Fixes: bd22f5cfcfe8f6 ("KVM: move and fix substitue search for missing CPUID entries")
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jacob Xu <jacobhxu@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/cpuid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ada2cae6bec51..0854a2a32a61a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -916,9 +916,11 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	/*
 	 * Intel CPUID semantics treats any query for an out-of-range
 	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
-	 * requested.
+	 * requested. AMD CPUID semantics returns all zeroes for any
+	 * undefined leaf, whether or not the leaf is in range.
 	 */
-	if (!entry && check_limit && !cpuid_function_in_range(vcpu, function)) {
+	if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
+	    !cpuid_function_in_range(vcpu, function)) {
 		max = kvm_find_cpuid_entry(vcpu, 0, 0);
 		if (max) {
 			function = max->eax;
-- 
2.20.1

