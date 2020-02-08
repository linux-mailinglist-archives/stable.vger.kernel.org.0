Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382D3156663
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgBHSeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:34:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34220 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727887AbgBHS3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-0003fW-FY; Sat, 08 Feb 2020 18:29:37 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-000COo-0L; Sat, 08 Feb 2020 18:29:36 +0000
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
Date:   Sat, 08 Feb 2020 18:20:08 +0000
Message-ID: <lsq.1581185940.60363127@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 069/148] perf probe: Fix to show inlined function
 callsite without entry_pc
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

commit 18e21eb671dc87a4f0546ba505a89ea93598a634 upstream.

Fix 'perf probe --line' option to show inlined function callsite lines
even if the function DIE has only ranges.

Without this:

  # perf probe -L amd_put_event_constraints
  ...
      2  {
      3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
                        __amd_put_nb_event_constraints(cpuc, event);
      5  }

With this patch:

  # perf probe -L amd_put_event_constraints
  ...
      2  {
      3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
      4                 __amd_put_nb_event_constraints(cpuc, event);
      5  }

Committer testing:

Before:

  [root@quaco ~]# perf probe -L amd_put_event_constraints
  <amd_put_event_constraints@/usr/src/debug/kernel-5.2.fc30/linux-5.2.18-200.fc30.x86_64/arch/x86/events/amd/core.c:0>
        0  static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
                                                struct perf_event *event)
        2  {
        3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
                          __amd_put_nb_event_constraints(cpuc, event);
        5  }

           PMU_FORMAT_ATTR(event, "config:0-7,32-35");
           PMU_FORMAT_ATTR(umask, "config:8-15"   );

  [root@quaco ~]#

After:

  [root@quaco ~]# perf probe -L amd_put_event_constraints
  <amd_put_event_constraints@/usr/src/debug/kernel-5.2.fc30/linux-5.2.18-200.fc30.x86_64/arch/x86/events/amd/core.c:0>
        0  static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
                                                struct perf_event *event)
        2  {
        3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
        4                 __amd_put_nb_event_constraints(cpuc, event);
        5  }

           PMU_FORMAT_ATTR(event, "config:0-7,32-35");
           PMU_FORMAT_ATTR(umask, "config:8-15"   );

  [root@quaco ~]# perf probe amd_put_event_constraints:4
  Added new event:
    probe:amd_put_event_constraints (on amd_put_event_constraints:4)

  You can now use it in all perf tools, such as:

  	perf record -e probe:amd_put_event_constraints -aR sleep 1

  [root@quaco ~]#

  [root@quaco ~]# perf probe -l
    probe:amd_put_event_constraints (on amd_put_event_constraints:4@arch/x86/events/amd/core.c)
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask@kernel/cpu.c)
  [root@quaco ~]#

Using it:

  [root@quaco ~]# perf trace -e probe:*
  ^C[root@quaco ~]#

Ok, Intel system here... :-)

Fixes: 4cc9cec636e7 ("perf probe: Introduce lines walker interface")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157199322107.8075.12659099000567865708.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/dwarf-aux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -628,7 +628,7 @@ static int __die_walk_funclines_cb(Dwarf
 	if (dwarf_tag(in_die) == DW_TAG_inlined_subroutine) {
 		fname = die_get_call_file(in_die);
 		lineno = die_get_call_lineno(in_die);
-		if (fname && lineno > 0 && dwarf_entrypc(in_die, &addr) == 0) {
+		if (fname && lineno > 0 && die_entrypc(in_die, &addr) == 0) {
 			lw->retval = lw->callback(fname, lineno, addr, lw->data);
 			if (lw->retval != 0)
 				return DIE_FIND_CB_END;

