Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5CF1566AB
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBHSgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:36:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33918 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727813AbgBHS3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dH-I6; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CNG-My; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Masami Hiramatsu" <masami.hiramatsu.pt@hitachi.com>,
        "Jiri Olsa" <jolsa@redhat.com>, "David Ahern" <dsahern@gmail.com>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        "Namhyung Kim" <namhyung@kernel.org>
Date:   Sat, 08 Feb 2020 18:19:59 +0000
Message-ID: <lsq.1581185940.619552824@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 060/148] perf probe: Fix to show lines of sys_
 functions correctly
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

commit 75186a9b09e47072f442f43e292cd47180b67b5c upstream.

"perf probe --lines sys_poll" shows only the first line of sys_poll,
because the SYSCALL_DEFINE macro:

  ----
  SYSCALL_DEFINE*(foo,...)
  {
    body;
  }
  ----

  is expanded as below (on debuginfo)

  ----

  static inline int SYSC_foo(...)
  {
    body;
  }
  int SyS_foo(...) <- is an alias of sys_foo.
  {
    return SYSC_foo(...);
  }
  ----

So, "perf probe --lines sys_foo" decodes SyS_foo function and it also skips
inlined functions(SYSC_foo) inside the target function because those functions
are usually defined somewhere else.

To fix this issue, this fix checks whether the inlined function is defined at
the same point of the target function, and if so, it doesn't skip the inline
function.

Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20150812012406.11811.94691.stgit@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/dwarf-aux.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -681,15 +681,18 @@ int die_walk_lines(Dwarf_Die *rt_die, li
 	Dwarf_Lines *lines;
 	Dwarf_Line *line;
 	Dwarf_Addr addr;
-	const char *fname;
+	const char *fname, *decf = NULL;
 	int lineno, ret = 0;
+	int decl = 0, inl;
 	Dwarf_Die die_mem, *cu_die;
 	size_t nlines, i;
 
 	/* Get the CU die */
-	if (dwarf_tag(rt_die) != DW_TAG_compile_unit)
+	if (dwarf_tag(rt_die) != DW_TAG_compile_unit) {
 		cu_die = dwarf_diecu(rt_die, &die_mem, NULL, NULL);
-	else
+		dwarf_decl_line(rt_die, &decl);
+		decf = dwarf_decl_file(rt_die);
+	} else
 		cu_die = rt_die;
 	if (!cu_die) {
 		pr_debug2("Failed to get CU from given DIE.\n");
@@ -720,9 +723,14 @@ int die_walk_lines(Dwarf_Die *rt_die, li
 			 * The line is included in given function, and
 			 * no inline block includes it.
 			 */
-			if (!dwarf_haspc(rt_die, addr) ||
-			    die_find_inlinefunc(rt_die, addr, &die_mem))
+			if (!dwarf_haspc(rt_die, addr))
 				continue;
+			if (die_find_inlinefunc(rt_die, addr, &die_mem)) {
+				dwarf_decl_line(&die_mem, &inl);
+				if (inl != decl ||
+				    decf != dwarf_decl_file(&die_mem))
+					continue;
+			}
 		/* Get source line */
 		fname = dwarf_linesrc(line, NULL, NULL);
 

