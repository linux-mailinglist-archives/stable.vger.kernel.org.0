Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01731B59DB
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 13:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgDWLBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 07:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgDWLBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 07:01:08 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 598EF20704;
        Thu, 23 Apr 2020 11:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587639668;
        bh=HgsNj2H2CWk1JhxVQWo3f0C7WZ/gAljvF34fqPbNRsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkhSnUwIAj2E7S1YEXB5tTMiRGYyIOj5LAGrDlJ8/IsdLDlodS28KowfaoXQUc6pH
         2T/4E+r9KFbSn5zJzWJl6RfaIVimaHxuXcP8pvnSeDGNXTGsTCnYNWKv5JRAvHmUW2
         Gor8SrQIJPGPvfdxogJIMhDYtgIyYRQB1twIMPxQ=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] perf-probe: Fix to check blacklist address correctly
Date:   Thu, 23 Apr 2020 20:01:04 +0900
Message-Id: <158763966411.30755.5882376357738273695.stgit@devnote2>
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

Fix to check kprobe blacklist address correctly with
relocated address by adjusting debuginfo address.

Since the address in the debuginfo is same as objdump,
it is different from relocated kernel address with KASLR.
Thus, the perf-probe always misses to catch the
blacklisted addresses.

Without this patch, perf probe can not detect the blacklist
addresses on KASLR enabled kernel.

=========
  # perf probe kprobe_dispatcher
  Failed to write event: Invalid argument
    Error: Failed to add events.
=========

With this patch, it correctly shows the error message.

=========
  # perf probe kprobe_dispatcher
  kprobe_dispatcher is blacklisted function, skip it.
  Probe point 'kprobe_dispatcher' not found.
    Error: Failed to add events.
=========

Fixes: 9aaf5a5f479b ("perf probe: Check kprobes blacklist when adding new events")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
---
 tools/perf/util/probe-event.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index eea132f512b0..f75df63309be 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -102,7 +102,7 @@ void exit_probe_symbol_maps(void)
 	symbol__exit();
 }
 
-static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
+static struct ref_reloc_sym *kernel_get_ref_reloc_sym(struct map **pmap)
 {
 	/* kmap->ref_reloc_sym should be set if host_machine is initialized */
 	struct kmap *kmap;
@@ -114,6 +114,10 @@ static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
 	kmap = map__kmap(map);
 	if (!kmap)
 		return NULL;
+
+	if (pmap)
+		*pmap = map;
+
 	return kmap->ref_reloc_sym;
 }
 
@@ -125,7 +129,7 @@ static int kernel_get_symbol_address_by_name(const char *name, u64 *addr,
 	struct map *map;
 
 	/* ref_reloc_sym is just a label. Need a special fix*/
-	reloc_sym = kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym(NULL);
 	if (reloc_sym && strcmp(name, reloc_sym->name) == 0)
 		*addr = (reloc) ? reloc_sym->addr : reloc_sym->unrelocated_addr;
 	else {
@@ -745,6 +749,7 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
 				       int ntevs)
 {
 	struct ref_reloc_sym *reloc_sym;
+	struct map *map;
 	char *tmp;
 	int i, skipped = 0;
 
@@ -753,7 +758,7 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
 		return post_process_offline_probe_trace_events(tevs, ntevs,
 						symbol_conf.vmlinux_name);
 
-	reloc_sym = kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym(&map);
 	if (!reloc_sym) {
 		pr_warning("Relocated base symbol is not found!\n");
 		return -EINVAL;
@@ -764,9 +769,13 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
 			continue;
 		if (tevs[i].point.retprobe && !kretprobe_offset_is_supported())
 			continue;
-		/* If we found a wrong one, mark it by NULL symbol */
+		/*
+		 * If we found a wrong one, mark it by NULL symbol.
+		 * Since addresses in debuginfo is same as objdump, we need
+		 * to convert it to addresses on memory.
+		 */
 		if (kprobe_warn_out_range(tevs[i].point.symbol,
-					  tevs[i].point.address)) {
+			map__objdump_2mem(map, tevs[i].point.address))) {
 			tmp = NULL;
 			skipped++;
 		} else {
@@ -2936,7 +2945,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	/* Note that the symbols in the kmodule are not relocated */
 	if (!pev->uprobes && !pev->target &&
 			(!pp->retprobe || kretprobe_offset_is_supported())) {
-		reloc_sym = kernel_get_ref_reloc_sym();
+		reloc_sym = kernel_get_ref_reloc_sym(NULL);
 		if (!reloc_sym) {
 			pr_warning("Relocated base symbol is not found!\n");
 			ret = -EINVAL;

