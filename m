Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04EC7383F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388122AbfGXT1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbfGXT13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:27:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45334229F4;
        Wed, 24 Jul 2019 19:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996448;
        bh=v3MjKObhyjpXhE1fPrp9pGxjjW+gNYX6LJYKcyoeLh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHv/xLdOjlqst6gp4nJtg++H+5a7xFKnPzqSY8MnpgAk8Z0iMXtueBnzOQltaHHL2
         o4ZES4DZtIefm0/Y8oqIsRhxp7hU5c7c3E9dTDLGkU3pclN0qXdx9cd9o0pTy1W2ic
         25n5JC3OV64tZwGhEPOngBDQpkk+lRfpGjrsW/MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        Borislav Petkov <bp@suse.de>,
        Jim Mattson <jmattson@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        marcorr@google.com, Peter Feiner <pfeiner@google.com>,
        pshier@google.com, Robert Hoo <robert.hu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 100/413] x86/cpufeatures: Add FDP_EXCPTN_ONLY and ZERO_FCS_FDS
Date:   Wed, 24 Jul 2019 21:16:31 +0200
Message-Id: <20190724191742.316204840@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cbb99c0f588737ec98c333558922ce47e9a95827 ]

Add the CPUID enumeration for Intel's de-feature bits to accommodate
passing these de-features through to kvm guests.

These de-features are (from SDM vol 1, section 8.1.8):
 - X86_FEATURE_FDP_EXCPTN_ONLY: If CPUID.(EAX=07H,ECX=0H):EBX[bit 6] = 1, the
   data pointer (FDP) is updated only for the x87 non-control instructions that
   incur unmasked x87 exceptions.
 - X86_FEATURE_ZERO_FCS_FDS: If CPUID.(EAX=07H,ECX=0H):EBX[bit 13] = 1, the
   processor deprecates FCS and FDS; it saves each as 0000H.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jim Mattson <jmattson@google.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: marcorr@google.com
Cc: Peter Feiner <pfeiner@google.com>
Cc: pshier@google.com
Cc: Robert Hoo <robert.hu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190605220252.103406-1-aaronlewis@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpufeatures.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 75f27ee2c263..1017b9c7dfe0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -239,12 +239,14 @@
 #define X86_FEATURE_BMI1		( 9*32+ 3) /* 1st group bit manipulation extensions */
 #define X86_FEATURE_HLE			( 9*32+ 4) /* Hardware Lock Elision */
 #define X86_FEATURE_AVX2		( 9*32+ 5) /* AVX2 instructions */
+#define X86_FEATURE_FDP_EXCPTN_ONLY	( 9*32+ 6) /* "" FPU data pointer updated only on x87 exceptions */
 #define X86_FEATURE_SMEP		( 9*32+ 7) /* Supervisor Mode Execution Protection */
 #define X86_FEATURE_BMI2		( 9*32+ 8) /* 2nd group bit manipulation extensions */
 #define X86_FEATURE_ERMS		( 9*32+ 9) /* Enhanced REP MOVSB/STOSB instructions */
 #define X86_FEATURE_INVPCID		( 9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM			( 9*32+11) /* Restricted Transactional Memory */
 #define X86_FEATURE_CQM			( 9*32+12) /* Cache QoS Monitoring */
+#define X86_FEATURE_ZERO_FCS_FDS	( 9*32+13) /* "" Zero out FPU CS and FPU DS */
 #define X86_FEATURE_MPX			( 9*32+14) /* Memory Protection Extension */
 #define X86_FEATURE_RDT_A		( 9*32+15) /* Resource Director Technology Allocation */
 #define X86_FEATURE_AVX512F		( 9*32+16) /* AVX-512 Foundation */
-- 
2.20.1



