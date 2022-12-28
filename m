Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EBA657CB8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiL1PfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiL1PfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:35:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FEE164B5;
        Wed, 28 Dec 2022 07:35:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8034861560;
        Wed, 28 Dec 2022 15:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69432C433D2;
        Wed, 28 Dec 2022 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241721;
        bh=JM9gF150SiFLYZZz7onMGQzXCLySd/ngSrYhvCa1ibE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4eflKTcrpq88f/7AHBDnoh86IFj7yGGkerqeLv0/7Iqlu2aDhFxeCuElS1aRTRMD
         RAbgRoZ7bKzIgrvCr6rLuRZ3vmD+1O76DOHaZYYaQvnkGZZMy1i8jAjay3aoKxsm+i
         wAnSENOnFR+hVRvO6zg83qHygPWDPvMahZEELGDM=
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
Subject: [PATCH 5.15 515/731] perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
Date:   Wed, 28 Dec 2022 15:40:22 +0100
Message-Id: <20221228144311.472336950@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index aaa465d7f011..c1db48ff01a5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -87,6 +87,8 @@
 # define F_LINUX_SPECIFIC_BASE	1024
 #endif
 
+#define RAW_SYSCALL_ARGS_NUM	6
+
 /*
  * strtoul: Go from a string to a value, i.e. for msr: MSR_FS_BASE to 0xc0000100
  */
@@ -107,7 +109,7 @@ struct syscall_fmt {
 		const char *sys_enter,
 			   *sys_exit;
 	}	   bpf_prog_name;
-	struct syscall_arg_fmt arg[6];
+	struct syscall_arg_fmt arg[RAW_SYSCALL_ARGS_NUM];
 	u8	   nr_args;
 	bool	   errpid;
 	bool	   timeout;
@@ -1224,7 +1226,7 @@ struct syscall {
  */
 struct bpf_map_syscall_entry {
 	bool	enabled;
-	u16	string_args_len[6];
+	u16	string_args_len[RAW_SYSCALL_ARGS_NUM];
 };
 
 /*
@@ -1649,7 +1651,7 @@ static int syscall__alloc_arg_fmts(struct syscall *sc, int nr_args)
 {
 	int idx;
 
-	if (nr_args == 6 && sc->fmt && sc->fmt->nr_args != 0)
+	if (nr_args == RAW_SYSCALL_ARGS_NUM && sc->fmt && sc->fmt->nr_args != 0)
 		nr_args = sc->fmt->nr_args;
 
 	sc->arg_fmt = calloc(nr_args, sizeof(*sc->arg_fmt));
@@ -1800,7 +1802,8 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 		sc->tp_format = trace_event__tp_format("syscalls", tp_name);
 	}
 
-	if (syscall__alloc_arg_fmts(sc, IS_ERR(sc->tp_format) ? 6 : sc->tp_format->format.nr_fields))
+	if (syscall__alloc_arg_fmts(sc, IS_ERR(sc->tp_format) ?
+					RAW_SYSCALL_ARGS_NUM : sc->tp_format->format.nr_fields))
 		return -ENOMEM;
 
 	if (IS_ERR(sc->tp_format))
-- 
2.35.1



