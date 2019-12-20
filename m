Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A82CD128312
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 21:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfLTUMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 15:12:19 -0500
Received: from mail.efficios.com ([167.114.142.138]:55104 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfLTUMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 15:12:19 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id A616A68FA9A;
        Fri, 20 Dec 2019 15:12:17 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id yqE96adCoYLl; Fri, 20 Dec 2019 15:12:17 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 1C18A68FA97;
        Fri, 20 Dec 2019 15:12:17 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 1C18A68FA97
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576872737;
        bh=980W3whSRgBeVIaqMTIFKJArmeV0Zx+uhmhhz5FKa8s=;
        h=From:To:Date:Message-Id;
        b=kIXRicsU3ZmQ2ebkOvSyMn7uOcWZVbX6npx4UZHYpc5L4YiLfNpivw3Eqt+tp7Efj
         6GbXUD4B3HIKkr1M8kkUUpBRfE1cS73+PUUKsegA403F6whWiCD4OBk7yp963G7gXK
         O9dSwqCyiyxQuLKLruPrathlMnWNgag+aTHqT+BOvnwC9tm43BwcmpNzV4WzRCL/zk
         l8qxRd/cXn5zuJZQEN6NlJToiqFGe3w0AhiAXmYFrTc1nx9ZqyvkYqShAIjI0jrX7+
         F7RFTg204Ob1H//lfNTnwxxNF5HzFMs50x7u+Kqpt2fUwyPeuO4vQIBXw4LtoBka4k
         DfU1pOpQYZSew==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id S8tKXA6YpzEL; Fri, 20 Dec 2019 15:12:17 -0500 (EST)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id BFE6068FA91;
        Fri, 20 Dec 2019 15:12:16 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Florian Weimer <fw@deneb.enyo.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Neel Natu <neelnatu@google.com>
Subject: [PATCH for 5.5 1/2] rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
Date:   Fri, 20 Dec 2019 15:12:06 -0500
Message-Id: <20191220201207.17389-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The rseq.h UAPI documents that the rseq_cs field must be cleared
before reclaiming memory that contains the targeted struct rseq_cs.

We should extend this comment to also dictate that the rseq_cs field
must be cleared before reclaiming memory of the code pointed to by
the rseq_cs start_ip and post_commit_offset fields.

While we can expect that use of dlclose(3) will typically unmap
both struct rseq_cs and its associated code at once, nothing would
theoretically prevent a JIT from reclaiming the code without
reclaiming the struct rseq_cs, which would erroneously allow the
kernel to consider new code which is not a rseq critical section
as a rseq critical section following a code reclaim.

Suggested-by: Florian Weimer <fw@deneb.enyo.de>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Florian Weimer <fw@deneb.enyo.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Neel Natu <neelnatu@google.com>
Cc: linux-api@vger.kernel.org
---
 include/uapi/linux/rseq.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
index 9a402fdb60e9..6f26b0b148a6 100644
--- a/include/uapi/linux/rseq.h
+++ b/include/uapi/linux/rseq.h
@@ -100,7 +100,9 @@ struct rseq {
 	 * instruction sequence block, as well as when the kernel detects that
 	 * it is preempting or delivering a signal outside of the range
 	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
-	 * before reclaiming memory that contains the targeted struct rseq_cs.
+	 * before reclaiming memory that contains the targeted struct rseq_cs
+	 * or reclaiming memory that contains the code refered to by the
+	 * start_ip and post_commit_offset fields of struct rseq_cs.
 	 *
 	 * Read and set by the kernel. Set by user-space with single-copy
 	 * atomicity semantics. This field should only be updated by the
-- 
2.17.1

