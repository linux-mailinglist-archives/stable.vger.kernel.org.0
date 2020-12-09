Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B812D4964
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 19:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733163AbgLISr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 13:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733254AbgLISpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 13:45:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC04AC06179C;
        Wed,  9 Dec 2020 10:44:41 -0800 (PST)
Date:   Wed, 09 Dec 2020 18:44:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607539480;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fOiBnEk+8/+kyqXmVd04bgw8qL+J7a4fTtASo7fvNvg=;
        b=HJkUQbxaYcPfYtfE2N7Ei1IM1cdZF+PESurq0TU9ZsUPHtRPsU020inzO7ApcPbjwe+o8y
        o7JvP6FXk4BUXr13/Jnb5/SBhqMZkGevZjgYRhA+PB5vreSR7KQ9qHLS5qZ2luqyyzVSg2
        wsh71H+yLBZhu7ee3/5rdENuASIliTScMAruXwjunPqvIdnRistX4yLAQTq1KFiil4I+Zt
        UEJ3GzLmSoi9dmJs+PK7MbL2m3z0NtW/Egu/YERmI2NjECXGKlire3yZTd3TcMjpXmDKeQ
        T851ahQ2DMOCLH9D1hxA4m5i6Pb7BBe79nbk03g3w3DCxQ2zPi5j0tkS1JdJeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607539480;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fOiBnEk+8/+kyqXmVd04bgw8qL+J7a4fTtASo7fvNvg=;
        b=mBZdqGaHUxzVd342cPoydQo6f4cEYfRq3g7l2keINadGoHBjNPTo2Pe1zBy9W20S1fctTc
        xcECg9S3FA+sQdAw==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel/lbr: Fix the return type of get_lbr_cycles()
Cc:     Stephane Eranian <eranian@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201125213720.15692-2-kan.liang@linux.intel.com>
References: <20201125213720.15692-2-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <160753947980.3364.1410052392262724615.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     f8129cd958b395575e5543ce25a8434874b04d3a
Gitweb:        https://git.kernel.org/tip/f8129cd958b395575e5543ce25a8434874b04d3a
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Wed, 25 Nov 2020 13:37:20 -08:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 09 Dec 2020 17:08:58 +01:00

perf/x86/intel/lbr: Fix the return type of get_lbr_cycles()

The cycle count of a timed LBR is always 1 in perf record -D.

The cycle count is stored in the first 16 bits of the IA32_LBR_x_INFO
register, but the get_lbr_cycles() return Boolean type.

Use u16 to replace the Boolean type.

Fixes: 47125db27e47 ("perf/x86/intel/lbr: Support Architectural LBR")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20201125213720.15692-2-kan.liang@linux.intel.com
---
 arch/x86/events/intel/lbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 8961653..e2b0efc 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -919,7 +919,7 @@ static __always_inline bool get_lbr_predicted(u64 info)
 	return !(info & LBR_INFO_MISPRED);
 }
 
-static __always_inline bool get_lbr_cycles(u64 info)
+static __always_inline u16 get_lbr_cycles(u64 info)
 {
 	if (static_cpu_has(X86_FEATURE_ARCH_LBR) &&
 	    !(x86_pmu.lbr_timed_lbr && info & LBR_INFO_CYC_CNT_VALID))
