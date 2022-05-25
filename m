Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22178533EBB
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 16:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiEYOHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 10:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245637AbiEYOFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 10:05:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC330C6E6B;
        Wed, 25 May 2022 07:03:35 -0700 (PDT)
Date:   Wed, 25 May 2022 14:03:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1653487414;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=55ocFR5c8Yck9KyS67JdgcKAJX3wIgoSeYZFc0YqsWw=;
        b=0f7I+wCG03Aaugbh2N8LSn5VKr19kU/XFztj04lan53h3cnuDzrkTc1GOyy0FLPKbmjHsj
        pLKnZNzRxq3Oxqfmsu2d3hIgZDjRQxgYlW5/tvvV3QVsFaw8GpA2kpsUwJ/o9JRRf3ppnt
        TdvLVgVZnp1flZDYazzLUhTXqxFosVSZPvVoJWpwPoW9cCOjB0TAn4cVB4UvSOld8pd9Lw
        nSvg0F5AChaZJ1zUhx1yTAMwxQo6kClSaDvf0hkY0UDJLZW1i3N8wNfJhg4J5C0wRt0AIa
        1CVSiaD2oTX4aOtITopIqM6TYb8lwFccWCDOt+Wjr8fQtPRtHjI1OvKOSdT0NQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1653487414;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=55ocFR5c8Yck9KyS67JdgcKAJX3wIgoSeYZFc0YqsWw=;
        b=sIqUpH8IFMVk9RDjQ4zZ0iNlpK8/cEtwtEBeVfwzDNwy9OPAhc9Gw/MmyoMgkyziN1fsim
        XxdYOM6hE+g9Y4AQ==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel: Fix event constraints for ICL
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220525133952.1660658-1-kan.liang@linux.intel.com>
References: <20220525133952.1660658-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <165348741321.4207.8002435699917268067.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     86dca369075b3e310c3c0adb0f81e513c562b5e4
Gitweb:        https://git.kernel.org/tip/86dca369075b3e310c3c0adb0f81e513c562b5e4
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Wed, 25 May 2022 06:39:52 -07:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 25 May 2022 15:55:52 +02:00

perf/x86/intel: Fix event constraints for ICL

According to the latest event list, the event encoding 0x55
INST_DECODED.DECODERS and 0x56 UOPS_DECODED.DEC0 are only available on
the first 4 counters. Add them into the event constraints table.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220525133952.1660658-1-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 955ae91..45024ab 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -276,7 +276,7 @@ static struct event_constraint intel_icl_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT_RANGE(0x03, 0x0a, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0x1f, 0x28, 0xf),
 	INTEL_EVENT_CONSTRAINT(0x32, 0xf),	/* SW_PREFETCH_ACCESS.* */
-	INTEL_EVENT_CONSTRAINT_RANGE(0x48, 0x54, 0xf),
+	INTEL_EVENT_CONSTRAINT_RANGE(0x48, 0x56, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0x60, 0x8b, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_TOTAL */
 	INTEL_UEVENT_CONSTRAINT(0x10a3, 0xff),  /* CYCLE_ACTIVITY.CYCLES_MEM_ANY */
