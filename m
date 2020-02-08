Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8021566B6
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgBHSgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:36:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33886 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727797AbgBHS3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:40 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-0003dG-0H; Sat, 08 Feb 2020 18:29:36 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-000CNy-DI; Sat, 08 Feb 2020 18:29:35 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Jiri Olsa" <jolsa@redhat.com>
Date:   Sat, 08 Feb 2020 18:20:03 +0000
Message-ID: <lsq.1581185940.266564127@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 064/148] perf probe: Fix to show function entry line
 as probe-able
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

commit 91e2f539eeda26ab00bd03fae8dc434c128c85ed upstream.

Fix die_walk_lines() to list the function entry line correctly.  Since
the dwarf_entrypc() does not return the entry pc if the DIE has only
range attribute, __die_walk_funclines() fails to list the declaration
line (entry line) in that case.

To solve this issue, this introduces die_entrypc() which correctly
returns the entry PC (the first address range) even if the DIE has only
range attribute. With this fix die_walk_lines() shows the function entry
line is able to probe correctly.

Fixes: 4cc9cec636e7 ("perf probe: Introduce lines walker interface")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157190837419.1859.4619125803596816752.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/dwarf-aux.c | 24 +++++++++++++++++++++++-
 tools/perf/util/dwarf-aux.h |  3 +++
 2 files changed, 26 insertions(+), 1 deletion(-)

--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -278,6 +278,28 @@ bool die_is_func_def(Dwarf_Die *dw_die)
 }
 
 /**
+ * die_entrypc - Returns entry PC (the lowest address) of a DIE
+ * @dw_die: a DIE
+ * @addr: where to store entry PC
+ *
+ * Since dwarf_entrypc() does not return entry PC if the DIE has only address
+ * range, we have to use this to retrieve the lowest address from the address
+ * range attribute.
+ */
+int die_entrypc(Dwarf_Die *dw_die, Dwarf_Addr *addr)
+{
+	Dwarf_Addr base, end;
+
+	if (!addr)
+		return -EINVAL;
+
+	if (dwarf_entrypc(dw_die, addr) == 0)
+		return 0;
+
+	return dwarf_ranges(dw_die, 0, &base, addr, &end) < 0 ? -ENOENT : 0;
+}
+
+/**
  * die_is_func_instance - Ensure that this DIE is an instance of a subprogram
  * @dw_die: a DIE
  *
@@ -647,7 +669,7 @@ static int __die_walk_funclines(Dwarf_Di
 	/* Handle function declaration line */
 	fname = dwarf_decl_file(sp_die);
 	if (fname && dwarf_decl_line(sp_die, &lineno) == 0 &&
-	    dwarf_entrypc(sp_die, &addr) == 0) {
+	    die_entrypc(sp_die, &addr) == 0) {
 		lw.retval = callback(fname, lineno, addr, data);
 		if (lw.retval != 0)
 			goto done;
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -38,6 +38,9 @@ extern int cu_find_lineinfo(Dwarf_Die *c
 extern int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
 			int (*callback)(Dwarf_Die *, void *), void *data);
 
+/* Get the lowest PC in DIE (including range list) */
+int die_entrypc(Dwarf_Die *dw_die, Dwarf_Addr *addr);
+
 /* Ensure that this DIE is a subprogram and definition (not declaration) */
 extern bool die_is_func_def(Dwarf_Die *dw_die);
 

