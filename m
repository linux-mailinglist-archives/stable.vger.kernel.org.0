Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576BB1C980E
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 19:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgEGRkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 13:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgEGRja (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 13:39:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFC9A21BE5;
        Thu,  7 May 2020 17:39:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jWkUa-000DmA-Ky; Thu, 07 May 2020 13:39:28 -0400
Message-ID: <20200507173928.535275446@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 07 May 2020 13:39:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-linus][PATCH 2/9] tracing/kprobes: Fix a double initialization typo
References: <20200507173904.729935165@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

Fix a typo that resulted in an unnecessary double
initialization to addr.

Link: http://lkml.kernel.org/r/158779374968.6082.2337484008464939919.stgit@devnote2

Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c7411a1a126f ("tracing/kprobe: Check whether the non-suffixed symbol is notrace")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index d0568af4a0ef..0d9300c3b084 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -453,7 +453,7 @@ static bool __within_notrace_func(unsigned long addr)
 
 static bool within_notrace_func(struct trace_kprobe *tk)
 {
-	unsigned long addr = addr = trace_kprobe_address(tk);
+	unsigned long addr = trace_kprobe_address(tk);
 	char symname[KSYM_NAME_LEN], *p;
 
 	if (!__within_notrace_func(addr))
-- 
2.26.2


