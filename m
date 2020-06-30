Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75C420F777
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 16:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgF3Opp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 10:45:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgF3Opo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 10:45:44 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61BDA20663;
        Tue, 30 Jun 2020 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593528343;
        bh=abNDI/DH6hSZqBfQPXF20Y1mRroh3CwDxheEkgsUCG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHavkQOubW0iEbvnP5heVAUBjwz8pFxmvFZouLPdRpzp56H+Lwj8opOWYYYNopCXD
         +XPDmqge4Y7P/ITz3WzUEq2V/tuQFVsFqjYqj2YxaWhSXKtU46ujM7xOwfgEfUR9uK
         9lnNtsqDTEP84pHqEr/+T7rqrSiihaD9dN91luLM=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     Changbin Du <changbin.du@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        mhiramat@kernel.org
Subject: [PATCH for 4.9 1/4] perf probe: Fix to check blacklist address correctly
Date:   Tue, 30 Jun 2020 23:45:40 +0900
Message-Id: <159352834007.45385.3483905196357537826.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <159352833055.45385.11124685086393181445.stgit@devnote2>
References: <159352833055.45385.11124685086393181445.stgit@devnote2>
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
index a7452fd3b6ee..0551a02ee17c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -118,7 +118,7 @@ static struct symbol *__find_kernel_function(u64 addr, struct map **mapp)
 	return machine__find_kernel_function(host_machine, addr, mapp);
 }
 
-static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
+static struct ref_reloc_sym *kernel_get_ref_reloc_sym(struct map **pmap)
 {
 	/* kmap->ref_reloc_sym should be set if host_machine is initialized */
 	struct kmap *kmap;
@@ -130,6 +130,10 @@ static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
 	kmap = map__kmap(map);
 	if (!kmap)
 		return NULL;
+
+	if (pmap)
+		*pmap = map;
+
 	return kmap->ref_reloc_sym;
 }
 
@@ -141,7 +145,7 @@ static int kernel_get_symbol_address_by_name(const char *name, u64 *addr,
 	struct map *map;
 
 	/* ref_reloc_sym is just a label. Need a special fix*/
-	reloc_sym = kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym(NULL);
 	if (reloc_sym && strcmp(name, reloc_sym->name) == 0)
 		*addr = (reloc) ? reloc_sym->addr : reloc_sym->unrelocated_addr;
 	else {
@@ -742,6 +746,7 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
 				       int ntevs)
 {
 	struct ref_reloc_sym *reloc_sym;
+	struct map *map;
 	char *tmp;
 	int i, skipped = 0;
 
@@ -750,7 +755,7 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
 		return post_process_offline_probe_trace_events(tevs, ntevs,
 						symbol_conf.vmlinux_name);
 
-	reloc_sym = kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym(&map);
 	if (!reloc_sym) {
 		pr_warning("Relocated base symbol is not found!\n");
 		return -EINVAL;
@@ -759,9 +764,13 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
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
@@ -2850,7 +2859,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 
 	/* Note that the symbols in the kmodule are not relocated */
 	if (!pev->uprobes && !pp->retprobe && !pev->target) {
-		reloc_sym = kernel_get_ref_reloc_sym();
+		reloc_sym = kernel_get_ref_reloc_sym(NULL);
 		if (!reloc_sym) {
 			pr_warning("Relocated base symbol is not found!\n");
 			ret = -EINVAL;

