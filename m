Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C71B1675BF
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733282AbgBUIbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733242AbgBUIOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:14:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99EE320578;
        Fri, 21 Feb 2020 08:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272892;
        bh=o+o0M9tu1mUFpsW0wcJx7bRm3a8dmU2NUuterE4EqvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1BkZ84gdFnoiOS+uGordZUE5n9f72ayEpyD9ruHEHSL+2Etnm89qKjcnfBxPYR/E
         Zpr67HtEswV8oaVgsQJDl62KYZGhtDFYiozDKYdJjDMI4oG0kzsnlAwhaIlpZAOHGK
         yeii/YJ7NUYTAhjj9FxeOkHpJGdGk+pVpuvKDFHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 314/344] trigger_next should increase position index
Date:   Fri, 21 Feb 2020 08:41:53 +0100
Message-Id: <20200221072418.600688688@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



