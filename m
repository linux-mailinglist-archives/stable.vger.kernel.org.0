Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D58BB2315
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 17:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390952AbfIMPM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 11:12:26 -0400
Received: from mail.efficios.com ([167.114.142.138]:52478 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388211AbfIMPM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 11:12:26 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 12D3C2D10CF;
        Fri, 13 Sep 2019 11:12:25 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 9kApdPTo4PfC; Fri, 13 Sep 2019 11:12:24 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 9F11E2D10C3;
        Fri, 13 Sep 2019 11:12:24 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 9F11E2D10C3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1568387544;
        bh=CF30skzmeT+OHOZpIIX+JRHGYZLBT9tYk5qDUQF0abw=;
        h=From:To:Date:Message-Id;
        b=nLRy5vzItmeyU9fB8/JrQPYtOpwgoVRNIf2mTFNczbPJezOhX4D0oELdgy41RaCBd
         n6b/elsAxflYzrhtkPvjKH9B34k8ploVl+IeibQKC4aTSk0rBvgDt6XaEZ9dukvHO5
         p5Y8/sr77BYPC0Mve53jffjmcMfWJ81ISWkfd7S7DgvyNpdppoDOKFGikKfFgoVkAF
         mqPc/V/EXI+w6RCDdF1Cr2wLEVq8I3dj+FBBjVEDRWnGB1tJDelgw0oFxLubwMnn7x
         l4oo5AiVjXyq5RIaKNMKmElPoCnOF2EjYWIJxra9GISWaTAwbu/pcjmRwgkou4zEYN
         I0eRysGinwWKA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id k4IJtem76veo; Fri, 13 Sep 2019 11:12:24 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 630762D10BD;
        Fri, 13 Sep 2019 11:12:24 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH for 5.3 1/3] rseq: Fix: Reject unknown flags on rseq unregister
Date:   Fri, 13 Sep 2019 11:12:18 -0400
Message-Id: <20190913151220.3105-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is preferrable to reject unknown flags within rseq unregistration
rather than to ignore them. It is an oversight caused by the fact that
the check for unknown flags is after the rseq unregister flag check.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: linux-api@vger.kernel.org
Cc: <stable@vger.kernel.org>
---
 kernel/rseq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rseq.c b/kernel/rseq.c
index 27c48eb7de40..a4f86a9d6937 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -310,6 +310,8 @@ SYSCALL_DEFINE4(rseq, struct rseq __user *, rseq, u32, rseq_len,
 	int ret;
 
 	if (flags & RSEQ_FLAG_UNREGISTER) {
+		if (flags & ~RSEQ_FLAG_UNREGISTER)
+			return -EINVAL;
 		/* Unregister rseq for current thread. */
 		if (current->rseq != rseq || !current->rseq)
 			return -EINVAL;
-- 
2.17.1

