Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0560F6AF450
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbjCGTQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbjCGTPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC986AE106
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:59:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C2EF6150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21471C433EF;
        Tue,  7 Mar 2023 18:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215545;
        bh=v8gaDKv/O8tzNfkrMkI7N4Dq1pSsyG43SgUXoNLKJrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4DHf5pzNh6/cXk7HhpzzG1+CkuHBgHt/B+cMXOq1naCSTaxINYas631eNV5D8vfG
         qbGxV8gfTuU1033VOPOEg2YfiQ5+L4tAM4Co5yiVsZSKiMvtsFgJeN1ArSwLNCHl/O
         aFBH5AUaYtJq/4QeGGa/exciqo01hFe17YMsmTGU=
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
Subject: [PATCH 5.15 265/567] perf intel-pt: Do not try to queue auxtrace data on pipe
Date:   Tue,  7 Mar 2023 18:00:01 +0100
Message-Id: <20230307165917.414559047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index 5415c4993c6b4..de63c418e4d1f 100644
--- a/tools/perf/Documentation/perf-intel-pt.txt
+++ b/tools/perf/Documentation/perf-intel-pt.txt
@@ -1526,6 +1526,36 @@ Can be compiled and traced:
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
index 0ef4cbf21e627..344b65a8f7687 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -1107,6 +1107,9 @@ int auxtrace_queue_data(struct perf_session *session, bool samples, bool events)
 	if (auxtrace__dont_decode(session))
 		return 0;
 
+	if (perf_data__is_pipe(session->data))
+		return 0;
+
 	if (!session->auxtrace || !session->auxtrace->queue_data)
 		return -EINVAL;
 
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 89863efedc82c..7a2ce387079e3 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -3942,6 +3942,12 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
 
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



