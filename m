Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E26A3E806C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhHJRsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236236AbhHJRq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:46:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55EFD61260;
        Tue, 10 Aug 2021 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617249;
        bh=KqXDFD6igxKn7WUli2jPpng69mg8Ha6TY3DfR4qYJbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CII7vpKhE6id+KGMiMgSUQXi14AhXDNgsaOwVksEd+vN08aZlXgRPvYaJaGJKzZJF
         lJTiQGJWcZ3ppwTz0Q87F23xCdFxcS2+WIA110yUs1lmOcFKoDvHBNjTOliy6pUDrL
         hZoYvqiP8+AgqsuDQ/BYDw4P6qGozdPfzsipHOSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 078/135] tracepoint: static call: Compare data on transition from 2->1 callees
Date:   Tue, 10 Aug 2021 19:30:12 +0200
Message-Id: <20210810172958.382412734@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit f7ec4121256393e1d03274acdca73eb18958f27e upstream.

On transition from 2->1 callees, we should be comparing .data rather
than .func, because the same callback can be registered twice with
different data, and what we care about here is that the data of array
element 0 is unchanged to skip rcu sync.

Link: https://lkml.kernel.org/r/20210805132717.23813-2-mathieu.desnoyers@efficios.com
Link: https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>
Fixes: 547305a64632 ("tracepoint: Fix out of sync data passing by static caller")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/tracepoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -359,7 +359,7 @@ static int tracepoint_remove_func(struct
 	} else {
 		rcu_assign_pointer(tp->funcs, tp_funcs);
 		tracepoint_update_call(tp, tp_funcs,
-				       tp_funcs[0].func != old[0].func);
+				       tp_funcs[0].data != old[0].data);
 	}
 	release_probes(old);
 	return 0;


