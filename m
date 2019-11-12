Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FDCF8E78
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 12:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfKLLWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 06:22:13 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33538 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbfKLLSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 06:18:06 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iUUBE-0000FX-6A; Tue, 12 Nov 2019 12:17:52 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id D58781C0357;
        Tue, 12 Nov 2019 12:17:51 +0100 (CET)
Date:   Tue, 12 Nov 2019 11:17:51 -0000
From:   "tip-bot2 for Leo Yan" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf tests: Fix out of bounds memory access
Cc:     Leo Yan <leo.yan@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wang Nan <wangnan0@huawei.com>, stable@vger.kernel.org,
        #@tip-bot2.tec.linutronix.de, v4.10+@tip-bot2.tec.linutronix.de,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191107020244.2427-1-leo.yan@linaro.org>
References: <20191107020244.2427-1-leo.yan@linaro.org>
MIME-Version: 1.0
Message-ID: <157355747152.29376.9122205661301300130.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     af8490eb2b33684e26a0a927a9d93ae43cd08890
Gitweb:        https://git.kernel.org/tip/af8490eb2b33684e26a0a927a9d93ae43cd08890
Author:        Leo Yan <leo.yan@linaro.org>
AuthorDate:    Thu, 07 Nov 2019 10:02:44 +08:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Thu, 07 Nov 2019 09:04:22 -03:00

perf tests: Fix out of bounds memory access

The test case 'Read backward ring buffer' failed on 32-bit architectures
which were found by LKFT perf testing.  The test failed on arm32 x15
device, qemu_arm32, qemu_i386, and found intermittent failure on i386;
the failure log is as below:

  50: Read backward ring buffer                  :
  --- start ---
  test child forked, pid 510
  Using CPUID GenuineIntel-6-9E-9
  mmap size 1052672B
  mmap size 8192B
  Finished reading overwrite ring buffer: rewind
  free(): invalid next size (fast)
  test child interrupted
  ---- end ----
  Read backward ring buffer: FAILED!

The log hints there have issue for memory usage, thus free() reports
error 'invalid next size' and directly exit for the case.  Finally, this
issue is root caused as out of bounds memory access for the data array
'evsel->id'.

The backward ring buffer test invokes do_test() twice.  'evsel->id' is
allocated at the first call with the flow:

  test__backward_ring_buffer()
    `-> do_test()
	  `-> evlist__mmap()
	        `-> evlist__mmap_ex()
	              `-> perf_evsel__alloc_id()

So 'evsel->id' is allocated with one item, and it will be used in
function perf_evlist__id_add():

   evsel->id[0] = id
   evsel->ids   = 1

At the second call for do_test(), it skips to initialize 'evsel->id'
and reuses the array which is allocated in the first call.  But
'evsel->ids' contains the stale value.  Thus:

   evsel->id[1] = id    -> out of bound access
   evsel->ids   = 2

To fix this issue, we will use evlist__open() and evlist__close() pair
functions to prepare and cleanup context for evlist; so 'evsel->id' and
'evsel->ids' can be initialized properly when invoke do_test() and avoid
the out of bounds memory access.

Fixes: ee74701ed8ad ("perf tests: Add test to check backward ring buffer")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: stable@vger.kernel.org # v4.10+
Link: http://lore.kernel.org/lkml/20191107020244.2427-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/backward-ring-buffer.c |  9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/tests/backward-ring-buffer.c b/tools/perf/tests/backward-ring-buffer.c
index a4cd30c..15cea51 100644
--- a/tools/perf/tests/backward-ring-buffer.c
+++ b/tools/perf/tests/backward-ring-buffer.c
@@ -148,6 +148,15 @@ int test__backward_ring_buffer(struct test *test __maybe_unused, int subtest __m
 		goto out_delete_evlist;
 	}
 
+	evlist__close(evlist);
+
+	err = evlist__open(evlist);
+	if (err < 0) {
+		pr_debug("perf_evlist__open: %s\n",
+			 str_error_r(errno, sbuf, sizeof(sbuf)));
+		goto out_delete_evlist;
+	}
+
 	err = do_test(evlist, 1, &sample_count, &comm_count);
 	if (err != TEST_OK)
 		goto out_delete_evlist;
