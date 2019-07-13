Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06B2679E4
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 13:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfGMLLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 07:11:44 -0400
Received: from terminus.zytor.com ([198.137.202.136]:55395 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfGMLLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 07:11:44 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x6DBAqfV3841685
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 13 Jul 2019 04:10:53 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x6DBAqfV3841685
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019061801; t=1563016254;
        bh=3xEz6p5aOvGBZ2JJ/xzY6MXlyxphrTDLkgi2kX1X6GU=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=SHIMaZ1CVqGWON1Sc+lWdEKCZaoBxpYwUSQjLHoQQR1zkO1QlWezX2SyYKOGVxLXa
         zHUhmoPOkk7gWLj7njfSv8UbnvP7fCLx0fwC1UvqdKS1iuASXgtrwicYkXcKPBYuZL
         HiTnBzzbIoNRUrOYvsKAyQmETPEHRwa2xvCdSDYehYjJAvmIpLwy+FBkpHFP5xw7RO
         pGv45CLhIVcVC56sWm2DwIpXt794JBprpXUB59s8pFrONKiHUUqNOIJ7o68ZGmfWLP
         V6vkQJSFEyuRNNCqHfeLIjQgTsGiIGo5EX8aq2m63qt2curdsUtMjljnTKXEkj5WFP
         g3ehsHGJc4XLA==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x6DBApYL3841681;
        Sat, 13 Jul 2019 04:10:51 -0700
Date:   Sat, 13 Jul 2019 04:10:51 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Kim Phillips <tipbot@zytor.com>
Message-ID: <tip-16f4641166b10e199f0d7b68c2c5f004fef0bda3@git.kernel.org>
Cc:     stable@vger.kernel.org, mliska@suse.cz, puwen@hygon.cn,
        linux-kernel@vger.kernel.org, vincent.weaver@maine.edu,
        namhyung@kernel.org, mingo@kernel.org, Gary.Hook@amd.com,
        tglx@linutronix.de, alexander.shishkin@linux.intel.com,
        peterz@infradead.org, eranian@google.com, acme@redhat.com,
        Janakarajan.Natarajan@amd.com, kim.phillips@amd.com,
        Suravee.Suthikulpanit@amd.com, jolsa@redhat.com,
        torvalds@linux-foundation.org, hpa@zytor.com, bp@alien8.de
Reply-To: acme@redhat.com, eranian@google.com, kim.phillips@amd.com,
          Janakarajan.Natarajan@amd.com, jolsa@redhat.com,
          Suravee.Suthikulpanit@amd.com, torvalds@linux-foundation.org,
          hpa@zytor.com, bp@alien8.de, stable@vger.kernel.org,
          puwen@hygon.cn, linux-kernel@vger.kernel.org, mliska@suse.cz,
          vincent.weaver@maine.edu, namhyung@kernel.org, Gary.Hook@amd.com,
          mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org,
          alexander.shishkin@linux.intel.com
In-Reply-To: <20190628215906.4276-1-kim.phillips@amd.com>
References: <20190628215906.4276-1-kim.phillips@amd.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/amd/uncore: Do not set 'ThreadMask' and
 'SliceMask' for non-L3 PMCs
Git-Commit-ID: 16f4641166b10e199f0d7b68c2c5f004fef0bda3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  16f4641166b10e199f0d7b68c2c5f004fef0bda3
Gitweb:     https://git.kernel.org/tip/16f4641166b10e199f0d7b68c2c5f004fef0bda3
Author:     Kim Phillips <kim.phillips@amd.com>
AuthorDate: Fri, 28 Jun 2019 21:59:20 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 13 Jul 2019 11:21:26 +0200

perf/x86/amd/uncore: Do not set 'ThreadMask' and 'SliceMask' for non-L3 PMCs

The following commit:

  d7cbbe49a930 ("perf/x86/amd/uncore: Set ThreadMask and SliceMask for L3 Cache perf events")

enables L3 PMC events for all threads and slices by writing 1's in
'ChL3PmcCfg' (L3 PMC PERF_CTL) register fields.

Those bitfields overlap with high order event select bits in the Data
Fabric PMC control register, however.

So when a user requests raw Data Fabric events (-e amd_df/event=0xYYY/),
the two highest order bits get inadvertently set, changing the counter
select to events that don't exist, and for which no counts are read.

This patch changes the logic to write the L3 masks only when dealing
with L3 PMC counters.

AMD Family 16h and below Northbridge (NB) counters were not affected.

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
Fixes: d7cbbe49a930 ("perf/x86/amd/uncore: Set ThreadMask and SliceMask for L3 Cache perf events")
Link: https://lkml.kernel.org/r/20190628215906.4276-1-kim.phillips@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/events/amd/uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 85e6984c560b..c2c4ae5fbbfc 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -206,7 +206,7 @@ static int amd_uncore_event_init(struct perf_event *event)
 	 * SliceMask and ThreadMask need to be set for certain L3 events in
 	 * Family 17h. For other events, the two fields do not affect the count.
 	 */
-	if (l3_mask)
+	if (l3_mask && is_llc_event(event))
 		hwc->config |= (AMD64_L3_SLICE_MASK | AMD64_L3_THREAD_MASK);
 
 	if (event->cpu < 0)
