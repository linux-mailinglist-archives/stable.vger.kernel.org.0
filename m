Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FB22A58D0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgKCVzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730375AbgKCUpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:45:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7E392242C;
        Tue,  3 Nov 2020 20:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436310;
        bh=On5W1dDIo6cAxusfp+TdHfsn0qFt324j24HN2eB1T6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSA5HYrMPX9jIL4MaU+nD0nPrpR6vrSOmWKcUao8loNjysFWUxBqquxABQLwITYSK
         l6rLgEuJwVnR9uzH2x+1CcBdBIahthIWgdl4LZ9Hm2sVZMgLWYsqkeZRUAxeVbNQAJ
         rJ935uojaRL+7F8zCGxS0j+mOcwCoSZS9Fr13fwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Eranian <stephane.eranian@google.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.9 195/391] perf/x86/amd/ibs: Fix raw sample data accumulation
Date:   Tue,  3 Nov 2020 21:34:06 +0100
Message-Id: <20201103203400.050412382@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 36e1be8ada994d509538b3b1d0af8b63c351e729 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/amd/ibs.c        |   26 ++++++++++++++++----------
 arch/x86/include/asm/msr-index.h |    1 +
 2 files changed, 17 insertions(+), 10 deletions(-)

--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -636,18 +636,24 @@ fail:
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


