Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A516A2012F6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404216AbgFSPTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404074AbgFSPQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D4BA2158C;
        Fri, 19 Jun 2020 15:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579786;
        bh=sFg5RpJdn4Zf+1Sc6Km2wWkYZjZb20V+2z6/fcV0ukY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRtcwsf7JB3YBEeatqCylBpp1amdLEqb4KPKYq+5vVxr8tdQ1uhJuY1KQrnGc0B3X
         KqkFp1r1bM3Vjt7Ag7wz4XzDceedXbO0oRogas+odgLmiiF6M79hUZQq1xWp8J4td6
         EY1GHmVlQv9gM6jPKlWcXUAAL4pJ39PHMdhe2VxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 5.4 258/261] perf probe: Fix to check blacklist address correctly
Date:   Fri, 19 Jun 2020 16:34:29 +0200
Message-Id: <20200619141702.241854622@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/probe-event.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

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
@@ -114,6 +114,10 @@ static struct ref_reloc_sym *kernel_get_
 	kmap = map__kmap(map);
 	if (!kmap)
 		return NULL;
+
+	if (pmap)
+		*pmap = map;
+
 	return kmap->ref_reloc_sym;
 }
 
@@ -125,7 +129,7 @@ static int kernel_get_symbol_address_by_
 	struct map *map;
 
 	/* ref_reloc_sym is just a label. Need a special fix*/
-	reloc_sym = kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym(NULL);
 	if (reloc_sym && strcmp(name, reloc_sym->name) == 0)
 		*addr = (reloc) ? reloc_sym->addr : reloc_sym->unrelocated_addr;
 	else {
@@ -745,6 +749,7 @@ post_process_kernel_probe_trace_events(s
 				       int ntevs)
 {
 	struct ref_reloc_sym *reloc_sym;
+	struct map *map;
 	char *tmp;
 	int i, skipped = 0;
 
@@ -753,7 +758,7 @@ post_process_kernel_probe_trace_events(s
 		return post_process_offline_probe_trace_events(tevs, ntevs,
 						symbol_conf.vmlinux_name);
 
-	reloc_sym = kernel_get_ref_reloc_sym();
+	reloc_sym = kernel_get_ref_reloc_sym(&map);
 	if (!reloc_sym) {
 		pr_warning("Relocated base symbol is not found!\n");
 		return -EINVAL;
@@ -764,9 +769,13 @@ post_process_kernel_probe_trace_events(s
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
@@ -2922,7 +2931,7 @@ static int find_probe_trace_events_from_
 	/* Note that the symbols in the kmodule are not relocated */
 	if (!pev->uprobes && !pev->target &&
 			(!pp->retprobe || kretprobe_offset_is_supported())) {
-		reloc_sym = kernel_get_ref_reloc_sym();
+		reloc_sym = kernel_get_ref_reloc_sym(NULL);
 		if (!reloc_sym) {
 			pr_warning("Relocated base symbol is not found!\n");
 			ret = -EINVAL;


