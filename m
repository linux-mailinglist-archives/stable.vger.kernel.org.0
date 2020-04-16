Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A2A1AC312
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897455AbgDPNh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896096AbgDPNhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:37:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9620E20732;
        Thu, 16 Apr 2020 13:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044242;
        bh=wI3rSj/W6AYF4oDxg5zKimwVW/fNHbKwmR8ewd1vzIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wb2FzjPG9Csy9RlRgYAphOiEar6eEv7m1ecruxRAsUg8WpbtSaaVS3FvMnpoZBu0n
         bmja78aHN8MW6jX91aKPtOpW7+Bm+rkRPd/icDXWN7mt0yBidrn2D8xHYkunEj9Kxa
         fu+RJ3UqI02JlM9Znix+nFsCjH4arNe9YuqOTObY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.5 138/257] x86/tsc_msr: Fix MSR_FSB_FREQ mask for Cherry Trail devices
Date:   Thu, 16 Apr 2020 15:23:09 +0200
Message-Id: <20200416131343.704498831@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit c8810e2ffc30c7e1577f9c057c4b85d984bbc35a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/tsc_msr.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

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


