Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FECC4FD50E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242727AbiDLH67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358716AbiDLHmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F171953B76;
        Tue, 12 Apr 2022 00:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87BD86177C;
        Tue, 12 Apr 2022 07:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C28C385A6;
        Tue, 12 Apr 2022 07:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747934;
        bh=NfCabbv+0+SdWxdiKzNvGN6aMUjVfEGF9MvN+oyWnoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsQlJ7e9vgYkMvYkSdAByUlmmNNhp+rZnCdRKiLax1A4hQ1lRCOuFl5/Ph7WzJzI0
         gbJHt8mmOHAlCstrupFvya3znbkRvGR5Qwfvj2gGTmb0VmeE1HoH8kdiWlBv5DEWrU
         fb+5ZTh6gn+T7xEQBUGqIv3t5D2MtjOrDjIVj1Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        James Clark <james.clark@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Truong <alexandre.truong@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 259/343] perf unwind: Dont show unwind error messages when augmenting frame pointer stack
Date:   Tue, 12 Apr 2022 08:31:17 +0200
Message-Id: <20220412062958.802234700@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: James Clark <james.clark@arm.com>

[ Upstream commit fa7095c5c3240bb2ecbc77f8b69be9b1d9e2cf60 ]

Commit Fixes: b9f6fbb3b2c29736 ("perf arm64: Inject missing frames when
using 'perf record --call-graph=fp'") intended to add a 'best effort'
DWARF unwind that improved the frame pointer stack in most scenarios.

It's expected that the unwind will fail sometimes, but this shouldn't be
reported as an error. It only works when the return address can be
determined from the contents of the link register alone.

Fix the error shown when the unwinder requires extra registers by adding
a new flag that suppresses error messages. This flag is not set in the
normal --call-graph=dwarf unwind mode so that behavior is not changed.

Fixes: b9f6fbb3b2c29736 ("perf arm64: Inject missing frames when using 'perf record --call-graph=fp'")
Reported-by: John Garry <john.garry@huawei.com>
Signed-off-by: James Clark <james.clark@arm.com>
Tested-by: John Garry <john.garry@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Truong <alexandre.truong@arm.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20220406145651.1392529-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/dwarf-unwind.c                     |  2 +-
 .../perf/util/arm64-frame-pointer-unwind-support.c  |  2 +-
 tools/perf/util/machine.c                           |  2 +-
 tools/perf/util/unwind-libdw.c                      | 10 +++++++---
 tools/perf/util/unwind-libdw.h                      |  1 +
 tools/perf/util/unwind-libunwind-local.c            | 10 +++++++---
 tools/perf/util/unwind-libunwind.c                  |  6 ++++--
 tools/perf/util/unwind.h                            | 13 ++++++++++---
 8 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index 2dab2d262060..afdca7f2959f 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -122,7 +122,7 @@ NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__thread(struct thread *thr
 	}
 
 	err = unwind__get_entries(unwind_entry, &cnt, thread,
-				  &sample, MAX_STACK);
+				  &sample, MAX_STACK, false);
 	if (err)
 		pr_debug("unwind failed\n");
 	else if (cnt != MAX_STACK) {
diff --git a/tools/perf/util/arm64-frame-pointer-unwind-support.c b/tools/perf/util/arm64-frame-pointer-unwind-support.c
index 2242a885fbd7..4940be4a0569 100644
--- a/tools/perf/util/arm64-frame-pointer-unwind-support.c
+++ b/tools/perf/util/arm64-frame-pointer-unwind-support.c
@@ -53,7 +53,7 @@ u64 get_leaf_frame_caller_aarch64(struct perf_sample *sample, struct thread *thr
 		sample->user_regs.cache_regs[PERF_REG_ARM64_SP] = 0;
 	}
 
-	ret = unwind__get_entries(add_entry, &entries, thread, sample, 2);
+	ret = unwind__get_entries(add_entry, &entries, thread, sample, 2, true);
 	sample->user_regs = old_regs;
 
 	if (ret || entries.length != 2)
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 394550003693..564abe17a0bd 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2983,7 +2983,7 @@ static int thread__resolve_callchain_unwind(struct thread *thread,
 		return 0;
 
 	return unwind__get_entries(unwind_entry, cursor,
-				   thread, sample, max_stack);
+				   thread, sample, max_stack, false);
 }
 
 int thread__resolve_callchain(struct thread *thread,
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index a74b517f7497..94aa40f6e348 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -200,7 +200,8 @@ frame_callback(Dwfl_Frame *state, void *arg)
 	bool isactivation;
 
 	if (!dwfl_frame_pc(state, &pc, NULL)) {
-		pr_err("%s", dwfl_errmsg(-1));
+		if (!ui->best_effort)
+			pr_err("%s", dwfl_errmsg(-1));
 		return DWARF_CB_ABORT;
 	}
 
@@ -208,7 +209,8 @@ frame_callback(Dwfl_Frame *state, void *arg)
 	report_module(pc, ui);
 
 	if (!dwfl_frame_pc(state, &pc, &isactivation)) {
-		pr_err("%s", dwfl_errmsg(-1));
+		if (!ui->best_effort)
+			pr_err("%s", dwfl_errmsg(-1));
 		return DWARF_CB_ABORT;
 	}
 
@@ -222,7 +224,8 @@ frame_callback(Dwfl_Frame *state, void *arg)
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct thread *thread,
 			struct perf_sample *data,
-			int max_stack)
+			int max_stack,
+			bool best_effort)
 {
 	struct unwind_info *ui, ui_buf = {
 		.sample		= data,
@@ -231,6 +234,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 		.cb		= cb,
 		.arg		= arg,
 		.max_stack	= max_stack,
+		.best_effort    = best_effort
 	};
 	Dwarf_Word ip;
 	int err = -EINVAL, i;
diff --git a/tools/perf/util/unwind-libdw.h b/tools/perf/util/unwind-libdw.h
index 0cbd2650e280..8c88bc4f2304 100644
--- a/tools/perf/util/unwind-libdw.h
+++ b/tools/perf/util/unwind-libdw.h
@@ -20,6 +20,7 @@ struct unwind_info {
 	void			*arg;
 	int			max_stack;
 	int			idx;
+	bool			best_effort;
 	struct unwind_entry	entries[];
 };
 
diff --git a/tools/perf/util/unwind-libunwind-local.c b/tools/perf/util/unwind-libunwind-local.c
index 71a353349181..41e29fc7648a 100644
--- a/tools/perf/util/unwind-libunwind-local.c
+++ b/tools/perf/util/unwind-libunwind-local.c
@@ -96,6 +96,7 @@ struct unwind_info {
 	struct perf_sample	*sample;
 	struct machine		*machine;
 	struct thread		*thread;
+	bool			 best_effort;
 };
 
 #define dw_read(ptr, type, end) ({	\
@@ -553,7 +554,8 @@ static int access_reg(unw_addr_space_t __maybe_unused as,
 
 	ret = perf_reg_value(&val, &ui->sample->user_regs, id);
 	if (ret) {
-		pr_err("unwind: can't read reg %d\n", regnum);
+		if (!ui->best_effort)
+			pr_err("unwind: can't read reg %d\n", regnum);
 		return ret;
 	}
 
@@ -666,7 +668,7 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 			return -1;
 
 		ret = unw_init_remote(&c, addr_space, ui);
-		if (ret)
+		if (ret && !ui->best_effort)
 			display_error(ret);
 
 		while (!ret && (unw_step(&c) > 0) && i < max_stack) {
@@ -704,12 +706,14 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 
 static int _unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct thread *thread,
-			struct perf_sample *data, int max_stack)
+			struct perf_sample *data, int max_stack,
+			bool best_effort)
 {
 	struct unwind_info ui = {
 		.sample       = data,
 		.thread       = thread,
 		.machine      = thread->maps->machine,
+		.best_effort  = best_effort
 	};
 
 	if (!data->user_regs.regs)
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index e89a5479b361..509c287ee762 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -80,9 +80,11 @@ void unwind__finish_access(struct maps *maps)
 
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			 struct thread *thread,
-			 struct perf_sample *data, int max_stack)
+			 struct perf_sample *data, int max_stack,
+			 bool best_effort)
 {
 	if (thread->maps->unwind_libunwind_ops)
-		return thread->maps->unwind_libunwind_ops->get_entries(cb, arg, thread, data, max_stack);
+		return thread->maps->unwind_libunwind_ops->get_entries(cb, arg, thread, data,
+								       max_stack, best_effort);
 	return 0;
 }
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index ab8ad469c8de..b2a03fa5289b 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -23,13 +23,19 @@ struct unwind_libunwind_ops {
 	void (*finish_access)(struct maps *maps);
 	int (*get_entries)(unwind_entry_cb_t cb, void *arg,
 			   struct thread *thread,
-			   struct perf_sample *data, int max_stack);
+			   struct perf_sample *data, int max_stack, bool best_effort);
 };
 
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
+/*
+ * When best_effort is set, don't report errors and fail silently. This could
+ * be expanded in the future to be more permissive about things other than
+ * error messages.
+ */
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct thread *thread,
-			struct perf_sample *data, int max_stack);
+			struct perf_sample *data, int max_stack,
+			bool best_effort);
 /* libunwind specific */
 #ifdef HAVE_LIBUNWIND_SUPPORT
 #ifndef LIBUNWIND__ARCH_REG_ID
@@ -65,7 +71,8 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 		    void *arg __maybe_unused,
 		    struct thread *thread __maybe_unused,
 		    struct perf_sample *data __maybe_unused,
-		    int max_stack __maybe_unused)
+		    int max_stack __maybe_unused,
+		    bool best_effort __maybe_unused)
 {
 	return 0;
 }
-- 
2.35.1



