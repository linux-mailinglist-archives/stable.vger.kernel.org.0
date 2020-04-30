Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A8B1BFC39
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgD3NxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbgD3NxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B29F24959;
        Thu, 30 Apr 2020 13:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254789;
        bh=qKBznBFSzgrBmpOQQU4ZAx53WL6oKabzuek0foUUyFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ureHbNsx64/bKVEuwtAUQo0w9oovbHgRn8Mu9A9OlmJgiOsw/aiLfpPwIh46bh58O
         vU+AN4YIjKhZTunxR8E05SYrKj8phcbedJCjfbJ5B0CXdUQN97xIGfcwPVbtB0xaq0
         FAu2u3ptY3vNjm2OCgYgFsQs9So107HUT2pNhjEA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>, KP Singh <kpsingh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 45/57] perf/core: fix parent pid/tid in task exit events
Date:   Thu, 30 Apr 2020 09:52:06 -0400
Message-Id: <20200430135218.20372-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit f3bed55e850926614b9898fe982f66d2541a36a5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 72d0cfd73cf11..7382fc95d41e5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7052,10 +7052,17 @@ static void perf_event_task_output(struct perf_event *event,
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
 
-- 
2.20.1

