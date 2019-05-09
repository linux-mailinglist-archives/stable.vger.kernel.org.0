Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E5219278
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfEISpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbfEISpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:45:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47C7C2183E;
        Thu,  9 May 2019 18:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427530;
        bh=S0Tt4ZKK6EQYjobmGT2IHopSDVpjcEeO0xmCEx3RX4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wze+88v6u5xpRPGUt1GHulNjYNC7xrljYPC4OMVbJQuMONrVMm3A02mxm9My/pxsz
         XV/rAYxQ0CNWLLE3w1iNBmzjauApdEfXHAQ9TRKnEBREhkq2pxi552c47GgW+eqrT+
         YgiUIlIh052f19Bqecvqkz/fvWOogfHIavLlwNdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Nelson DSouza <nelson.dsouza@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, tonyj@suse.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/42] perf/x86/intel: Initialize TFA MSR
Date:   Thu,  9 May 2019 20:42:06 +0200
Message-Id: <20190509181256.166848807@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
References: <20190509181252.616018683@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d7262457e35dbe239659e62654e56f8ddb814bed ]

Stephane reported that the TFA MSR is not initialized by the kernel,
but the TFA bit could set by firmware or as a leftover from a kexec,
which makes the state inconsistent.

Reported-by: Stephane Eranian <eranian@google.com>
Tested-by: Nelson DSouza <nelson.dsouza@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: tonyj@suse.com
Link: https://lkml.kernel.org/r/20190321123849.GN6521@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 74e26803be5dd..82ddee4ab25fd 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3427,6 +3427,12 @@ static void intel_pmu_cpu_starting(int cpu)
 
 	cpuc->lbr_sel = NULL;
 
+	if (x86_pmu.flags & PMU_FL_TFA) {
+		WARN_ON_ONCE(cpuc->tfa_shadow);
+		cpuc->tfa_shadow = ~0ULL;
+		intel_set_tfa(cpuc, false);
+	}
+
 	if (x86_pmu.version > 1)
 		flip_smm_bit(&x86_pmu.attr_freeze_on_smi);
 
-- 
2.20.1



