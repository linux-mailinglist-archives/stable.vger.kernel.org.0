Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181C62B64A0
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732253AbgKQNew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732207AbgKQNen (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95432207BC;
        Tue, 17 Nov 2020 13:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620083;
        bh=UPwJARsOdU6P1yw4JwYRAKDD8DH4a/UifEn2hEdex+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YIPbQ3vFpWqQ+cU/aY3WkCK7CLkSCB6yvgwrzs1QB7f9IhgBF37AfFbGjmm50ERen
         E7xKQziRBr/NgLrkF696wViMIuQu4HmPW/WBZWBrnidRPxTkB9At5e27UKCf/s5biX
         jySmLn+0QgEx0Pt0p3ojKw+b0J3mItz2QduFxdRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 102/255] tracing: Fix the checking of stackidx in __ftrace_trace_stack
Date:   Tue, 17 Nov 2020 14:04:02 +0100
Message-Id: <20201117122143.919637262@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6e2fb7dc41bf3..1c76a0faf3cd1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2611,7 +2611,7 @@ trace_event_buffer_lock_reserve(struct trace_buffer **current_rb,
 	/*
 	 * If tracing is off, but we have triggers enabled
 	 * we still need to look at the event data. Use the temp_buffer
-	 * to store the trace event for the tigger to use. It's recusive
+	 * to store the trace event for the trigger to use. It's recursive
 	 * safe and will not be recorded anywhere.
 	 */
 	if (!entry && trace_file->flags & EVENT_FILE_FL_TRIGGER_COND) {
@@ -2934,7 +2934,7 @@ static void __ftrace_trace_stack(struct trace_buffer *buffer,
 	stackidx = __this_cpu_inc_return(ftrace_stack_reserve) - 1;
 
 	/* This should never happen. If it does, yell once and skip */
-	if (WARN_ON_ONCE(stackidx > FTRACE_KSTACK_NESTING))
+	if (WARN_ON_ONCE(stackidx >= FTRACE_KSTACK_NESTING))
 		goto out;
 
 	/*
-- 
2.27.0



