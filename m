Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B15156602
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgBHSbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:31:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34824 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727976AbgBHS3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:50 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-0003do-1g; Sat, 08 Feb 2020 18:29:36 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CNQ-VL; Sat, 08 Feb 2020 18:29:35 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Jiri Olsa" <jolsa@kernel.org>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "David Ahern" <dsahern@gmail.com>,
        "Peter Zijlstra" <peterz@infradead.org>
Date:   Sat, 08 Feb 2020 18:20:01 +0000
Message-ID: <lsq.1581185940.982847114@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 062/148] perf probe: Skip if the function address is 0
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 0ad45b33c58dca60dec7e1fb44766753bc4a7a38 upstream.

Skip probes if the entry address of the target function is 0.  This can
happen when we're handling C++ debuginfo files.

E.g. without this fix, below case still fail.
  ----
  $ ./perf probe -x /usr/lib64/libstdc++.so.6 -vD is_open
  probe-definition(0): is_open
  symbol:is_open file:(null) line:0 offset:0 return:0 lazy:(null)
  0 arguments
  symbol:catch file:(null) line:0 offset:0 return:0 lazy:(null)
  symbol:throw file:(null) line:0 offset:0 return:0 lazy:(null)
  symbol:rethrow file:(null) line:0 offset:0 return:0 lazy:(null)
  Open Debuginfo file: /usr/lib/debug/usr/lib64/libstdc++.so.6.0.22.debug
  Try to find probe point from debuginfo.
  Matched function: is_open [295df]
  found inline addr: 0x8ca80
  Probe point found: is_open+0
  found inline addr: 0x8ca70
  Probe point found: is_open+0
  found inline addr: 0x8ca60
  Probe point found: is_open+0
  Matched function: is_open [6527f]
  Matched function: is_open [9fe8a]
  Probe point found: is_open+0
  Matched function: is_open [19710b]
  found inline addr: 0xecca9
  Probe point found: stdio_filebuf+57
  found inline addr: 0x0
  Probe point found: swap+0
  Matched function: is_open [19fc9d]
  Probe point found: is_open+0
  Found 7 probe_trace_events.
  p:probe_libstdc++/is_open /usr/lib64/libstdc++.so.6.0.22:0x8ca80
  p:probe_libstdc++/is_open_1 /usr/lib64/libstdc++.so.6.0.22:0x8ca70
  p:probe_libstdc++/is_open_2 /usr/lib64/libstdc++.so.6.0.22:0x8ca60
  p:probe_libstdc++/is_open_3 /usr/lib64/libstdc++.so.6.0.22:0xb0ad0
  p:probe_libstdc++/is_open_4 /usr/lib64/libstdc++.so.6.0.22:0xecca9
  Failed to synthesize probe trace event.
    Error: Failed to add events. Reason: Invalid argument (Code: -22)
  ----
This is because some instances have entry_pc == 0 (see 19710b and
19fc9d). With this fix, those are skipped.

  ----
  $ ./perf probe -x /usr/lib64/libstdc++.so.6 -D is_open
  p:probe_libstdc++/is_open /usr/lib64/libstdc++.so.6.0.22:0x8ca80
  p:probe_libstdc++/is_open_1 /usr/lib64/libstdc++.so.6.0.22:0x8ca70
  p:probe_libstdc++/is_open_2 /usr/lib64/libstdc++.so.6.0.22:0x8ca60
  p:probe_libstdc++/is_open_3 /usr/lib64/libstdc++.so.6.0.22:0xb0ad0
  p:probe_libstdc++/is_open_4 /usr/lib64/libstdc++.so.6.0.22:0xecca9
  ----

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/147464490707.29804.14277897643725143867.stgit@devbox
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/probe-finder.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -871,6 +871,11 @@ static int probe_point_inline_cb(Dwarf_D
 				   dwarf_diename(in_die));
 			return -ENOENT;
 		}
+		if (addr == 0) {
+			pr_debug("%s has no valid entry address. skipped.\n",
+				 dwarf_diename(in_die));
+			return -ENOENT;
+		}
 		pf->addr = addr;
 		pf->addr += pp->offset;
 		pr_debug("found inline addr: 0x%jx\n",
@@ -912,8 +917,13 @@ static int probe_point_search_cb(Dwarf_D
 	} else if (die_is_func_instance(sp_die)) {
 		/* Instances always have the entry address */
 		dwarf_entrypc(sp_die, &pf->addr);
+		/* But in some case the entry address is 0 */
+		if (pf->addr == 0) {
+			pr_debug("%s has no entry PC. Skipped\n",
+				 dwarf_diename(sp_die));
+			param->retval = 0;
 		/* Real function */
-		if (pp->lazy_line)
+		} else if (pp->lazy_line)
 			param->retval = find_probe_point_lazy(sp_die, pf);
 		else {
 			pf->addr += pp->offset;

