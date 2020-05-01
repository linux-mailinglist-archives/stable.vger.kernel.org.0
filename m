Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF991C1476
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbgEANjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731211AbgEANjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 367EF2495D;
        Fri,  1 May 2020 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340378;
        bh=evDVQjdYXTl7DELz2MomaNd81AX60YXNBSVhLz7OUKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5jJIE9Zn8fUqilDYMtRDurO8EQHazbZ+b7FRBs41HaiNLrgIhAXsHI3KboIjsP26
         Bdipy24CKh/JsMRdUyd2q6VTQPsKmlz4UHRYgX5ZFgkKcz7EkYkEDN4yeVu41/n4if
         bFFOY7OxD2F6NyEmKQDAYLh7baPQzFczg9aSycQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, KP Singh <kpsingh@google.com>,
        Ian Rogers <irogers@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 42/83] perf/core: fix parent pid/tid in task exit events
Date:   Fri,  1 May 2020 15:23:21 +0200
Message-Id: <20200501131535.947379254@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

commit f3bed55e850926614b9898fe982f66d2541a36a5 upstream.

Current logic yields the child task as the parent.

Before:
$ perf record bash -c "perf list > /dev/null"
$ perf script -D |grep 'FORK\|EXIT'
4387036190981094 0x5a70 [0x30]: PERF_RECORD_FORK(10472:10472):(10470:10470)
4387036606207580 0xf050 [0x30]: PERF_RECORD_EXIT(10472:10472):(10472:10472)
4387036607103839 0x17150 [0x30]: PERF_RECORD_EXIT(10470:10470):(10470:10470)
                                                   ^
  Note the repeated values here -------------------/

After:
383281514043 0x9d8 [0x30]: PERF_RECORD_FORK(2268:2268):(2266:2266)
383442003996 0x2180 [0x30]: PERF_RECORD_EXIT(2268:2268):(2266:2266)
383451297778 0xb70 [0x30]: PERF_RECORD_EXIT(2266:2266):(2265:2265)

Fixes: 94d5d1b2d891 ("perf_counter: Report the cloning task as parent on perf_counter_fork()")
Reported-by: KP Singh <kpsingh@google.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200417182842.12522-1-irogers@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7052,10 +7052,17 @@ static void perf_event_task_output(struc
 		goto out;
 
 	task_event->event_id.pid = perf_event_pid(event, task);
-	task_event->event_id.ppid = perf_event_pid(event, current);
-
 	task_event->event_id.tid = perf_event_tid(event, task);
-	task_event->event_id.ptid = perf_event_tid(event, current);
+
+	if (task_event->event_id.header.type == PERF_RECORD_EXIT) {
+		task_event->event_id.ppid = perf_event_pid(event,
+							task->real_parent);
+		task_event->event_id.ptid = perf_event_pid(event,
+							task->real_parent);
+	} else {  /* PERF_RECORD_FORK */
+		task_event->event_id.ppid = perf_event_pid(event, current);
+		task_event->event_id.ptid = perf_event_tid(event, current);
+	}
 
 	task_event->event_id.time = perf_event_clock(event);
 


