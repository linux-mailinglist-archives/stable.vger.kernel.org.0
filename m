Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BEA2A1791
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 14:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgJaNJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 09:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgJaNJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 09:09:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF49520723;
        Sat, 31 Oct 2020 13:09:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kYqdP-006Clw-7l; Sat, 31 Oct 2020 09:09:31 -0400
Message-ID: <20201031130931.062903467@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 31 Oct 2020 09:06:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [for-linus][PATCH 1/3] tracing: Fix out of bounds write in get_trace_buf
References: <20201031130642.971173960@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

The nesting count of trace_printk allows for 4 levels of nesting. The
nesting counter starts at zero and is incremented before being used to
retrieve the current context's buffer. But the index to the buffer uses the
nesting counter after it was incremented, and not its original number,
which in needs to do.

Link: https://lkml.kernel.org/r/20201029161905.4269-1-hqjagain@gmail.com

Cc: stable@vger.kernel.org
Fixes: 3d9622c12c887 ("tracing: Add barrier to trace_printk() buffer nesting modification")
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 528971714fc6..daa96215e294 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3132,7 +3132,7 @@ static char *get_trace_buf(void)
 
 	/* Interrupts must see nesting incremented before we use the buffer */
 	barrier();
-	return &buffer->buffer[buffer->nesting][0];
+	return &buffer->buffer[buffer->nesting - 1][0];
 }
 
 static void put_trace_buf(void)
-- 
2.28.0


