Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FFD15DD90
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388935AbgBNP7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:59:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388929AbgBNP7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04CAD2187F;
        Fri, 14 Feb 2020 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695969;
        bh=sysEa46Yz0+Q77T04gaS8Khuim8g/xr/Jf5pGs2Miq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAUKKEbqnlV+/kojYXYkfXfAgsLteKQ0LuGsQuAvZHQ5u2x4b+vBOqDMMk0G8W15a
         9Ts4ASlKv6Ddya9D5YIdGKLd0Y2Ca7e6IBdMd9Y9dzAjd2IWvctHCkQFA/4oMpGJjT
         olBVYB3DHiZ1lP8dVEPj3yh9cpvT6QSxORc0tfR0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 497/542] ftrace: fpid_next() should increase position index
Date:   Fri, 14 Feb 2020 10:48:09 -0500
Message-Id: <20200214154854.6746-497-sashal@kernel.org>
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
index 3581bd96d6eb3..ddb47a0af854b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7038,9 +7038,10 @@ static void *fpid_next(struct seq_file *m, void *v, loff_t *pos)
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

