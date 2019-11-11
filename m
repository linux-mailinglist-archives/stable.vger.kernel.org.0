Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F11F7D4D
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbfKKSzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:55:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbfKKSzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:55:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE732222BD;
        Mon, 11 Nov 2019 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498530;
        bh=Tqhu+9f03OilOW6+eILq5Bv9vTNqSi1CiKwBg/6mxrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZ1X7nXF5NyEgZcz+vDHtYk0sly0enGmvRwMtTXK0ReaexQtviXTPvt8QIlSf+Snb
         EHCDIZlaPjDmbou1ZzN5+OSEyX6FdxG1yL5oiPn3dvLSY8hTE4ndDeXkrMdPcW0K8i
         ps+q2ys/mhKJeELu9SNSLnFokX/iezY/ZU/uxqDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 145/193] perf/x86/amd/ibs: Handle erratum #420 only on the affected CPU family (10h)
Date:   Mon, 11 Nov 2019 19:28:47 +0100
Message-Id: <20191111181511.854049502@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit e431e79b60603079d269e0c2a5177943b95fa4b6 ]

This saves us writing the IBS control MSR twice when disabling the
event.

I searched revision guides for all families since 10h, and did not
find occurrence of erratum #420, nor anything remotely similar:
so we isolate the secondary MSR write to family 10h only.

Also unconditionally update the count mask for IBS Op implementations
that have read & writeable current count (CurCnt) fields in addition
to the MaxCnt field.  These bits were reserved on prior
implementations, and therefore shouldn't have negative impact.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Fixes: c9574fe0bdb9 ("perf/x86-ibs: Implement workaround for IBS erratum #420")
Link: https://lkml.kernel.org/r/20191023150955.30292-2-kim.phillips@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 98ba21a588a15..26c36357c4c9c 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -377,7 +377,8 @@ static inline void perf_ibs_disable_event(struct perf_ibs *perf_ibs,
 					  struct hw_perf_event *hwc, u64 config)
 {
 	config &= ~perf_ibs->cnt_mask;
-	wrmsrl(hwc->config_base, config);
+	if (boot_cpu_data.x86 == 0x10)
+		wrmsrl(hwc->config_base, config);
 	config &= ~perf_ibs->enable_mask;
 	wrmsrl(hwc->config_base, config);
 }
@@ -553,7 +554,8 @@ static struct perf_ibs perf_ibs_op = {
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_CONFIG_MASK,
-	.cnt_mask		= IBS_OP_MAX_CNT,
+	.cnt_mask		= IBS_OP_MAX_CNT | IBS_OP_CUR_CNT |
+				  IBS_OP_CUR_CNT_RAND,
 	.enable_mask		= IBS_OP_ENABLE,
 	.valid_mask		= IBS_OP_VAL,
 	.max_period		= IBS_OP_MAX_CNT << 4,
-- 
2.20.1



