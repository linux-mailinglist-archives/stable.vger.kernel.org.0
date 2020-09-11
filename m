Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B762659EC
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 09:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgIKHEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 03:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgIKHCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 03:02:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE814C061756;
        Fri, 11 Sep 2020 00:02:29 -0700 (PDT)
Date:   Fri, 11 Sep 2020 07:02:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599807747;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=fiItmY//vlU7KtX1mrQMS+7R4kiDx8bE8Aq1XKN98rU=;
        b=WlydLXCIWRRKVxnqvhtkmarD+RsWPUcpgZH7zp3p7CzR5wblIkWnNZjImHy6sjr2jYwKvH
        5ImST5+Ix6istO0w7WJWGBnlfKmDqJiqbMSdGgRdksCIXqtQcNMlHNEEAI2LGeow3kRxVf
        IU7+mWdj1jQSQTM/ZFUHzgNAqIx3JLtYC22Wkw/iXvAy8wETh738OgtBVucsN1BcGAIwBd
        l7yWHA4OlvmHHgdKa1OL8wchA6fL9DrHaci9FfCPPCbVO00vzSk9sPkD/nFVcs0UZnx4nD
        7tJJCjatay+cNR7EGt84HY+91T/McOUrJOJ61j2iIHtNenJOEdalbpy1jP1MiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599807747;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=fiItmY//vlU7KtX1mrQMS+7R4kiDx8bE8Aq1XKN98rU=;
        b=d4gsMa6hGazxesQRaA/3HMmcAK/ksgW8nqcwBN2JBhrK2K0Lo4IBAgjPdFACfBjAcnzuq7
        YRahyINvpEYe2WCg==
From:   "tip-bot2 for Kim Phillips" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] arch/x86/amd/ibs: Fix re-arming IBS Fetch
Cc:     Stephane Eranian <stephane.eranian@google.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <159980774597.20229.8759755692830085791.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     221bfce5ebbdf72ff08b3bf2510ae81058ee568b
Gitweb:        https://git.kernel.org/tip/221bfce5ebbdf72ff08b3bf2510ae81058ee568b
Author:        Kim Phillips <kim.phillips@amd.com>
AuthorDate:    Tue, 08 Sep 2020 16:47:36 -05:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 10 Sep 2020 11:19:36 +02:00

arch/x86/amd/ibs: Fix re-arming IBS Fetch

Stephane Eranian found a bug in that IBS' current Fetch counter was not
being reset when the driver would write the new value to clear it along
with the enable bit set, and found that adding an MSR write that would
first disable IBS Fetch would make IBS Fetch reset its current count.

Indeed, the PPR for AMD Family 17h Model 31h B0 55803 Rev 0.54 - Sep 12,
2019 states "The periodic fetch counter is set to IbsFetchCnt [...] when
IbsFetchEn is changed from 0 to 1."

Explicitly set IbsFetchEn to 0 and then to 1 when re-enabling IBS Fetch,
so the driver properly resets the internal counter to 0 and IBS
Fetch starts counting again.

A family 15h machine tested does not have this problem, and the extra
wrmsr is also not needed on Family 19h, so only do the extra wrmsr on
families 16h through 18h.

Reported-by: Stephane Eranian <stephane.eranian@google.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
[peterz: optimized]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
---
 arch/x86/events/amd/ibs.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index ea323dc..40669ea 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -89,6 +89,7 @@ struct perf_ibs {
 	u64				max_period;
 	unsigned long			offset_mask[1];
 	int				offset_max;
+	unsigned int			fetch_count_reset_broken : 1;
 	struct cpu_perf_ibs __percpu	*pcpu;
 
 	struct attribute		**format_attrs;
@@ -370,7 +371,12 @@ perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
 static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
 					 struct hw_perf_event *hwc, u64 config)
 {
-	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
+	u64 tmp = hwc->config | config;
+
+	if (perf_ibs->fetch_count_reset_broken)
+		wrmsrl(hwc->config_base, tmp & ~perf_ibs->enable_mask);
+
+	wrmsrl(hwc->config_base, tmp | perf_ibs->enable_mask);
 }
 
 /*
@@ -756,6 +762,13 @@ static __init void perf_event_ibs_init(void)
 {
 	struct attribute **attr = ibs_op_format_attrs;
 
+	/*
+	 * Some chips fail to reset the fetch count when it is written; instead
+	 * they need a 0-1 transition of IbsFetchEn.
+	 */
+	if (boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
+		perf_ibs_fetch.fetch_count_reset_broken = 1;
+
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
 
 	if (ibs_caps & IBS_CAPS_OPCNT) {
