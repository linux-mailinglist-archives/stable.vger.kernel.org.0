Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3973B1566B4
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgBHSgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:36:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33906 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727803AbgBHS3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dR-Qj; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CNL-Nj; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "David Ahern" <dsahern@gmail.com>,
        "Masami Hiramatsu" <masami.hiramatsu.pt@hitachi.com>,
        "Jiri Olsa" <jolsa@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>
Date:   Sat, 08 Feb 2020 18:20:00 +0000
Message-ID: <lsq.1581185940.29626518@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 061/148] perf probe: Fix to add missed brace around
 if block
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

commit 86a76027457633488b0a83d5e2bb944159885605 upstream.

The commit 75186a9b09e4 (perf probe: Fix to show lines of sys_ functions
correctly) introduced a bug by a missed brace around if block. This
fixes to add it.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Fixes: 75186a9b09e4 ("perf probe: Fix to show lines of sys_ functions correctly")
Link: http://lkml.kernel.org/r/20150812215541.9088.62425.stgit@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/dwarf-aux.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -717,7 +717,7 @@ int die_walk_lines(Dwarf_Die *rt_die, li
 			continue;
 		}
 		/* Filter lines based on address */
-		if (rt_die != cu_die)
+		if (rt_die != cu_die) {
 			/*
 			 * Address filtering
 			 * The line is included in given function, and
@@ -731,6 +731,7 @@ int die_walk_lines(Dwarf_Die *rt_die, li
 				    decf != dwarf_decl_file(&die_mem))
 					continue;
 			}
+		}
 		/* Get source line */
 		fname = dwarf_linesrc(line, NULL, NULL);
 

