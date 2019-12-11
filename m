Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982ED11B858
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbfLKQRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:17:24 -0500
Received: from mail.efficios.com ([167.114.142.138]:44000 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729742AbfLKQRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 11:17:24 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 28725686C28;
        Wed, 11 Dec 2019 11:17:23 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id EPJ9Ban-ojuM; Wed, 11 Dec 2019 11:17:22 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id A4444686C0A;
        Wed, 11 Dec 2019 11:17:22 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com A4444686C0A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576081042;
        bh=XtEH5PGXdU9J9Un0UKLWRvsMum7tk4G/OgscPixXs5o=;
        h=From:To:Date:Message-Id;
        b=SWxYM5M2ejcsOs5LLI49aAxj7zcOoqKjoSo/nL/U1XU0w3BIm2OLeebyMMj2WXvDa
         Zn2p0Cw7dq6uD/WAVeES8LoKvxlWo8vquVy8Pk8MjdA3K+MS3VoASqDk1y6Egj9w/h
         1Uil7R9SuvVt2dEShamnOnMVpYtpaUOBcLpI0ucRjN5rvZd+ffl4Ug0Wv+wxISYzOv
         5HwmBt+3qpMH9BfhskBAba4oXKSCLGqvXRIRSr23rQ7zZRH1Fd3PAmBtMAMgpPTcTQ
         5s9Qv6HiCW98Oe3gWv4zIcmnUO0BrME+Ejx2LTcc7LFjvxqJMyVjiJcxcWZ99aZw5k
         l+d2bXIZ4oiFQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id rHQU6bdTc5Ja; Wed, 11 Dec 2019 11:17:22 -0500 (EST)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 6F872686BF4;
        Wed, 11 Dec 2019 11:17:22 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 5.5 1/3] rseq: Fix: Reject unknown flags on rseq unregister
Date:   Wed, 11 Dec 2019 11:17:11 -0500
Message-Id: <20191211161713.4490-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
References: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
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

