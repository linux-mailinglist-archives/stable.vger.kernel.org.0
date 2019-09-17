Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134D8B5553
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 20:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbfIQSaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 14:30:12 -0400
Received: from mail.efficios.com ([167.114.142.138]:37456 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbfIQSaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 14:30:11 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 88B3A1D4DEC;
        Tue, 17 Sep 2019 14:30:10 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id la2lHpKLUR6o; Tue, 17 Sep 2019 14:30:10 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 1DE6C1D4DDD;
        Tue, 17 Sep 2019 14:30:10 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 1DE6C1D4DDD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1568745010;
        bh=XtEH5PGXdU9J9Un0UKLWRvsMum7tk4G/OgscPixXs5o=;
        h=From:To:Date:Message-Id;
        b=btfPXCIRQaFL847enyvmvgIW6/6ZUz4Ke6LDqi2QpLmAYnH8uG2c9HmlNliNCG/1F
         doeZQCQi60iYVV8yFIf2BrU3E2BpUQQQsGMHyPw6VpeIaICvUvGCzYx80oNasdtxWm
         7VRqQWiQcMDJXKr3Rcc56TkkphKO/cTDm5YGwU/RojFM3bJbGSe5Rer0L9fsNGaag9
         uvUwTpwCv3JVyhUjhBZnevpf2U8R9HRgW/vKKwZfLWHwlS1xvFl1XUr/R6Gn3JqjfC
         A4kUj5Kf5uTWj9w0ukL01IuuRyfQFk7N6Z7da4TtSwUHc2DM6ekEqw2qz+1dYYAoao
         UJ6GBXdsOPAbw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id n7jYPQ8DKpBF; Tue, 17 Sep 2019 14:30:10 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id B0FD91D4DC9;
        Tue, 17 Sep 2019 14:30:09 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 5.4 1/3] rseq: Fix: Reject unknown flags on rseq unregister
Date:   Tue, 17 Sep 2019 14:29:57 -0400
Message-Id: <20190917182959.16333-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
References: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
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
Cc: <stable@vger.kernel.org>	# v4.18+
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

