Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E1A3CA67C
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbhGOSsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238897AbhGOSry (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:47:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33580613D2;
        Thu, 15 Jul 2021 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374700;
        bh=LSLT1XLobsp7Ag5hdiSVQhRhRsAB9zdQBrJKly2LBAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deZ5GcDLzs7uoRclh3keBWGuG3sPcv541wqKROYvNInzF6hliLZ2x6V+d/xjKmRtM
         Bz5/QLPMsE1CG6o4JuCeVr0R6e3lH9FehN138oTiS57PdQ1QdiM9bq/ZxlOHu2KvdJ
         rm5651kmkfwuLM70ACrfnh9XWRCV1F2cpyH4m2Y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.4 074/122] perf bench: Fix 2 memory sanitizer warnings
Date:   Thu, 15 Jul 2021 20:38:41 +0200
Message-Id: <20210715182509.449639236@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

commit d2c73501a767514b6c85c7feff9457a165d51057 upstream.

Memory sanitizer warns if a write is performed where the memory being
read for the write is uninitialized. Avoid this warning by initializing
the memory.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20200912053725.1405857-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/bench/sched-messaging.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -66,11 +66,10 @@ static void fdpair(int fds[2])
 /* Block until we're ready to go */
 static void ready(int ready_out, int wakefd)
 {
-	char dummy;
 	struct pollfd pollfd = { .fd = wakefd, .events = POLLIN };
 
 	/* Tell them we're ready. */
-	if (write(ready_out, &dummy, 1) != 1)
+	if (write(ready_out, "R", 1) != 1)
 		err(EXIT_FAILURE, "CLIENT: ready write");
 
 	/* Wait for "GO" signal */
@@ -85,6 +84,7 @@ static void *sender(struct sender_contex
 	unsigned int i, j;
 
 	ready(ctx->ready_out, ctx->wakefd);
+	memset(data, 'S', sizeof(data));
 
 	/* Now pump to every receiver. */
 	for (i = 0; i < nr_loops; i++) {


