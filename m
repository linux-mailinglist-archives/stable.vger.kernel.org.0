Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8122B61DB
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbgKQNXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:23:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731193AbgKQNXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:23:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09B242463D;
        Tue, 17 Nov 2020 13:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619384;
        bh=J/OoGI3lhZzsJVrWdJRlf7V+GkrL+Pr584KccF1kmCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yibHGKl7ICr0XUQCA/ipv1eyG2p44D+Q63bC8+G0cjRJ5RkKHtmwHjUS2qUui7GSU
         U4G215STcQVft+JVwmFy0odLwkvrP6psvONPuOoUdJJkkfUszfAGFMLBpkjUjKQY7M
         FQsydz6lyMBroXl2tR8gv3vjMwx38fgfyRbWsiYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanislav Ivanichkin <sivanichkin@yandex-team.ru>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/151] perf trace: Fix segfault when trying to trace events by cgroup
Date:   Tue, 17 Nov 2020 14:04:11 +0100
Message-Id: <20201117122122.437439911@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Ivanichkin <sivanichkin@yandex-team.ru>

[ Upstream commit a6293f36ac92ab513771a98efe486477be2f981f ]

  # ./perf trace -e sched:sched_switch -G test -a sleep 1
  perf: Segmentation fault
  Obtained 11 stack frames.
  ./perf(sighandler_dump_stack+0x43) [0x55cfdc636db3]
  /lib/x86_64-linux-gnu/libc.so.6(+0x3efcf) [0x7fd23eecafcf]
  ./perf(parse_cgroups+0x36) [0x55cfdc673f36]
  ./perf(+0x3186ed) [0x55cfdc70d6ed]
  ./perf(parse_options_subcommand+0x629) [0x55cfdc70e999]
  ./perf(cmd_trace+0x9c2) [0x55cfdc5ad6d2]
  ./perf(+0x1e8ae0) [0x55cfdc5ddae0]
  ./perf(+0x1e8ded) [0x55cfdc5ddded]
  ./perf(main+0x370) [0x55cfdc556f00]
  /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xe6) [0x7fd23eeadb96]
  ./perf(_start+0x29) [0x55cfdc557389]
  Segmentation fault
  #

 It happens because "struct trace" in option->value is passed to the
 parse_cgroups function instead of "struct evlist".

Fixes: 9ea42ba4411ac ("perf trace: Support setting cgroups as targets")
Signed-off-by: Stanislav Ivanichkin <sivanichkin@yandex-team.ru>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Link: http://lore.kernel.org/lkml/20201027094357.94881-1-sivanichkin@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index bb5130d021554..a5201de1a191d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -3979,9 +3979,9 @@ do_concat:
 	err = 0;
 
 	if (lists[0]) {
-		struct option o = OPT_CALLBACK('e', "event", &trace->evlist, "event",
-					       "event selector. use 'perf list' to list available events",
-					       parse_events_option);
+		struct option o = {
+			.value = &trace->evlist,
+		};
 		err = parse_events_option(&o, lists[0], 0);
 	}
 out:
@@ -3995,9 +3995,12 @@ static int trace__parse_cgroups(const struct option *opt, const char *str, int u
 {
 	struct trace *trace = opt->value;
 
-	if (!list_empty(&trace->evlist->core.entries))
-		return parse_cgroups(opt, str, unset);
-
+	if (!list_empty(&trace->evlist->core.entries)) {
+		struct option o = {
+			.value = &trace->evlist,
+		};
+		return parse_cgroups(&o, str, unset);
+	}
 	trace->cgroup = evlist__findnew_cgroup(trace->evlist, str);
 
 	return 0;
-- 
2.27.0



