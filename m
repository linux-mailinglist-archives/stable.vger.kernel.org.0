Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9009729BC07
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802634AbgJ0Puf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801431AbgJ0PlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B65FC222E9;
        Tue, 27 Oct 2020 15:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813283;
        bh=KBUREtmmo+3uvcLL72+r3TUoaWFydzczI+bhCK82yWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pEqv2nayBPI2et7T6JNnAP1/Zx93coePTO8j3CtnfsStlGjSqvq+pAA/mWltd9iD
         EW4+WzkyyuYcru2Q3s4Oq/Enab4bMInTcgYY2zI/s835x1irhmrHDSQTLLV9H6pCMq
         Hr8Q2N5R1yl+/f8/OgHmLU4yAiHHtHADXEuOwsAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 499/757] perf trace: Fix off by ones in memset() after realloc() in arches using libaudit
Date:   Tue, 27 Oct 2020 14:52:29 +0100
Message-Id: <20201027135513.859324304@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit f3013f7ed465479e60c1ab1921a5718fc541cc3b ]

'perf trace ls' started crashing after commit d21cb73a9025 on
!HAVE_SYSCALL_TABLE_SUPPORT configs (armv7l here) like this:

  0  strlen () at ../sysdeps/arm/armv6t2/strlen.S:126
  1  0xb6800780 in __vfprintf_internal (s=0xbeff9908, s@entry=0xbeff9900, format=0xa27160 "]: %s()", ap=..., mode_flags=<optimized out>) at vfprintf-internal.c:1688
  ...
  5  0x0056ecdc in fprintf (__fmt=0xa27160 "]: %s()", __stream=<optimized out>) at /usr/include/bits/stdio2.h:100
  6  trace__sys_exit (trace=trace@entry=0xbeffc710, evsel=evsel@entry=0xd968d0, event=<optimized out>, sample=sample@entry=0xbeffc3e8) at builtin-trace.c:2475
  7  0x00566d40 in trace__handle_event (sample=0xbeffc3e8, event=<optimized out>, trace=0xbeffc710) at builtin-trace.c:3122
  ...
  15 main (argc=2, argv=0xbefff6e8) at perf.c:538

It is because memset in trace__read_syscall_info zeroes wrong memory:

1) when initializing for the first time, it does not reset the last id.

2) in other cases, it resets the last id of previous buffer.

ad 1) it causes the crash above as sc->name used in the fprintf above
      contains garbage.

ad 2) it sets nonexistent from true back to false for id 11 here. Not
      sure, what the consequences are.

So fix it by introducing a special case for the initial initialization
and do the right +1 in both cases.

Fixes: d21cb73a9025 ("perf trace: Grow the syscall table as needed when using libaudit")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20201001093419.15761-1-jslaby@suse.cz
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index bea461b6f937b..44a75f234db17 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1762,7 +1762,11 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 		if (table == NULL)
 			return -ENOMEM;
 
-		memset(table + trace->sctbl->syscalls.max_id, 0, (id - trace->sctbl->syscalls.max_id) * sizeof(*sc));
+		// Need to memset from offset 0 and +1 members if brand new
+		if (trace->syscalls.table == NULL)
+			memset(table, 0, (id + 1) * sizeof(*sc));
+		else
+			memset(table + trace->sctbl->syscalls.max_id + 1, 0, (id - trace->sctbl->syscalls.max_id) * sizeof(*sc));
 
 		trace->syscalls.table	      = table;
 		trace->sctbl->syscalls.max_id = id;
-- 
2.25.1



