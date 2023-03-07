Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2C06AEA85
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjCGRef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjCGReT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07E659E79
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:30:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A337B6150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE6AC433EF;
        Tue,  7 Mar 2023 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210205;
        bh=zaWjMsi5uzuAx0ISdRQ1V4Jreir8Pb2KUfD1F6bE/AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMkTu+FpD0eMOk1ONYq++k7WtyYEPoNOkto44Sgf3JTAwOiVjLW6C7uPj7nAY0PV4
         8zT5Iq0NSu7+lI2tYWduc6dPG5oNSqZMxZHSxGncFtHtRD2h8k5PM2zHGFmB6yCvrI
         aCA9quCXJVhpEgeLnCAAofbUP/C1F1ZI0lDWAh3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        James Clark <james.clark@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Leo Yan <leo.yan@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0467/1001] perf intel-pt: Do not try to queue auxtrace data on pipe
Date:   Tue,  7 Mar 2023 17:53:59 +0100
Message-Id: <20230307170041.656893861@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit aeb802f872a7c42e4381f36041e77d1745908255 ]

When it processes AUXTRACE_INFO, it calls to auxtrace_queue_data() to
collect AUXTRACE data first.  That won't work with pipe since it needs
lseek() to read the scattered aux data.

  $ perf record -o- -e intel_pt// true | perf report -i- --itrace=i100
  # To display the perf.data header info, please use --header/--header-only options.
  #
  0x4118 [0xa0]: failed to process type: 70
  Error:
  failed to process sample

For the pipe mode, it can handle the aux data as it gets.  But there's
no guarantee it can get the aux data in time.  So the following warning
will be shown at the beginning:

  WARNING: Intel PT with pipe mode is not recommended.
           The output cannot relied upon.  In particular,
           time stamps and the order of events may be incorrect.

Fixes: dbd134322e74f19d ("perf intel-pt: Add support for decoding AUX area samples")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20230131023350.1903992-3-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-intel-pt.txt | 30 ++++++++++++++++++++++
 tools/perf/util/auxtrace.c                 |  3 +++
 tools/perf/util/intel-pt.c                 |  6 +++++
 3 files changed, 39 insertions(+)

diff --git a/tools/perf/Documentation/perf-intel-pt.txt b/tools/perf/Documentation/perf-intel-pt.txt
index 7b6ccd2fa3bf1..9d485a9cdb198 100644
--- a/tools/perf/Documentation/perf-intel-pt.txt
+++ b/tools/perf/Documentation/perf-intel-pt.txt
@@ -1821,6 +1821,36 @@ Can be compiled and traced:
  $
 
 
+Pipe mode
+---------
+Pipe mode is a problem for Intel PT and possibly other auxtrace users.
+It's not recommended to use a pipe as data output with Intel PT because
+of the following reason.
+
+Essentially the auxtrace buffers do not behave like the regular perf
+event buffers.  That is because the head and tail are updated by
+software, but in the auxtrace case the data is written by hardware.
+So the head and tail do not get updated as data is written.
+
+In the Intel PT case, the head and tail are updated only when the trace
+is disabled by software, for example:
+    - full-trace, system wide : when buffer passes watermark
+    - full-trace, not system-wide : when buffer passes watermark or
+                                    context switches
+    - snapshot mode : as above but also when a snapshot is made
+    - sample mode : as above but also when a sample is made
+
+That means finished-round ordering doesn't work.  An auxtrace buffer
+can turn up that has data that extends back in time, possibly to the
+very beginning of tracing.
+
+For a perf.data file, that problem is solved by going through the trace
+and queuing up the auxtrace buffers in advance.
+
+For pipe mode, the order of events and timestamps can presumably
+be messed up.
+
+
 EXAMPLE
 -------
 
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index c2e323cd7d496..d4b04fa07a119 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -1133,6 +1133,9 @@ int auxtrace_queue_data(struct perf_session *session, bool samples, bool events)
 	if (auxtrace__dont_decode(session))
 		return 0;
 
+	if (perf_data__is_pipe(session->data))
+		return 0;
+
 	if (!session->auxtrace || !session->auxtrace->queue_data)
 		return -EINVAL;
 
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 6d3921627e332..b8b29756fbf13 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -4379,6 +4379,12 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
 
 	intel_pt_setup_pebs_events(pt);
 
+	if (perf_data__is_pipe(session->data)) {
+		pr_warning("WARNING: Intel PT with pipe mode is not recommended.\n"
+			   "         The output cannot relied upon.  In particular,\n"
+			   "         timestamps and the order of events may be incorrect.\n");
+	}
+
 	if (pt->sampling_mode || list_empty(&session->auxtrace_index))
 		err = auxtrace_queue_data(session, true, true);
 	else
-- 
2.39.2



