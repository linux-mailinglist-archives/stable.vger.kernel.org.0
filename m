Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5ACB2318
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 17:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391251AbfIMPM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 11:12:28 -0400
Received: from mail.efficios.com ([167.114.142.138]:52528 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390046AbfIMPM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 11:12:26 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 9C5082D10E3;
        Fri, 13 Sep 2019 11:12:25 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id unlKTUZBJcRb; Fri, 13 Sep 2019 11:12:25 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 283182D10D5;
        Fri, 13 Sep 2019 11:12:25 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 283182D10D5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1568387545;
        bh=R1uDxu6JmVZWnms7KmM5Xfbr4EQZKJSQmPO+FxTpCrc=;
        h=From:To:Date:Message-Id;
        b=Cqml94Fnn+DiJJkXrZrr+dt/ptb9d8LFJYu8rP7KDWAH8dLgD8Tg+g01WaphG3edq
         RiqdMk9Z39ImLFa7udkrrp1mTXW6BuzTats1k8cH3pyiqu1V2ZsAU6+Ljdup7C30nY
         Ho1qbsT7IIze6/+DJRfn+R3QqvagxIND35jdmhEJFrPywZDBwY4ioA3coo0lpzs3NE
         rKK7NL77yOtBNK0edD+s5sN40wFnFAfk3I4+Iuq89LHoQ3ao5ZKQU0Pk5JIIZkx0Eh
         6UMVks9uzC+dQelmhF1393rKRlgDHjLN/CpXV6wcwiUewZU8xkcbo+2t2r6m8oVIEZ
         f2WitdF0FszZw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id E8HsZamj1xfX; Fri, 13 Sep 2019 11:12:25 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id CD1B12D10C6;
        Fri, 13 Sep 2019 11:12:24 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        "Tommi T . Rantala" <tommi.t.rantala@nokia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, stable@vger.kernel.org
Subject: [PATCH for 5.3 3/3] rseq/selftests: Fix: Namespace gettid() for compatibility with glibc 2.30
Date:   Fri, 13 Sep 2019 11:12:20 -0400
Message-Id: <20190913151220.3105-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190913151220.3105-1-mathieu.desnoyers@efficios.com>
References: <20190913151220.3105-1-mathieu.desnoyers@efficios.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

glibc 2.30 introduces gettid() in public headers, which clashes with
the internal static definition within rseq selftests.

Rename gettid() to rseq_gettid() to eliminate this symbol name clash.

Reported-by: Tommi T. Rantala <tommi.t.rantala@nokia.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Tommi T. Rantala <tommi.t.rantala@nokia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
---
 tools/testing/selftests/rseq/param_test.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/rseq/param_test.c b/tools/testing/selftests/rseq/param_test.c
index eec2663261f2..e8a657a5f48a 100644
--- a/tools/testing/selftests/rseq/param_test.c
+++ b/tools/testing/selftests/rseq/param_test.c
@@ -15,7 +15,7 @@
 #include <errno.h>
 #include <stddef.h>
 
-static inline pid_t gettid(void)
+static inline pid_t rseq_gettid(void)
 {
 	return syscall(__NR_gettid);
 }
@@ -373,11 +373,12 @@ void *test_percpu_spinlock_thread(void *arg)
 		rseq_percpu_unlock(&data->lock, cpu);
 #ifndef BENCHMARK
 		if (i != 0 && !(i % (reps / 10)))
-			printf_verbose("tid %d: count %lld\n", (int) gettid(), i);
+			printf_verbose("tid %d: count %lld\n",
+				       (int) rseq_gettid(), i);
 #endif
 	}
 	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
-		       (int) gettid(), nr_abort, signals_delivered);
+		       (int) rseq_gettid(), nr_abort, signals_delivered);
 	if (!opt_disable_rseq && thread_data->reg &&
 	    rseq_unregister_current_thread())
 		abort();
@@ -454,11 +455,12 @@ void *test_percpu_inc_thread(void *arg)
 		} while (rseq_unlikely(ret));
 #ifndef BENCHMARK
 		if (i != 0 && !(i % (reps / 10)))
-			printf_verbose("tid %d: count %lld\n", (int) gettid(), i);
+			printf_verbose("tid %d: count %lld\n",
+				       (int) rseq_gettid(), i);
 #endif
 	}
 	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
-		       (int) gettid(), nr_abort, signals_delivered);
+		       (int) rseq_gettid(), nr_abort, signals_delivered);
 	if (!opt_disable_rseq && thread_data->reg &&
 	    rseq_unregister_current_thread())
 		abort();
@@ -605,7 +607,7 @@ void *test_percpu_list_thread(void *arg)
 	}
 
 	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
-		       (int) gettid(), nr_abort, signals_delivered);
+		       (int) rseq_gettid(), nr_abort, signals_delivered);
 	if (!opt_disable_rseq && rseq_unregister_current_thread())
 		abort();
 
@@ -796,7 +798,7 @@ void *test_percpu_buffer_thread(void *arg)
 	}
 
 	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
-		       (int) gettid(), nr_abort, signals_delivered);
+		       (int) rseq_gettid(), nr_abort, signals_delivered);
 	if (!opt_disable_rseq && rseq_unregister_current_thread())
 		abort();
 
@@ -1011,7 +1013,7 @@ void *test_percpu_memcpy_buffer_thread(void *arg)
 	}
 
 	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
-		       (int) gettid(), nr_abort, signals_delivered);
+		       (int) rseq_gettid(), nr_abort, signals_delivered);
 	if (!opt_disable_rseq && rseq_unregister_current_thread())
 		abort();
 
-- 
2.17.1

