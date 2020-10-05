Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A98283A1F
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgJEPbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJEPb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B237C2085B;
        Mon,  5 Oct 2020 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911889;
        bh=2GjSQPTuaB7TWlIdz4/eFf2g6Be55yicyNCrJRNW1j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qt2YJLhKNp45Ah6xfMU1QWKsdu+uJ86ZhO1znXXiuu9RHkEjyHTrNJVFVaH1thICL
         0cs6NSBQsj/kzTXilAo3AjKZBOzvNobN/ohd9D8Cn4CXJXd06tY8MEvFa6mP8v35v6
         q2SBIpVsaS0qA6l6rpTxmuXCW1zqI26gbmmcZqog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul McKenney <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.8 19/85] ftrace: Move RCU is watching check after recursion check
Date:   Mon,  5 Oct 2020 17:26:15 +0200
Message-Id: <20201005142115.662558364@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit b40341fad6cc2daa195f8090fd3348f18fff640a upstream.

The first thing that the ftrace function callback helper functions should do
is to check for recursion. Peter Zijlstra found that when
"rcu_is_watching()" had its notrace removed, it caused perf function tracing
to crash. This is because the call of rcu_is_watching() is tested before
function recursion is checked and and if it is traced, it will cause an
infinite recursion loop.

rcu_is_watching() should still stay notrace, but to prevent this should
never had crashed in the first place. The recursion prevention must be the
first thing done in callback functions.

Link: https://lore.kernel.org/r/20200929112541.GM2628@hirez.programming.kicks-ass.net

Cc: stable@vger.kernel.org
Cc: Paul McKenney <paulmck@kernel.org>
Fixes: c68c0fa293417 ("ftrace: Have ftrace_ops_get_func() handle RCU and PER_CPU flags too")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6877,16 +6877,14 @@ static void ftrace_ops_assist_func(unsig
 {
 	int bit;
 
-	if ((op->flags & FTRACE_OPS_FL_RCU) && !rcu_is_watching())
-		return;
-
 	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
 	if (bit < 0)
 		return;
 
 	preempt_disable_notrace();
 
-	op->func(ip, parent_ip, op, regs);
+	if (!(op->flags & FTRACE_OPS_FL_RCU) || rcu_is_watching())
+		op->func(ip, parent_ip, op, regs);
 
 	preempt_enable_notrace();
 	trace_clear_recursion(bit);


