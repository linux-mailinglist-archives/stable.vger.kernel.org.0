Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61833F1950
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 14:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbhHSMbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 08:31:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8046 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239297AbhHSMbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 08:31:33 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gr3yF1htRzYqV5;
        Thu, 19 Aug 2021 20:30:29 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:30:54 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:30:54 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
CC:     Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Ian Rogers" <irogers@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10.y 3/6] perf record: Fix memory leak in vDSO found using ASAN
Date:   Thu, 19 Aug 2021 20:19:09 +0800
Message-ID: <1629375552-51897-4-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
References: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

commit 41d585411311abf187e5f09042978fe7073a9375 upstream.

I got several memory leak reports from Asan with a simple command.  It
was because VDSO is not released due to the refcount.  Like in
__dsos_addnew_id(), it should put the refcount after adding to the list.

  $ perf record true
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.030 MB perf.data (10 samples) ]

  =================================================================
  ==692599==ERROR: LeakSanitizer: detected memory leaks

  Direct leak of 439 byte(s) in 1 object(s) allocated from:
    #0 0x7fea52341037 in __interceptor_calloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:154
    #1 0x559bce4aa8ee in dso__new_id util/dso.c:1256
    #2 0x559bce59245a in __machine__addnew_vdso util/vdso.c:132
    #3 0x559bce59245a in machine__findnew_vdso util/vdso.c:347
    #4 0x559bce50826c in map__new util/map.c:175
    #5 0x559bce503c92 in machine__process_mmap2_event util/machine.c:1787
    #6 0x559bce512f6b in machines__deliver_event util/session.c:1481
    #7 0x559bce515107 in perf_session__deliver_event util/session.c:1551
    #8 0x559bce51d4d2 in do_flush util/ordered-events.c:244
    #9 0x559bce51d4d2 in __ordered_events__flush util/ordered-events.c:323
    #10 0x559bce519bea in __perf_session__process_events util/session.c:2268
    #11 0x559bce519bea in perf_session__process_events util/session.c:2297
    #12 0x559bce2e7a52 in process_buildids /home/namhyung/project/linux/tools/perf/builtin-record.c:1017
    #13 0x559bce2e7a52 in record__finish_output /home/namhyung/project/linux/tools/perf/builtin-record.c:1234
    #14 0x559bce2ed4f6 in __cmd_record /home/namhyung/project/linux/tools/perf/builtin-record.c:2026
    #15 0x559bce2ed4f6 in cmd_record /home/namhyung/project/linux/tools/perf/builtin-record.c:2858
    #16 0x559bce422db4 in run_builtin /home/namhyung/project/linux/tools/perf/perf.c:313
    #17 0x559bce2acac8 in handle_internal_command /home/namhyung/project/linux/tools/perf/perf.c:365
    #18 0x559bce2acac8 in run_argv /home/namhyung/project/linux/tools/perf/perf.c:409
    #19 0x559bce2acac8 in main /home/namhyung/project/linux/tools/perf/perf.c:539
    #20 0x7fea51e76d09 in __libc_start_main ../csu/libc-start.c:308

  Indirect leak of 32 byte(s) in 1 object(s) allocated from:
    #0 0x7fea52341037 in __interceptor_calloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:154
    #1 0x559bce520907 in nsinfo__copy util/namespaces.c:169
    #2 0x559bce50821b in map__new util/map.c:168
    #3 0x559bce503c92 in machine__process_mmap2_event util/machine.c:1787
    #4 0x559bce512f6b in machines__deliver_event util/session.c:1481
    #5 0x559bce515107 in perf_session__deliver_event util/session.c:1551
    #6 0x559bce51d4d2 in do_flush util/ordered-events.c:244
    #7 0x559bce51d4d2 in __ordered_events__flush util/ordered-events.c:323
    #8 0x559bce519bea in __perf_session__process_events util/session.c:2268
    #9 0x559bce519bea in perf_session__process_events util/session.c:2297
    #10 0x559bce2e7a52 in process_buildids /home/namhyung/project/linux/tools/perf/builtin-record.c:1017
    #11 0x559bce2e7a52 in record__finish_output /home/namhyung/project/linux/tools/perf/builtin-record.c:1234
    #12 0x559bce2ed4f6 in __cmd_record /home/namhyung/project/linux/tools/perf/builtin-record.c:2026
    #13 0x559bce2ed4f6 in cmd_record /home/namhyung/project/linux/tools/perf/builtin-record.c:2858
    #14 0x559bce422db4 in run_builtin /home/namhyung/project/linux/tools/perf/perf.c:313
    #15 0x559bce2acac8 in handle_internal_command /home/namhyung/project/linux/tools/perf/perf.c:365
    #16 0x559bce2acac8 in run_argv /home/namhyung/project/linux/tools/perf/perf.c:409
    #17 0x559bce2acac8 in main /home/namhyung/project/linux/tools/perf/perf.c:539
    #18 0x7fea51e76d09 in __libc_start_main ../csu/libc-start.c:308

  SUMMARY: AddressSanitizer: 471 byte(s) leaked in 2 allocation(s).

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210315045641.700430-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 tools/perf/util/vdso.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 3cc91ad..43beb16 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -133,6 +133,8 @@ static struct dso *__machine__addnew_vdso(struct machine *machine, const char *s
 	if (dso != NULL) {
 		__dsos__add(&machine->dsos, dso);
 		dso__set_long_name(dso, long_name, false);
+		/* Put dso here because __dsos_add already got it */
+		dso__put(dso);
 	}
 
 	return dso;
-- 
1.7.12.4

