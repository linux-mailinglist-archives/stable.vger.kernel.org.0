Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE7F29E9A0
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 11:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgJ2Kvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 06:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgJ2Kvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 06:51:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA40AC0613CF;
        Thu, 29 Oct 2020 03:51:40 -0700 (PDT)
Date:   Thu, 29 Oct 2020 10:51:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603968698;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Azl78zt/NBcg5O7rnft4BwuImw5wLENmFNMrTqxlEQA=;
        b=hw9ncp3cknEGaid3kCcbMJ3b3x+E6pxImtxjLmPdQ0HlQnyy2CuHosQ6qZPuu04di8d3wS
        w8XUMpIYfidi0qmi84MCMEEYBLZEj/dtWyLFpEGaSUWScl3derSPS9vS35224xIRh/MSiN
        ErDqDWWOAnJiitHGM9aF1lfpNqBPttLrh1GHjnj/9uUy3PjRc82KskwE2h5PYGlNtgya/0
        I0LICQ3BKmv2sUSx55weTpkwt4G6ROOQ3AsaxP8g1en56f5V4lJk/HQ6nRNzuM/pkWaROG
        IKko2qk01cAbYrmaTpDboyElP7hvWXlKZxqLzKyA8CjUCmPnlyGwpzK5ukJdEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603968698;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Azl78zt/NBcg5O7rnft4BwuImw5wLENmFNMrTqxlEQA=;
        b=0QiFqh+5R3Num3ZekOLHlKUS16x7MbEivBV9zTUlbfsgmdTXKkSYu/CE+Ys9Lj8JbIwxIe
        hMQQET6+TvrcrnCQ==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel: Add event constraint for
 CYCLE_ACTIVITY.STALLS_MEM_ANY
Cc:     Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20201019164529.32154-1-kan.liang@linux.intel.com>
References: <20201019164529.32154-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <160396869773.397.6435807847521409209.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     306e3e91edf1c6739a55312edd110d298ff498dd
Gitweb:        https://git.kernel.org/tip/306e3e91edf1c6739a55312edd110d298ff498dd
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Mon, 19 Oct 2020 09:45:29 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 29 Oct 2020 11:00:41 +01:00

perf/x86/intel: Add event constraint for CYCLE_ACTIVITY.STALLS_MEM_ANY

The event CYCLE_ACTIVITY.STALLS_MEM_ANY (0x14a3) should be available on
all 8 GP counters on ICL, but it's only scheduled on the first four
counters due to the current ICL constraint table.

Add a line for the CYCLE_ACTIVITY.STALLS_MEM_ANY event in the ICL
constraint table.
Correct the comments for the CYCLE_ACTIVITY.CYCLES_MEM_ANY event.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20201019164529.32154-1-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 4d70c7d..0e590c5 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -257,7 +257,8 @@ static struct event_constraint intel_icl_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT_RANGE(0x48, 0x54, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0x60, 0x8b, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_TOTAL */
-	INTEL_UEVENT_CONSTRAINT(0x10a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_MEM_ANY */
+	INTEL_UEVENT_CONSTRAINT(0x10a3, 0xff),  /* CYCLE_ACTIVITY.CYCLES_MEM_ANY */
+	INTEL_UEVENT_CONSTRAINT(0x14a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_MEM_ANY */
 	INTEL_EVENT_CONSTRAINT(0xa3, 0xf),      /* CYCLE_ACTIVITY.* */
 	INTEL_EVENT_CONSTRAINT_RANGE(0xa8, 0xb0, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xb7, 0xbd, 0xf),
