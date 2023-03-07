Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F576AEF76
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbjCGSXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbjCGSX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E24591B54
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:18:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72C82CE1C82
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E616C433EF;
        Tue,  7 Mar 2023 18:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213100;
        bh=mt32santaK6ITPXQHPGV+Er/rBAXLkBAtun49oCb5sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOzfgIPCOD+pGByb89kJ37xsPP8F/Hd7coxSu3bc1Ul/cYpnIg7zaBq092xXAA05o
         mo0pPQeDCplJVTTPTt4v6lSQIlIKHoy6yUJgGYFkBzqoTeCFrI3nHynSG2y/2160J/
         1ekbsKY9v+mgdSTiM6qb4ZZcIhyIHv9dGHIwyoqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Jihong <yangjihong1@huawei.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 398/885] perf record: Fix segfault with --overwrite and --max-size
Date:   Tue,  7 Mar 2023 17:55:32 +0100
Message-Id: <20230307170019.695077871@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 91621be65d6812cd74b2ea09573ff9ee0cbf5666 ]

When --overwrite and --max-size options of perf record are used
together, a segmentation fault occurs. The following is an example:

  # perf record -e sched:sched* --overwrite --max-size 1K -a -- sleep 1
  [ perf record: Woken up 1 times to write data ]
  perf: Segmentation fault
  Obtained 12 stack frames.
  ./perf/perf(+0x197673) [0x55f99710b673]
  /lib/x86_64-linux-gnu/libc.so.6(+0x3ef0f) [0x7fa45f3cff0f]
  ./perf/perf(+0x8eb40) [0x55f997002b40]
  ./perf/perf(+0x1f6882) [0x55f99716a882]
  ./perf/perf(+0x794c2) [0x55f996fed4c2]
  ./perf/perf(+0x7b7c7) [0x55f996fef7c7]
  ./perf/perf(+0x9074b) [0x55f99700474b]
  ./perf/perf(+0x12e23c) [0x55f9970a223c]
  ./perf/perf(+0x12e54a) [0x55f9970a254a]
  ./perf/perf(+0x7db60) [0x55f996ff1b60]
  /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xe6) [0x7fa45f3b2c86]
  ./perf/perf(+0x7dfe9) [0x55f996ff1fe9]
  Segmentation fault (core dumped)

backtrace of the core file is as follows:

  (gdb) bt
  #0  record__bytes_written (rec=0x55f99755a200 <record>) at builtin-record.c:234
  #1  record__output_max_size_exceeded (rec=0x55f99755a200 <record>) at builtin-record.c:242
  #2  record__write (map=0x0, size=12816, bf=0x55f9978da2e0, rec=0x55f99755a200 <record>) at builtin-record.c:263
  #3  process_synthesized_event (tool=tool@entry=0x55f99755a200 <record>, event=event@entry=0x55f9978da2e0, sample=sample@entry=0x0, machine=machine@entry=0x55f997893658) at builtin-record.c:618
  #4  0x000055f99716a883 in __perf_event__synthesize_id_index (tool=tool@entry=0x55f99755a200 <record>, process=process@entry=0x55f997002aa0 <process_synthesized_event>, evlist=0x55f9978928b0, machine=machine@entry=0x55f997893658,
      from=from@entry=0) at util/synthetic-events.c:1895
  #5  0x000055f99716a91f in perf_event__synthesize_id_index (tool=tool@entry=0x55f99755a200 <record>, process=process@entry=0x55f997002aa0 <process_synthesized_event>, evlist=<optimized out>, machine=machine@entry=0x55f997893658)
      at util/synthetic-events.c:1905
  #6  0x000055f996fed4c3 in record__synthesize (tail=tail@entry=true, rec=0x55f99755a200 <record>) at builtin-record.c:1997
  #7  0x000055f996fef7c8 in __cmd_record (argc=argc@entry=2, argv=argv@entry=0x7ffc67551260, rec=0x55f99755a200 <record>) at builtin-record.c:2802
  #8  0x000055f99700474c in cmd_record (argc=<optimized out>, argv=0x7ffc67551260) at builtin-record.c:4258
  #9  0x000055f9970a223d in run_builtin (p=0x55f997564d88 <commands+264>, argc=10, argv=0x7ffc67551260) at perf.c:330
  #10 0x000055f9970a254b in handle_internal_command (argc=10, argv=0x7ffc67551260) at perf.c:384
  #11 0x000055f996ff1b61 in run_argv (argcp=<synthetic pointer>, argv=<synthetic pointer>) at perf.c:428
  #12 main (argc=<optimized out>, argv=0x7ffc67551260) at perf.c:562

The reason is that record__bytes_written accesses the freed memory rec->thread_data,
The process is as follows:
  __cmd_record
    -> record__free_thread_data
      -> zfree(&rec->thread_data)         // free rec->thread_data
    -> record__synthesize
      -> perf_event__synthesize_id_index
        -> process_synthesized_event
          -> record__write
            -> record__bytes_written      // access rec->thread_data

We add a member variable "thread_bytes_written" in the struct "record"
to save the data size written by the threads.

Fixes: 6d57581659f72299 ("perf record: Add support for limit perf output file size")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jiwei Sun <jiwei.sun@windriver.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/CAM9d7ci_TRrqBQVQNW8=GwakUr7SsZpYxaaty-S4bxF8zJWyqw@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 59f3d98a0196d..48c3461b496c4 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -154,6 +154,7 @@ struct record {
 	struct perf_tool	tool;
 	struct record_opts	opts;
 	u64			bytes_written;
+	u64			thread_bytes_written;
 	struct perf_data	data;
 	struct auxtrace_record	*itr;
 	struct evlist	*evlist;
@@ -226,14 +227,7 @@ static bool switch_output_time(struct record *rec)
 
 static u64 record__bytes_written(struct record *rec)
 {
-	int t;
-	u64 bytes_written = rec->bytes_written;
-	struct record_thread *thread_data = rec->thread_data;
-
-	for (t = 0; t < rec->nr_threads; t++)
-		bytes_written += thread_data[t].bytes_written;
-
-	return bytes_written;
+	return rec->bytes_written + rec->thread_bytes_written;
 }
 
 static bool record__output_max_size_exceeded(struct record *rec)
@@ -255,10 +249,12 @@ static int record__write(struct record *rec, struct mmap *map __maybe_unused,
 		return -1;
 	}
 
-	if (map && map->file)
+	if (map && map->file) {
 		thread->bytes_written += size;
-	else
+		rec->thread_bytes_written += size;
+	} else {
 		rec->bytes_written += size;
+	}
 
 	if (record__output_max_size_exceeded(rec) && !done) {
 		fprintf(stderr, "[ perf record: perf size limit reached (%" PRIu64 " KB),"
-- 
2.39.2



