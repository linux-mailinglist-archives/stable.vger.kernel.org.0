Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BF71215CE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbfLPSSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:18:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731858AbfLPSSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:18:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE427207FF;
        Mon, 16 Dec 2019 18:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520332;
        bh=wwlmxGK47+3NKt/tCyF1WitVXEn7YD87pa8sUS9EE8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=actTZaSAtAlkWvsRA8QMeGxhX3/mtNZybOInMhK/8cs2ZndyYb2yXFz31+Londt/n
         xRf8CO7qIiE832uiHTI9FOTzSXcQLGBL0PQiuVimDTjsF/lHgtYyNpGqvm0+++p2wA
         29+LJQHRSeZ2XVNy0pfuXhPlCO0I/LJtu9B0c0mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 111/177] perf tests: Fix out of bounds memory access
Date:   Mon, 16 Dec 2019 18:49:27 +0100
Message-Id: <20191216174842.136673983@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

commit af8490eb2b33684e26a0a927a9d93ae43cd08890 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/tests/backward-ring-buffer.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/perf/tests/backward-ring-buffer.c
+++ b/tools/perf/tests/backward-ring-buffer.c
@@ -147,6 +147,15 @@ int test__backward_ring_buffer(struct te
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


