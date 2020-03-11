Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0823E182461
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 23:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgCKWFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 18:05:21 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40801 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729223AbgCKWFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 18:05:21 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jC9TZ-0001hC-J6; Wed, 11 Mar 2020 23:05:17 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 367D31C224A;
        Wed, 11 Mar 2020 23:05:17 +0100 (CET)
Date:   Wed, 11 Mar 2020 22:05:16 -0000
From:   "tip-bot2 for Hans de Goede" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/timers] x86/tsc_msr: Fix MSR_FSB_FREQ mask for Cherry Trail devices
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200223140610.59612-2-hdegoede@redhat.com>
References: <20200223140610.59612-2-hdegoede@redhat.com>
MIME-Version: 1.0
Message-ID: <158396431695.28353.14027321767001755746.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/timers branch of tip:

Commit-ID:     c8810e2ffc30c7e1577f9c057c4b85d984bbc35a
Gitweb:        https://git.kernel.org/tip/c8810e2ffc30c7e1577f9c057c4b85d984bbc35a
Author:        Hans de Goede <hdegoede@redhat.com>
AuthorDate:    Sun, 23 Feb 2020 15:06:09 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 11 Mar 2020 22:57:39 +01:00

x86/tsc_msr: Fix MSR_FSB_FREQ mask for Cherry Trail devices

According to the "Intel 64 and IA-32 Architectures Software Developer's
Manual Volume 4: Model-Specific Registers" on Cherry Trail (Airmont)
devices the 4 lowest bits of the MSR_FSB_FREQ mask indicate the bus freq
unlike on e.g. Bay Trail where only the lowest 3 bits are used.

This is also the reason why MAX_NUM_FREQS is defined as 9, since Cherry
Trail SoCs have 9 possible frequencies, so the lo value from the MSR needs
to be masked with 0x0f, not with 0x07 otherwise the 9th frequency will get
interpreted as the 1st.

Bump MAX_NUM_FREQS to 16 to avoid any possibility of addressing the array
out of bounds and makes the mask part of the cpufreq struct so it can be
set it per model.

While at it also log an error when the index points to an uninitialized
part of the freqs lookup-table.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200223140610.59612-2-hdegoede@redhat.com

---
 arch/x86/kernel/tsc_msr.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index 5fa41ac..9503089 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -15,7 +15,7 @@
 #include <asm/param.h>
 #include <asm/tsc.h>
 
-#define MAX_NUM_FREQS	9
+#define MAX_NUM_FREQS	16 /* 4 bits to select the frequency */
 
 /*
  * If MSR_PERF_STAT[31] is set, the maximum resolved bus ratio can be
@@ -27,6 +27,7 @@
 struct freq_desc {
 	bool use_msr_plat;
 	u32 freqs[MAX_NUM_FREQS];
+	u32 mask;
 };
 
 /*
@@ -37,37 +38,44 @@ struct freq_desc {
 static const struct freq_desc freq_desc_pnw = {
 	.use_msr_plat = false,
 	.freqs = { 0, 0, 0, 0, 0, 99840, 0, 83200 },
+	.mask = 0x07,
 };
 
 static const struct freq_desc freq_desc_clv = {
 	.use_msr_plat = false,
 	.freqs = { 0, 133200, 0, 0, 0, 99840, 0, 83200 },
+	.mask = 0x07,
 };
 
 static const struct freq_desc freq_desc_byt = {
 	.use_msr_plat = true,
 	.freqs = { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 },
+	.mask = 0x07,
 };
 
 static const struct freq_desc freq_desc_cht = {
 	.use_msr_plat = true,
 	.freqs = { 83300, 100000, 133300, 116700, 80000, 93300, 90000,
 		   88900, 87500 },
+	.mask = 0x0f,
 };
 
 static const struct freq_desc freq_desc_tng = {
 	.use_msr_plat = true,
 	.freqs = { 0, 100000, 133300, 0, 0, 0, 0, 0 },
+	.mask = 0x07,
 };
 
 static const struct freq_desc freq_desc_ann = {
 	.use_msr_plat = true,
 	.freqs = { 83300, 100000, 133300, 100000, 0, 0, 0, 0 },
+	.mask = 0x0f,
 };
 
 static const struct freq_desc freq_desc_lgm = {
 	.use_msr_plat = true,
 	.freqs = { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 },
+	.mask = 0x0f,
 };
 
 static const struct x86_cpu_id tsc_msr_cpu_ids[] = {
@@ -93,6 +101,7 @@ unsigned long cpu_khz_from_msr(void)
 	const struct freq_desc *freq_desc;
 	const struct x86_cpu_id *id;
 	unsigned long res;
+	int index;
 
 	id = x86_match_cpu(tsc_msr_cpu_ids);
 	if (!id)
@@ -109,13 +118,17 @@ unsigned long cpu_khz_from_msr(void)
 
 	/* Get FSB FREQ ID */
 	rdmsr(MSR_FSB_FREQ, lo, hi);
+	index = lo & freq_desc->mask;
 
 	/* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz) */
-	freq = freq_desc->freqs[lo & 0x7];
+	freq = freq_desc->freqs[index];
 
 	/* TSC frequency = maximum resolved freq * maximum resolved bus ratio */
 	res = freq * ratio;
 
+	if (freq == 0)
+		pr_err("Error MSR_FSB_FREQ index %d is unknown\n", index);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	lapic_timer_period = (freq * 1000) / HZ;
 #endif
