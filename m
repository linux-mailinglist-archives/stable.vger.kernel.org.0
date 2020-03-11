Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB26182465
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 23:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgCKWFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 18:05:22 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40803 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729518AbgCKWFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 18:05:21 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jC9TZ-0001hF-U2; Wed, 11 Mar 2020 23:05:18 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 99E231C2249;
        Wed, 11 Mar 2020 23:05:17 +0100 (CET)
Date:   Wed, 11 Mar 2020 22:05:17 -0000
From:   "tip-bot2 for Hans de Goede" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/timers] x86/tsc_msr: Use named struct initializers
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200223140610.59612-1-hdegoede@redhat.com>
References: <20200223140610.59612-1-hdegoede@redhat.com>
MIME-Version: 1.0
Message-ID: <158396431730.28353.16602854182721546383.tip-bot2@tip-bot2>
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

Commit-ID:     812c2d7506fde7cdf83cb2532810a65782b51741
Gitweb:        https://git.kernel.org/tip/812c2d7506fde7cdf83cb2532810a65782b51741
Author:        Hans de Goede <hdegoede@redhat.com>
AuthorDate:    Sun, 23 Feb 2020 15:06:08 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 11 Mar 2020 22:57:39 +01:00

x86/tsc_msr: Use named struct initializers

Use named struct initializers for the freq_desc struct-s initialization
and change the "u8 msr_plat" to a "bool use_msr_plat" to make its meaning
more clear instead of relying on a comment to explain it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200223140610.59612-1-hdegoede@redhat.com

---
 arch/x86/kernel/tsc_msr.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index e0cbe4f..5fa41ac 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -22,10 +22,10 @@
  * read in MSR_PLATFORM_ID[12:8], otherwise in MSR_PERF_STAT[44:40].
  * Unfortunately some Intel Atom SoCs aren't quite compliant to this,
  * so we need manually differentiate SoC families. This is what the
- * field msr_plat does.
+ * field use_msr_plat does.
  */
 struct freq_desc {
-	u8 msr_plat;	/* 1: use MSR_PLATFORM_INFO, 0: MSR_IA32_PERF_STATUS */
+	bool use_msr_plat;
 	u32 freqs[MAX_NUM_FREQS];
 };
 
@@ -35,31 +35,39 @@ struct freq_desc {
  * by MSR based on SDM.
  */
 static const struct freq_desc freq_desc_pnw = {
-	0, { 0, 0, 0, 0, 0, 99840, 0, 83200 }
+	.use_msr_plat = false,
+	.freqs = { 0, 0, 0, 0, 0, 99840, 0, 83200 },
 };
 
 static const struct freq_desc freq_desc_clv = {
-	0, { 0, 133200, 0, 0, 0, 99840, 0, 83200 }
+	.use_msr_plat = false,
+	.freqs = { 0, 133200, 0, 0, 0, 99840, 0, 83200 },
 };
 
 static const struct freq_desc freq_desc_byt = {
-	1, { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 }
+	.use_msr_plat = true,
+	.freqs = { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 },
 };
 
 static const struct freq_desc freq_desc_cht = {
-	1, { 83300, 100000, 133300, 116700, 80000, 93300, 90000, 88900, 87500 }
+	.use_msr_plat = true,
+	.freqs = { 83300, 100000, 133300, 116700, 80000, 93300, 90000,
+		   88900, 87500 },
 };
 
 static const struct freq_desc freq_desc_tng = {
-	1, { 0, 100000, 133300, 0, 0, 0, 0, 0 }
+	.use_msr_plat = true,
+	.freqs = { 0, 100000, 133300, 0, 0, 0, 0, 0 },
 };
 
 static const struct freq_desc freq_desc_ann = {
-	1, { 83300, 100000, 133300, 100000, 0, 0, 0, 0 }
+	.use_msr_plat = true,
+	.freqs = { 83300, 100000, 133300, 100000, 0, 0, 0, 0 },
 };
 
 static const struct freq_desc freq_desc_lgm = {
-	1, { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 }
+	.use_msr_plat = true,
+	.freqs = { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 },
 };
 
 static const struct x86_cpu_id tsc_msr_cpu_ids[] = {
@@ -91,7 +99,7 @@ unsigned long cpu_khz_from_msr(void)
 		return 0;
 
 	freq_desc = (struct freq_desc *)id->driver_data;
-	if (freq_desc->msr_plat) {
+	if (freq_desc->use_msr_plat) {
 		rdmsr(MSR_PLATFORM_INFO, lo, hi);
 		ratio = (lo >> 8) & 0xff;
 	} else {
