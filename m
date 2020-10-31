Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503C32A178B
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 14:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgJaNJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 09:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgJaNJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 09:09:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B85502071A;
        Sat, 31 Oct 2020 13:09:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kYqdP-006CmR-Ch; Sat, 31 Oct 2020 09:09:31 -0400
Message-ID: <20201031130931.265995362@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 31 Oct 2020 09:06:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 2/3] ftrace: Fix recursion check for NMI test
References: <20201031130642.971173960@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The code that checks recursion will work to only do the recursion check once
if there's nested checks. The top one will do the check, the other nested
checks will see recursion was already checked and return zero for its "bit".
On the return side, nothing will be done if the "bit" is zero.

The problem is that zero is returned for the "good" bit when in NMI context.
This will set the bit for NMIs making it look like *all* NMI tracing is
recursing, and prevent tracing of anything in NMI context!

The simple fix is to return "bit + 1" and subtract that bit on the end to
get the real bit.

Cc: stable@vger.kernel.org
Fixes: edc15cafcbfa3 ("tracing: Avoid unnecessary multiple recursion checks")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f3f5e77123ad..fee535a89560 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -698,7 +698,7 @@ static __always_inline int trace_test_and_set_recursion(int start, int max)
 	current->trace_recursion = val;
 	barrier();
 
-	return bit;
+	return bit + 1;
 }
 
 static __always_inline void trace_clear_recursion(int bit)
@@ -708,6 +708,7 @@ static __always_inline void trace_clear_recursion(int bit)
 	if (!bit)
 		return;
 
+	bit--;
 	bit = 1 << bit;
 	val &= ~bit;
 
-- 
2.28.0


