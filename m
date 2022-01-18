Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A123492A76
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347325AbiARQKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243394AbiARQJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:09:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695F3C061401;
        Tue, 18 Jan 2022 08:09:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B508612D1;
        Tue, 18 Jan 2022 16:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1167C00446;
        Tue, 18 Jan 2022 16:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522160;
        bh=u20GRXqdFoWwdO0HLqYOO3U5SYterS/PKJI/gjDF68E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1nDj1QpsFr/rSFQvCHNsR0MWhDWTPucgvPG/Xyyal5ZJsTTWA3uKEm9Dzyig1OQM
         gi3aTK0BCVnYiriUdvAfBaMFE/4IygC9uB7GLS2BVGINLXCiukLNDGPGMFkDHz3xkn
         BaFh+pJAaxlfXdfE7bxYC/nWLmmpQqrEk2sZ2uCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dario Petrillo <dario.pk1@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 5.15 19/28] perf annotate: Avoid TUI crash when navigating in the annotation of recursive functions
Date:   Tue, 18 Jan 2022 17:06:05 +0100
Message-Id: <20220118160452.511243269@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dario Petrillo <dario.pk1@gmail.com>

commit d5962fb7d69073bf68fb647531cfd4f0adf84be3 upstream.

In 'perf report', entering a recursive function from inside of itself
(either directly of indirectly through some other function) results in
calling symbol__annotate2 multiple() times, and freeing the whole
disassembly when exiting from the innermost instance.

The first issue causes the function's disassembly to be duplicated, and
the latter a heap use-after-free (and crash) when trying to access the
disassembly again.

I reproduced the bug on perf 5.11.22 (Ubuntu 20.04.3 LTS) and 5.16.rc8
with the following testcase (compile with gcc recursive.c -o recursive).
To reproduce:

- perf record ./recursive
- perf report
- enter fibonacci and annotate it
- move the cursor on one of the "callq fibonacci" instructions and press enter
  - at this point there will be two copies of the function in the disassembly
- go back by pressing q, and perf will crash

  #include <stdio.h>

  int fibonacci(int n)
  {
      if(n <= 2) return 1;
      return fibonacci(n-1) + fibonacci(n-2);
  }

  int main()
  {
      printf("%d\n", fibonacci(40));
  }

This patch addresses the issue by annotating a function and freeing the
associated memory on exit only if no annotation is already present, so
that a recursive function is only annotated on entry.

Signed-off-by: Dario Petrillo <dario.pk1@gmail.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@kernel.org
Link: http://lore.kernel.org/lkml/20220109234441.325106-1-dario.pk1@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/ui/browsers/annotate.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -966,6 +966,7 @@ int symbol__tui_annotate(struct map_symb
 		.opts = opts,
 	};
 	int ret = -1, err;
+	int not_annotated = list_empty(&notes->src->source);
 
 	if (sym == NULL)
 		return -1;
@@ -973,13 +974,15 @@ int symbol__tui_annotate(struct map_symb
 	if (ms->map->dso->annotate_warned)
 		return -1;
 
-	err = symbol__annotate2(ms, evsel, opts, &browser.arch);
-	if (err) {
-		char msg[BUFSIZ];
-		ms->map->dso->annotate_warned = true;
-		symbol__strerror_disassemble(ms, err, msg, sizeof(msg));
-		ui__error("Couldn't annotate %s:\n%s", sym->name, msg);
-		goto out_free_offsets;
+	if (not_annotated) {
+		err = symbol__annotate2(ms, evsel, opts, &browser.arch);
+		if (err) {
+			char msg[BUFSIZ];
+			ms->map->dso->annotate_warned = true;
+			symbol__strerror_disassemble(ms, err, msg, sizeof(msg));
+			ui__error("Couldn't annotate %s:\n%s", sym->name, msg);
+			goto out_free_offsets;
+		}
 	}
 
 	ui_helpline__push("Press ESC to exit");
@@ -994,9 +997,11 @@ int symbol__tui_annotate(struct map_symb
 
 	ret = annotate_browser__run(&browser, evsel, hbt);
 
-	annotated_source__purge(notes->src);
+	if(not_annotated)
+		annotated_source__purge(notes->src);
 
 out_free_offsets:
-	zfree(&notes->offsets);
+	if(not_annotated)
+		zfree(&notes->offsets);
 	return ret;
 }


