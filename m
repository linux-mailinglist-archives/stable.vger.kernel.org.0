Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5D512834F
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 21:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfLTUda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 15:33:30 -0500
Received: from mail.efficios.com ([167.114.142.138]:55672 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfLTUd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 15:33:29 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id DC3DA68F2C3;
        Fri, 20 Dec 2019 15:33:27 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id CPvs-XqN2J55; Fri, 20 Dec 2019 15:33:27 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 8158E68F2C0;
        Fri, 20 Dec 2019 15:33:27 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 8158E68F2C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576874007;
        bh=MLuS/W5sZSrwoLRlQgBwaQH1/R/vS60vCofiQLnlPSk=;
        h=From:To:Date:Message-Id;
        b=tPOJqZVLrBaH5LTY6w1DuHdR4nvKrKri63giVIVjGB6uqPAO12be2G1QfC6RtPp7w
         EmE+moleow1aajwnYoqLkuoXV2fdB4QzpHSPrEveoaZJZSffBmPkXh/v9Gk4d33HaJ
         2XNIcZs2OCSH9ylEXn6V9r2EbIJ/YK7wLKENE/DMWW9MVTWZ4mr7PmgKkXpZDTuQro
         BOxufjrG5M0dbTikKfG6twfIug88XLYrBtXqqEjbesEZ+65RvdB3QIh5PrgSQfRMPH
         omhOemKiDL6wZp+rGxyOXqgshvBIbKMtIIUTPiliKMzXCB7YwXgi7Y32Ef+DNBjI32
         rZPf/WwDsUSZA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id rsMdaeLaeLZr; Fri, 20 Dec 2019 15:33:27 -0500 (EST)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 4019968F2BA;
        Fri, 20 Dec 2019 15:33:27 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH for 5.5 2/2 v2] rseq/selftests: Clarify rseq_prepare_unload() helper requirements
Date:   Fri, 20 Dec 2019 15:33:18 -0500
Message-Id: <20191220203318.18739-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191220203318.18739-1-mathieu.desnoyers@efficios.com>
References: <20191220203318.18739-1-mathieu.desnoyers@efficios.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The rseq.h UAPI now documents that the rseq_cs field must be cleared
before reclaiming memory that contains the targeted struct rseq_cs, but
also that the rseq_cs field must be cleared before reclaiming memory of
the code pointed to by the rseq_cs start_ip and post_commit_offset
fields.

While we can expect that use of dlclose(3) will typically unmap
both struct rseq_cs and its associated code at once, nothing would
theoretically prevent a JIT from reclaiming the code without
reclaiming the struct rseq_cs, which would erroneously allow the
kernel to consider new code which is not a rseq critical section
as a rseq critical section following a code reclaim.

Suggested-by: Florian Weimer <fw@deneb.enyo.de>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Florian Weimer <fw@deneb.enyo.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
---
 tools/testing/selftests/rseq/rseq.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
index d40d60e7499e..3f63eb362b92 100644
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -149,11 +149,13 @@ static inline void rseq_clear_rseq_cs(void)
 /*
  * rseq_prepare_unload() should be invoked by each thread executing a rseq
  * critical section at least once between their last critical section and
- * library unload of the library defining the rseq critical section
- * (struct rseq_cs). This also applies to use of rseq in code generated by
- * JIT: rseq_prepare_unload() should be invoked at least once by each
- * thread executing a rseq critical section before reclaim of the memory
- * holding the struct rseq_cs.
+ * library unload of the library defining the rseq critical section (struct
+ * rseq_cs) or the code referred to by the struct rseq_cs start_ip and
+ * post_commit_offset fields. This also applies to use of rseq in code
+ * generated by JIT: rseq_prepare_unload() should be invoked at least once by
+ * each thread executing a rseq critical section before reclaim of the memory
+ * holding the struct rseq_cs or reclaim of the code pointed to by struct
+ * rseq_cs start_ip and post_commit_offset fields.
  */
 static inline void rseq_prepare_unload(void)
 {
-- 
2.17.1

