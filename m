Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580CDB9575
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 18:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392142AbfITQXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 12:23:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52774 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404706AbfITQVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 12:21:11 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iBLeU-00040r-Pe; Fri, 20 Sep 2019 18:20:59 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 701491C0E2B;
        Fri, 20 Sep 2019 18:20:57 +0200 (CEST)
Date:   Fri, 20 Sep 2019 16:20:57 -0000
From:   "tip-bot2 for Srikar Dronamraju" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf stat: Fix a segmentation fault when using
 repeat forever
Cc:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        v4.2+@tip-bot2.tec.linutronix.de, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20190904094738.9558-3-srikar@linux.vnet.ibm.com>
References: <20190904094738.9558-3-srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Message-ID: <156899645738.24167.5948421311795247905.tip-bot2@tip-bot2>
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

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     443f2d5ba13d65ccfd879460f77941875159d154
Gitweb:        https://git.kernel.org/tip/443f2d5ba13d65ccfd879460f77941875159d154
Author:        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate:    Wed, 04 Sep 2019 15:17:38 +05:30
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Fri, 20 Sep 2019 10:28:26 -03:00

perf stat: Fix a segmentation fault when using repeat forever

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
---
 tools/perf/builtin-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index fa4b148..60cdd38 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1956,7 +1956,7 @@ int cmd_stat(int argc, const char **argv)
 			perf_evlist__reset_prev_raw_counts(evsel_list);
 
 		status = run_perf_stat(argc, argv, run_idx);
-		if (forever && status != -1) {
+		if (forever && status != -1 && !interval) {
 			print_counters(NULL, argc, argv);
 			perf_stat__reset_stats();
 		}
