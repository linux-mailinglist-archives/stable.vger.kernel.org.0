Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A40B66488E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbjAJSMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238829AbjAJSL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:11:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCB9B56;
        Tue, 10 Jan 2023 10:10:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB5556182C;
        Tue, 10 Jan 2023 18:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2930C433D2;
        Tue, 10 Jan 2023 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374230;
        bh=9NdXOmkiTVBp0bp3bFhoadq9j659g/3HfDuElJpJhKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvlFK+1x92rmHO2nxfUAJvbotJePTGcpR1jm7m28GZrpBvCjGjOdXBM4LhEfAt0nN
         9ErglWA15vvDaIrvDcBHvTh4bgopmOTG1NxGj241WlGxDUFtmf0xBMD590fQ0XVGws
         7NRfbVtkfrJJ1G0zse+ng1W24KYlvRjn0RfNuTmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, bpf@vger.kernel.org,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 094/148] perf stat: Fix handling of --for-each-cgroup with --bpf-counters to match non BPF mode
Date:   Tue, 10 Jan 2023 19:03:18 +0100
Message-Id: <20230110180020.176795133@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 54b353a20c7e8be98414754f5aff98c8a68fcc1f ]

The --for-each-cgroup can have the same cgroup multiple times, but this
confuses BPF counters (since they have the same cgroup id), making only
the last cgroup events to be counted.

Let's check the cgroup name before adding a new entry to the cgroups
list.

Before:

  $ sudo ./perf stat -a --bpf-counters --for-each-cgroup /,/ sleep 1

   Performance counter stats for 'system wide':

       <not counted> msec cpu-clock                        /
       <not counted>      context-switches                 /
       <not counted>      cpu-migrations                   /
       <not counted>      page-faults                      /
       <not counted>      cycles                           /
       <not counted>      instructions                     /
       <not counted>      branches                         /
       <not counted>      branch-misses                    /
            8,016.04 msec cpu-clock                        /                #    7.998 CPUs utilized
               6,152      context-switches                 /                #  767.461 /sec
                 250      cpu-migrations                   /                #   31.187 /sec
                 442      page-faults                      /                #   55.139 /sec
         613,111,487      cycles                           /                #    0.076 GHz
         280,599,604      instructions                     /                #    0.46  insn per cycle
          57,692,724      branches                         /                #    7.197 M/sec
           3,385,168      branch-misses                    /                #    5.87% of all branches

         1.002220125 seconds time elapsed

After it becomes similar to the non-BPF mode:

  $ sudo ./perf stat -a --bpf-counters --for-each-cgroup /,/  sleep 1

   Performance counter stats for 'system wide':

            8,013.38 msec cpu-clock                        /                #    7.998 CPUs utilized
               6,859      context-switches                 /                #  855.944 /sec
                 334      cpu-migrations                   /                #   41.680 /sec
                 345      page-faults                      /                #   43.053 /sec
         782,326,119      cycles                           /                #    0.098 GHz
         471,645,724      instructions                     /                #    0.60  insn per cycle
          94,963,430      branches                         /                #   11.851 M/sec
           3,685,511      branch-misses                    /                #    3.88% of all branches

         1.001864539 seconds time elapsed

Committer notes:

As a reminder, to test with BPF counters one has to use BUILD_BPF_SKEL=1
in the make command line and have clang/llvm installed when building
perf, otherwise the --bpf-counters option will not be available:

  # perf stat -a --bpf-counters --for-each-cgroup /,/ sleep 1
  Error: unknown option `bpf-counters'

   Usage: perf stat [<options>] [<command>]

      -a, --all-cpus        system-wide collection from all CPUs
  <SNIP>
  #

Fixes: bb1c15b60b981d10 ("perf stat: Support regex pattern in --for-each-cgroup")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: bpf@vger.kernel.org
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/r/20230104064402.1551516-5-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cgroup.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index e99b41f9be45..cd978c240e0d 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -224,6 +224,19 @@ static int add_cgroup_name(const char *fpath, const struct stat *sb __maybe_unus
 	return 0;
 }
 
+static int check_and_add_cgroup_name(const char *fpath)
+{
+	struct cgroup_name *cn;
+
+	list_for_each_entry(cn, &cgroup_list, list) {
+		if (!strcmp(cn->name, fpath))
+			return 0;
+	}
+
+	/* pretend if it's added by ftw() */
+	return add_cgroup_name(fpath, NULL, FTW_D, NULL);
+}
+
 static void release_cgroup_list(void)
 {
 	struct cgroup_name *cn;
@@ -242,7 +255,7 @@ static int list_cgroups(const char *str)
 	struct cgroup_name *cn;
 	char *s;
 
-	/* use given name as is - for testing purpose */
+	/* use given name as is when no regex is given */
 	for (;;) {
 		p = strchr(str, ',');
 		e = p ? p : eos;
@@ -253,13 +266,13 @@ static int list_cgroups(const char *str)
 			s = strndup(str, e - str);
 			if (!s)
 				return -1;
-			/* pretend if it's added by ftw() */
-			ret = add_cgroup_name(s, NULL, FTW_D, NULL);
+
+			ret = check_and_add_cgroup_name(s);
 			free(s);
-			if (ret)
+			if (ret < 0)
 				return -1;
 		} else {
-			if (add_cgroup_name("", NULL, FTW_D, NULL) < 0)
+			if (check_and_add_cgroup_name("/") < 0)
 				return -1;
 		}
 
-- 
2.35.1



