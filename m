Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5216C133435
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgAGVYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:24:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728382AbgAGVAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:00:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D4392081E;
        Tue,  7 Jan 2020 21:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430834;
        bh=QsJ20k1VVZJ10/BTHoJeI+2CvvnJtI6kiGbeTCKQi6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQqo3uhZqEpIU5Ghsa9IZJvOQE33sWl0kuqDYE09bnS1Eb2SJqJogKvEOyogmd6+N
         seqwCMJgrykXV7ihmOUjaQ6r8LPWIvJKIAmzBHjzV7iW/SsJDQjlhSbhJd1V+MSnMx
         KzFydMWo+SH7z71vCOTwKQTBde/CIFoLoIRYlCJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Tommi T. Rantala" <tommi.t.rantala@nokia.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH 5.4 114/191] rseq/selftests: Fix: Namespace gettid() for compatibility with glibc 2.30
Date:   Tue,  7 Jan 2020 21:53:54 +0100
Message-Id: <20200107205339.083839626@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 8df34c56321479bfa1ec732c675b686c2b4df412 upstream.

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
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/rseq/param_test.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

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
@@ -373,11 +373,12 @@ void *test_percpu_spinlock_thread(void *
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
 
@@ -796,7 +798,7 @@ void *test_percpu_buffer_thread(void *ar
 	}
 
 	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
-		       (int) gettid(), nr_abort, signals_delivered);
+		       (int) rseq_gettid(), nr_abort, signals_delivered);
 	if (!opt_disable_rseq && rseq_unregister_current_thread())
 		abort();
 
@@ -1011,7 +1013,7 @@ void *test_percpu_memcpy_buffer_thread(v
 	}
 
 	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
-		       (int) gettid(), nr_abort, signals_delivered);
+		       (int) rseq_gettid(), nr_abort, signals_delivered);
 	if (!opt_disable_rseq && rseq_unregister_current_thread())
 		abort();
 


