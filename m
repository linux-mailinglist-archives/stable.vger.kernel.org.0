Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F8133F074
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 13:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhCQMie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 08:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhCQMi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 08:38:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A07C06174A;
        Wed, 17 Mar 2021 05:38:27 -0700 (PDT)
Date:   Wed, 17 Mar 2021 12:38:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615984706;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NMK9mwYemz31+TAh2smZqXf6rAO8D93gOnHoa7VYhuU=;
        b=0pr6LBYQpF0sIMjckGbctFZxBGrDcLEKBPnVjDuEb102m6wWPyGlLgGauiVibneNFsphTU
        k/WmV2SS1N2CQHx9Zvf3J9hQsdSKuKaQBZRJfKaBFe2PmtmghoV3iMPApoeZmP7JKDgAkq
        tINXQsAwEk/+1kTxlv6xwQzy7Of9VBlwBONTL1NodwHZwE55uxfYwS4Z4ldYA7T1A7IVul
        szGJ98MRGJMVhlKqftbKndxzVJrsv0X8lUzZ3gHTERJ0ltELYQl4W5a3rBnaarqQ0bZDef
        UdE3eY9t53LmIHKCeoUAp2e/yTBNB0iq8/J72j4tYSwTAdkp5NPp0gV6WwS4Sw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615984706;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NMK9mwYemz31+TAh2smZqXf6rAO8D93gOnHoa7VYhuU=;
        b=aQq0sLazXcCQOFp1kTk3JTaynKivOp92FBar5NbZ5YWE+7J5hGSazQBd+cAoCcppLsCaBA
        dRr47z0olh6Tp+Bg==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel: Fix unchecked MSR access error
 caused by VLBR_EVENT
Cc:     Vince Weaver <vincent.weaver@maine.edu>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1615555298-140216-2-git-send-email-kan.liang@linux.intel.com>
References: <1615555298-140216-2-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <161598470558.398.3008177602318423260.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     2dc0572f2cef87425147658698dce2600b799bd3
Gitweb:        https://git.kernel.org/tip/2dc0572f2cef87425147658698dce2600b799bd3
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Fri, 12 Mar 2021 05:21:38 -08:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 16 Mar 2021 21:44:39 +01:00

perf/x86/intel: Fix unchecked MSR access error caused by VLBR_EVENT

On a Haswell machine, the perf_fuzzer managed to trigger this message:

[117248.075892] unchecked MSR access error: WRMSR to 0x3f1 (tried to
write 0x0400000000000000) at rIP: 0xffffffff8106e4f4
(native_write_msr+0x4/0x20)
[117248.089957] Call Trace:
[117248.092685]  intel_pmu_pebs_enable_all+0x31/0x40
[117248.097737]  intel_pmu_enable_all+0xa/0x10
[117248.102210]  __perf_event_task_sched_in+0x2df/0x2f0
[117248.107511]  finish_task_switch.isra.0+0x15f/0x280
[117248.112765]  schedule_tail+0xc/0x40
[117248.116562]  ret_from_fork+0x8/0x30

A fake event called VLBR_EVENT may use the bit 58 of the PEBS_ENABLE, if
the precise_ip is set. The bit 58 is reserved by the HW. Accessing the
bit causes the unchecked MSR access error.

The fake event doesn't support PEBS. The case should be rejected.

Fixes: 097e4311cda9 ("perf/x86: Add constraint to create guest LBR event without hw counter")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1615555298-140216-2-git-send-email-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 7bbb5bb..37ce384 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3659,6 +3659,9 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		return ret;
 
 	if (event->attr.precise_ip) {
+		if ((event->attr.config & INTEL_ARCH_EVENT_MASK) == INTEL_FIXED_VLBR_EVENT)
+			return -EINVAL;
+
 		if (!(event->attr.freq || (event->attr.wakeup_events && !event->attr.watermark))) {
 			event->hw.flags |= PERF_X86_EVENT_AUTO_RELOAD;
 			if (!(event->attr.sample_type &
