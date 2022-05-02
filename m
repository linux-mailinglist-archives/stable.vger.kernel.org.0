Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB02517A53
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 01:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiEBXGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 19:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiEBXGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 19:06:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3102DD5E
        for <stable@vger.kernel.org>; Mon,  2 May 2022 16:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 879ED612DB
        for <stable@vger.kernel.org>; Mon,  2 May 2022 23:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBDAC385AE;
        Mon,  2 May 2022 23:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651532599;
        bh=cO0IrMk9A4D5IymKF5FrhjDT1JzG+xd0r9LlmUnwvV8=;
        h=Subject:To:Cc:From:Date:From;
        b=Q70PZRb4hGJu1QMe1MWcHrkmkH92GUPEetxUThM8Hrb0SEHazunfAKZdcbLi9BmEL
         M3a4jxo/pX2I2dP7Raf4x2Vr9z5u2xEGPHWaYBZhq3FhHYdupU9+vD1fcD33Jhh32Y
         vfhWIyQQzE8rojoIuXY11RHB0IGx5mHvldcvNJ2Y=
Subject: FAILED: patch "[PATCH] perf symbol: Pass is_kallsyms to symbols__fixup_end()" failed to apply to 5.4-stable tree
To:     namhyung@kernel.org, acme@redhat.com, hca@linux.ibm.com,
        irogers@google.com, john.garry@huawei.com, jolsa@kernel.org,
        leo.yan@linaro.org, mark.rutland@arm.com,
        mathieu.poirier@linaro.org, mhiramat@kernel.org, mingo@kernel.org,
        mpe@ellerman.id.au, mpetlan@redhat.com, peterz@infradead.org,
        songliubraving@fb.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 01:03:18 +0200
Message-ID: <165153259824820@kroah.com>
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

From 838425f2defe5262906b698752d28fd2fca1aac2 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 15 Apr 2022 17:40:46 -0700
Subject: [PATCH] perf symbol: Pass is_kallsyms to symbols__fixup_end()

The symbol fixup is necessary for symbols in kallsyms since they don't
have size info.  So we use the next symbol's address to calculate the
size.  Now it's also used for user binaries because sometimes they miss
size for hand-written asm functions.

There's a arch-specific function to handle kallsyms differently but
currently it cannot distinguish kallsyms from others.  Pass this
information explicitly to handle it properly.  Note that those arch
functions will be moved to the generic function so I didn't added it to
the arch-functions.

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
Link: https://lore.kernel.org/r/20220416004048.1514900-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 31cd59a2b66e..ecd377938eea 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1290,7 +1290,7 @@ dso__load_sym_internal(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 	 * For misannotated, zeroed, ASM function sizes.
 	 */
 	if (nr > 0) {
-		symbols__fixup_end(&dso->symbols);
+		symbols__fixup_end(&dso->symbols, false);
 		symbols__fixup_duplicate(&dso->symbols);
 		if (kmap) {
 			/*
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index dea0fc495185..1b85cc1422a9 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -217,7 +217,8 @@ void symbols__fixup_duplicate(struct rb_root_cached *symbols)
 	}
 }
 
-void symbols__fixup_end(struct rb_root_cached *symbols)
+void symbols__fixup_end(struct rb_root_cached *symbols,
+			bool is_kallsyms __maybe_unused)
 {
 	struct rb_node *nd, *prevnd = rb_first_cached(symbols);
 	struct symbol *curr, *prev;
@@ -1467,7 +1468,7 @@ int __dso__load_kallsyms(struct dso *dso, const char *filename,
 	if (kallsyms__delta(kmap, filename, &delta))
 		return -1;
 
-	symbols__fixup_end(&dso->symbols);
+	symbols__fixup_end(&dso->symbols, true);
 	symbols__fixup_duplicate(&dso->symbols);
 
 	if (dso->kernel == DSO_SPACE__KERNEL_GUEST)
@@ -1659,7 +1660,7 @@ int dso__load_bfd_symbols(struct dso *dso, const char *debugfile)
 #undef bfd_asymbol_section
 #endif
 
-	symbols__fixup_end(&dso->symbols);
+	symbols__fixup_end(&dso->symbols, false);
 	symbols__fixup_duplicate(&dso->symbols);
 	dso->adjust_symbols = 1;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fbf866d82dcc..5fcdd1f94c56 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -203,7 +203,7 @@ void __symbols__insert(struct rb_root_cached *symbols, struct symbol *sym,
 		       bool kernel);
 void symbols__insert(struct rb_root_cached *symbols, struct symbol *sym);
 void symbols__fixup_duplicate(struct rb_root_cached *symbols);
-void symbols__fixup_end(struct rb_root_cached *symbols);
+void symbols__fixup_end(struct rb_root_cached *symbols, bool is_kallsyms);
 void maps__fixup_end(struct maps *maps);
 
 typedef int (*mapfn_t)(u64 start, u64 len, u64 pgoff, void *data);

