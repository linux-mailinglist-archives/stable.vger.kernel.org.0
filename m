Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC4715EF8D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387958AbgBNRsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:48:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387591AbgBNP7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E94D24680;
        Fri, 14 Feb 2020 15:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695970;
        bh=o+o0M9tu1mUFpsW0wcJx7bRm3a8dmU2NUuterE4EqvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4Yl6TaGwhb9QSQYu/tzv1qriFYnc/cM/Em6fzd1mpbbrA68EYiuMN95ARTiYbeB+
         FeQYW93bCFEMNPHSYWTdJsotQ+Ntn+5gcX4R+AchIcUkBvsBsrWuMuwcqnGeCMzR0p
         pkUSdZGkWROIlBQx82sAO3MDuz2n45qFoLAQrRSM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 498/542] trigger_next should increase position index
Date:   Fri, 14 Feb 2020 10:48:10 -0500
Message-Id: <20200214154854.6746-498-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 6722b23e7a2ace078344064a9735fb73e554e9ef ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

Without patch:
 # dd bs=30 skip=1 if=/sys/kernel/tracing/events/sched/sched_switch/trigger
 dd: /sys/kernel/tracing/events/sched/sched_switch/trigger: cannot skip to specified offset
 n traceoff snapshot stacktrace enable_event disable_event enable_hist disable_hist hist
 # Available triggers:
 # traceon traceoff snapshot stacktrace enable_event disable_event enable_hist disable_hist hist
 6+1 records in
 6+1 records out
 206 bytes copied, 0.00027916 s, 738 kB/s

Notice the printing of "# Available triggers:..." after the line.

With the patch:
 # dd bs=30 skip=1 if=/sys/kernel/tracing/events/sched/sched_switch/trigger
 dd: /sys/kernel/tracing/events/sched/sched_switch/trigger: cannot skip to specified offset
 n traceoff snapshot stacktrace enable_event disable_event enable_hist disable_hist hist
 2+1 records in
 2+1 records out
 88 bytes copied, 0.000526867 s, 167 kB/s

It only prints the end of the file, and does not restart.

Link: http://lkml.kernel.org/r/3c35ee24-dd3a-8119-9c19-552ed253388a@virtuozzo.com

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_trigger.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 40106fff06a48..287d77eae59b3 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -116,9 +116,10 @@ static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
 {
 	struct trace_event_file *event_file = event_file_data(m->private);
 
-	if (t == SHOW_AVAILABLE_TRIGGERS)
+	if (t == SHOW_AVAILABLE_TRIGGERS) {
+		(*pos)++;
 		return NULL;
-
+	}
 	return seq_list_next(t, &event_file->triggers, pos);
 }
 
-- 
2.20.1

