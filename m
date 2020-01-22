Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDAE8145105
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgAVJh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbgAVJh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:37:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 245D02467E;
        Wed, 22 Jan 2020 09:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685845;
        bh=QJMqdlQTrWLFK5kNgpIMRewl/OI1gerUGY6pL8y02KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MZL+/vs4B0jmg/QsHm34BS4bVNBTuVPqsHn1J3+/rDzVxwjLfikuk5RYM+Jcf+lU
         W4cDWYz+E5x1/eVP4egIX3p86d1i4yIyo65oqx92xmXycE+xvLw7pejfj8pPzbVE5k
         6HD1dZoL9HuVCYADckBHJwp9K5sUE6yz5sWqNmLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 4.9 96/97] perf probe: Fix wrong address verification
Date:   Wed, 22 Jan 2020 10:29:40 +0100
Message-Id: <20200122092811.399085852@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/probe-finder.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -612,38 +612,26 @@ static int convert_to_trace_point(Dwarf_
 				  const char *function,
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
 
-	symbol = dwarf_diename(sp_die);
+	/* Try to get actual symbol name from symtab */
+	symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
 	if (!symbol) {
-		/* Try to get the symbol name from symtab */
-		symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
-		if (!symbol) {
-			pr_warning("Failed to find symbol at 0x%lx\n",
-				   (unsigned long)paddr);
-			return -ENOENT;
-		}
-		eaddr = sym.st_value;
+		pr_warning("Failed to find symbol at 0x%lx\n",
+			   (unsigned long)paddr);
+		return -ENOENT;
 	}
+	eaddr = sym.st_value;
+
 	tp->offset = (unsigned long)(paddr - eaddr);
 	tp->address = (unsigned long)paddr;
 	tp->symbol = strdup(symbol);


