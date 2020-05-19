Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E7A1D9FD4
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 20:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgESSo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 14:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgESSoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 14:44:24 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50301C08C5C0;
        Tue, 19 May 2020 11:44:24 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jb7Do-0006am-9M; Tue, 19 May 2020 20:44:12 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id CE2001C0178;
        Tue, 19 May 2020 20:44:11 +0200 (CEST)
Date:   Tue, 19 May 2020 18:44:11 -0000
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel: Add more available bits for
 OFFCORE_RESPONSE of Intel Tremont
Cc:     Stephane Eranian <eranian@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200501125442.7030-1-kan.liang@linux.intel.com>
References: <20200501125442.7030-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <158991385175.17951.3596220331125126731.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     0813c40556fce1eeefb996e020cc5339e0b84137
Gitweb:        https://git.kernel.org/tip/0813c40556fce1eeefb996e020cc5339e0b84137
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Fri, 01 May 2020 05:54:42 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 19 May 2020 20:34:16 +02:00

perf/x86/intel: Add more available bits for OFFCORE_RESPONSE of Intel Tremont

The mask in the extra_regs for Intel Tremont need to be extended to
allow more defined bits.

"Outstanding Requests" (bit 63) is only available on MSR_OFFCORE_RSP0;

Fixes: 6daeb8737f8a ("perf/x86/intel: Add Tremont core PMU support")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200501125442.7030-1-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 332954c..ca35c8b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -1892,8 +1892,8 @@ static __initconst const u64 tnt_hw_cache_extra_regs
 
 static struct extra_reg intel_tnt_extra_regs[] __read_mostly = {
 	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
-	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0xffffff9fffull, RSP_0),
-	INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0xffffff9fffull, RSP_1),
+	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x800ff0ffffff9fffull, RSP_0),
+	INTEL_UEVENT_EXTRA_REG(0x02b7, MSR_OFFCORE_RSP_1, 0xff0ffffff9fffull, RSP_1),
 	EVENT_EXTRA_END
 };
 
