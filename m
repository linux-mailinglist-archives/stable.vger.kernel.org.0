Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F09541D0E
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377299AbiFGWHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383771AbiFGWGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1721F2514B6;
        Tue,  7 Jun 2022 12:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8074DB82182;
        Tue,  7 Jun 2022 19:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D484DC385A2;
        Tue,  7 Jun 2022 19:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629458;
        bh=tSAIjWFM34vuidDzwJFdmwK/RQGawZs8P4WYWjtZDpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqJqcvORwhH0HRP7ghaFr5yWC6EopX4NtIr1P6Xd7XXr/XLkdOTimBaAGg2GW6zjy
         FVcyNIwqiJonM2DtF9N4t+vHD+0giPDVH7ZozpvTH7IXc8GmH6aogIFAH/mGIaxCiZ
         BZ+se3DhuOgWlvGe+dxx+X/HUj3gj1PxEqEJohZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kael_w@yeah.net,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 698/879] rtla: Avoid record NULL pointer dereference
Date:   Tue,  7 Jun 2022 19:03:36 +0200
Message-Id: <20220607165023.107763069@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 2a6b52ed72c822b5ee146a6a00ea66614fe02653 ]

Fix the following null/deref_null.cocci errors:
./tools/tracing/rtla/src/osnoise_hist.c:870:31-36: ERROR: record is NULL but dereferenced.
./tools/tracing/rtla/src/osnoise_top.c:650:31-36: ERROR: record is NULL but dereferenced.
./tools/tracing/rtla/src/timerlat_hist.c:905:31-36: ERROR: record is NULL but dereferenced.
./tools/tracing/rtla/src/timerlat_top.c:700:31-36: ERROR: record is NULL but dereferenced.

"record" is NULL before calling osnoise_init_trace_tool.
Add a tag "out_free" to avoid dereferring a NULL pointer.

Link: https://lkml.kernel.org/r/ae0e4500d383db0884eb2820286afe34ca303778.1651247710.git.bristot@kernel.org
Link: https://lore.kernel.org/r/20220408151406.34823-1-wanjiabing@vivo.com/

Cc: kael_w@yeah.net
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Fixes: 51d64c3a1819 ("rtla: Add -e/--event support")
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/osnoise_hist.c  |  5 +++--
 tools/tracing/rtla/src/osnoise_top.c   |  9 +++++----
 tools/tracing/rtla/src/timerlat_hist.c | 11 ++++++-----
 tools/tracing/rtla/src/timerlat_top.c  | 11 ++++++-----
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
index b4380d45cacd..5d7ea479ac89 100644
--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -809,7 +809,7 @@ int osnoise_hist_main(int argc, char *argv[])
 		retval = set_comm_sched_attr("osnoise/", &params->sched_param);
 		if (retval) {
 			err_msg("Failed to set sched parameters\n");
-			goto out_hist;
+			goto out_free;
 		}
 	}
 
