Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CFE171F36
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbgB0OAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732498AbgB0OAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:00:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A8220578;
        Thu, 27 Feb 2020 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812044;
        bh=NtWsg5WK7mx+W8fFPsrVUDYPhd4aBxrwTVv3Tc1Vd/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMoqF7Hah205DLXpWx35ORb3jDbwhF4lVIBVEu7gpjgcaw1/JbVmh5w9tfJlkppWi
         Q7jZTA7NhlPTyBGwy0oTI15GQ32HRtAGHo/vuIW6CNKXzXFcJwNwEbOQNFPE1kDVLa
         vcaueJ8DRqLFdBqaqTz3Dk+v4BsK0AYQ5tkEpWzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 152/237] ftrace: fpid_next() should increase position index
Date:   Thu, 27 Feb 2020 14:36:06 +0100
Message-Id: <20200227132307.757197690@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
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
index 8974ecbcca3cb..8a8d92a8045b1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6317,9 +6317,10 @@ static void *fpid_next(struct seq_file *m, void *v, loff_t *pos)
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



