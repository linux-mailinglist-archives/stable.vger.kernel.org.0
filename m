Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6B5291E8B
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgJRTUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727316AbgJRTUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:20:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA8A8222EB;
        Sun, 18 Oct 2020 19:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048834;
        bh=Q9CHD5Ou3bkw3/j9FIqWOLtSLv6yrwBRIhK/v9KYZrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+aUPYqtEs71j1oMNdQiMTPXG26r0VyYlGyar3tgde89CIFpcwJdwpWdEZ3R/1/Ws
         ImI3iZ8nCBrS0YLjtjgbN2M/jnvbFH570gdk15NTje6LkOLb0Cx5Zc/c+kCOt3AqUu
         5aVcr1e4RvJmgo66QX8VKrwuYFhuUYkDeeWl3cuk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>,
        Youquan Song <youquan.song@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 006/101] x86/mce: Add Skylake quirk for patrol scrub reported errors
Date:   Sun, 18 Oct 2020 15:18:51 -0400
Message-Id: <20201018192026.4053674-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit fd258dc4442c5c1c069c6b5b42bfe7d10cddda95 ]

The patrol scrubber in Skylake and Cascade Lake systems can be configured
to report uncorrected errors using a special signature in the machine
check bank and to signal using CMCI instead of machine check.

Update the severity calculation mechanism to allow specifying the model,
minimum stepping and range of machine check bank numbers.

Add a new rule to detect the special signature (on model 0x55, stepping
>=4 in any of the memory controller banks).

 [ bp: Rewrite it.
   aegl: Productize it. ]

Suggested-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200930021313.31810-2-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/severity.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/severity.c b/arch/x86/kernel/cpu/mce/severity.c
index e1da619add192..567ce09a02868 100644
--- a/arch/x86/kernel/cpu/mce/severity.c
+++ b/arch/x86/kernel/cpu/mce/severity.c
@@ -9,9 +9,11 @@
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/debugfs.h>
-#include <asm/mce.h>
 #include <linux/uaccess.h>
 
+#include <asm/mce.h>
+#include <asm/intel-family.h>
+
 #include "internal.h"
 
 /*
@@ -40,9 +42,14 @@ static struct severity {
 	unsigned char context;
 	unsigned char excp;
 	unsigned char covered;
+	unsigned char cpu_model;
+	unsigned char cpu_minstepping;
+	unsigned char bank_lo, bank_hi;
 	char *msg;
 } severities[] = {
 #define MCESEV(s, m, c...) { .sev = MCE_ ## s ## _SEVERITY, .msg = m, ## c }
+#define BANK_RANGE(l, h) .bank_lo = l, .bank_hi = h
+#define MODEL_STEPPING(m, s) .cpu_model = m, .cpu_minstepping = s
 #define  KERNEL		.context = IN_KERNEL
 #define  USER		.context = IN_USER
 #define  KERNEL_RECOV	.context = IN_KERNEL_RECOV
@@ -97,7 +104,6 @@ static struct severity {
 		KEEP, "Corrected error",
 		NOSER, BITCLR(MCI_STATUS_UC)
 		),
-
 	/*
 	 * known AO MCACODs reported via MCE or CMC:
 	 *
@@ -113,6 +119,18 @@ static struct severity {
 		AO, "Action optional: last level cache writeback error",
 		SER, MASK(MCI_UC_AR|MCACOD, MCI_STATUS_UC|MCACOD_L3WB)
 		),
+	/*
+	 * Quirk for Skylake/Cascade Lake. Patrol scrubber may be configured
+	 * to report uncorrected errors using CMCI with a special signature.
+	 * UC=0, MSCOD=0x0010, MCACOD=binary(000X 0000 1100 XXXX) reported
+	 * in one of the memory controller banks.
+	 * Set severity to "AO" for same action as normal patrol scrub error.
+	 */
+	MCESEV(
+		AO, "Uncorrected Patrol Scrub Error",
+		SER, MASK(MCI_STATUS_UC|MCI_ADDR|0xffffeff0, MCI_ADDR|0x001000c0),
+		MODEL_STEPPING(INTEL_FAM6_SKYLAKE_X, 4), BANK_RANGE(13, 18)
+	),
 
 	/* ignore OVER for UCNA */
 	MCESEV(
@@ -324,6 +342,12 @@ static int mce_severity_intel(struct mce *m, int tolerant, char **msg, bool is_e
 			continue;
 		if (s->excp && excp != s->excp)
 			continue;
+		if (s->cpu_model && boot_cpu_data.x86_model != s->cpu_model)
+			continue;
+		if (s->cpu_minstepping && boot_cpu_data.x86_stepping < s->cpu_minstepping)
+			continue;
+		if (s->bank_lo && (m->bank < s->bank_lo || m->bank > s->bank_hi))
+			continue;
 		if (msg)
 			*msg = s->msg;
 		s->covered = 1;
-- 
2.25.1

