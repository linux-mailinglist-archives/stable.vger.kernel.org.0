Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EE82ACC6C
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732976AbgKJDzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733039AbgKJDzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 299B6208FE;
        Tue, 10 Nov 2020 03:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980510;
        bh=iHiH8YlWWY2/Y3wk98ZXK2c658guRT96KOGjGgLzr0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuZT7TkkB0ak1HLhnpkQFKKqfVhvedNSNd/f9q7uSxqWMCamphjdW0qVLVK4O1sH1
         VWlTydgDh4rRjraAn5J9vuQktn+i8jY9tpn1EpFkm+n6R8V61HDmG3ZsDe9sJBqo1z
         a0A/ZKIo29cbrI6bdz6YLQ1gKoU6v7QS/QqYccbQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiujun Huang <hqjagain@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 21/42] tracing: Fix the checking of stackidx in __ftrace_trace_stack
Date:   Mon,  9 Nov 2020 22:54:19 -0500
Message-Id: <20201110035440.424258-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

[ Upstream commit 906695e59324635c62b5ae59df111151a546ca66 ]

The array size is FTRACE_KSTACK_NESTING, so the index FTRACE_KSTACK_NESTING
is illegal too. And fix two typos by the way.

Link: https://lkml.kernel.org/r/20201031085714.2147-1-hqjagain@gmail.com

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5b2a664812b10..5530dd2f06dba 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2510,7 +2510,7 @@ trace_event_buffer_lock_reserve(struct ring_buffer **current_rb,
 	/*
 	 * If tracing is off, but we have triggers enabled
 	 * we still need to look at the event data. Use the temp_buffer
-	 * to store the trace event for the tigger to use. It's recusive
+	 * to store the trace event for the trigger to use. It's recursive
 	 * safe and will not be recorded anywhere.
 	 */
 	if (!entry && trace_file->flags & EVENT_FILE_FL_TRIGGER_COND) {
@@ -2832,7 +2832,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	stackidx = __this_cpu_inc_return(ftrace_stack_reserve) - 1;
 
 	/* This should never happen. If it does, yell once and skip */
-	if (WARN_ON_ONCE(stackidx > FTRACE_KSTACK_NESTING))
+	if (WARN_ON_ONCE(stackidx >= FTRACE_KSTACK_NESTING))
 		goto out;
 
 	/*
-- 
2.27.0

