Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E26ED2337
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387467AbfJJIkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387411AbfJJIkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 463FB21D56;
        Thu, 10 Oct 2019 08:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696813;
        bh=2KO0PQV+YfYTOs5nrDmOcGrwFcq5NKyOlH5jzXPiB0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRns0Dxnc64qiJX3bJI0f3mLv0nfeJfYVNC9dwecSiBaBjNulE4blBUjGmZFo7vxf
         iphXXfzAJ2bPxA+E/Qyz1UhhBoFIawG+kE2XZKOUS9olvmWIdHQiQ1+c1K+LkNvndb
         4sM0McFV1UPFs3Y841Gk90eqTxBt3xVsaBKWga7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [PATCH 5.3 061/148] perf stat: Fix a segmentation fault when using repeat forever
Date:   Thu, 10 Oct 2019 10:35:22 +0200
Message-Id: <20191010083614.848736651@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

commit 443f2d5ba13d65ccfd879460f77941875159d154 upstream.

Observe a segmentation fault when 'perf stat' is asked to repeat forever
with the interval option.

Without fix:

  # perf stat -r 0 -I 5000 -e cycles -a sleep 10
  #           time             counts unit events
       5.000211692  3,13,89,82,34,157      cycles
      10.000380119  1,53,98,52,22,294      cycles
      10.040467280       17,16,79,265      cycles
  Segmentation fault

This problem was only observed when we use forever option aka -r 0 and
works with limited repeats. Calling print_counter with ts being set to
NULL, is not a correct option when interval is set. Hence avoid
print_counter(NULL,..)  if interval is set.

With fix:

  # perf stat -r 0 -I 5000 -e cycles -a sleep 10
   #           time             counts unit events
       5.019866622  3,15,14,43,08,697      cycles
      10.039865756  3,15,16,31,95,261      cycles
      10.059950628     1,26,05,47,158      cycles
       5.009902655  3,14,52,62,33,932      cycles
      10.019880228  3,14,52,22,89,154      cycles
      10.030543876       66,90,18,333      cycles
       5.009848281  3,14,51,98,25,437      cycles
      10.029854402  3,15,14,93,04,918      cycles
       5.009834177  3,14,51,95,92,316      cycles

Committer notes:

Did the 'git bisect' to find the cset introducing the problem to add the
Fixes tag below, and at that time the problem reproduced as:

  (gdb) run stat -r0 -I500 sleep 1
  <SNIP>
  Program received signal SIGSEGV, Segmentation fault.
  print_interval (prefix=prefix@entry=0x7fffffffc8d0 "", ts=ts@entry=0x0) at builtin-stat.c:866
  866		sprintf(prefix, "%6lu.%09lu%s", ts->tv_sec, ts->tv_nsec, csv_sep);
  (gdb) bt
  #0  print_interval (prefix=prefix@entry=0x7fffffffc8d0 "", ts=ts@entry=0x0) at builtin-stat.c:866
  #1  0x000000000041860a in print_counters (ts=ts@entry=0x0, argc=argc@entry=2, argv=argv@entry=0x7fffffffd640) at builtin-stat.c:938
  #2  0x0000000000419a7f in cmd_stat (argc=2, argv=0x7fffffffd640, prefix=<optimized out>) at builtin-stat.c:1411
  #3  0x000000000045c65a in run_builtin (p=p@entry=0x6291b8 <commands+216>, argc=argc@entry=5, argv=argv@entry=0x7fffffffd640) at perf.c:370
  #4  0x000000000045c893 in handle_internal_command (argc=5, argv=0x7fffffffd640) at perf.c:429
  #5  0x000000000045c8f1 in run_argv (argcp=argcp@entry=0x7fffffffd4ac, argv=argv@entry=0x7fffffffd4a0) at perf.c:473
  #6  0x000000000045cac9 in main (argc=<optimized out>, argv=<optimized out>) at perf.c:588
  (gdb)

Mostly the same as just before this patch:

  Program received signal SIGSEGV, Segmentation fault.
  0x00000000005874a7 in print_interval (config=0xa1f2a0 <stat_config>, evlist=0xbc9b90, prefix=0x7fffffffd1c0 "`", ts=0x0) at util/stat-display.c:964
  964		sprintf(prefix, "%6lu.%09lu%s", ts->tv_sec, ts->tv_nsec, config->csv_sep);
  (gdb) bt
  #0  0x00000000005874a7 in print_interval (config=0xa1f2a0 <stat_config>, evlist=0xbc9b90, prefix=0x7fffffffd1c0 "`", ts=0x0) at util/stat-display.c:964
  #1  0x0000000000588047 in perf_evlist__print_counters (evlist=0xbc9b90, config=0xa1f2a0 <stat_config>, _target=0xa1f0c0 <target>, ts=0x0, argc=2, argv=0x7fffffffd670)
      at util/stat-display.c:1172
  #2  0x000000000045390f in print_counters (ts=0x0, argc=2, argv=0x7fffffffd670) at builtin-stat.c:656
  #3  0x0000000000456bb5 in cmd_stat (argc=2, argv=0x7fffffffd670) at builtin-stat.c:1960
  #4  0x00000000004dd2e0 in run_builtin (p=0xa30e00 <commands+288>, argc=5, argv=0x7fffffffd670) at perf.c:310
  #5  0x00000000004dd54d in handle_internal_command (argc=5, argv=0x7fffffffd670) at perf.c:362
  #6  0x00000000004dd694 in run_argv (argcp=0x7fffffffd4cc, argv=0x7fffffffd4c0) at perf.c:406
  #7  0x00000000004dda11 in main (argc=5, argv=0x7fffffffd670) at perf.c:531
  (gdb)

Fixes: d4f63a4741a8 ("perf stat: Introduce print_counters function")
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org # v4.2+
Link: http://lore.kernel.org/lkml/20190904094738.9558-3-srikar@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-stat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1962,7 +1962,7 @@ int cmd_stat(int argc, const char **argv
 				run_idx + 1);
 
 		status = run_perf_stat(argc, argv, run_idx);
-		if (forever && status != -1) {
+		if (forever && status != -1 && !interval) {
 			print_counters(NULL, argc, argv);
 			perf_stat__reset_stats();
 		}


