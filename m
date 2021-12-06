Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A771469D46
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377425AbhLFP2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41162 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347052AbhLFPYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF55061328;
        Mon,  6 Dec 2021 15:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F88C341C5;
        Mon,  6 Dec 2021 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804083;
        bh=hQyTUfjEScAoD/ZE+L9HMWzpB6mgkVPAkpeRka90jZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3Af0OcMJrYMYPF/sDvnQDfvq5rNwgQEPwIP0w5Raoew9/4XTqDPPiYFmwWdVFjbs
         DC/ZD0ijvi6BTe/YNjJT34VdHekzul/pyG8mFkDRUbS012gcT78Tjth07fmK6COq/I
         bv/gkwWXd2ypFlffTit20b7aI4Hg4FeeU7KxZrTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/207] x86/hyperv: Move required MSRs check to initial platform probing
Date:   Mon,  6 Dec 2021 15:54:34 +0100
Message-Id: <20211206145610.900057280@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d20eef3d452a5..b6d48ca5b0f17 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -348,20 +348,13 @@ static void __init hv_get_partition_id(void)
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



