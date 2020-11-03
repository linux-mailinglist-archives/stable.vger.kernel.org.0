Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E0E2A580A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbgKCVrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731899AbgKCUvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09D37223FD;
        Tue,  3 Nov 2020 20:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436662;
        bh=Yv/f268HFJkN+1vSeyywKjbrMmMCXFppzKgHQgZDufA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EX4rO+siQLJGxS7Ue415H6z+uDm/mIhZfKC+mdF5qzh9OJMD5jnKWg/66JckAiUKe
         FzHWeKHgiuyon+xMEqdS1+VugT6kEOjFhlyxPOI/GL9cSgQ7CoyxbMzPn5Hfc/cafM
         GsqM5NG/UzbLvYyH4y1SFrFNVfUMRPsTFbITrB4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.9 310/391] perf python scripting: Fix printable strings in python3 scripts
Date:   Tue,  3 Nov 2020 21:36:01 +0100
Message-Id: <20201103203408.027456100@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

commit 6fcd5ddc3b1467b3586972ef785d0d926ae4cdf4 upstream.

Hagen reported broken strings in python3 tracepoint scripts:

  make PYTHON=python3
  perf record -e sched:sched_switch -a -- sleep 5
  perf script --gen-script py
  perf script -s ./perf-script.py

  [..]
  sched__sched_switch      7 563231.759525792        0 swapper   prev_comm=bytearray(b'swapper/7\x00\x00\x00\x00\x00\x00\x00'), prev_pid=0, prev_prio=120, prev_state=, next_comm=bytearray(b'mutex-thread-co\x00'),

The problem is in the is_printable_array function that does not take the
zero byte into account and claim such string as not printable, so the
code will create byte array instead of string.

Committer testing:

After this fix:

sched__sched_switch 3 484522.497072626  1158680 kworker/3:0-eve  prev_comm=kworker/3:0, prev_pid=1158680, prev_prio=120, prev_state=I, next_comm=swapper/3, next_pid=0, next_prio=120
Sample: {addr=0, cpu=3, datasrc=84410401, datasrc_decode=N/A|SNP N/A|TLB N/A|LCK N/A, ip=18446744071841817196, period=1, phys_addr=0, pid=1158680, tid=1158680, time=484522497072626, transaction=0, values=[(0, 0)], weight=0}

sched__sched_switch 4 484522.497085610  1225814 perf             prev_comm=perf, prev_pid=1225814, prev_prio=120, prev_state=, next_comm=migration/4, next_pid=30, next_prio=0
Sample: {addr=0, cpu=4, datasrc=84410401, datasrc_decode=N/A|SNP N/A|TLB N/A|LCK N/A, ip=18446744071841817196, period=1, phys_addr=0, pid=1225814, tid=1225814, time=484522497085610, transaction=0, values=[(0, 0)], weight=0}

Fixes: 249de6e07458 ("perf script python: Fix string vs byte array resolving")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200928201135.3633850-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/print_binary.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/print_binary.c
+++ b/tools/perf/util/print_binary.c
@@ -50,7 +50,7 @@ int is_printable_array(char *p, unsigned
 
 	len--;
 
-	for (i = 0; i < len; i++) {
+	for (i = 0; i < len && p[i]; i++) {
 		if (!isprint(p[i]) && !isspace(p[i]))
 			return 0;
 	}


