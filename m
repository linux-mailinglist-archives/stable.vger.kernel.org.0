Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D5C66C7EF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbjAPQfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbjAPQfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:35:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D17630B16;
        Mon, 16 Jan 2023 08:22:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6F62B8107A;
        Mon, 16 Jan 2023 16:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3854C433EF;
        Mon, 16 Jan 2023 16:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886172;
        bh=GEqRgcv6qwOd4bMO2GWXjbCrKdAgRn9Gkkceh44pWFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHrBoq8x4nPgJkUtyjMHqjqZnMkYFRcNdRGB2I6LKQWBpRNSkZigcSoNb7f79VmCJ
         XVG/MeOa5TRIbV1e4D0ohx2pgr6gNWlKgGG9xJbmP49YUkmeCcegpIMbZt1HcVr7xT
         BNoKfK3tJc8PpFLVYgXwjp7B25XF3OlKwSACkMJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Leo Yan <leo.yan@linaro.org>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 330/658] perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
Date:   Mon, 16 Jan 2023 16:46:58 +0100
Message-Id: <20230116154924.650597828@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit eadcab4c7a66e1df03d32da0db55d89fd9343fcc ]

This patch defines a macro RAW_SYSCALL_ARGS_NUM to replace the open
coded number '6'.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: bpf@vger.kernel.org
Link: https://lore.kernel.org/r/20221121075237.127706-2-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 03e9a5d8eb55 ("perf trace: Handle failure when trace point folder is missed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 4cb3252623f5..e41b6ffafbd3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -86,6 +86,8 @@
 # define F_LINUX_SPECIFIC_BASE	1024
 #endif
 
+#define RAW_SYSCALL_ARGS_NUM	6
+
 /*
  * strtoul: Go from a string to a value, i.e. for msr: MSR_FS_BASE to 0xc0000100
  */
@@ -105,7 +107,7 @@ struct syscall_fmt {
 		const char *sys_enter,
 			   *sys_exit;
 	}	   bpf_prog_name;
-	struct syscall_arg_fmt arg[6];
+	struct syscall_arg_fmt arg[RAW_SYSCALL_ARGS_NUM];
 	u8	   nr_args;
 	bool	   errpid;
 	bool	   timeout;
@@ -1018,7 +1020,7 @@ struct syscall {
  */
 struct bpf_map_syscall_entry {
 	bool	enabled;
-	u16	string_args_len[6];
+	u16	string_args_len[RAW_SYSCALL_ARGS_NUM];
 };
 
 /*
@@ -1443,7 +1445,7 @@ static int syscall__alloc_arg_fmts(struct syscall *sc, int nr_args)
 {
 	int idx;
 
-	if (nr_args == 6 && sc->fmt && sc->fmt->nr_args != 0)
+	if (nr_args == RAW_SYSCALL_ARGS_NUM && sc->fmt && sc->fmt->nr_args != 0)
 		nr_args = sc->fmt->nr_args;
 
 	sc->arg_fmt = calloc(nr_args, sizeof(*sc->arg_fmt));
@@ -1571,7 +1573,8 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 		sc->tp_format = trace_event__tp_format("syscalls", tp_name);
 	}
 
-	if (syscall__alloc_arg_fmts(sc, IS_ERR(sc->tp_format) ? 6 : sc->tp_format->format.nr_fields))
+	if (syscall__alloc_arg_fmts(sc, IS_ERR(sc->tp_format) ?
+					RAW_SYSCALL_ARGS_NUM : sc->tp_format->format.nr_fields))
 		return -ENOMEM;
 
 	if (IS_ERR(sc->tp_format))
-- 
2.35.1



