Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985053E81DC
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhHJSDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237583AbhHJSBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:01:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF0B7613A1;
        Tue, 10 Aug 2021 17:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617621;
        bh=WC4duxA5gNh5Pkh6xkoDfxpUn0RbcDfKjuVUS46jcJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHonKAsNnaNdDGcBrWpab9oK1PCa1lpuYVa0cps4pHX7KbHF5rDV3WmsaVoB/AlhX
         zTax+4J/6Tqr5e3G37FPeG2VEulutWRRg0DX9DVpg0OsIhfiTa2KdwRkNiiHsLUps2
         rxCxkADXq3cUwzOp08c2idXDjA64o4g+bWRpKI8s=
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
Subject: [PATCH 5.13 105/175] tracepoint: static call: Compare data on transition from 2->1 callees
Date:   Tue, 10 Aug 2021 19:30:13 +0200
Message-Id: <20210810173004.423537753@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
@@ -338,7 +338,7 @@ static int tracepoint_remove_func(struct
 	} else {
 		rcu_assign_pointer(tp->funcs, tp_funcs);
 		tracepoint_update_call(tp, tp_funcs,
-				       tp_funcs[0].func != old[0].func);
+				       tp_funcs[0].data != old[0].data);
 	}
 	release_probes(old);
 	return 0;


