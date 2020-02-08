Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FF61566B7
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgBHSgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:36:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33880 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727789AbgBHS3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:40 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-0003dE-0G; Sat, 08 Feb 2020 18:29:36 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-000CO3-HW; Sat, 08 Feb 2020 18:29:35 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Jiri Olsa" <jolsa@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Masami Hiramatsu" <mhiramat@kernel.org>
Date:   Sat, 08 Feb 2020 18:20:04 +0000
Message-ID: <lsq.1581185940.153668418@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 065/148] perf probe: Fix wrong address verification
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

commit 07d369857808b7e8e471bbbbb0074a6718f89b31 upstream.

Since there are some DIE which has only ranges instead of the
combination of entrypc/highpc, address verification must use
dwarf_haspc() instead of dwarf_entrypc/dwarf_highpc.

Also, the ranges only DIE will have a partial code in different section
(e.g. unlikely code will be in text.unlikely as "FUNC.cold" symbol). In
that case, we can not use dwarf_entrypc() or die_entrypc(), because the
offset from original DIE can be a minus value.

Instead, this simply gets the symbol and offset from symtab.

Without this patch;

  # perf probe -D clear_tasks_mm_cpumask:1
  Failed to get entry address of clear_tasks_mm_cpumask
    Error: Failed to add events.

And with this patch:

  # perf probe -D clear_tasks_mm_cpumask:1
  p:probe/clear_tasks_mm_cpumask clear_tasks_mm_cpumask+0
  p:probe/clear_tasks_mm_cpumask_1 clear_tasks_mm_cpumask+5
  p:probe/clear_tasks_mm_cpumask_2 clear_tasks_mm_cpumask+8
  p:probe/clear_tasks_mm_cpumask_3 clear_tasks_mm_cpumask+16
  p:probe/clear_tasks_mm_cpumask_4 clear_tasks_mm_cpumask+82

Committer testing:

I managed to reproduce the above:

  [root@quaco ~]# perf probe -D clear_tasks_mm_cpumask:1
  p:probe/clear_tasks_mm_cpumask _text+919968
  p:probe/clear_tasks_mm_cpumask_1 _text+919973
  p:probe/clear_tasks_mm_cpumask_2 _text+919976
  [root@quaco ~]#

But then when trying to actually put the probe in place, it fails if I
use :0 as the offset:

  [root@quaco ~]# perf probe -L clear_tasks_mm_cpumask | head -5
  <clear_tasks_mm_cpumask@/usr/src/debug/kernel-5.2.fc30/linux-5.2.18-200.fc30.x86_64/kernel/cpu.c:0>
        0  void clear_tasks_mm_cpumask(int cpu)
        1  {
        2  	struct task_struct *p;

  [root@quaco ~]# perf probe clear_tasks_mm_cpumask:0
  Probe point 'clear_tasks_mm_cpumask' not found.
    Error: Failed to add events.
  [root@quaco

The next patch is needed to fix this case.

Fixes: 576b523721b7 ("perf probe: Fix probing symbols with optimization suffix")
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157199318513.8075.10463906803299647907.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -588,34 +588,26 @@ static int convert_to_trace_point(Dwarf_
 				  Dwarf_Addr paddr, bool retprobe,
 				  struct probe_trace_point *tp)
 {
-	Dwarf_Addr eaddr, highaddr;
+	Dwarf_Addr eaddr;
 	GElf_Sym sym;
 	const char *symbol;
 
 	/* Verify the address is correct */
-	if (dwarf_entrypc(sp_die, &eaddr) != 0) {
-		pr_warning("Failed to get entry address of %s\n",
-			   dwarf_diename(sp_die));
-		return -ENOENT;
-	}
-	if (dwarf_highpc(sp_die, &highaddr) != 0) {
-		pr_warning("Failed to get end address of %s\n",
-			   dwarf_diename(sp_die));
-		return -ENOENT;
-	}
-	if (paddr > highaddr) {
-		pr_warning("Offset specified is greater than size of %s\n",
+	if (!dwarf_haspc(sp_die, paddr)) {
+		pr_warning("Specified offset is out of %s\n",
 			   dwarf_diename(sp_die));
 		return -EINVAL;
 	}
 
-	/* Get an appropriate symbol from symtab */
+	/* Try to get actual symbol name from symtab */
 	symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
 	if (!symbol) {
 		pr_warning("Failed to find symbol at 0x%lx\n",
 			   (unsigned long)paddr);
 		return -ENOENT;
 	}
+	eaddr = sym.st_value;
+
 	tp->offset = (unsigned long)(paddr - sym.st_value);
 	tp->address = (unsigned long)paddr;
 	tp->symbol = strdup(symbol);

