Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55912659DB
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 09:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgIKHCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 03:02:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45076 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgIKHCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 03:02:31 -0400
Date:   Fri, 11 Sep 2020 07:02:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599807748;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wEHOxkdlqmxFYEdk7iUjGYv/0FBMO8f9KO0LYJkQ/Bk=;
        b=DvceqLzlrWlvwvLvvmzu/Df4O/9MOBN0EK3h9rV8v3d+ygt0sqSQjVrq8k35XF1YfRZRqY
        U+nDwYj/C1x9+Ab3lu3ogLYQibuKtDrufO2gZZ+C55TjvuawCfpUYW7cwY6O2nsKger1OB
        UiHt2KnTIZVwIj4rw97Kbblw7XZRfWHPShSMTKtZ59cvrbO6TixVusyHfyeYarpeOBxsyb
        dchwQRacMqsp3uw5148+SO62MZ4UiVMnxZ+Q27Y1pAsYVdnTsHXLWPctpK1ExojzmP/kpW
        BDNn7SkVgwLqGpjp0xEFHdgXt4Ft7q0foFLFA91KutjK2Ot/EP5O9BBeui31mw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599807748;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wEHOxkdlqmxFYEdk7iUjGYv/0FBMO8f9KO0LYJkQ/Bk=;
        b=MQTCl1C0BjxHibw4CuECTJUwkj8m/n5f0NBz746VlLCzcT5Yv96INTm/UmneKmdKPiMlGW
        2pUwjXXPL4O8xgCw==
From:   "tip-bot2 for Kim Phillips" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/amd/ibs: Fix raw sample data accumulation
Cc:     Stephane Eranian <stephane.eranian@google.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200908214740.18097-6-kim.phillips@amd.com>
References: <20200908214740.18097-6-kim.phillips@amd.com>
MIME-Version: 1.0
Message-ID: <159980774733.20229.8857189007953193576.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     36e1be8ada994d509538b3b1d0af8b63c351e729
Gitweb:        https://git.kernel.org/tip/36e1be8ada994d509538b3b1d0af8b63c351e729
Author:        Kim Phillips <kim.phillips@amd.com>
AuthorDate:    Tue, 08 Sep 2020 16:47:38 -05:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 10 Sep 2020 11:19:35 +02:00

perf/x86/amd/ibs: Fix raw sample data accumulation

Neither IbsBrTarget nor OPDATA4 are populated in IBS Fetch mode.
Don't accumulate them into raw sample user data in that case.

Also, in Fetch mode, add saving the IBS Fetch Control Extended MSR.

Technically, there is an ABI change here with respect to the IBS raw
sample data format, but I don't see any perf driver version information
being included in perf.data file headers, but, existing users can detect
whether the size of the sample record has reduced by 8 bytes to
determine whether the IBS driver has this fix.

Fixes: 904cb3677f3a ("perf/x86/amd/ibs: Update IBS MSRs and feature definitions")
Reported-by: Stephane Eranian <stephane.eranian@google.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200908214740.18097-6-kim.phillips@amd.com
---
 arch/x86/events/amd/ibs.c        | 26 ++++++++++++++++----------
 arch/x86/include/asm/msr-index.h |  1 +
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 863174a..cfbd020 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -630,18 +630,24 @@ fail:
 				       perf_ibs->offset_max,
 				       offset + 1);
 	} while (offset < offset_max);
+	/*
+	 * Read IbsBrTarget, IbsOpData4, and IbsExtdCtl separately
+	 * depending on their availability.
+	 * Can't add to offset_max as they are staggered
+	 */
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
-		/*
-		 * Read IbsBrTarget and IbsOpData4 separately
-		 * depending on their availability.
-		 * Can't add to offset_max as they are staggered
-		 */
-		if (ibs_caps & IBS_CAPS_BRNTRGT) {
-			rdmsrl(MSR_AMD64_IBSBRTARGET, *buf++);
-			size++;
+		if (perf_ibs == &perf_ibs_op) {
+			if (ibs_caps & IBS_CAPS_BRNTRGT) {
+				rdmsrl(MSR_AMD64_IBSBRTARGET, *buf++);
+				size++;
+			}
+			if (ibs_caps & IBS_CAPS_OPDATA4) {
+				rdmsrl(MSR_AMD64_IBSOPDATA4, *buf++);
+				size++;
+			}
 		}
-		if (ibs_caps & IBS_CAPS_OPDATA4) {
-			rdmsrl(MSR_AMD64_IBSOPDATA4, *buf++);
+		if (perf_ibs == &perf_ibs_fetch && (ibs_caps & IBS_CAPS_FETCHCTLEXTD)) {
+			rdmsrl(MSR_AMD64_ICIBSEXTDCTL, *buf++);
 			size++;
 		}
 	}
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index dc131b8..2d39c31 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -464,6 +464,7 @@
 #define MSR_AMD64_IBSOP_REG_MASK	((1UL<<MSR_AMD64_IBSOP_REG_COUNT)-1)
 #define MSR_AMD64_IBSCTL		0xc001103a
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
+#define MSR_AMD64_ICIBSEXTDCTL		0xc001103c
 #define MSR_AMD64_IBSOPDATA4		0xc001103d
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
 #define MSR_AMD64_SEV			0xc0010131
