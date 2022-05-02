Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125F3517A54
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 01:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiEBXH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 19:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiEBXHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 19:07:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0EE2DAAB
        for <stable@vger.kernel.org>; Mon,  2 May 2022 16:03:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10BD86126D
        for <stable@vger.kernel.org>; Mon,  2 May 2022 23:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7FCC385AC;
        Mon,  2 May 2022 23:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651532633;
        bh=yLuRTikPgLc+y8y38USm0kceTyuhtChXdN7+Nf79bFU=;
        h=Subject:To:Cc:From:Date:From;
        b=f0XAU4d9raf1pHzEKIT2LFkAnl4vWy0qN20sgzkII4uyPWqrRHTA1ydVNY1unP/FW
         Z9GR++8aa7d45Pr1q3eOzXZ51RHuGuvNvbcOdhF1lzZgV+ugHcaqUGdZl92bGSGa76
         YPkC4D4nh6mYV6d04LS2t2QKrfSrzuh68Dd2FLIs=
Subject: FAILED: patch "[PATCH] perf symbol: Update symbols__fixup_end()" failed to apply to 5.4-stable tree
To:     namhyung@kernel.org, acme@redhat.com, hca@linux.ibm.com,
        irogers@google.com, john.garry@huawei.com, jolsa@kernel.org,
        leo.yan@linaro.org, mark.rutland@arm.com,
        mathieu.poirier@linaro.org, mhiramat@kernel.org, mingo@kernel.org,
        mpe@ellerman.id.au, mpetlan@redhat.com, peterz@infradead.org,
        songliubraving@fb.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 01:03:52 +0200
Message-ID: <165153263217796@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8799ebce84d672aae1dc3170510f6a3e66f96b11 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 15 Apr 2022 17:40:47 -0700
Subject: [PATCH] perf symbol: Update symbols__fixup_end()

Now arch-specific functions all do the same thing.  When it fixes the
symbol address it needs to check the boundary between the kernel image
and modules.  For the last symbol in the previous region, it cannot
know the exact size as it's discarded already.  Thus it just uses a
small page size (4096) and rounds it up like the last symbol.

Fixes: 3cf6a32f3f2a4594 ("perf symbols: Fix symbol size calculation condition")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-s390@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20220416004048.1514900-3-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1b85cc1422a9..623094e866fd 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -217,8 +217,8 @@ void symbols__fixup_duplicate(struct rb_root_cached *symbols)
 	}
 }
 
-void symbols__fixup_end(struct rb_root_cached *symbols,
-			bool is_kallsyms __maybe_unused)
+/* Update zero-sized symbols using the address of the next symbol */
+void symbols__fixup_end(struct rb_root_cached *symbols, bool is_kallsyms)
 {
 	struct rb_node *nd, *prevnd = rb_first_cached(symbols);
 	struct symbol *curr, *prev;
@@ -232,8 +232,29 @@ void symbols__fixup_end(struct rb_root_cached *symbols,
 		prev = curr;
 		curr = rb_entry(nd, struct symbol, rb_node);
 
-		if (prev->end == prev->start || prev->end != curr->start)
-			arch__symbols__fixup_end(prev, curr);
+		/*
+		 * On some architecture kernel text segment start is located at
+		 * some low memory address, while modules are located at high
+		 * memory addresses (or vice versa).  The gap between end of
+		 * kernel text segment and beginning of first module's text
+		 * segment is very big.  Therefore do not fill this gap and do
+		 * not assign it to the kernel dso map (kallsyms).
+		 *
+		 * In kallsyms, it determines module symbols using '[' character
+		 * like in:
+		 *   ffffffffc1937000 T hdmi_driver_init  [snd_hda_codec_hdmi]
+		 */
+		if (prev->end == prev->start) {
+			/* Last kernel/module symbol mapped to end of page */
+			if (is_kallsyms && (!strchr(prev->name, '[') !=
+					    !strchr(curr->name, '[')))
+				prev->end = roundup(prev->end + 4096, 4096);
+			else
+				prev->end = curr->start;
+
+			pr_debug4("%s sym:%s end:%#" PRIx64 "\n",
+				  __func__, prev->name, prev->end);
+		}
 	}
 
 	/* Last entry */

