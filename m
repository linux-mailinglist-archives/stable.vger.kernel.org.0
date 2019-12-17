Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F620122038
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfLQAxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:53:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35538 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727193AbfLQAvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003Ml-Gm; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005ak-Be; Tue, 17 Dec 2019 00:51:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Borislav Petkov" <bp@alien8.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Vince Weaver" <vincent.weaver@maine.edu>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        "Jiri Olsa" <jolsa@redhat.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Stephane Eranian" <eranian@google.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        "Kim Phillips" <kim.phillips@amd.com>
Date:   Tue, 17 Dec 2019 00:47:10 +0000
Message-ID: <lsq.1576543535.24713784@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 096/136] perf/x86/amd/ibs: Handle erratum #420 only
 on the affected CPU family (10h)
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kim Phillips <kim.phillips@amd.com>

commit e431e79b60603079d269e0c2a5177943b95fa4b6 upstream.

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
[bwh: Backported to 3.16:
 - Don't update the count mask; we don't use or define the CurCnt fields here
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -351,7 +351,8 @@ static inline void perf_ibs_disable_even
 					  struct hw_perf_event *hwc, u64 config)
 {
 	config &= ~perf_ibs->cnt_mask;
-	wrmsrl(hwc->config_base, config);
+	if (boot_cpu_data.x86 == 0x10)
+		wrmsrl(hwc->config_base, config);
 	config &= ~perf_ibs->enable_mask;
 	wrmsrl(hwc->config_base, config);
 }

