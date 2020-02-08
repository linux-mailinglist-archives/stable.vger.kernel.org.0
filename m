Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33D815664A
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgBHS3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34038 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727843AbgBHS3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-0003fL-5q; Sat, 08 Feb 2020 18:29:37 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-000COP-RH; Sat, 08 Feb 2020 18:29:35 +0000
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
Date:   Sat, 08 Feb 2020 18:20:06 +0000
Message-ID: <lsq.1581185940.771658760@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 067/148] perf probe: Fix to probe an inline function
 which has no entry pc
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

commit eb6933b29d20bf2c3053883d409a53f462c1a3ac upstream.

Fix perf probe to probe an inlne function which has no entry pc
or low pc but only has ranges attribute.

This seems very rare case, but I could find a few examples, as
same as probe_point_search_cb(), use die_entrypc() to get the
entry address in probe_point_inline_cb() too.

Without this patch:

  # perf probe -D __amd_put_nb_event_constraints
  Failed to get entry address of __amd_put_nb_event_constraints.
  Probe point '__amd_put_nb_event_constraints' not found.
    Error: Failed to add events.

With this patch:

  # perf probe -D __amd_put_nb_event_constraints
  p:probe/__amd_put_nb_event_constraints amd_put_event_constraints+43

Committer testing:

Before:

  [root@quaco ~]# perf probe -D __amd_put_nb_event_constraints
  Failed to get entry address of __amd_put_nb_event_constraints.
  Probe point '__amd_put_nb_event_constraints' not found.
    Error: Failed to add events.
  [root@quaco ~]#

After:

  [root@quaco ~]# perf probe -D __amd_put_nb_event_constraints
  p:probe/__amd_put_nb_event_constraints _text+33789
  [root@quaco ~]#

Fixes: 4ea42b181434 ("perf: Add perf probe subcommand, a kprobe-event setup helper")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157199320336.8075.16189530425277588587.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/probe-finder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -858,7 +858,7 @@ static int probe_point_inline_cb(Dwarf_D
 		ret = find_probe_point_lazy(in_die, pf);
 	else {
 		/* Get probe address */
-		if (dwarf_entrypc(in_die, &addr) != 0) {
+		if (die_entrypc(in_die, &addr) != 0) {
 			pr_warning("Failed to get entry address of %s.\n",
 				   dwarf_diename(in_die));
 			return -ENOENT;

