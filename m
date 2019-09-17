Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C248DB554C
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbfIQSaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 14:30:15 -0400
Received: from mail.efficios.com ([167.114.142.138]:37512 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbfIQSaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 14:30:12 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 6E67B1D4E13;
        Tue, 17 Sep 2019 14:30:11 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id cC-ngBrkweCl; Tue, 17 Sep 2019 14:30:11 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 0AE0B1D4E0F;
        Tue, 17 Sep 2019 14:30:11 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 0AE0B1D4E0F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1568745011;
        bh=bsQbUCGG+66P6uaoaenq7Ys0bJ2R9XxktPLL9tZTcj4=;
        h=From:To:Date:Message-Id;
        b=kOocle93YMUW6RJIUFX50Gb33i9DsLfrZo0YA2TKHKcmS2wpAn0NzVmvMa5mMVCTQ
         5CxU5jGnn8XQjRYqCqPebd7UdVvxLrbF0SonvnePRwi7E9IAaMwECq0pF8ZpONqOhh
         /48LVnj8LeG8gaNOBicOdf9Gg/RFcHnTDPtwRG110e3vF+YwEsDS7RwFuUarrIGplY
         MaihncqTqKSPWsjCsks/57+wrGntUZsYXQT2BH4FgMeU5tCYpGrEHAJ0Ku7mNkK7KL
         bHIZ/8D+punyNkHbc83c0cMNmntY3biax/YDAzAU1zF7BJIl/vwPqXgskKWXxK6IwB
         DF1mv0scILPMQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 3720i6ynFqVc; Tue, 17 Sep 2019 14:30:10 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 80ED11D4DE6;
        Tue, 17 Sep 2019 14:30:10 -0400 (EDT)
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
Subject: [PATCH for 5.4 3/3] rseq/selftests: Fix: Namespace gettid() for compatibility with glibc 2.30
Date:   Tue, 17 Sep 2019 14:29:59 -0400
Message-Id: <20190917182959.16333-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
References: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
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

