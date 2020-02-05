Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF491533F5
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 16:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgBEPet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 10:34:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53955 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727458AbgBEPep (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 10:34:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580916883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=caUfaVHz1AYLDdvYehvzNinQzEx13uI71o3enK91vHI=;
        b=Sk0zBSKUKMV2tl3Nan2+yOZT1hx6d2IN3jMvqdrIzh9TSJJPz74OB1zM+Kkg1GeDSh2H4d
        O0k8Kis/1TNjFMilxFI8igAGpHig4fOcUnuecnlrjwlRyNWV1gt1MUTtXOQY35bqyEmdBg
        4WyG3hhHocdjsnXttHX9JM0s2Hr9+nk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-Ao3aM429M1iwauUEoudK6g-1; Wed, 05 Feb 2020 10:34:42 -0500
X-MC-Unique: Ao3aM429M1iwauUEoudK6g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FB1D1137843;
        Wed,  5 Feb 2020 15:34:40 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-116-179.ams2.redhat.com [10.36.116.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B751C857AE;
        Wed,  5 Feb 2020 15:34:37 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 3/3] x86/tsc_msr: Make MSR derived TSC frequency more accurate
Date:   Wed,  5 Feb 2020 16:34:28 +0100
Message-Id: <20200205153428.437087-4-hdegoede@redhat.com>
In-Reply-To: <20200205153428.437087-1-hdegoede@redhat.com>
References: <20200205153428.437087-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The "Intel 64 and IA-32 Architectures Software Developer=E2=80=99s Manual
Volume 4: Model-Specific Registers" has the following table for the
values from freq_desc_byt:

   000B: 083.3 MHz
   001B: 100.0 MHz
   010B: 133.3 MHz
   011B: 116.7 MHz
   100B: 080.0 MHz

Notice how for e.g the 83.3 MHz value there are 3 significant digits,
which translates to an accuracy of a 1000 ppm, where as your typical
crystal oscillator is 20 - 100 ppm, so the accuracy of the frequency
format used in the Software Developer=E2=80=99s Manual is not really help=
ful.

As far as we know Bay Trail SoCs use a 25 MHz crystal and Cherry Trail
uses a 19.2 MHz crystal, the crystal is the source clk for a root PLL
which outputs 1600 and 100 MHz. It is unclear if the root PLL outputs are
used directly by the CPU clock PLL or if there is another PLL in between.

This does not matter though, we can model the chain of PLLs as a single
PLL with a quotient equal to the quotients of all PLLs in the chain
multiplied.

So we can create a simplified model of the CPU clock setup using a
reference clock of 100 MHz plus a quotient which gets us as close to the
frequency from the SDM as possible.

For the 83.3 MHz example from above this would give us 100 MHz * 5 / 6 =3D
83 and 1/3 MHz, which matches exactly what has been measured on actual hw=
.

This commit makes the tsc_msr.c code use a simplified PLL model with a
reference clock of 100 MHz for all Bay and Cherry Trail models.

This has been tested on the following models:

              CPU freq before:        CPU freq after this commit:
Intel N2840   2165.800 MHz            2166.667 MHz
Intel Z3736   1332.800 MHz            1333.333 MHz
Intel Z3775   1466.300 MHz            1466.667 MHz
Intel Z8350   1440.000 MHz            1440.000 MHz
Intel Z8750   1600.000 MHz            1600.000 MHz

This fixes the time drifting by about 1 second per hour (20 - 30 seconds
per day) on (some) devices which rely on the tsc_msr.c code to determine
the TSC frequency.

Cc: stable@vger.kernel.org
Reported-by: Vipul Kumar <vipulk0511@gmail.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-s/DSM/SDM/
-Do not refer to Merrifield / Moorefield as BYT / CHT, they only share th=
e
 CPU core design and otherwise are significantly different
---
 arch/x86/kernel/tsc_msr.c | 90 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index 95030895fffa..b10be7f4d760 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -17,6 +17,23 @@
=20
 #define MAX_NUM_FREQS	16 /* 4 bits to select the frequency */
=20
+/*
+ * The frequency numbers in the SDM are e.g. 83.3 MHz, which does not co=
ntain a
+ * lot of accuracy which leads to clock drift. As far as we know Bay Tra=
il SoCs
+ * use a 25 MHz crystal and Cherry Trail uses a 19.2 MHz crystal, the cr=
ystal
+ * is the source clk for a root PLL which outputs 1600 and 100 MHz. It i=
s
+ * unclear if the root PLL outputs are used directly by the CPU clock PL=
L or
+ * if there is another PLL in between.
+ * This does not matter though, we can model the chain of PLLs as a sing=
le PLL
+ * with a quotient equal to the quotients of all PLLs in the chain multi=
plied.
+ * So we can create a simplified model of the CPU clock setup using a re=
ference
+ * clock of 100 MHz plus a quotient which gets us as close to the freque=
ncy
+ * from the SDM as possible.
+ * For the 83.3 MHz example from above this would give us 100 MHz * 5 / =
6 =3D
+ * 83 and 1/3 MHz, which matches exactly what has been measured on actua=
l hw.
+ */
+#define REFERENCE_KHZ 100000
+
 /*
  * If MSR_PERF_STAT[31] is set, the maximum resolved bus ratio can be
  * read in MSR_PLATFORM_ID[12:8], otherwise in MSR_PERF_STAT[44:40].
@@ -26,6 +43,14 @@
  */
 struct freq_desc {
 	bool use_msr_plat;
+	struct {
+		u32 multiplier;
+		u32 divider;
+	} pairs[MAX_NUM_FREQS];
+	/*
+	 * Some CPU frequencies in the SDM do not map to known PLL freqs, in
+	 * that case the pairs arrays is empty and the freqs array is used.
+	 */
 	u32 freqs[MAX_NUM_FREQS];
 	u32 mask;
 };
@@ -47,31 +72,64 @@ static const struct freq_desc freq_desc_clv =3D {
 	.mask =3D 0x07,
 };
=20
+/*
+ * Bay Trail SDM MSR_FSB_FREQ frequencies simplified PLL model:
+ *  000:   100 *  5 /  6  =3D  83.3333 MHz
+ *  001:   100 *  1 /  1  =3D 100.0000 MHz
+ *  010:   100 *  4 /  3  =3D 133.3333 MHz
+ *  011:   100 *  7 /  6  =3D 116.6667 MHz
+ *  100:   100 *  4 /  5  =3D  80.0000 MHz
+ */
 static const struct freq_desc freq_desc_byt =3D {
 	.use_msr_plat =3D true,
-	.freqs =3D { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 },
+	.pairs =3D { { 5, 6 }, { 1, 1 }, { 4, 3 }, { 7, 6 }, { 4, 5 } },
 	.mask =3D 0x07,
 };
=20
+/*
+ * Cherry Trail SDM MSR_FSB_FREQ frequencies simplified PLL model:
+ * 0000:   100 *  5 /  6  =3D  83.3333 MHz
+ * 0001:   100 *  1 /  1  =3D 100.0000 MHz
+ * 0010:   100 *  4 /  3  =3D 133.3333 MHz
+ * 0011:   100 *  7 /  6  =3D 116.6667 MHz
+ * 0100:   100 *  4 /  5  =3D  80.0000 MHz
+ * 0101:   100 * 14 / 15  =3D  93.3333 MHz
+ * 0110:   100 *  9 / 10  =3D  90.0000 MHz
+ * 0111:   100 *  8 /  9  =3D  88.8889 MHz
+ * 1000:   100 *  7 /  8  =3D  87.5000 MHz
+ */
 static const struct freq_desc freq_desc_cht =3D {
 	.use_msr_plat =3D true,
-	.freqs =3D { 83300, 100000, 133300, 116700, 80000, 93300, 90000,
-		   88900, 87500 },
+	.pairs =3D { {  5,  6 }, { 1,  1 }, { 4, 3 }, { 7, 6 }, { 4, 5 },
+		   { 14, 15 }, { 9, 10 }, { 8, 9 }, { 7, 8 } },
 	.mask =3D 0x0f,
 };
=20
+/*
+ * Merriefield SDM MSR_FSB_FREQ frequencies simplified PLL model:
+ * 0001:   100 *  1 /  1  =3D 100.0000 MHz
+ * 0010:   100 *  4 /  3  =3D 133.3333 MHz
+ */
 static const struct freq_desc freq_desc_tng =3D {
 	.use_msr_plat =3D true,
-	.freqs =3D { 0, 100000, 133300, 0, 0, 0, 0, 0 },
+	.pairs =3D { { 0, 0 }, { 1, 1 }, { 4, 3 } },
 	.mask =3D 0x07,
 };
=20
+/*
+ * Moorefield SDM MSR_FSB_FREQ frequencies simplified PLL model:
+ * 0000:   100 *  5 /  6  =3D  83.3333 MHz
+ * 0001:   100 *  1 /  1  =3D 100.0000 MHz
+ * 0010:   100 *  4 /  3  =3D 133.3333 MHz
+ * 0011:   100 *  1 /  1  =3D 100.0000 MHz
+ */
 static const struct freq_desc freq_desc_ann =3D {
 	.use_msr_plat =3D true,
-	.freqs =3D { 83300, 100000, 133300, 100000, 0, 0, 0, 0 },
+	.pairs =3D { { 5, 6 }, { 1, 1 }, { 4, 3 }, { 1, 1 } },
 	.mask =3D 0x0f,
 };
=20
+/* 24 MHz crystal? : 24 * 13 / 4 =3D 78 MHz */
 static const struct freq_desc freq_desc_lgm =3D {
 	.use_msr_plat =3D true,
 	.freqs =3D { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 },
@@ -120,11 +178,23 @@ unsigned long cpu_khz_from_msr(void)
 	rdmsr(MSR_FSB_FREQ, lo, hi);
 	index =3D lo & freq_desc->mask;
=20
-	/* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz=
) */
-	freq =3D freq_desc->freqs[index];
-
-	/* TSC frequency =3D maximum resolved freq * maximum resolved bus ratio=
 */
-	res =3D freq * ratio;
+	/*
+	 * Note this also catches cases where the index points to an unpopulate=
d
+	 * part of pairs, in that case the else will set freq and res to 0.
+	 */
+	if (freq_desc->pairs[index].divider) {
+		freq =3D DIV_ROUND_CLOSEST(REFERENCE_KHZ *
+					    freq_desc->pairs[index].multiplier,
+					 freq_desc->pairs[index].divider);
+		/* Multiply by ratio before the divide for better accuracy */
+		res =3D DIV_ROUND_CLOSEST(REFERENCE_KHZ *
+					    freq_desc->pairs[index].multiplier *
+					    ratio,
+					freq_desc->pairs[index].divider);
+	} else {
+		freq =3D freq_desc->freqs[index];
+		res =3D freq * ratio;
+	}
=20
 	if (freq =3D=3D 0)
 		pr_err("Error MSR_FSB_FREQ index %d is unknown\n", index);
--=20
2.24.1

