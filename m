Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C4F6947C
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbfGOObd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388927AbfGOObd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:31:33 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 972712086C;
        Mon, 15 Jul 2019 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201092;
        bh=Dt1XW2Wj4UkA3O8cjRveBiHK9T1bNOVNtGlcV9g/pHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hF5j2OdurPFk6CaA1qExxlMqRb2O1c3k0CvUomaLSnng8vI6y27JIByMss+s4YsN9
         TBsQJjS2i78NxaSSCnEVkyDc+jUfxw8bs8QJoHV0UsDTE62saM/uRW3fVp6ugG3m8o
         VPo0sptRTJWex2kUFAPh/1/jMf62nFyXhEKARNTU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>, Borislav Petkov <bp@suse.de>,
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
Subject: [PATCH AUTOSEL 4.14 049/105] x86/cpufeatures: Add FDP_EXCPTN_ONLY and ZERO_FCS_FDS
Date:   Mon, 15 Jul 2019 10:27:43 -0400
Message-Id: <20190715142839.9896-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

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
index 48ef9ed8226d..4cb8315c521f 100644
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

