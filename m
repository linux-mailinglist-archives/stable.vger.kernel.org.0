Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6A412EFA7
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgABWro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:47:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729706AbgABW3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:29:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5111122525;
        Thu,  2 Jan 2020 22:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004152;
        bh=0q0liihG/rS2VbIemaU/lIs9XpyflQYud4IQ5oZsDHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vX7oYh4x/y2MSyuLvkhwINW92f0VgviREeYELIzZQe68eCQdvl9ysP9745EHy2jHl
         U/jpaTxxglxdoU1LW3dWN/7uCi+kITzjCCO7txcSmKptiZk4rVcKoYKaEaq3r3JI3v
         AINlCACrhKOq/2IViZ60l4rKs//nsXucYB0ubZr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 060/171] perf probe: Skip end-of-sequence and non statement lines
Date:   Thu,  2 Jan 2020 23:06:31 +0100
Message-Id: <20200102220555.227215580@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit f4d99bdfd124823a81878b44b5e8750b97f73902 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 41bfb4c977d0..7eec3ae7b3c5 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -770,6 +770,7 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 	int decl = 0, inl;
 	Dwarf_Die die_mem, *cu_die;
 	size_t nlines, i;
+	bool flag;
 
 	/* Get the CU die */
 	if (dwarf_tag(rt_die) != DW_TAG_compile_unit) {
@@ -800,6 +801,12 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
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
-- 
2.20.1



