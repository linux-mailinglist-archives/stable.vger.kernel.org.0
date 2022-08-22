Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A7359BC2D
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 11:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiHVJBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 05:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiHVJA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 05:00:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EDE2E9EE;
        Mon, 22 Aug 2022 02:00:56 -0700 (PDT)
Date:   Mon, 22 Aug 2022 09:00:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661158854;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dM3ojszo3Veb8HoUmWERKHR8FJOVeplfXo3T1F8LY58=;
        b=gj7pKeIaBS2ImOOqOgKXS9jcGggbX1n0/F+0+34kqcOkTkaGMNZKhWQRWsvjD3mMX1PkHI
        XbDhhV0Ealw1qqu1h+Rysm3fviIkPKVKutCziLNWQnXk04ZhQsPXkYRHsshiqTCtWQ9JOQ
        kyUy5Uvjqr12KLiJ1bOMlH64VrJStGe2vrKi3uRupIU0t1MYSo7C3Bv+DvFhvkavPv0YJj
        ktgRrELclzmlSKDyz6ZQg0bgpPY00ZkkjTnEb3MKFE9kOPQsWcag6mysA8Jg6yrC41whoX
        /jXWu3Yd2A8DZigmyOCeaONKijTb9eOXAHcB/vnDZ7FrqVokCTRMYjaS7toa3A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661158854;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dM3ojszo3Veb8HoUmWERKHR8FJOVeplfXo3T1F8LY58=;
        b=j34P7dibyDnyYA3Xyjlxq2hCc3/JTKJ2n7RxH2UgnSpB3GLctBP1Uwu4Zy89lDxnljQfqf
        CSwhcVh1E7qt0vDw==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/lbr: Enable the branch type for the Arch
 LBR by default
Cc:     Stephane Eranian <eranian@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220816125612.2042397-1-kan.liang@linux.intel.com>
References: <20220816125612.2042397-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <166115885282.401.13470060231625531121.tip-bot2@tip-bot2>
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

Commit-ID:     32ba156df1b1c8804a4e5be5339616945eafea22
Gitweb:        https://git.kernel.org/tip/32ba156df1b1c8804a4e5be5339616945eafea22
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Tue, 16 Aug 2022 05:56:11 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Fri, 19 Aug 2022 19:47:30 +02:00

perf/x86/lbr: Enable the branch type for the Arch LBR by default

On the platform with Arch LBR, the HW raw branch type encoding may leak
to the perf tool when the SAVE_TYPE option is not set.

In the intel_pmu_store_lbr(), the HW raw branch type is stored in
lbr_entries[].type. If the SAVE_TYPE option is set, the
lbr_entries[].type will be converted into the generic PERF_BR_* type
in the intel_pmu_lbr_filter() and exposed to the user tools.
But if the SAVE_TYPE option is NOT set by the user, the current perf
kernel doesn't clear the field. The HW raw branch type leaks.

There are two solutions to fix the issue for the Arch LBR.
One is to clear the field if the SAVE_TYPE option is NOT set.
The other solution is to unconditionally convert the branch type and
expose the generic type to the user tools.

The latter is implemented here, because
- The branch type is valuable information. I don't see a case where
  you would not benefit from the branch type. (Stephane Eranian)
- Not having the branch type DOES NOT save any space in the
  branch record (Stephane Eranian)
- The Arch LBR HW can retrieve the common branch types from the
  LBR_INFO. It doesn't require the high overhead SW disassemble.

Fixes: 47125db27e47 ("perf/x86/intel/lbr: Support Architectural LBR")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220816125612.2042397-1-kan.liang@linux.intel.com
---
 arch/x86/events/intel/lbr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 4f70fb6..47fca6a 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1097,6 +1097,14 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
 
 	if (static_cpu_has(X86_FEATURE_ARCH_LBR)) {
 		reg->config = mask;
+
+		/*
+		 * The Arch LBR HW can retrieve the common branch types
+		 * from the LBR_INFO. It doesn't require the high overhead
+		 * SW disassemble.
+		 * Enable the branch type by default for the Arch LBR.
+		 */
+		reg->reg |= X86_BR_TYPE_SAVE;
 		return 0;
 	}
 
