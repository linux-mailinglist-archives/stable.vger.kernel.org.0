Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1374012EFB1
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgABW2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:28:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729534AbgABW2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:28:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A33D420866;
        Thu,  2 Jan 2020 22:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004131;
        bh=jZM6XJMeqo7saqhRTRc4VmRtoNuUJQ9hBG+NCriRYSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5annuJ5M5g6MKwS1ZS4UPAoFpYQ5hcjDVEONhy3+sAerDpFjICUkN9McI6ER0IPF
         MmBHdwMYI2hOwtnSZU3R2ICw1hcAkaC6ku2G/dAbmNEMWDUbKuGE96zzwcEypIRrrI
         W3rpoxUFSAvBZ/TB+d+D/Lpj4sZaAv23ufYcWLvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 051/171] perf probe: Fix to list probe event with correct line number
Date:   Thu,  2 Jan 2020 23:06:22 +0100
Message-Id: <20200102220554.031050526@linuxfoundation.org>
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

[ Upstream commit 3895534dd78f0fd4d3f9e05ee52b9cdd444a743e ]

Since debuginfo__find_probe_point() uses dwarf_entrypc() for finding the
entry address of the function on which a probe is, it will fail when the
function DIE has only ranges attribute.

To fix this issue, use die_entrypc() instead of dwarf_entrypc().

Without this fix, perf probe -l shows incorrect offset:

  # perf probe -l
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask+18446744071579263632@work/linux/linux/kernel/cpu.c)
    probe:clear_tasks_mm_cpumask_1 (on clear_tasks_mm_cpumask+18446744071579263752@work/linux/linux/kernel/cpu.c)

With this:

  # perf probe -l
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask@work/linux/linux/kernel/cpu.c)
    probe:clear_tasks_mm_cpumask_1 (on clear_tasks_mm_cpumask:21@work/linux/linux/kernel/cpu.c)

Committer testing:

Before:

  [root@quaco ~]# perf probe -l
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask+18446744071579765152@kernel/cpu.c)
  [root@quaco ~]#

After:

  [root@quaco ~]# perf probe -l
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask@kernel/cpu.c)
  [root@quaco ~]#

Fixes: 1d46ea2a6a40 ("perf probe: Fix listing incorrect line number with inline function")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157199321227.8075.14655572419136993015.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-finder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 0d9d6e0803b8..248d3ff7e345 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1567,7 +1567,7 @@ int debuginfo__find_probe_point(struct debuginfo *dbg, unsigned long addr,
 		/* Get function entry information */
 		func = basefunc = dwarf_diename(&spdie);
 		if (!func ||
-		    dwarf_entrypc(&spdie, &baseaddr) != 0 ||
+		    die_entrypc(&spdie, &baseaddr) != 0 ||
 		    dwarf_decl_line(&spdie, &baseline) != 0) {
 			lineno = 0;
 			goto post;
@@ -1584,7 +1584,7 @@ int debuginfo__find_probe_point(struct debuginfo *dbg, unsigned long addr,
 		while (die_find_top_inlinefunc(&spdie, (Dwarf_Addr)addr,
 						&indie)) {
 			/* There is an inline function */
-			if (dwarf_entrypc(&indie, &_addr) == 0 &&
+			if (die_entrypc(&indie, &_addr) == 0 &&
 			    _addr == addr) {
 				/*
 				 * addr is at an inline function entry.
-- 
2.20.1



