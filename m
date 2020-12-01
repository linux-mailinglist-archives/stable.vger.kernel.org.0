Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2EF2CA7A4
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392001AbgLAQB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391343AbgLAQB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 11:01:28 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8775E2224F;
        Tue,  1 Dec 2020 16:00:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kk84U-002R8Q-F1; Tue, 01 Dec 2020 11:00:06 -0500
Message-ID: <20201201160006.344891693@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 01 Dec 2020 10:58:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [for-linus][PATCH 09/12] tracing: Fix alignment of static buffer
References: <20201201155835.647858317@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

With 5.9 kernel on ARM64, I found ftrace_dump output was broken but
it had no problem with normal output "cat /sys/kernel/debug/tracing/trace".

With investigation, it seems coping the data into temporal buffer seems to
break the align binary printf expects if the static buffer is not aligned
with 4-byte. IIUC, get_arg in bstr_printf expects that args has already
right align to be decoded and seq_buf_bprintf says ``the arguments are saved
in a 32bit word array that is defined by the format string constraints``.
So if we don't keep the align under copy to temporal buffer, the output
will be broken by shifting some bytes.

This patch fixes it.

Link: https://lkml.kernel.org/r/20201125225654.1618966-1-minchan@kernel.org

Cc: <stable@vger.kernel.org>
Fixes: 8e99cf91b99bb ("tracing: Do not allocate buffer in trace_find_next_entry() in atomic")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 410cfeb16db5..7d53c5bdea3e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3534,7 +3534,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 }
 
 #define STATIC_TEMP_BUF_SIZE	128
-static char static_temp_buf[STATIC_TEMP_BUF_SIZE];
+static char static_temp_buf[STATIC_TEMP_BUF_SIZE] __aligned(4);
 
 /* Find the next real entry, without updating the iterator itself */
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
-- 
2.28.0