@@ -819,7 +819,7 @@ int osnoise_hist_main(int argc, char *argv[])
 		record = osnoise_init_trace_tool("osnoise");
 		if (!record) {
 			err_msg("Failed to enable the trace instance\n");
-			goto out_hist;
+			goto out_free;
 		}
 
 		if (params->events) {
@@ -869,6 +869,7 @@ int osnoise_hist_main(int argc, char *argv[])
 out_hist:
 	trace_events_destroy(&record->trace, params->events);
 	params->events = NULL;
+out_free:
 	osnoise_free_histogram(tool->data);
 out_destroy:
 	osnoise_destroy_tool(record);
diff --git a/tools/tracing/rtla/src/osnoise_top.c b/tools/tracing/rtla/src/osnoise_top.c
index 72c2fd6ce005..76479bfb2922 100644
--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -572,7 +572,7 @@ int osnoise_top_main(int argc, char **argv)
 	retval = osnoise_top_apply_config(tool, params);
 	if (retval) {
 		err_msg("Could not apply config\n");
-		goto out_top;
+		goto out_free;
 	}
 
 	trace = &tool->trace;
@@ -580,14 +580,14 @@ int osnoise_top_main(int argc, char **argv)
 	retval = enable_osnoise(trace);
 	if (retval) {
 		err_msg("Failed to enable osnoise tracer\n");
-		goto out_top;
+		goto out_free;
 	}
 
 	if (params->set_sched) {
 		retval = set_comm_sched_attr("osnoise/", &params->sched_param);
 		if (retval) {
 			err_msg("Failed to set sched parameters\n");
-			goto out_top;
+			goto out_free;
 		}
 	}
 
@@ -597,7 +597,7 @@ int osnoise_top_main(int argc, char **argv)
 		record = osnoise_init_trace_tool("osnoise");
 		if (!record) {
 			err_msg("Failed to enable the trace instance\n");
-			goto out_top;
+			goto out_free;
 		}
 
 		if (params->events) {
@@ -649,6 +649,7 @@ int osnoise_top_main(int argc, char **argv)
 out_top:
 	trace_events_destroy(&record->trace, params->events);
 	params->events = NULL;
+out_free:
 	osnoise_free_top(tool->data);
 	osnoise_destroy_tool(record);
 	osnoise_destroy_tool(tool);
diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index dc908126c610..f3ec628f5e51 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -821,7 +821,7 @@ int timerlat_hist_main(int argc, char *argv[])
 	retval = timerlat_hist_apply_config(tool, params);
 	if (retval) {
 		err_msg("Could not apply config\n");
-		goto out_hist;
+		goto out_free;
 	}
 
 	trace = &tool->trace;
@@ -829,14 +829,14 @@ int timerlat_hist_main(int argc, char *argv[])
 	retval = enable_timerlat(trace);
 	if (retval) {
 		err_msg("Failed to enable timerlat tracer\n");
-		goto out_hist;
+		goto out_free;
 	}
 
 	if (params->set_sched) {
 		retval = set_comm_sched_attr("timerlat/", &params->sched_param);
 		if (retval) {
 			err_msg("Failed to set sched parameters\n");
-			goto out_hist;
+			goto out_free;
 		}
 	}
 
@@ -844,7 +844,7 @@ int timerlat_hist_main(int argc, char *argv[])
 		dma_latency_fd = set_cpu_dma_latency(params->dma_latency);
 		if (dma_latency_fd < 0) {
 			err_msg("Could not set /dev/cpu_dma_latency.\n");
-			goto out_hist;
+			goto out_free;
 		}
 	}
 
@@ -854,7 +854,7 @@ int timerlat_hist_main(int argc, char *argv[])
 		record = osnoise_init_trace_tool("timerlat");
 		if (!record) {
 			err_msg("Failed to enable the trace instance\n");
-			goto out_hist;
+			goto out_free;
 		}
 
 		if (params->events) {
@@ -904,6 +904,7 @@ int timerlat_hist_main(int argc, char *argv[])
 		close(dma_latency_fd);
 	trace_events_destroy(&record->trace, params->events);
 	params->events = NULL;
+out_free:
 	timerlat_free_histogram(tool->data);
 	osnoise_destroy_tool(record);
 	osnoise_destroy_tool(tool);
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 1f754c3df53f..35452a1d45e9 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -612,7 +612,7 @@ int timerlat_top_main(int argc, char *argv[])
 	retval = timerlat_top_apply_config(top, params);
 	if (retval) {
 		err_msg("Could not apply config\n");
-		goto out_top;
+		goto out_free;
 	}
 
 	trace = &top->trace;
@@ -620,14 +620,14 @@ int timerlat_top_main(int argc, char *argv[])
 	retval = enable_timerlat(trace);
 	if (retval) {
 		err_msg("Failed to enable timerlat tracer\n");
-		goto out_top;
+		goto out_free;
 	}
 
 	if (params->set_sched) {
 		retval = set_comm_sched_attr("timerlat/", &params->sched_param);
 		if (retval) {
 			err_msg("Failed to set sched parameters\n");
-			goto out_top;
+			goto out_free;
 		}
 	}
 
@@ -635,7 +635,7 @@ int timerlat_top_main(int argc, char *argv[])
 		dma_latency_fd = set_cpu_dma_latency(params->dma_latency);
 		if (dma_latency_fd < 0) {
 			err_msg("Could not set /dev/cpu_dma_latency.\n");
-			goto out_top;
+			goto out_free;
 		}
 	}
 
@@ -645,7 +645,7 @@ int timerlat_top_main(int argc, char *argv[])
 		record = osnoise_init_trace_tool("timerlat");
 		if (!record) {
 			err_msg("Failed to enable the trace instance\n");
-			goto out_top;
+			goto out_free;
 		}
 
 		if (params->events) {
@@ -699,6 +699,7 @@ int timerlat_top_main(int argc, char *argv[])
 		close(dma_latency_fd);
 	trace_events_destroy(&record->trace, params->events);
 	params->events = NULL;
+out_free:
 	timerlat_free_top(top->data);
 	osnoise_destroy_tool(record);
 	osnoise_destroy_tool(top);
-- 
2.35.1



