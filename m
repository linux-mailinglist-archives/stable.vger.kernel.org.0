Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3041B685D
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgDWXOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:14:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49834 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728444AbgDWXGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-0004hp-Ev; Fri, 24 Apr 2020 00:06:36 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvR-00E6pi-Iv; Fri, 24 Apr 2020 00:06:33 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter Shier" <pshier@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Jacob Xu" <jacobhxu@google.com>,
        "Eric Biggers" <ebiggers@kernel.org>,
        "Jim Mattson" <jmattson@google.com>
Date:   Fri, 24 Apr 2020 00:06:00 +0100
Message-ID: <lsq.1587683028.442053405@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 133/245] kvm: x86: Host feature SSBD doesn't imply
 guest feature SPEC_CTRL_SSBD
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16: adjust indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -400,7 +400,8 @@ static inline int __do_cpuid_ent(struct
 				entry->edx |= F(SPEC_CTRL);
 			if (boot_cpu_has(X86_FEATURE_STIBP))
 				entry->edx |= F(INTEL_STIBP);
-			if (boot_cpu_has(X86_FEATURE_SSBD))
+			if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+			    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 				entry->edx |= F(SPEC_CTRL_SSBD);
 			/*
 			 * We emulate ARCH_CAPABILITIES in software even

