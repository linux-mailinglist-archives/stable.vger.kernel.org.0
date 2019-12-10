Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD22119B78
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfLJWI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:08:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729117AbfLJWEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8B2E20838;
        Tue, 10 Dec 2019 22:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015483;
        bh=SCOD7Y8+kckcHiBEFj1WtBs0qD6FTzawym+LVOif+KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1TOjXKVPwoXuS/LagILFe6u1YpEL7NnjX+PDkJnDsV3Yd6h4yW8oWfHLBszdaSu3
         kFPo8WLrDPGq5Sn7VRWRCvKvvU89LbrV1bRJKacL7TCRm3fCEzK5YywPt4VjTGofbm
         Qy7Kf7ekfMFo9toNOcqVL9XOcbJswvC+HkGpLSw0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 087/130] perf probe: Fix to show inlined function callsite without entry_pc
Date:   Tue, 10 Dec 2019 17:02:18 -0500
Message-Id: <20191210220301.13262-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 18e21eb671dc87a4f0546ba505a89ea93598a634 ]

Fix 'perf probe --line' option to show inlined function callsite lines
even if the function DIE has only ranges.

Without this:

  # perf probe -L amd_put_event_constraints
  ...
      2  {
      3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
                        __amd_put_nb_event_constraints(cpuc, event);
      5  }

With this patch:

  # perf probe -L amd_put_event_constraints
  ...
      2  {
      3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
      4                 __amd_put_nb_event_constraints(cpuc, event);
      5  }

Committer testing:

Before:

  [root@quaco ~]# perf probe -L amd_put_event_constraints
  <amd_put_event_constraints@/usr/src/debug/kernel-5.2.fc30/linux-5.2.18-200.fc30.x86_64/arch/x86/events/amd/core.c:0>
        0  static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
                                                struct perf_event *event)
        2  {
        3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
                          __amd_put_nb_event_constraints(cpuc, event);
        5  }

           PMU_FORMAT_ATTR(event, "config:0-7,32-35");
           PMU_FORMAT_ATTR(umask, "config:8-15"   );

  [root@quaco ~]#

After:

  [root@quaco ~]# perf probe -L amd_put_event_constraints
  <amd_put_event_constraints@/usr/src/debug/kernel-5.2.fc30/linux-5.2.18-200.fc30.x86_64/arch/x86/events/amd/core.c:0>
        0  static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
                                                struct perf_event *event)
        2  {
        3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
        4                 __amd_put_nb_event_constraints(cpuc, event);
        5  }

           PMU_FORMAT_ATTR(event, "config:0-7,32-35");
           PMU_FORMAT_ATTR(umask, "config:8-15"   );

  [root@quaco ~]# perf probe amd_put_event_constraints:4
  Added new event:
    probe:amd_put_event_constraints (on amd_put_event_constraints:4)

  You can now use it in all perf tools, such as:

  	perf record -e probe:amd_put_event_constraints -aR sleep 1

  [root@quaco ~]#

  [root@quaco ~]# perf probe -l
    probe:amd_put_event_constraints (on amd_put_event_constraints:4@arch/x86/events/amd/core.c)
    probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask@kernel/cpu.c)
  [root@quaco ~]#

Using it:

  [root@quaco ~]# perf trace -e probe:*
  ^C[root@quaco ~]#

Ok, Intel system here... :-)

Fixes: 4cc9cec636e7 ("perf probe: Introduce lines walker interface")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157199322107.8075.12659099000567865708.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 21c2ed42ad6b7..0a5de865563cf 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -686,7 +686,7 @@ static int __die_walk_funclines_cb(Dwarf_Die *in_die, void *data)
 	if (dwarf_tag(in_die) == DW_TAG_inlined_subroutine) {
 		fname = die_get_call_file(in_die);
 		lineno = die_get_call_lineno(in_die);
-		if (fname && lineno > 0 && dwarf_entrypc(in_die, &addr) == 0) {
+		if (fname && lineno > 0 && die_entrypc(in_die, &addr) == 0) {
 			lw->retval = lw->callback(fname, lineno, addr, lw->data);
 			if (lw->retval != 0)
 				return DIE_FIND_CB_END;
-- 
2.20.1

