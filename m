Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4574218B890
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 15:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgCSOEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 10:04:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60718 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCSOEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 10:04:53 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jEvmu-0001oV-9g; Thu, 19 Mar 2020 15:04:44 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id D20671C22A2;
        Thu, 19 Mar 2020 15:04:43 +0100 (CET)
Date:   Thu, 19 Mar 2020 14:04:43 -0000
From:   "tip-bot2 for Masami Hiramatsu" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf probe: Fix to delete multiple probe event
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        He Zhe <zhe.he@windriver.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <158287666197.16697.7514373548551863562.stgit@devnote2>
References: <158287666197.16697.7514373548551863562.stgit@devnote2>
MIME-Version: 1.0
Message-ID: <158462668350.28353.16128321208340622107.tip-bot2@tip-bot2>
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

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     6b8d68f1ce9266b05a55e93c62923ff51daae4c1
Gitweb:        https://git.kernel.org/tip/6b8d68f1ce9266b05a55e93c62923ff51daae4c1
Author:        Masami Hiramatsu <mhiramat@kernel.org>
AuthorDate:    Fri, 28 Feb 2020 16:57:42 +09:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Mon, 09 Mar 2020 10:41:14 -03:00

perf probe: Fix to delete multiple probe event

When we put an event with multiple probes, perf-probe fails to delete
with filters. This comes from a failure to list up the event name
because of overwrapping its name.

To fix this issue, skip to list up the event which has same name.

Without this patch:

  # perf probe -l \*
    probe_perf:map__map_ip (on perf_sample__fprintf_brstackoff:21@
    probe_perf:map__map_ip (on perf_sample__fprintf_brstackoff:25@
    probe_perf:map__map_ip (on append_inlines:12@util/machine.c in
    probe_perf:map__map_ip (on unwind_entry:19@util/machine.c in /
    probe_perf:map__map_ip (on map__map_ip@util/map.h in /home/mhi
    probe_perf:map__map_ip (on map__map_ip@util/map.h in /home/mhi
  # perf probe -d \*
  "*" does not hit any event.
    Error: Failed to delete events. Reason: No such file or directory (Code: -2)

With it:

  # perf probe -d \*
  Removed event: probe_perf:map__map_ip
  #

Fixes: 72363540c009 ("perf probe: Support multiprobe event")
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Reported-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/158287666197.16697.7514373548551863562.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/probe-file.c b/tools/perf/util/probe-file.c
index 0f5fda1..8c85294 100644
--- a/tools/perf/util/probe-file.c
+++ b/tools/perf/util/probe-file.c
@@ -206,6 +206,9 @@ static struct strlist *__probe_file__get_namelist(int fd, bool include_group)
 		} else
 			ret = strlist__add(sl, tev.event);
 		clear_probe_trace_event(&tev);
+		/* Skip if there is same name multi-probe event in the list */
+		if (ret == -EEXIST)
+			ret = 0;
 		if (ret < 0)
 			break;
 	}
