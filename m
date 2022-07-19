Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C14F579E0E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242446AbiGSM52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242328AbiGSM4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78505C962;
        Tue, 19 Jul 2022 05:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ADF26177D;
        Tue, 19 Jul 2022 12:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4715BC341C6;
        Tue, 19 Jul 2022 12:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233367;
        bh=TbdUjynScr+nnVAJZyWxktS96gdnHpTb1GUq694sUlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jD3gcjzkk7xOhDU+SZp4pX+TMwwWD/vkcovqosQFDmTxKBSjs99YHQgjYv8dv2k03
         19kN1yPeiBwUp7g6nXQWaWLeseqjO7cHFeN+JDwliNIZHC0lwrnIseD5i2K1maWYo2
         v45Cpk549Q+LHJIaTqwt3zHg+xm7XDU6DBBFajQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 099/231] tracing: Fix sleeping while atomic in kdb ftdump
Date:   Tue, 19 Jul 2022 13:53:04 +0200
Message-Id: <20220719114723.033189917@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 495fcec8648cdfb483b5b9ab310f3839f07cb3b8 ]

If you drop into kdb and type "ftdump" you'll get a sleeping while
atomic warning from memory allocation in trace_find_next_entry().

This appears to have been caused by commit ff895103a84a ("tracing:
Save off entry when peeking at next entry"), which added the
allocation in that path. The problematic commit was already fixed by
commit 8e99cf91b99b ("tracing: Do not allocate buffer in
trace_find_next_entry() in atomic") but that fix missed the kdb case.

The fix here is easy: just move the assignment of the static buffer to
the place where it should have been to begin with:
trace_init_global_iter(). That function is called in two places, once
is right before the assignment of the static buffer added by the
previous fix and once is in kdb.

Note that it appears that there's a second static buffer that we need
to assign that was added in commit efbbdaa22bb7 ("tracing: Show real
address for trace event arguments"), so we'll move that too.

Link: https://lkml.kernel.org/r/20220708170919.1.I75844e5038d9425add2ad853a608cb44bb39df40@changeid

Fixes: ff895103a84a ("tracing: Save off entry when peeking at next entry")
Fixes: efbbdaa22bb7 ("tracing: Show real address for trace event arguments")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 114c31bdf8f9..c0c98b0c86e7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9863,6 +9863,12 @@ void trace_init_global_iter(struct trace_iterator *iter)
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
 	if (trace_clocks[iter->tr->clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
+
+	/* Can not use kmalloc for iter.temp and iter.fmt */
+	iter->temp = static_temp_buf;
+	iter->temp_size = STATIC_TEMP_BUF_SIZE;
+	iter->fmt = static_fmt_buf;
+	iter->fmt_size = STATIC_FMT_BUF_SIZE;
 }
 
 void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
@@ -9895,11 +9901,6 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 
 	/* Simulate the iterator */
 	trace_init_global_iter(&iter);
-	/* Can not use kmalloc for iter.temp and iter.fmt */
-	iter.temp = static_temp_buf;
-	iter.temp_size = STATIC_TEMP_BUF_SIZE;
-	iter.fmt = static_fmt_buf;
-	iter.fmt_size = STATIC_FMT_BUF_SIZE;
 
 	for_each_tracing_cpu(cpu) {
 		atomic_inc(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
-- 
2.35.1



