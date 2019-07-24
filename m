Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758C273B4D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405116AbfGXT6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405110AbfGXT6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:58:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4AD220665;
        Wed, 24 Jul 2019 19:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998319;
        bh=R8xhwqWoNjf592ijyVip6z+iPjKBIxTJqfL6bn/9hDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdLiyPi1TO7+v/OGGiTlhtoVpyjs92cqKQzT5uM1HwhSDMNYtbpN1SR1D5n/B+maR
         3ziF7vUL4JtUTg9EUOM7chIqMSU6PzMwm2mpyN2x4jQWoSC+eqPmlfBRLa43T4IRXe
         dvVjrksF/tq+a+1DbAnJZHiKKlQmyXWP8rDLPxMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Gary Hook <Gary.Hook@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Liska <mliska@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Pu Wen <puwen@hygon.cn>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.1 324/371] perf/x86/amd/uncore: Set the thread mask for F17h L3 PMCs
Date:   Wed, 24 Jul 2019 21:21:16 +0200
Message-Id: <20190724191748.277200359@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 2f217d58a8a086d3399fecce39fb358848e799c4 upstream.

Fill in the L3 performance event select register ThreadMask
bitfield, to enable per hardware thread accounting.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Gary Hook <Gary.Hook@amd.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Liska <mliska@suse.cz>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pu Wen <puwen@hygon.cn>
Cc: Stephane Eranian <eranian@google.com>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lkml.kernel.org/r/20190628215906.4276-2-kim.phillips@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/amd/uncore.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -205,15 +205,22 @@ static int amd_uncore_event_init(struct
 	hwc->config = event->attr.config & AMD64_RAW_EVENT_MASK_NB;
 	hwc->idx = -1;
 
+	if (event->cpu < 0)
+		return -EINVAL;
+
 	/*
 	 * SliceMask and ThreadMask need to be set for certain L3 events in
 	 * Family 17h. For other events, the two fields do not affect the count.
 	 */
-	if (l3_mask && is_llc_event(event))
-		hwc->config |= (AMD64_L3_SLICE_MASK | AMD64_L3_THREAD_MASK);
+	if (l3_mask && is_llc_event(event)) {
+		int thread = 2 * (cpu_data(event->cpu).cpu_core_id % 4);
 
-	if (event->cpu < 0)
-		return -EINVAL;
+		if (smp_num_siblings > 1)
+			thread += cpu_data(event->cpu).apicid & 1;
+
+		hwc->config |= (1ULL << (AMD64_L3_THREAD_SHIFT + thread) &
+				AMD64_L3_THREAD_MASK) | AMD64_L3_SLICE_MASK;
+	}
 
 	uncore = event_to_amd_uncore(event);
 	if (!uncore)


