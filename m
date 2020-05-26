Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0731B1AC936
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406687AbgDPPU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898663AbgDPNrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:47:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B48921974;
        Thu, 16 Apr 2020 13:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044840;
        bh=KAASmrYb++HJPA3aAIxo3b3Wo1cOBCFKWgeDuqpjtIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6Sa3s4VnQhbOXnExnEe/6fihqwYHRgKAaKiH7PRRFbHE1a3w68wpRGMTq0IBh5bo
         RFleNkX06d2bzBalOOyde7/CEk3taowQ2IGdc9oNWJIvAUuvbbXXgM5eXBA+1qY7X6
         dkNiDzOhKNcnMXTVhEy2qxHawYKNycM8QYtXDQDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vipul Kumar <vipulk0511@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.4 122/232] x86/tsc_msr: Make MSR derived TSC frequency more accurate
Date:   Thu, 16 Apr 2020 15:23:36 +0200
Message-Id: <20200416131330.358311582@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit fac01d11722c92a186b27ee26cd429a8066adfb5 upstream.

The "Intel 64 and IA-32 Architectures Software Developer’s Manual Volume 4:
Model-Specific Registers" has the following table for the values from
freq_desc_byt:

   000B: 083.3 MHz
   001B: 100.0 MHz
   010B: 133.3 MHz
   011B: 116.7 MHz
   100B: 080.0 MHz

Notice how for e.g the 83.3 MHz value there are 3 significant digits, which
translates to an accuracy of a 1000 ppm, where as a typical crystal
oscillator is 20 - 100 ppm, so the accuracy of the frequency format used in
the Software Developer’s Manual is not really helpful.

As far as we know Bay Trail SoCs use a 25 MHz crystal and Cherry Trail
uses a 19.2 MHz crystal, the crystal is the source clock for a root PLL
which outputs 1600 and 100 MHz. It is unclear if the root PLL outputs are
used directly by the CPU clock PLL or if there is another PLL in between.

This does not matter though, we can model the chain of PLLs as a single PLL
with a quotient equal to the quotients of all PLLs in the chain multiplied.

So we can create a simplified model of the CPU clock setup using a
reference clock of 100 MHz plus a quotient which gets us as close to the
frequency from the SDM as possible.

For the 83.3 MHz example from above this would give 100 MHz * 5 / 6 = 83
and 1/3 MHz, which matches exactly what has been measured on actual
hardware.

Use a simplified PLL model with a reference clock of 100 MHz for all Bay
and Cherry Trail models.

This has been tested on the following models:

              CPU freq before:        CPU freq after:
Intel N2840   2165.800 MHz            2166.667 MHz
Intel Z3736   1332.800 MHz            1333.333 MHz
Intel Z3775   1466.300 MHz            1466.667 MHz
Intel Z8350   1440.000 MHz            1440.000 MHz
Intel Z8750   1600.000 MHz            1600.000 MHz

This fixes the time drifting by about 1 second per hour (20 - 30 seconds
per day) on (some) devices which rely on the tsc_msr.c code to determine
the TSC frequency.

Reported-by: Vipul Kumar <vipulk0511@gmail.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200223140610.59612-3-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/tsc_msr.c |   97 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 86 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -18,6 +18,28 @@
 #define MAX_NUM_FREQS	16 /* 4 bits to select the frequency */
 
 /*
+ * The frequency numbers in the SDM are e.g. 83.3 MHz, which does not contain a
+ * lot of accuracy which leads to clock drift. As far as we know Bay Trail SoCs
+ * use a 25 MHz crystal and Cherry Trail uses a 19.2 MHz crystal, the crystal
+ * is the source clk for a root PLL which outputs 1600 and 100 MHz. It is
+ * unclear if the root PLL outputs are used directly by the CPU clock PLL or
+ * if there is another PLL in between.
+ * This does not matter though, we can model the chain of PLLs as a single PLL
+ * with a quotient equal to the quotients of all PLLs in the chain multiplied.
+ * So we can create a simplified model of the CPU clock setup using a reference
+ * clock of 100 MHz plus a quotient which gets us as close to the frequency
+ * from the SDM as possible.
+ * For the 83.3 MHz example from above this would give us 100 MHz * 5 / 6 =
+ * 83 and 1/3 MHz, which matches exactly what has been measured on actual hw.
+ */
+#define TSC_REFERENCE_KHZ 100000
+
+struct muldiv {
+	u32 multiplier;
+	u32 divider;
+};
+
+/*
  * If MSR_PERF_STAT[31] is set, the maximum resolved bus ratio can be
  * read in MSR_PLATFORM_ID[12:8], otherwise in MSR_PERF_STAT[44:40].
  * Unfortunately some Intel Atom SoCs aren't quite compliant to this,
@@ -26,6 +48,11 @@
  */
 struct freq_desc {
 	bool use_msr_plat;
+	struct muldiv muldiv[MAX_NUM_FREQS];
+	/*
+	 * Some CPU frequencies in the SDM do not map to known PLL freqs, in
+	 * that case the muldiv array is empty and the freqs array is used.
+	 */
 	u32 freqs[MAX_NUM_FREQS];
 	u32 mask;
 };
@@ -47,31 +74,66 @@ static const struct freq_desc freq_desc_
 	.mask = 0x07,
 };
 
