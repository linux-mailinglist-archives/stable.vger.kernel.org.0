Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0591B59DE
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 13:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgDWLBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 07:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbgDWLBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 07:01:17 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C07CC20704;
        Thu, 23 Apr 2020 11:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587639677;
        bh=fOJxF/ls2VSw+2hhqPNsxveGbkSp3Nbou1jMHx7y9xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DODjxxNlXNnv7BugKoEkz3w5C1Uym8i4zuUUm4CzGm+L+jnaTa3sE0MWXogNEBOE5
         xbptPNqmWNxUCgisMde8thxcJph/JoWIytrtjUo7qTfOUmKLp6bLDoYi2JTx6PFmix
         fjf7u2CfV6wGbWH3ZlfqiGDzcTvAl0hIYzsJKaJo=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] perf-probe: Check address correctness by map instead of _etext
Date:   Thu, 23 Apr 2020 20:01:13 +0900
Message-Id: <158763967332.30755.4922496724365529088.stgit@devnote2>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <158763965400.30755.14484569071233923742.stgit@devnote2>
References: <158763965400.30755.14484569071233923742.stgit@devnote2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 03db8b583d1c ("perf tools: Fix maps__find_symbol_by_name()")
introduced map address range check in maps__find_symbol_by_name(),
we can not get "_etext" from kernel map because _etext is placed
on the edge of the kernel .text section (= kernel map in perf.)

To fix this issue, this checks the address correctness
by map address range information (map->start and map->end)
instead of using _etext address.

This can cause an error if the target inlined function is
embedded in both __init function and normal function.

For exaample, request_resource() is a normal function but also
embedded in __init reserve_setup(). In this case, the probe point
in reserve_setup() must be skipped. However, without this fix,
it failes to setup all probe points.
================
  # ./perf probe -v request_resource
  probe-definition(0): request_resource
  symbol:request_resource file:(null) line:0 offset:0 return:0 lazy:(null)
  0 arguments
  Looking at the vmlinux_path (8 entries long)
  Using /usr/lib/debug/lib/modules/5.5.17-200.fc31.x86_64/vmlinux for symbols
  Open Debuginfo file: /usr/lib/debug/lib/modules/5.5.17-200.fc31.x86_64/vmlinux
  Try to find probe point from debuginfo.
  Matched function: request_resource [15e29ad]
  found inline addr: 0xffffffff82fbf892
  Probe point found: reserve_setup+204
  found inline addr: 0xffffffff810e9790
  Probe point found: request_resource+0
  Found 2 probe_trace_events.
  Opening /sys/kernel/debug/tracing//kprobe_events write=1
  Opening /sys/kernel/debug/tracing//README write=0
  Writing event: p:probe/request_resource _text+33290386
  Failed to write event: Invalid argument
    Error: Failed to add events. Reason: Invalid argument (Code: -22)
================

With this fix,

================
  # ./perf probe request_resource
  reserve_setup is out of .text, skip it.
  Added new events:
    (null):(null)        (on request_resource)
    probe:request_resource (on request_resource)

  You can now use it in all perf tools, such as:

  	perf record -e probe:request_resource -aR sleep 1

================

Fixes: 03db8b583d1c ("perf tools: Fix maps__find_symbol_by_name()")
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
---
 tools/perf/util/probe-event.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f75df63309be..a5387e03e365 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -236,21 +236,22 @@ static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
 static bool kprobe_blacklist__listed(unsigned long address);
 static bool kprobe_warn_out_range(const char *symbol, unsigned long address)
 {
-	u64 etext_addr = 0;
-	int ret;
-
-	/* Get the address of _etext for checking non-probable text symbol */
-	ret = kernel_get_symbol_address_by_name("_etext", &etext_addr,
-						false, false);
+	struct map *map;
+	bool ret = false;
 
-	if (ret == 0 && etext_addr < address)
-		pr_warning("%s is out of .text, skip it.\n", symbol);
-	else if (kprobe_blacklist__listed(address))
+	map = kernel_get_module_map(NULL);
+	if (map) {
+		ret = address <= map->start || map->end < address;
+		if (ret)
+			pr_warning("%s is out of .text, skip it.\n", symbol);
+		map__put(map);
+	}
+	if (!ret && kprobe_blacklist__listed(address)) {
 		pr_warning("%s is blacklisted function, skip it.\n", symbol);
-	else
-		return false;
+		ret = true;
+	}
 
-	return true;
+	return ret;
 }
 
 /*

