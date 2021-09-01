Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643783FDB89
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344955AbhIAMmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344949AbhIAMkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76F1261102;
        Wed,  1 Sep 2021 12:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499779;
        bh=4k0lG/mTsGiHgZERnpLcm+PUut0x4b3bA3ZX7OD0HGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAhbjx44C2Qx29o430lUnMTFkRNOXihEgX6DyGxdKYJxgxxpBgsF2/Aycq4zml8Gd
         pufTNUH+s7uVfktnk3RHaYbu5a7manpOl7BzUOf08f+UPXQ7Rub9psGDrJcMLtfcFC
         ckDKSxqNHOBdmNDrsqTlhdwOz3l5G4QGDAUN4mLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 082/103] perf record: Fix memory leak in vDSO found using ASAN
Date:   Wed,  1 Sep 2021 14:28:32 +0200
Message-Id: <20210901122303.306492241@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/vdso.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -133,6 +133,8 @@ static struct dso *__machine__addnew_vds
 	if (dso != NULL) {
 		__dsos__add(&machine->dsos, dso);
 		dso__set_long_name(dso, long_name, false);
+		/* Put dso here because __dsos_add already got it */
+		dso__put(dso);
 	}
 
 	return dso;


