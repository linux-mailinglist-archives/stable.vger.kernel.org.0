Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767F615667F
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgBHSfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:35:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34206 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727883AbgBHS3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-0003fe-ID; Sat, 08 Feb 2020 18:29:37 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-000CPJ-5p; Sat, 08 Feb 2020 18:29:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "Jiri Olsa" <jolsa@redhat.com>
Date:   Sat, 08 Feb 2020 18:20:12 +0000
Message-ID: <lsq.1581185940.855920811@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 073/148] perf probe: Skip end-of-sequence and non
 statement lines
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

commit f4d99bdfd124823a81878b44b5e8750b97f73902 upstream.

Skip end-of-sequence and non-statement lines while walking through lines
list.

The "end-of-sequence" line information means:

 "the current address is that of the first byte after the
  end of a sequence of target machine instructions."
 (DWARF version 4 spec 6.2.2)

This actually means out of scope and we can not probe on it.

On the other hand, the statement lines (is_stmt) means:

 "the current instruction is a recommended breakpoint location.
  A recommended breakpoint location is intended to “represent”
  a line, a statement and/or a semantically distinct subpart
  of a statement."

 (DWARF version 4 spec 6.2.2)

So, non-statement line info also should be skipped.

These can reduce unneeded probe points and also avoid an error.

E.g. without this patch:

  # perf probe -a "clear_tasks_mm_cpumask:1"
  Added new events:
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask:1)
    probe:clear_tasks_mm_cpumask_1 (on clear_tasks_mm_cpumask:1)
    probe:clear_tasks_mm_cpumask_2 (on clear_tasks_mm_cpumask:1)
    probe:clear_tasks_mm_cpumask_3 (on clear_tasks_mm_cpumask:1)
    probe:clear_tasks_mm_cpumask_4 (on clear_tasks_mm_cpumask:1)

  You can now use it in all perf tools, such as:

  	perf record -e probe:clear_tasks_mm_cpumask_4 -aR sleep 1

  #

This puts 5 probes on one line, but acutally it's not inlined function.
This is because there are many non statement instructions at the
function prologue.

With this patch:

  # perf probe -a "clear_tasks_mm_cpumask:1"
  Added new event:
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask:1)

  You can now use it in all perf tools, such as:

  	perf record -e probe:clear_tasks_mm_cpumask -aR sleep 1

  #

Now perf-probe skips unneeded addresses.

Committer testing:

Slightly different results, but similar:

Before:

  # uname -a
  Linux quaco 5.3.8-200.fc30.x86_64 #1 SMP Tue Oct 29 14:46:22 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
  #
  # perf probe -a "clear_tasks_mm_cpumask:1"
  Added new events:
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask:1)
    probe:clear_tasks_mm_cpumask_1 (on clear_tasks_mm_cpumask:1)
    probe:clear_tasks_mm_cpumask_2 (on clear_tasks_mm_cpumask:1)

  You can now use it in all perf tools, such as:

  	perf record -e probe:clear_tasks_mm_cpumask_2 -aR sleep 1

  #

After:

  # perf probe -a "clear_tasks_mm_cpumask:1"
  Added new event:
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask:1)

  You can now use it in all perf tools, such as:

  	perf record -e probe:clear_tasks_mm_cpumask -aR sleep 1

  # perf probe -l
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask@kernel/cpu.c)
  #

Fixes: 4cc9cec636e7 ("perf probe: Introduce lines walker interface")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157241936090.32002.12156347518596111660.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/dwarf-aux.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -712,6 +712,7 @@ int die_walk_lines(Dwarf_Die *rt_die, li
 	int decl = 0, inl;
 	Dwarf_Die die_mem, *cu_die;
 	size_t nlines, i;
+	bool flag;
 
 	/* Get the CU die */
 	if (dwarf_tag(rt_die) != DW_TAG_compile_unit) {
@@ -742,6 +743,12 @@ int die_walk_lines(Dwarf_Die *rt_die, li
 				  "Possible error in debuginfo.\n");
 			continue;
 		}
+		/* Skip end-of-sequence */
+		if (dwarf_lineendsequence(line, &flag) != 0 || flag)
+			continue;
+		/* Skip Non statement line-info */
+		if (dwarf_linebeginstatement(line, &flag) != 0 || !flag)
+			continue;
 		/* Filter lines based on address */
 		if (rt_die != cu_die) {
 			/*

