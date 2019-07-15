Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E459468B8F
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730606AbfGONit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730576AbfGONir (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:38:47 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A92E52086C;
        Mon, 15 Jul 2019 13:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563197926;
        bh=UgBnm5CqekNXx0XvATMnra5j8zwoiHPfhNR+FXV/lhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ck6Yqt6hysXXKSiZNIKZunnoZZOLsqXQXStAhSr4Ltsl4X/a16waUhsAXxL4jSLtu
         tXPnJEK9auo3873FwnaM3MGhewsVrrPBeI3p08nQ606c18z7s+5uCld3JaD7yn9TL7
         D9FA5NoQXzLYxO74Lh1ijE11mxOE6MezocFk/2zI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Drake <drake@endlessm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, len.brown@intel.com,
        linux@endlessm.com, rafael.j.wysocki@intel.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 013/219] x86/tsc: Use CPUID.0x16 to calculate missing crystal frequency
Date:   Mon, 15 Jul 2019 09:34:45 -0400
Message-Id: <20190715133811.2441-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715133811.2441-1-sashal@kernel.org>
References: <20190715133811.2441-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Drake <drake@endlessm.com>

[ Upstream commit 604dc9170f2435d27da5039a3efd757dceadc684 ]

native_calibrate_tsc() had a data mapping Intel CPU families
and crystal clock speed, but hardcoded tables are not ideal, and this
approach was already problematic at least in the Skylake X case, as
seen in commit:

  b51120309348 ("x86/tsc: Fix erroneous TSC rate on Skylake Xeon")

By examining CPUID data from http://instlatx64.atw.hu/ and units
in the lab, we have found that 3 different scenarios need to be dealt
with, and we can eliminate most of the hardcoded data using an approach a
little more advanced than before:

 1. ApolloLake, GeminiLake, CannonLake (and presumably all new chipsets
    from this point) report the crystal frequency directly via CPUID.0x15.
    That's definitive data that we can rely upon.

 2. Skylake, Kabylake and all variants of those two chipsets report a
    crystal frequency of zero, however we can calculate the crystal clock
    speed by condidering data from CPUID.0x16.

    This method correctly distinguishes between the two crystal clock
    frequencies present on different Skylake X variants that caused
    headaches before.

    As the calculations do not quite match the previously-hardcoded values
    in some cases (e.g. 23913043Hz instead of 24MHz), TSC refinement is
    enabled on all platforms where we had to calculate the crystal
    frequency in this way.

 3. Denverton (GOLDMONT_X) reports a crystal frequency of zero and does
    not support CPUID.0x16, so we leave this entry hardcoded.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Daniel Drake <drake@endlessm.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: len.brown@intel.com
Cc: linux@endlessm.com
Cc: rafael.j.wysocki@intel.com
Link: http://lkml.kernel.org/r/20190509055417.13152-1-drake@endlessm.com
Link: https://lkml.kernel.org/r/20190419083533.32388-1-drake@endlessm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/tsc.c | 47 +++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 3fae23834069..12e5af305abd 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -629,31 +629,38 @@ unsigned long native_calibrate_tsc(void)
 
 	crystal_khz = ecx_hz / 1000;
 
-	if (crystal_khz == 0) {
-		switch (boot_cpu_data.x86_model) {
-		case INTEL_FAM6_SKYLAKE_MOBILE:
-		case INTEL_FAM6_SKYLAKE_DESKTOP:
-		case INTEL_FAM6_KABYLAKE_MOBILE:
-		case INTEL_FAM6_KABYLAKE_DESKTOP:
-			crystal_khz = 24000;	/* 24.0 MHz */
-			break;
-		case INTEL_FAM6_ATOM_GOLDMONT_X:
-			crystal_khz = 25000;	/* 25.0 MHz */
-			break;
-		case INTEL_FAM6_ATOM_GOLDMONT:
-			crystal_khz = 19200;	/* 19.2 MHz */
-			break;
-		}
-	}
+	/*
+	 * Denverton SoCs don't report crystal clock, and also don't support
+	 * CPUID.0x16 for the calculation below, so hardcode the 25MHz crystal
+	 * clock.
+	 */
+	if (crystal_khz == 0 &&
+			boot_cpu_data.x86_model == INTEL_FAM6_ATOM_GOLDMONT_X)
+		crystal_khz = 25000;
 
-	if (crystal_khz == 0)
-		return 0;
 	/*
-	 * TSC frequency determined by CPUID is a "hardware reported"
+	 * TSC frequency reported directly by CPUID is a "hardware reported"
 	 * frequency and is the most accurate one so far we have. This
 	 * is considered a known frequency.
 	 */
-	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+	if (crystal_khz != 0)
+		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+
+	/*
+	 * Some Intel SoCs like Skylake and Kabylake don't report the crystal
+	 * clock, but we can easily calculate it to a high degree of accuracy
+	 * by considering the crystal ratio and the CPU speed.
+	 */
+	if (crystal_khz == 0 && boot_cpu_data.cpuid_level >= 0x16) {
+		unsigned int eax_base_mhz, ebx, ecx, edx;
+
+		cpuid(0x16, &eax_base_mhz, &ebx, &ecx, &edx);
+		crystal_khz = eax_base_mhz * 1000 *
+			eax_denominator / ebx_numerator;
+	}
+
+	if (crystal_khz == 0)
+		return 0;
 
 	/*
 	 * For Atom SoCs TSC is the only reliable clocksource.
-- 
2.20.1

