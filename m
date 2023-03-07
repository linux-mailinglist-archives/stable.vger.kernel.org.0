Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01456AF44A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbjCGTPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbjCGTPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41359CD642
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:58:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFDEFB819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DE7C433EF;
        Tue,  7 Mar 2023 18:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215536;
        bh=kMvp7gFlYG48e0gy9zh2ds+6ngif3I7ByloV1K603Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNuTtotbEljyIHadmybnZqlhvpyy5NUvZQEsLzkVd63q3OG/SeYBBok7dTEjMZDbz
         bVrOaebSdtkDEDQ1BqwCUQEssMX6ykXY8dObBztsSfl9h5wTi4GPURkr3J8ohNBi3B
         I8S2IDmflIjZUmZYOuOak5Ryq0MEGU64VOdDWUjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/567] perf intel-pt: Add documentation for Event Trace and TNT disable
Date:   Tue,  7 Mar 2023 17:59:58 +0100
Message-Id: <20230307165917.268155751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 24e3599c5a88e0e2995e3f5c9305f80195942dc9 ]

Add documentation for Event Trace and TNT disable to the perf Intel PT man
page.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/r/20220124084201.2699795-26-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: aeb802f872a7 ("perf intel-pt: Do not try to queue auxtrace data on pipe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-intel-pt.txt | 104 ++++++++++++++++++++-
 1 file changed, 102 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-intel-pt.txt b/tools/perf/Documentation/perf-intel-pt.txt
index db465fa7ee918..48460923a0e4e 100644
--- a/tools/perf/Documentation/perf-intel-pt.txt
+++ b/tools/perf/Documentation/perf-intel-pt.txt
@@ -108,9 +108,10 @@ displayed as follows:
 
 	perf script --itrace=ibxwpe -F+flags
 
-The flags are "bcrosyiABExgh" which stand for branch, call, return, conditional,
+The flags are "bcrosyiABExghDt" which stand for branch, call, return, conditional,
 system, asynchronous, interrupt, transaction abort, trace begin, trace end,
-in transaction, VM-entry, and VM-exit respectively.
+in transaction, VM-entry, VM-exit, interrupt disabled, and interrupt disable
+toggle respectively.
 
 perf script also supports higher level ways to dump instruction traces:
 
@@ -472,6 +473,30 @@ pwr_evt		Enable power events.  The power events provide information about
 		which contains "1" if the feature is supported and
 		"0" otherwise.
 
+event		Enable Event Trace.  The events provide information about asynchronous
+		events.
+
+		Support for this feature is indicated by:
+
+			/sys/bus/event_source/devices/intel_pt/caps/event_trace
+
+		which contains "1" if the feature is supported and
+		"0" otherwise.
+
+notnt		Disable TNT packets.  Without TNT packets, it is not possible to walk
+		executable code to reconstruct control flow, however FUP, TIP, TIP.PGE
+		and TIP.PGD packets still indicate asynchronous control flow, and (if
+		return compression is disabled - see noretcomp) return statements.
+		The advantage of eliminating TNT packets is reducing the size of the
+		trace and corresponding tracing overhead.
+
+		Support for this feature is indicated by:
+
+			/sys/bus/event_source/devices/intel_pt/caps/tnt_disable
+
+		which contains "1" if the feature is supported and
+		"0" otherwise.
+
 
 AUX area sampling option
 ~~~~~~~~~~~~~~~~~~~~~~~~
@@ -865,6 +890,8 @@ The letters are:
 	p	synthesize "power" events (incl. PSB events)
 	c	synthesize branches events (calls only)
 	r	synthesize branches events (returns only)
+	o	synthesize PEBS-via-PT events
+	I	synthesize Event Trace events
 	e	synthesize tracing error events
 	d	create a debug log
 	g	synthesize a call chain (use with i or x)
@@ -1338,6 +1365,79 @@ There were none.
           :17006 17006 [001] 11500.262869216:  ffffffff8220116e error_entry+0xe ([guest.kernel.kallsyms])               pushq  %rax
 
 
+Event Trace
+-----------
+
+Event Trace records information about asynchronous events, for example interrupts,
+faults, VM exits and entries.  The information is recorded in CFE and EVD packets,
+and also the Interrupt Flag is recorded on the MODE.Exec packet.  The CFE packet
+contains a type field to identify one of the following:
+
+	 1	INTR		interrupt, fault, exception, NMI
+	 2	IRET		interrupt return
+	 3	SMI		system management interrupt
+	 4	RSM		resume from system management mode
+	 5	SIPI		startup interprocessor interrupt
+	 6	INIT		INIT signal
+	 7	VMENTRY		VM-Entry
+	 8	VMEXIT		VM-Entry
+	 9	VMEXIT_INTR	VM-Exit due to interrupt
+	10	SHUTDOWN	Shutdown
+
+For more details, refer to the Intel 64 and IA-32 Architectures Software
+Developer Manuals (version 076 or later).
+
+The capability to do Event Trace is indicated by the
+/sys/bus/event_source/devices/intel_pt/caps/event_trace file.
+
+Event trace is selected for recording using the "event" config term. e.g.
+
+	perf record -e intel_pt/event/u uname
+
+Event trace events are output using the --itrace I option. e.g.
+
+	perf script --itrace=Ie
+
+perf script displays events containing CFE type, vector and event data,
+in the form:
+
+	  evt:   hw int            (t)  cfe: INTR IP: 1 vector: 3 PFA: 0x8877665544332211
+
+The IP flag indicates if the event binds to an IP, which includes any case where
+flow control packet generation is enabled, as well as when CFE packet IP bit is
+set.
+
+perf script displays events containing changes to the Interrupt Flag in the form:
+
+	iflag:   t                      IFLAG: 1->0 via branch
+
+where "via branch" indicates a branch (interrupt or return from interrupt) and
+"non branch" indicates an instruction such as CFI, STI or POPF).
+
+In addition, the current state of the interrupt flag is indicated by the presence
+or absence of the "D" (interrupt disabled) perf script flag.  If the interrupt
+flag is changed, then the "t" flag is also included i.e.
+
+		no flag, interrupts enabled IF=1
+	t	interrupts become disabled IF=1 -> IF=0
+	D	interrupts are disabled IF=0
+	Dt	interrupts become enabled  IF=0 -> IF=1
+
+The intel-pt-events.py script illustrates how to access Event Trace information
+using a Python script.
+
+
+TNT Disable
+-----------
+
+TNT packets are disabled using the "notnt" config term. e.g.
+
+	perf record -e intel_pt/notnt/u uname
+
+In that case the --itrace q option is forced because walking executable code
+to reconstruct the control flow is not possible.
+
+
 
 SEE ALSO
 --------
-- 
2.39.2