+/*
+ * Bay Trail SDM MSR_FSB_FREQ frequencies simplified PLL model:
+ *  000:   100 *  5 /  6  =  83.3333 MHz
+ *  001:   100 *  1 /  1  = 100.0000 MHz
+ *  010:   100 *  4 /  3  = 133.3333 MHz
+ *  011:   100 *  7 /  6  = 116.6667 MHz
+ *  100:   100 *  4 /  5  =  80.0000 MHz
+ */
 static const struct freq_desc freq_desc_byt = {
 	.use_msr_plat = true,
-	.freqs = { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 },
+	.muldiv = { { 5, 6 }, { 1, 1 }, { 4, 3 }, { 7, 6 },
+		    { 4, 5 } },
 	.mask = 0x07,
 };
 
+/*
+ * Cherry Trail SDM MSR_FSB_FREQ frequencies simplified PLL model:
+ * 0000:   100 *  5 /  6  =  83.3333 MHz
+ * 0001:   100 *  1 /  1  = 100.0000 MHz
+ * 0010:   100 *  4 /  3  = 133.3333 MHz
+ * 0011:   100 *  7 /  6  = 116.6667 MHz
+ * 0100:   100 *  4 /  5  =  80.0000 MHz
+ * 0101:   100 * 14 / 15  =  93.3333 MHz
+ * 0110:   100 *  9 / 10  =  90.0000 MHz
+ * 0111:   100 *  8 /  9  =  88.8889 MHz
+ * 1000:   100 *  7 /  8  =  87.5000 MHz
+ */
 static const struct freq_desc freq_desc_cht = {
 	.use_msr_plat = true,
-	.freqs = { 83300, 100000, 133300, 116700, 80000, 93300, 90000,
-		   88900, 87500 },
+	.muldiv = { { 5, 6 }, {  1,  1 }, { 4,  3 }, { 7, 6 },
+		    { 4, 5 }, { 14, 15 }, { 9, 10 }, { 8, 9 },
+		    { 7, 8 } },
 	.mask = 0x0f,
 };
 
+/*
+ * Merriefield SDM MSR_FSB_FREQ frequencies simplified PLL model:
+ * 0001:   100 *  1 /  1  = 100.0000 MHz
+ * 0010:   100 *  4 /  3  = 133.3333 MHz
+ */
 static const struct freq_desc freq_desc_tng = {
 	.use_msr_plat = true,
-	.freqs = { 0, 100000, 133300, 0, 0, 0, 0, 0 },
+	.muldiv = { { 0, 0 }, { 1, 1 }, { 4, 3 } },
 	.mask = 0x07,
 };
 
+/*
+ * Moorefield SDM MSR_FSB_FREQ frequencies simplified PLL model:
+ * 0000:   100 *  5 /  6  =  83.3333 MHz
+ * 0001:   100 *  1 /  1  = 100.0000 MHz
+ * 0010:   100 *  4 /  3  = 133.3333 MHz
+ * 0011:   100 *  1 /  1  = 100.0000 MHz
+ */
 static const struct freq_desc freq_desc_ann = {
 	.use_msr_plat = true,
-	.freqs = { 83300, 100000, 133300, 100000, 0, 0, 0, 0 },
+	.muldiv = { { 5, 6 }, { 1, 1 }, { 4, 3 }, { 1, 1 } },
 	.mask = 0x0f,
 };
 
+/* 24 MHz crystal? : 24 * 13 / 4 = 78 MHz */
 static const struct freq_desc freq_desc_lgm = {
 	.use_msr_plat = true,
 	.freqs = { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 },
@@ -97,9 +159,10 @@ static const struct x86_cpu_id tsc_msr_c
  */
 unsigned long cpu_khz_from_msr(void)
 {
-	u32 lo, hi, ratio, freq;
+	u32 lo, hi, ratio, freq, tscref;
 	const struct freq_desc *freq_desc;
 	const struct x86_cpu_id *id;
+	const struct muldiv *md;
 	unsigned long res;
 	int index;
 
@@ -119,12 +182,24 @@ unsigned long cpu_khz_from_msr(void)
 	/* Get FSB FREQ ID */
 	rdmsr(MSR_FSB_FREQ, lo, hi);
 	index = lo & freq_desc->mask;
+	md = &freq_desc->muldiv[index];
 
-	/* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz) */
-	freq = freq_desc->freqs[index];
-
-	/* TSC frequency = maximum resolved freq * maximum resolved bus ratio */
-	res = freq * ratio;
+	/*
+	 * Note this also catches cases where the index points to an unpopulated
+	 * part of muldiv, in that case the else will set freq and res to 0.
+	 */
+	if (md->divider) {
+		tscref = TSC_REFERENCE_KHZ * md->multiplier;
+		freq = DIV_ROUND_CLOSEST(tscref, md->divider);
+		/*
+		 * Multiplying by ratio before the division has better
+		 * accuracy than just calculating freq * ratio.
+		 */
+		res = DIV_ROUND_CLOSEST(tscref * ratio, md->divider);
+	} else {
+		freq = freq_desc->freqs[index];
+		res = freq * ratio;
+	}
 
 	if (freq == 0)
 		pr_err("Error MSR_FSB_FREQ index %d is unknown\n", index);


