Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5EB6676F3
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbjALOi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239479AbjALOhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:37:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C7855866
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:27:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31781B81E73
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A187C433D2;
        Thu, 12 Jan 2023 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533667;
        bh=7RdxT3Vxsqz+U4p64o5sqTMbWRMSFOTc/xaxmyfD9i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pX+hXl+uDFUH2ZE0PxMLUqYBSSHmRlAmgxobQBdP33XH1FNG8IJej4eq7m0gtuSNH
         46+thb/6ZqdxbEGSgZO+YHIMcO7viYxlDmlPMnBpOiqtPXFiIypWCe60z7rICdgeAb
         ljT4f4G9rvcwCRJZ9ASYrGmbcYql07O/E34kVys0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Carsten Haitzler <carsten.haitzler@arm.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, martin.lau@kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 552/783] perf debug: Set debug_peo_args and redirect_to_stderr variable to correct values in perf_quiet_option()
Date:   Thu, 12 Jan 2023 14:54:28 +0100
Message-Id: <20230112135549.815160021@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 188ac720d364035008a54d249cf47b4cc100f819 ]

When perf uses quiet mode, perf_quiet_option() sets the 'debug_peo_args'
variable to -1, and display_attr() incorrectly determines the value of
'debug_peo_args'.  As a result, unexpected information is displayed.

Before:

  # perf record --quiet -- ls > /dev/null
  ------------------------------------------------------------
  perf_event_attr:
    size                             128
    { sample_period, sample_freq }   4000
    sample_type                      IP|TID|TIME|PERIOD
    read_format                      ID|LOST
    disabled                         1
    inherit                          1
    mmap                             1
    comm                             1
    freq                             1
    enable_on_exec                   1
    task                             1
    precise_ip                       3
    sample_id_all                    1
    exclude_guest                    1
    mmap2                            1
    comm_exec                        1
    ksymbol                          1
    bpf_event                        1
  ------------------------------------------------------------
  ...

After:
  # perf record --quiet -- ls > /dev/null
  #

redirect_to_stderr is a similar problem.

Fixes: f78eaef0e0493f60 ("perf tools: Allow to force redirect pr_debug to stderr.")
Fixes: ccd26741f5e6bdf2 ("perf tool: Provide an option to print perf_event_open args and return value")
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Carsten Haitzler <carsten.haitzler@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: martin.lau@kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Link: https://lore.kernel.org/r/20221220035702.188413-2-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 0af163abaa62..854dd3d2d8de 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -207,6 +207,10 @@ int perf_quiet_option(void)
 		opt++;
 	}
 
+	/* For debug variables that are used as bool types, set to 0. */
+	redirect_to_stderr = 0;
+	debug_peo_args = 0;
+
 	return 0;
 }
 
-- 
2.35.1



