Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4013B15660B
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgBHSbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:31:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34820 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727974AbgBHS3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:50 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dB-IC; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CNB-MB; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Masami Hiramatsu" <masami.hiramatsu.pt@hitachi.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Namhyung Kim" <namhyung@kernel.org>
Date:   Sat, 08 Feb 2020 18:19:58 +0000
Message-ID: <lsq.1581185940.917825935@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 059/148] perf probe: Fix to handle optimized
 not-inlined functions
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

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

commit e1ecbbc3fa834cc6b4b344edb1968e734d57189b upstream.

Fix to handle optimized no-inline functions which have only function
definition but no actual instance at that point.

To fix this problem, we need to find actual instance of the function.

Without this patch:
  ----
  # perf probe -a __up
  Failed to get entry address of __up.
    Error: Failed to add events.
  # perf probe -L __up
  Specified source line is not found.
    Error: Failed to show lines.
  ----

With this patch:
  ----
  # perf probe -a __up
  Added new event:
    probe:__up           (on __up)

  You can now use it in all perf tools, such as:

          perf record -e probe:__up -aR sleep 1

  # perf probe -L __up
  <__up@/home/fedora/ksrc/linux-3/kernel/locking/semaphore.c:0>
        0  static noinline void __sched __up(struct semaphore *sem)
           {
                  struct semaphore_waiter *waiter = list_first_entry(&sem->wait_
                                                          struct semaphore_waite
        4         list_del(&waiter->list);
        5         waiter->up = true;
        6         wake_up_process(waiter->task);
        7  }
  ----

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20150130093744.30575.43290.stgit@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/dwarf-aux.c    | 15 +++++++++++++++
 tools/perf/util/dwarf-aux.h    |  3 +++
 tools/perf/util/probe-finder.c | 12 ++++--------
 3 files changed, 22 insertions(+), 8 deletions(-)

--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -278,6 +278,21 @@ bool die_is_func_def(Dwarf_Die *dw_die)
 }
 
 /**
+ * die_is_func_instance - Ensure that this DIE is an instance of a subprogram
+ * @dw_die: a DIE
+ *
+ * Ensure that this DIE is an instance (which has an entry address).
+ * This returns true if @dw_die is a function instance. If not, you need to
+ * call die_walk_instances() to find actual instances.
+ **/
+bool die_is_func_instance(Dwarf_Die *dw_die)
+{
+	Dwarf_Addr tmp;
+
+	/* Actually gcc optimizes non-inline as like as inlined */
+	return !dwarf_func_inline(dw_die) && dwarf_entrypc(dw_die, &tmp) == 0;
+}
+/**
  * die_get_data_member_location - Get the data-member offset
  * @mb_die: a DIE of a member of a data structure
  * @offs: The offset of the member in the data structure
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -41,6 +41,9 @@ extern int cu_walk_functions_at(Dwarf_Di
 /* Ensure that this DIE is a subprogram and definition (not declaration) */
 extern bool die_is_func_def(Dwarf_Die *dw_die);
 
+/* Ensure that this DIE is an instance of a subprogram */
+extern bool die_is_func_instance(Dwarf_Die *dw_die);
+
 /* Compare diename and tname */
 extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
 
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -909,17 +909,13 @@ static int probe_point_search_cb(Dwarf_D
 		dwarf_decl_line(sp_die, &pf->lno);
 		pf->lno += pp->line;
 		param->retval = find_probe_point_by_line(pf);
-	} else if (!dwarf_func_inline(sp_die)) {
+	} else if (die_is_func_instance(sp_die)) {
+		/* Instances always have the entry address */
+		dwarf_entrypc(sp_die, &pf->addr);
 		/* Real function */
 		if (pp->lazy_line)
 			param->retval = find_probe_point_lazy(sp_die, pf);
 		else {
-			if (dwarf_entrypc(sp_die, &pf->addr) != 0) {
-				pr_warning("Failed to get entry address of "
-					   "%s.\n", dwarf_diename(sp_die));
-				param->retval = -ENOENT;
-				return DWARF_CB_ABORT;
-			}
 			pf->addr += pp->offset;
 			/* TODO: Check the address in this function */
 			param->retval = call_probe_finder(sp_die, pf);
@@ -1514,7 +1510,7 @@ static int line_range_search_cb(Dwarf_Di
 		pr_debug("New line range: %d to %d\n", lf->lno_s, lf->lno_e);
 		lr->start = lf->lno_s;
 		lr->end = lf->lno_e;
-		if (dwarf_func_inline(sp_die))
+		if (!die_is_func_instance(sp_die))
 			param->retval = die_walk_instances(sp_die,
 						line_range_inline_cb, lf);
 		else

