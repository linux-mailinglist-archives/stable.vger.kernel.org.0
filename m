Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922A43E15A2
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 15:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240960AbhHEN1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 09:27:38 -0400
Received: from mail.efficios.com ([167.114.26.124]:35268 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240788AbhHEN1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 09:27:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 73552370804;
        Thu,  5 Aug 2021 09:27:23 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id HrTLieDXdMWJ; Thu,  5 Aug 2021 09:27:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 054B93704E3;
        Thu,  5 Aug 2021 09:27:23 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 054B93704E3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1628170043;
        bh=RIOd3bKT5xyxVjKji6iSJjdTMwCEFAS2QLS4P5hpqHM=;
        h=From:To:Date:Message-Id;
        b=skI5bVT/VQcXsGQDvlPjDsrSe6J1isIpMT9MvIXN7CD0UxirnNehCptem7bZp7swh
         0GeDkQ71vhojElkkZJ/AN/OuVuVNpGJpA5TN4X6YVqLxvPPS6EhRBdJklrccl6i1wN
         b1fXinGgOF67TfCNUFKbNFhBOdNZQu7ah8i44NkJBqojCTDbi5F5n2AFObfD8oqXb0
         z7S4x6M2p9ERVo66GfSZGKH1EQRVTQ5dpqZNV8xxbzGwChXB2pJKQaxsn4xgHqsEqg
         oLUv1vJNsdAbhltJNjm5eC02Hphmj0yfzJaCHbasK2Y+qtkJVotB45EdL7X+mDna7/
         nDR2dYcLnh9fQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SUv0GByxNU6S; Thu,  5 Aug 2021 09:27:22 -0400 (EDT)
Received: from localhost.localdomain (173-246-27-5.qc.cable.ebox.net [173.246.27.5])
        by mail.efficios.com (Postfix) with ESMTPSA id CE62B370458;
        Thu,  5 Aug 2021 09:27:22 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 1/3] Fix: tracepoint: static call: compare data on transition from 2->1 callees
Date:   Thu,  5 Aug 2021 09:27:15 -0400
Message-Id: <20210805132717.23813-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805132717.23813-1-mathieu.desnoyers@efficios.com>
References: <20210805132717.23813-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On transition from 2->1 callees, we should be comparing .data rather
than .func, because the same callback can be registered twice with
different data, and what we care about here is that the data of array
element 0 is unchanged to skip rcu sync.

Link: https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/
Fixes: d25e37d89dd2 ("tracepoint: Optimize using static_call()")
Fixes: 547305a64632 ("tracepoint: Fix out of sync data passing by static caller")
Fixes: 352384d5c84e ("tracepoints: Update static_call before tp_funcs when adding a tracepoint")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: <stable@vger.kernel.org> # 5.10+
---
 kernel/tracepoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index fc32821f8240..133b6454b287 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -338,7 +338,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
 	} else {
 		rcu_assign_pointer(tp->funcs, tp_funcs);
 		tracepoint_update_call(tp, tp_funcs,
-				       tp_funcs[0].func != old[0].func);
+				       tp_funcs[0].data != old[0].data);
 	}
 	release_probes(old);
 	return 0;
-- 
2.17.1

