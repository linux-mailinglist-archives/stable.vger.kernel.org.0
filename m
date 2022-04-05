Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795204F38B4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377113AbiDEL11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349560AbiDEJuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066A19B;
        Tue,  5 Apr 2022 02:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A05615E5;
        Tue,  5 Apr 2022 09:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D80BC385A1;
        Tue,  5 Apr 2022 09:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152098;
        bh=do+8eEDPBQpwYEPcf4XkVabUT7HYYAJoLGuwgo0KY/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGgJk6FIfNO9v6hJv0/RWLdpZSrtPQCRTPREGRmIAMmMDq8GbCJffD6gbn0B0N1zi
         zjWUq/PcTWRZvcvIJKrxP8uG1EioGQrf3C/FK/a2z5+gz5GVuY9aWmTMwC8L1IZ6Yu
         B75yHycSIsNOfCsc2+y2HtdbS6mvLr5xaAOYm02g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 653/913] perf stat: Fix forked applications enablement of counters
Date:   Tue,  5 Apr 2022 09:28:35 +0200
Message-Id: <20220405070359.412755534@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit d0a0a511493d269514fcbd852481cdca32c95350 ]

I have run into the following issue:

 # perf stat -a -e new_pmu/INSTRUCTION_7/ --  mytest -c1 7

 Performance counter stats for 'system wide':

                 0      new_pmu/INSTRUCTION_7/

       0.000366428 seconds time elapsed
 #

The new PMU for s390 counts the execution of certain CPU instructions.
The root cause is the extremely small run time of the mytest program. It
just executes some assembly instructions and then exits.

In above invocation the instruction is executed exactly one time (-c1
option). The PMU is expected to report this one time execution by a
counter value of one, but fails to do so in some cases, not all.

Debugging reveals the invocation of the child process is done
*before* the counter events are installed and enabled.

Tracing reveals that sometimes the child process starts and exits before
the event is installed on all CPUs. The more CPUs the machine has, the
more often this miscount happens.

Fix this by reversing the start of the work load after the events have
been installed on the specified CPUs. Now the comment also matches the
code.

Output after:

 # perf stat -a -e new_pmu/INSTRUCTION_7/ --  mytest -c1 7

 Performance counter stats for 'system wide':

                 1      new_pmu/INSTRUCTION_7/

       0.000366428 seconds time elapsed
 #

Now the correct result is reported rock solid all the time regardless
how many CPUs are online.

Reviewers notes:

Jiri:

Right, without -a the event has enable_on_exec so the race does not
matter, but it's a problem for system wide with fork.

Namhyung:

Agreed. Also we may move the enable_counters() and the clock code out of
the if block to be shared with the else block.

Fixes: acf2892270dcc428 ("perf stat: Use perf_evlist__prepare/start_workload()")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20220317155346.577384-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f0ecfda34ece..1a194edb5452 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -956,10 +956,10 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	 * Enable counters and exec the command:
 	 */
 	if (forks) {
-		evlist__start_workload(evsel_list);
 		err = enable_counters();
 		if (err)
 			return -1;
+		evlist__start_workload(evsel_list);
 
 		t0 = rdclock();
 		clock_gettime(CLOCK_MONOTONIC, &ref_time);
-- 
2.34.1



