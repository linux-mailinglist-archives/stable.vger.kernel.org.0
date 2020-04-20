Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C892C1B0A8F
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgDTMtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgDTMtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:49:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47C82206E9;
        Mon, 20 Apr 2020 12:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386940;
        bh=Rqx7MWgS7q50vCw/8VlakyRZJXCOTVBhhrcAPRxbAwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtgRVRvBHkDL5iLoquCx8u6meXowlUrIkLjnc9TDvoENRkOO0Ee2vo/qcyewetW0j
         hKMnUOBJXtGHil75rs/RaenecGAcjEFTCK6OS9LzqMg5Y7LnPORoMNrFpzj7J8m3vh
         0blC3EHVEZhihovwyGdun9vbuE1ziFzbOPpJ5xbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/40] kvm: x86: Host feature SSBD doesnt imply guest feature SPEC_CTRL_SSBD
Date:   Mon, 20 Apr 2020 14:39:39 +0200
Message-Id: <20200420121503.511127673@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

commit 396d2e878f92ec108e4293f1c77ea3bc90b414ff upstream.

The host reports support for the synthetic feature X86_FEATURE_SSBD
when any of the three following hardware features are set:
  CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31]
  CPUID.80000008H:EBX.AMD_SSBD[bit 24]
  CPUID.80000008H:EBX.VIRT_SSBD[bit 25]

Either of the first two hardware features implies the existence of the
IA32_SPEC_CTRL MSR, but CPUID.80000008H:EBX.VIRT_SSBD[bit 25] does
not. Therefore, CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31] should only be
set in the guest if CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31] or
CPUID.80000008H:EBX.AMD_SSBD[bit 24] is set on the host.

Fixes: 0c54914d0c52a ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Jacob Xu <jacobhxu@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 4.x: adjust indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 48c24d0e9e75c..1fe9ccabc082a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -509,7 +509,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 				entry->edx |= F(SPEC_CTRL);
 			if (boot_cpu_has(X86_FEATURE_STIBP))
 				entry->edx |= F(INTEL_STIBP);
-			if (boot_cpu_has(X86_FEATURE_SSBD))
+			if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+			    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 				entry->edx |= F(SPEC_CTRL_SSBD);
 			/*
 			 * We emulate ARCH_CAPABILITIES in software even
-- 
2.20.1



