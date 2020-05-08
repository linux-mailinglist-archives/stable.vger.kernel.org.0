Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC88F1CB019
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgEHMhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgEHMhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF937207DD;
        Fri,  8 May 2020 12:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941472;
        bh=V2OjuT9f/QpJ6BnqvZuXrCXGGWej49JIhebHk+sWrnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LshjoaUQDpkXUljuqs+BYAuwk95HF3h2C7zqujAcNc+W4ZCqUVvGjmyBaP1WXAjtm
         dgOZBbx82sGwK/KuFsLQuEgiCxCuPqaoe9dP5Gv3dAG5nfqnKEBEfVZkTDZwYLYnCB
         fGQQCYGS/4dE4fwYTf/6jDfk05pA2fOp4XngsMEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, jolsa@kernel.org,
        kan.liang@intel.com, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 045/312] perf/x86: Fix filter_events() bug with event mappings
Date:   Fri,  8 May 2020 14:30:36 +0200
Message-Id: <20200508123127.726833611@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

commit 61b87cae6361ea6af161c1ffa549898892707b19 upstream.

This patch fixes a bug in the filter_events() function.

The patch fixes the bug whereby if some mappings did not
exist, e.g., STALLED_CYCLES_FRONTEND, then any event after it
in the attrs array would disappear from the published list of
events in /sys/devices/cpu/events. This could be verified
easily on any system post SNB (which do not publish
STALLED_CYCLES_FRONTEND):

	$ ./perf stat -e cycles,ref-cycles true
	Performance counter stats for 'true':
              1,217,348      cycles
	<not supported>      ref-cycles

The problem is that in filter_events() there is an assumption
that the argument (attrs) is organized in increasing continuous
event indexes related to the event_map(). But if we remove the
non-supported events by shifing the position in the array, then
the lookup x86_pmu.event_map() needs to compensate for it, otherwise
we are looking up the wrong index. This patch corrects this problem
by compensating for the deleted events and with that ref-cycles
reappears (here shown on Haswell):

	$ perf stat -e ref-cycles,cycles true
	Performance counter stats for 'true':
         4,525,910      ref-cycles
         1,064,920      cycles
       0.002943888 seconds time elapsed

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: jolsa@kernel.org
Cc: kan.liang@intel.com
Fixes: 8300daa26755 ("perf/x86: Filter out undefined events from sysfs events attribute")
Link: http://lkml.kernel.org/r/1449516805-6637-1-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1550,6 +1550,7 @@ static void __init filter_events(struct
 {
 	struct device_attribute *d;
 	struct perf_pmu_events_attr *pmu_attr;
+	int offset = 0;
 	int i, j;
 
 	for (i = 0; attrs[i]; i++) {
@@ -1558,7 +1559,7 @@ static void __init filter_events(struct
 		/* str trumps id */
 		if (pmu_attr->event_str)
 			continue;
-		if (x86_pmu.event_map(i))
+		if (x86_pmu.event_map(i + offset))
 			continue;
 
 		for (j = i; attrs[j]; j++)
@@ -1566,6 +1567,14 @@ static void __init filter_events(struct
 
 		/* Check the shifted attr. */
 		i--;
+
+		/*
+		 * event_map() is index based, the attrs array is organized
+		 * by increasing event index. If we shift the events, then
+		 * we need to compensate for the event_map(), otherwise
+		 * we are looking up the wrong event in the map
+		 */
+		offset++;
 	}
 }
 


