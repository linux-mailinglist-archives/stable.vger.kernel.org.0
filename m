Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79426584C4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiL1RB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbiL1RBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:01:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A061D326
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:56:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F404B613E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6AFC433EF;
        Wed, 28 Dec 2022 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246565;
        bh=77Ax692QPbClaw5Sew2l0xTyYFdYyuwdAt/P++1XU+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hiav8E5sBet0ZSI7yTVRC/aiDFjXbfGsaIxksxUaKoen4Qhr6YOxdcb+pWZnSvi91
         LgLSTy94rNq9I2re7ijihmfFOLa69pfgom/+1+j8fQrr104mWZRUxPoEnnggAybf+F
         WDPuv3fkS/h9tC3bkcBhh8Kq1+ZZ5mit3/dWb2rk=
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
Subject: [PATCH 6.1 1083/1146] perf debug: Set debug_peo_args and redirect_to_stderr variable to correct values in perf_quiet_option()
Date:   Wed, 28 Dec 2022 15:43:42 +0100
Message-Id: <20221228144359.623016718@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 65e6c22f38e4..190e818a0717 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -241,6 +241,10 @@ int perf_quiet_option(void)
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



