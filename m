Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D3B21238C
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 14:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgGBMlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 08:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgGBMlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 08:41:47 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ACF220885;
        Thu,  2 Jul 2020 12:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593693706;
        bh=RnCsvWMa8b1eC7neCgyATgOwh/659A6dD2WeiU+QDpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCZN1KCfSSfBVMlZdqsEEiPj5ekjhKrSBJgQN2QETaX4pdQfHuHNNCf7t8/koBbgc
         Lt9cXbbvKv0YYpTFghJBxP/c2n4VZpr52YlXZv551aIMa9BFcRnbkMu2yc0KSGwOHB
         mglTzwIhhN6+FpoA/4PoYoh8li0JsMZfe1FUmxhs=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Changbin Du <changbin.du@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        mhiramat@kernel.org
Subject: [PATCH for 4.4.y 1/5] perf probe: Fix to check blacklist address correctly
Date:   Thu,  2 Jul 2020 21:41:42 +0900
Message-Id: <159369370274.82195.11710492245736974992.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <159369369207.82195.5763005209795799082.stgit@devnote2>
References: <159369369207.82195.5763005209795799082.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 80526491c2ca6abc028c0f0dbb0707a1f35fb18a upstream.

Fix to check kprobe blacklist address correctly with relocated address
by adjusting debuginfo address.

Since the address in the debuginfo is same as objdump, it is different
from relocated kernel address with KASLR.  Thus, 'perf probe' always
misses to catch the blacklisted addresses.

Without this patch, 'perf probe' can not detect the blacklist addresses
on a KASLR enabled kernel.

  # perf probe kprobe_dispatcher
  Failed to write event: Invalid argument
    Error: Failed to add events.
  #

With this patch, it correctly shows the error message.

  # perf probe kprobe_dispatcher
  kprobe_dispatcher is blacklisted function, skip it.
  Probe point 'kprobe_dispatcher' not found.
    Error: Failed to add events.
  #

Fixes: 9aaf5a5f479b ("perf probe: Check kprobes blacklist when adding new events")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/158763966411.30755.5882376357738273695.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 0195b7e8c54a..4f05424096b6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -122,7 +122,7 @@ static struct symbol *__find_kernel_function(u64 addr, struct map **mapp)
 	return machine__find_kernel_function(host_machine, addr, mapp, NULL);
 }
 
-static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
+static struct ref_reloc_sym *kernel_get_ref_reloc_sym(struct map **pmap)
 {
 	/* kmap->ref_reloc_sym should be set if host_machine is initialized */
 	struct kmap *kmap;
@@ -134,6 +134,10 @@ static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
 	kmap = map__kmap(map);
 	if (!kmap)
 		return NULL;
+
+	if (pmap)
+		*pmap = map;
+
 	return kmap->ref_reloc_sym;
 }
 
@@ -145,7 +149,7 @@ static int kernel_get_symbol_address_by_name(const char *name, u64 *addr,
 	struct map *map;
 
 	/* ref_reloc_sym is just a label. Need a special fix*/
-	reloc_sym = kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym(NULL);
 	if (reloc_sym && strcmp(name, reloc_sym->name) == 0)
 		*addr = (reloc) ? reloc_sym->addr : reloc_sym->unrelocated_addr;
 	else {
@@ -618,6 +622,7 @@ static int post_process_probe_trace_events(struct probe_trace_event *tevs,
 					   bool uprobe)
 {
 	struct ref_reloc_sym *reloc_sym;
+	struct map *map;
 	char *tmp;
 	int i, skipped = 0;
 
@@ -628,7 +633,7 @@ static int post_process_probe_trace_events(struct probe_trace_event *tevs,
 	if (module)
 		return add_module_to_probe_trace_events(tevs, ntevs, module);
 
-	reloc_sym = kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym(&map);
 	if (!reloc_sym) {
 		pr_warning("Relocated base symbol is not found!\n");
 		return -EINVAL;
@@ -637,9 +642,13 @@ static int post_process_probe_trace_events(struct probe_trace_event *tevs,
 	for (i = 0; i < ntevs; i++) {
 		if (!tevs[i].point.address || tevs[i].point.retprobe)
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
@@ -2553,7 +2562,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 
 	/* Note that the symbols in the kmodule are not relocated */
 	if (!pev->uprobes && !pp->retprobe && !pev->target) {
-		reloc_sym = kernel_get_ref_reloc_sym();
+		reloc_sym = kernel_get_ref_reloc_sym(NULL);
 		if (!reloc_sym) {
 			pr_warning("Relocated base symbol is not found!\n");
 			ret = -EINVAL;

