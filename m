Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E132115662B
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgBHS3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34200 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727884AbgBHS3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-0003fo-J7; Sat, 08 Feb 2020 18:29:37 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-000CPZ-CO; Sat, 08 Feb 2020 18:29:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "Jiri Olsa" <jolsa@redhat.com>,
        "Namhyung Kim" <namhyung@kernel.org>
Date:   Sat, 08 Feb 2020 18:20:15 +0000
Message-ID: <lsq.1581185940.273828537@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 076/148] perf probe: Skip overlapped location on
 searching variables
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

commit dee36a2abb67c175265d49b9a8c7dfa564463d9a upstream.

Since debuginfo__find_probes() callback function can be called with  the
location which already passed, the callback function must filter out
such overlapped locations.

add_probe_trace_event() has already done it by commit 1a375ae7659a
("perf probe: Skip same probe address for a given line"), but
add_available_vars() doesn't. Thus perf probe -v shows same address
repeatedly as below:

  # perf probe -V vfs_read:18
  Available variables at vfs_read:18
          @<vfs_read+217>
                  char*   buf
                  loff_t* pos
                  ssize_t ret
                  struct file*    file
          @<vfs_read+217>
                  char*   buf
                  loff_t* pos
                  ssize_t ret
                  struct file*    file
          @<vfs_read+226>
                  char*   buf
                  loff_t* pos
                  ssize_t ret
                  struct file*    file

With this fix, perf probe -V shows it correctly:

  # perf probe -V vfs_read:18
  Available variables at vfs_read:18
          @<vfs_read+217>
                  char*   buf
                  loff_t* pos
                  ssize_t ret
                  struct file*    file
          @<vfs_read+226>
                  char*   buf
                  loff_t* pos
                  ssize_t ret
                  struct file*    file

Fixes: cf6eb489e5c0 ("perf probe: Show accessible local variables")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157241938927.32002.4026859017790562751.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/probe-finder.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1230,6 +1230,18 @@ static int collect_variables_cb(Dwarf_Di
 		return DIE_FIND_CB_SIBLING;
 }
 
+static bool available_var_finder_overlap(struct available_var_finder *af)
+{
+	int i;
+
+	for (i = 0; i < af->nvls; i++) {
+		if (af->pf.addr == af->vls[i].point.address)
+			return true;
+	}
+	return false;
+
+}
+
 /* Add a found vars into available variables list */
 static int add_available_vars(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
@@ -1239,6 +1251,14 @@ static int add_available_vars(Dwarf_Die
 	Dwarf_Die die_mem;
 	int ret;
 
+	/*
+	 * For some reason (e.g. different column assigned to same address),
+	 * this callback can be called with the address which already passed.
+	 * Ignore it first.
+	 */
+	if (available_var_finder_overlap(af))
+		return 0;
+
 	/* Check number of tevs */
 	if (af->nvls == af->max_vls) {
 		pr_warning("Too many( > %d) probe point found.\n", af->max_vls);

