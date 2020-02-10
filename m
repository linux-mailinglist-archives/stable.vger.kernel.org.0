Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFCF157C57
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgBJMfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbgBJMfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:07 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 235DD214DB;
        Mon, 10 Feb 2020 12:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338107;
        bh=V4Vj4iXVZCOwvr/0Kky48M0kWDdquu7/d64KrYgidMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIIbxzWezzOxJeKVBSU5IaWA8YdllZrNYoi2j01DCba/bMtQkGLRXPwt08UEYVbqy
         QfLt0wd7ocAfHaKaKBNC2cPlhKyiIFC5uviG0BnZ4JkttPdeC7lv8Q4q+BUBBtFICz
         mfQS8/uPQvBtUNW0auZGGqLyuqOeK9R1e4gOyIj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        syzbot+774fddf07b7ab29a1e55@syzkaller.appspotmail.com,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 4.19 029/195] tracing: Fix sched switch start/stop refcount racy updates
Date:   Mon, 10 Feb 2020 04:31:27 -0800
Message-Id: <20200210122309.320840403@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 64ae572bc7d0060429e40e1c8d803ce5eb31a0d6 upstream.

Reading the sched_cmdline_ref and sched_tgid_ref initial state within
tracing_start_sched_switch without holding the sched_register_mutex is
racy against concurrent updates, which can lead to tracepoint probes
being registered more than once (and thus trigger warnings within
tracepoint.c).

[ May be the fix for this bug ]
Link: https://lore.kernel.org/r/000000000000ab6f84056c786b93@google.com

Link: http://lkml.kernel.org/r/20190817141208.15226-1-mathieu.desnoyers@efficios.com

Cc: stable@vger.kernel.org
CC: Steven Rostedt (VMware) <rostedt@goodmis.org>
CC: Joel Fernandes (Google) <joel@joelfernandes.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Paul E. McKenney <paulmck@linux.ibm.com>
Reported-by: syzbot+774fddf07b7ab29a1e55@syzkaller.appspotmail.com
Fixes: d914ba37d7145 ("tracing: Add support for recording tgid of tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_sched_switch.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -89,8 +89,10 @@ static void tracing_sched_unregister(voi
 
 static void tracing_start_sched_switch(int ops)
 {
-	bool sched_register = (!sched_cmdline_ref && !sched_tgid_ref);
+	bool sched_register;
+
 	mutex_lock(&sched_register_mutex);
+	sched_register = (!sched_cmdline_ref && !sched_tgid_ref);
 
 	switch (ops) {
 	case RECORD_CMDLINE:


