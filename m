Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F2C131A4A
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 22:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgAFVT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 16:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgAFVT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 16:19:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC6B82081E;
        Mon,  6 Jan 2020 21:19:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1ioZn3-000MV1-Si; Mon, 06 Jan 2020 16:19:57 -0500
Message-Id: <20200106211957.757088760@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 06 Jan 2020 16:19:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>
Subject: [for-linus][PATCH 1/7] tracing: Initialize val to zero in parse_entry of inject code
References: <20200106211901.293910946@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

gcc produces a variable may be uninitialized warning for "val" in
parse_entry(). This is really a false positive, but the code is subtle
enough to just initialize val to zero and it's not a fast path to worry
about it.

Marked for stable to remove the warning in the stable trees as well.

Cc: stable@vger.kernel.org
Fixes: 6c3edaf9fd6a3 ("tracing: Introduce trace event injection")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_inject.c b/kernel/trace/trace_events_inject.c
index d45079ee62f8..22bcf7c51d1e 100644
--- a/kernel/trace/trace_events_inject.c
+++ b/kernel/trace/trace_events_inject.c
@@ -195,7 +195,7 @@ static int parse_entry(char *str, struct trace_event_call *call, void **pentry)
 	unsigned long irq_flags;
 	void *entry = NULL;
 	int entry_size;
-	u64 val;
+	u64 val = 0;
 	int len;
 
 	entry = trace_alloc_entry(call, &entry_size);
-- 
2.24.0


