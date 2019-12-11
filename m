Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF34411B85F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbfLKQRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:17:32 -0500
Received: from mail.efficios.com ([167.114.142.138]:44036 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730073AbfLKQRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 11:17:24 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 9E6A3686C41;
        Wed, 11 Dec 2019 11:17:23 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 2bjAHApc-Uqd; Wed, 11 Dec 2019 11:17:23 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 40298686C30;
        Wed, 11 Dec 2019 11:17:23 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 40298686C30
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576081043;
        bh=bsQbUCGG+66P6uaoaenq7Ys0bJ2R9XxktPLL9tZTcj4=;
        h=From:To:Date:Message-Id;
        b=YJrhYIzUuwONWXl9gxsvv1xdQuKpFN8C9GV+kndyWH67DF1NbVHYimuCULM7IlZRU
         ERVWUZB6kbiYdUPDrl932hP2yUI3NHy9bnXB2x+J0EZ/mQ8wi1z+sCV2Agd74yfMRj
         PxDDBEnybDHilji3u5NLJ2dSJlmYT/ixbw95ADsB+Hi5eflYc2Xh0XElLGj7OA1gu8
         1h6G15beOdn1znR57Vx/SBXcnj03HRxXeE03vIKPog+M3KI/T/DYnCh3NRc8qJcMyI
         pe3cxqbchHIS8Fw50mcojWKVxwRSAhuXUfBPwG5kWBSogJwqTrXZky/JBIoLKYsgJS
         6YcYJ176CP46w==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id oAEOHck51DEN; Wed, 11 Dec 2019 11:17:23 -0500 (EST)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id DD262686C12;
        Wed, 11 Dec 2019 11:17:22 -0500 (EST)
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
        "Tommi T . Rantala" <tommi.t.rantala@nokia.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH for 5.5 3/3] rseq/selftests: Fix: Namespace gettid() for compatibility with glibc 2.30
Date:   Wed, 11 Dec 2019 11:17:13 -0500
Message-Id: <20191211161713.4490-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
References: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
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
Cc: <stable@vger.kernel.org>	# v4.18+
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

