Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6B445E4DE
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357656AbhKZChb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357593AbhKZCfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:35:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E6A161139;
        Fri, 26 Nov 2021 02:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893932;
        bh=JBW4JTVIlBnnJCqUHHYMsHk8WInP0PA4aJaeMp0KjqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LI0P/qzrSERA/78qiAdCZTvXgS7BMr8kx3/l2IfNIXdNmzx0Aow1HY0Eeo3CxuC2B
         6vDiIELBUZCjvThxiBGcu/CH0ycfxajLNcxg4XO+4LNlKxpAwbXsMT5/7G0EyceQv1
         HvfPirArAX8akAo6cI+0aZi0Z+wJ7Sx3c//Dk7NjRLhusuIWfO3lnwoiyRBmxe0CwR
         bJL0VI3fbSU6RVE9R8OVxTrrMddDxLRO47K2H1hVE8c+1GGIH1j62TuXYMhaN7DhUt
         q7heiPXxVytLq9jvoCZL/XiyVb15pW4vNekVEdvmcRT4Y/C54cefWbhIw/bROgRiD3
         nkHYqRIKBZJKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/39] x86/hyperv: Move required MSRs check to initial platform probing
Date:   Thu, 25 Nov 2021 21:31:25 -0500
Message-Id: <20211126023156.441292-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit f3e613e72f66226b3bea1046c1b864f67a3000a4 ]

Explicitly check for MSR_HYPERCALL and MSR_VP_INDEX support when probing
for running as a Hyper-V guest instead of waiting until hyperv_init() to
detect the bogus configuration.  Add messages to give the admin a heads
up that they are likely running on a broken virtual machine setup.

At best, silently disabling Hyper-V is confusing and difficult to debug,
e.g. the kernel _says_ it's using all these fancy Hyper-V features, but
always falls back to the native versions.  At worst, the half baked setup
will crash/hang the kernel.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20211104182239.1302956-3-seanjc@google.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c      |  9 +--------
 arch/x86/kernel/cpu/mshyperv.c | 20 +++++++++++++++-----
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 179fc173104d7..3f66ed2c53729 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -345,20 +345,13 @@ static void __init hv_get_partition_id(void)
  */
 void __init hyperv_init(void)
 {
-	u64 guest_id, required_msrs;
+	u64 guest_id;
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 	int cpuhp;
 
 	if (x86_hyper_type != X86_HYPER_MS_HYPERV)
 		return;
 
-	/* Absolutely required MSRs */
-	required_msrs = HV_MSR_HYPERCALL_AVAILABLE |
-		HV_MSR_VP_INDEX_AVAILABLE;
-
-	if ((ms_hyperv.features & required_msrs) != required_msrs)
-		return;
-
 	if (hv_common_init())
 		return;
 
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index e095c28d27ae8..ef6316fef99ff 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -163,12 +163,22 @@ static uint32_t  __init ms_hyperv_platform(void)
 	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
 	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
 
-	if (eax >= HYPERV_CPUID_MIN &&
-	    eax <= HYPERV_CPUID_MAX &&
-	    !memcmp("Microsoft Hv", hyp_signature, 12))
-		return HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS;
+	if (eax < HYPERV_CPUID_MIN || eax > HYPERV_CPUID_MAX ||
+	    memcmp("Microsoft Hv", hyp_signature, 12))
+		return 0;
 
-	return 0;
+	/* HYPERCALL and VP_INDEX MSRs are mandatory for all features. */
+	eax = cpuid_eax(HYPERV_CPUID_FEATURES);
+	if (!(eax & HV_MSR_HYPERCALL_AVAILABLE)) {
+		pr_warn("x86/hyperv: HYPERCALL MSR not available.\n");
+		return 0;
+	}
+	if (!(eax & HV_MSR_VP_INDEX_AVAILABLE)) {
+		pr_warn("x86/hyperv: VP_INDEX MSR not available.\n");
+		return 0;
+	}
+
+	return HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS;
 }
 
 static unsigned char hv_get_nmi_reason(void)
-- 
2.33.0

