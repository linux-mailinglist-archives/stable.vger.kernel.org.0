Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C6212834B
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 21:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfLTUd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 15:33:28 -0500
Received: from mail.efficios.com ([167.114.142.138]:55634 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfLTUd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 15:33:28 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 0EEF768F2B5;
        Fri, 20 Dec 2019 15:33:27 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id ega1qVusbkSK; Fri, 20 Dec 2019 15:33:26 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id AAF4568F2B2;
        Fri, 20 Dec 2019 15:33:26 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com AAF4568F2B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576874006;
        bh=rhxSrAmuooP5b3DU5MSM/F/3eJvosKC02/r/pl+fytU=;
        h=From:To:Date:Message-Id;
        b=qF3cOpOBd3CVHgaKY2y0M5uuIZOdhk89csCHCLHFbzbZqXcl9hV/KevQJ8ujwTwk6
         RqRiWC0IxskoKK3m75ibyEFtkQDoCCwJNgxVffFqqUueAHDh7wHPL6YrFzTgy9IYY1
         ieWwaeq9u/+Au55lihQ9Lfs6ximp3/yvDtYKnr6+dXXnJdDnJpUqHX0zg0bS5SlmVW
         XYsnau5xZ1G+Q572Wh/07tH+UW3PEde3vCxBScDtvjo9d9ZEPeQfdyTNCAxQVZmkPO
         k+o7pBYGxgsqMob60rBQXqDUYOp7DZi1DkqOZE+WIc/AL7sdqQOGsWURyoBXSp5SVO
         2eYE6V2z48bsw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id m1AYT8eCdXEF; Fri, 20 Dec 2019 15:33:26 -0500 (EST)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 5F6C368F2AC;
        Fri, 20 Dec 2019 15:33:26 -0500 (EST)
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
Subject: [PATCH for 5.5 1/2 v2] rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
Date:   Fri, 20 Dec 2019 15:33:17 -0500
Message-Id: <20191220203318.18739-1-mathieu.desnoyers@efficios.com>
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
index 9a402fdb60e9..d94afdfc4b7c 100644
--- a/include/uapi/linux/rseq.h
+++ b/include/uapi/linux/rseq.h
@@ -100,7 +100,9 @@ struct rseq {
 	 * instruction sequence block, as well as when the kernel detects that
 	 * it is preempting or delivering a signal outside of the range
 	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
-	 * before reclaiming memory that contains the targeted struct rseq_cs.
+	 * before reclaiming memory that contains the targeted struct rseq_cs
+	 * or reclaiming memory that contains the code referred to by the
+	 * start_ip and post_commit_offset fields of struct rseq_cs.
 	 *
 	 * Read and set by the kernel. Set by user-space with single-copy
 	 * atomicity semantics. This field should only be updated by the
-- 
2.17.1

