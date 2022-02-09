Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB114AFC31
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbiBIS5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241386AbiBIS4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:56:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597B9C05CB86;
        Wed,  9 Feb 2022 10:56:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECB10612CC;
        Wed,  9 Feb 2022 18:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31742C36AE2;
        Wed,  9 Feb 2022 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644433011;
        bh=ZUacl007zA4k+q0kyD4PfVFmSEOT8YIduCKetp5Er64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQhukoaaJP/aHyWmZAJnnEX/9nEMcJbnH8EBAR4Hwq1rdJ+O73fnWf3e7dZS95+rc
         yDNxxC6TbCrDU06NNV1VN2q9FkDLB4A33RbQyIdb1TviiZOR3XVARqmBebTfxC7DRP
         YVkxqySQjnHM1kxX2dBX1eINb20L0mOozThi8WRhRyNiiW/BPQzPvMDAx9UdFdO6qi
         1aSw6yoYdAC19VZU8Icy14EhJQ8sMPjHqaR+MmH+A3g2fNhWNHK5ZKzgW7BCP46sCZ
         dYFquRl7v/nPglFs3gkAHFzhpE8yn25WD0hqfo2awdCGTMhEwXLMeRMsXNf7XkNUGJ
         8JmcQ3vOBoOhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.16 8/8] KVM: x86: Report deprecated x87 features in supported CPUID
Date:   Wed,  9 Feb 2022 13:56:34 -0500
Message-Id: <20220209185635.48730-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209185635.48730-1-sashal@kernel.org>
References: <20220209185635.48730-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit e3bcfda012edd3564e12551b212afbd2521a1f68 ]

CPUID.(EAX=7,ECX=0):EBX.FDP_EXCPTN_ONLY[bit 6] and
CPUID.(EAX=7,ECX=0):EBX.ZERO_FCS_FDS[bit 13] are "defeature"
bits. Unlike most of the other CPUID feature bits, these bits are
clear if the features are present and set if the features are not
present. These bits should be reported in KVM_GET_SUPPORTED_CPUID,
because if these bits are set on hardware, they cannot be cleared in
the guest CPUID. Doing so would claim guest support for a feature that
the hardware doesn't support and that can't be efficiently emulated.

Of course, any software (e.g WIN87EM.DLL) expecting these features to
be present likely predates these CPUID feature bits and therefore
doesn't know to check for them anyway.

Aaron Lewis added the corresponding X86_FEATURE macros in
commit cbb99c0f5887 ("x86/cpufeatures: Add FDP_EXCPTN_ONLY and
ZERO_FCS_FDS"), with the intention of reporting these bits in
KVM_GET_SUPPORTED_CPUID, but I was unable to find a proposed patch on
the kvm list.

Opportunistically reordered the CPUID_7_0_EBX capability bits from
least to most significant.

Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220204001348.2844660-1-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/cpuid.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index add8f58d686e3..bf18679757c70 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -532,12 +532,13 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_mask(CPUID_7_0_EBX,
-		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | F(INVPCID) | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
-		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
-		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
-		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | 0 /*INTEL_PT*/
-	);
+		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
+		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
+		F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ | F(AVX512F) |
+		F(AVX512DQ) | F(RDSEED) | F(ADX) | F(SMAP) | F(AVX512IFMA) |
+		F(CLFLUSHOPT) | F(CLWB) | 0 /*INTEL_PT*/ | F(AVX512PF) |
+		F(AVX512ER) | F(AVX512CD) | F(SHA_NI) | F(AVX512BW) |
+		F(AVX512VL));
 
 	kvm_cpu_cap_mask(CPUID_7_ECX,
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
-- 
2.34.1

