Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A32B1C4383
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgEDR7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730658AbgEDR7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFCF020746;
        Mon,  4 May 2020 17:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615143;
        bh=/d4LLvuy0JaQAOIVCX8DV7isbzzvmVxxFXjbhAkZVNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHFq3E2xZjeq5Wl8BWtjXL5YVBMjGSS3l86o8KknOa6vQliILifUxA81nCBq0VRCZ
         mfSlObOgd89aoPSzPho/aIBXV23Kk6icnj/wv5sf6QxgsCMSGWu9BNFDu6JGzzwHPs
         uPc/ghKnjw+QAP4eD0Za5K87ilXizBRqRFkCHLdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 13/18] perf/x86: Fix uninitialized value usage
Date:   Mon,  4 May 2020 19:57:11 +0200
Message-Id: <20200504165444.253471372@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit e01d8718de4170373cd7fbf5cf6f9cb61cebb1e9 upstream.

When calling intel_alt_er() with .idx != EXTRA_REG_RSP_* we will not
initialize alt_idx and then use this uninitialized value to index an
array.

When that is not fatal, it can result in an infinite loop in its
caller __intel_shared_reg_get_constraints(), with IRQs disabled.

Alternative error modes are random memory corruption due to the
cpuc->shared_regs->regs[] array overrun, which manifest in either
get_constraints or put_constraints doing weird stuff.

Only took 6 hours of painful debugging to find this. Neither GCC nor
Smatch warnings flagged this bug.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Fixes: ae3f011fc251 ("perf/x86/intel: Fix SLM MSR_OFFCORE_RSP1 valid_mask")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event_intel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1937,7 +1937,8 @@ intel_bts_constraints(struct perf_event
 
 static int intel_alt_er(int idx, u64 config)
 {
-	int alt_idx;
+	int alt_idx = idx;
+
 	if (!(x86_pmu.flags & PMU_FL_HAS_RSP_1))
 		return idx;
 


