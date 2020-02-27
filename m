Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D783C172085
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbgB0Oni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:43:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730349AbgB0NtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:49:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4221E20578;
        Thu, 27 Feb 2020 13:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811359;
        bh=f3FB7IBIjO231L3q8BcFPZb+tImF0hnLMlwnUYFEUMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2eyIZ5uzt4BQXc24aHv+y0NnZarnpjm6gRYx/O4gfCKhDf+ChUftn0oCY9TkRL8bq
         qkwC+snV3oiL86zAWU8zl0EdPoVqZHq5Gd64mOt5uny3fMiYbbuZQN6H/VtYb55IeA
         AzsXxCdjwWd67KOQnuMZkww9i86nf1AhTJk6METU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 103/165] ftrace: fpid_next() should increase position index
Date:   Thu, 27 Feb 2020 14:36:17 +0100
Message-Id: <20200227132246.178585643@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit e4075e8bdffd93a9b6d6e1d52fabedceeca5a91b ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

Without patch:
 # dd bs=4 skip=1 if=/sys/kernel/tracing/set_ftrace_pid
 dd: /sys/kernel/tracing/set_ftrace_pid: cannot skip to specified offset
 id
 no pid
 2+1 records in
 2+1 records out
 10 bytes copied, 0.000213285 s, 46.9 kB/s

Notice the "id" followed by "no pid".

With the patch:
 # dd bs=4 skip=1 if=/sys/kernel/tracing/set_ftrace_pid
 dd: /sys/kernel/tracing/set_ftrace_pid: cannot skip to specified offset
 id
 0+1 records in
 0+1 records out
 3 bytes copied, 0.000202112 s, 14.8 kB/s

Notice that it only prints "id" and not the "no pid" afterward.

Link: http://lkml.kernel.org/r/4f87c6ad-f114-30bb-8506-c32274ce2992@virtuozzo.com

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 71a40e5c3a9f0..2ae98f8bce81b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5455,9 +5455,10 @@ static void *fpid_next(struct seq_file *m, void *v, loff_t *pos)
 	struct trace_array *tr = m->private;
 	struct trace_pid_list *pid_list = rcu_dereference_sched(tr->function_pids);
 
-	if (v == FTRACE_NO_PIDS)
+	if (v == FTRACE_NO_PIDS) {
+		(*pos)++;
 		return NULL;
-
+	}
 	return trace_pid_next(pid_list, v, pos);
 }
 
-- 
2.20.1



