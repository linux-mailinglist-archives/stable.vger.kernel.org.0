Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9069712C824
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732077AbfL2RvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732072AbfL2RvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:51:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC59920718;
        Sun, 29 Dec 2019 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641883;
        bh=vwhE9Lb82quyMJwQCSJAsu3MVGD0hjqpeFiWyHf1JvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/qJeZwGfx/0YjGbq/H9L802+sT6FhNjf15grShWiCtAQQoyf3V0dgpgBmY6JAgMN
         TodghggUZqaxbPpwEBQY3PA5UcDJHmW5aNDGgRvqir43ycaQJL2kLAg7tQAWqwZIeD
         9I28VekhTv4jhOtM2+K5sLGKWTgS9vTXZJFlaDPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 252/434] perf probe: Fix to probe a function which has no entry pc
Date:   Sun, 29 Dec 2019 18:25:05 +0100
Message-Id: <20191229172718.657510315@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 5d16dbcc311d91267ddb45c6da4f187be320ecee ]

Fix 'perf probe' to probe a function which has no entry pc or low pc but
only has ranges attribute.

probe_point_search_cb() uses dwarf_entrypc() to get the probe address,
but that doesn't work for the function DIE which has only ranges
attribute. Use die_entrypc() instead.

Without this fix:

  # perf probe -k ../build-x86_64/vmlinux -D clear_tasks_mm_cpumask:0
  Probe point 'clear_tasks_mm_cpumask' not found.
    Error: Failed to add events.

With this:

  # perf probe -k ../build-x86_64/vmlinux -D clear_tasks_mm_cpumask:0
  p:probe/clear_tasks_mm_cpumask clear_tasks_mm_cpumask+0

Committer testing:

Before:

  [root@quaco ~]# perf probe clear_tasks_mm_cpumask:0
  Probe point 'clear_tasks_mm_cpumask' not found.
    Error: Failed to add events.
  [root@quaco ~]#

After:

  [root@quaco ~]# perf probe clear_tasks_mm_cpumask:0
  Added new event:
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask)

  You can now use it in all perf tools, such as:

  	perf record -e probe:clear_tasks_mm_cpumask -aR sleep 1

  [root@quaco ~]#

Using it with 'perf trace':

  [root@quaco ~]# perf trace -e probe:clear_tasks_mm_cpumask

Doesn't seem to be used in x86_64:

  $ find . -name "*.c" | xargs grep clear_tasks_mm_cpumask
  ./kernel/cpu.c: * clear_tasks_mm_cpumask - Safely clear tasks' mm_cpumask for a CPU
  ./kernel/cpu.c:void clear_tasks_mm_cpumask(int cpu)
  ./arch/xtensa/kernel/smp.c:	clear_tasks_mm_cpumask(cpu);
  ./arch/csky/kernel/smp.c:	clear_tasks_mm_cpumask(cpu);
  ./arch/sh/kernel/smp.c:	clear_tasks_mm_cpumask(cpu);
  ./arch/arm/kernel/smp.c:	clear_tasks_mm_cpumask(cpu);
  ./arch/powerpc/mm/nohash/mmu_context.c:	clear_tasks_mm_cpumask(cpu);
  $ find . -name "*.h" | xargs grep clear_tasks_mm_cpumask
  ./include/linux/cpu.h:void clear_tasks_mm_cpumask(int cpu);
  $ find . -name "*.S" | xargs grep clear_tasks_mm_cpumask
  $

Fixes: e1ecbbc3fa83 ("perf probe: Fix to handle optimized not-inlined functions")
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157199319438.8075.4695576954550638618.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-finder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 7857ae7a10b7..4079ed617f53 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -994,7 +994,7 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 		param->retval = find_probe_point_by_line(pf);
 	} else if (die_is_func_instance(sp_die)) {
 		/* Instances always have the entry address */
-		dwarf_entrypc(sp_die, &pf->addr);
+		die_entrypc(sp_die, &pf->addr);
 		/* But in some case the entry address is 0 */
 		if (pf->addr == 0) {
 			pr_debug("%s has no entry PC. Skipped\n",
-- 
2.20.1



