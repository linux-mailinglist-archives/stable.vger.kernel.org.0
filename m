Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995D16B456C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbjCJOdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjCJOdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC2523848;
        Fri, 10 Mar 2023 06:33:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 597BA6191D;
        Fri, 10 Mar 2023 14:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FD7C433EF;
        Fri, 10 Mar 2023 14:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458783;
        bh=yQJSZcfYXWTDUyGGmtHOLv8S1mP2iPgVwEZ5UYp+008=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/kcfRgzt/O/ESEOhBn13h287+KB9MMp1z9OmuZOjteSq4JQnA8zE+FwxpMfDWXsY
         h5YAfhDXgzzlqGb+W376pZ+PnVTpRFlZpXLGDfLHUvn8KEZRi/IGyKLzqzo02aF1Lf
         QltaId+S7W1VSpArMtHIVdhGY5WVsHppUgcsN5Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        llvm@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Rix <trix@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/357] perf llvm: Fix inadvertent file creation
Date:   Fri, 10 Mar 2023 14:37:12 +0100
Message-Id: <20230310133741.006036179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 9f19aab47ced012eddef1e2bc96007efc7713b61 ]

The LLVM template is first echo-ed into command_out and then
command_out executed. The echo surrounds the template with double
quotes, however, the template itself may contain quotes. This is
generally innocuous but in tools/perf/tests/bpf-script-test-prologue.c
we see:
...
SEC("func=null_lseek file->f_mode offset orig")
...
where the first double quote ends the double quote of the echo, then
the > redirects output into a file called f_mode.

To avoid this inadvertent behavior substitute redirects and similar
characters to be ASCII control codes, then substitute the output in
the echo back again.

Fixes: 5eab5a7ee032acaa ("perf llvm: Display eBPF compiling command in debug output")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: bpf@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: llvm@lists.linux.dev
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20230105082609.344538-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/llvm-utils.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/llvm-utils.c b/tools/perf/util/llvm-utils.c
index e7c7e3232fc5a..b275a1b297c30 100644
--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -523,14 +523,37 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 
 	pr_debug("llvm compiling command template: %s\n", template);
 
+	/*
+	 * Below, substitute control characters for values that can cause the
+	 * echo to misbehave, then substitute the values back.
+	 */
 	err = -ENOMEM;
-	if (asprintf(&command_echo, "echo -n \"%s\"", template) < 0)
+	if (asprintf(&command_echo, "echo -n \a%s\a", template) < 0)
 		goto errout;
 
+#define SWAP_CHAR(a, b) do { if (*p == a) *p = b; } while (0)
+	for (char *p = command_echo; *p; p++) {
+		SWAP_CHAR('<', '\001');
+		SWAP_CHAR('>', '\002');
+		SWAP_CHAR('"', '\003');
+		SWAP_CHAR('\'', '\004');
+		SWAP_CHAR('|', '\005');
+		SWAP_CHAR('&', '\006');
+		SWAP_CHAR('\a', '"');
+	}
 	err = read_from_pipe(command_echo, (void **) &command_out, NULL);
 	if (err)
 		goto errout;
 
+	for (char *p = command_out; *p; p++) {
+		SWAP_CHAR('\001', '<');
+		SWAP_CHAR('\002', '>');
+		SWAP_CHAR('\003', '"');
+		SWAP_CHAR('\004', '\'');
+		SWAP_CHAR('\005', '|');
+		SWAP_CHAR('\006', '&');
+	}
+#undef SWAP_CHAR
 	pr_debug("llvm compiling command : %s\n", command_out);
 
 	err = read_from_pipe(template, &obj_buf, &obj_buf_sz);
-- 
2.39.2



