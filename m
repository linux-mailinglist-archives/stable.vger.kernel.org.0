Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBB04AFC5A
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiBIS5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241450AbiBIS5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:57:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E28C050CD3;
        Wed,  9 Feb 2022 10:57:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 986E8B82386;
        Wed,  9 Feb 2022 18:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131B0C340EE;
        Wed,  9 Feb 2022 18:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644433032;
        bh=TyD2aMjxLMkZUzR4ycHZFT9SUVAGZ7tCb5EfJ04mpnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVblF0VZsjEITi4STb8jsL+0lu7RM6DApmzo9wYvxk2X2v2LX0ZySTZqg75Y5RQIm
         caGhRbAoSOFEIUbTvPs8Rh5bG0bWzqUQjOhhXLU10GQ2PQBsWKFEHga4AnffFfdPlI
         bMy4a118D9PDDRS3GBCf96glWKMcdjvq1vIqGGdwfqD5beGUqdbkdidMQbF12egXp8
         oCQiK+MflocQsq+k+EBjaDTnfggvzTVLhbiHSPRNIyZ1rdVLKIST3LQbXYkg2+kOwC
         0C52XpAzVZBvELAjThRK3fg0ASmNPuk16k1gGntVxI5kibBKB0TfzITS4r9HqHOCiU
         0ee55MS8RFL0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 8/8] KVM: x86: Report deprecated x87 features in supported CPUID
Date:   Wed,  9 Feb 2022 13:56:53 -0500
Message-Id: <20220209185653.48833-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209185653.48833-1-sashal@kernel.org>
References: <20220209185653.48833-1-sashal@kernel.org>
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
index f666fd79d8ad6..5f1d4a5aa8716 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -421,12 +421,13 @@ void kvm_set_cpu_caps(void)
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

