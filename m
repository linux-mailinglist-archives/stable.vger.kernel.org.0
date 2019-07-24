Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761AD73E7B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389290AbfGXTjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389939AbfGXTja (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8197229F3;
        Wed, 24 Jul 2019 19:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997170;
        bh=qIUI0Na8vCijcEjObETvQCA0O1xN6Q4ok4GitC6WA3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+1nZAhNUyurQ/0+ih4vN1cpl0KcT7sYzQDksrNjxryJ9V5U1/gLCe3+2c1AEhCU6
         OkW8A+uyVPnVjhDqeffa/RiT3vDwMkQTgVHwSbXD32ZkG2/9sH2obaDYgNviFHxrxN
         zyQ4t0ysXEu8KtXhWwHkBvsjPB0Zi5GmDsXcP3T4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eiichi Tsukata <devel@etsukata.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.2 303/413] tracing: Fix user stack trace "??" output
Date:   Wed, 24 Jul 2019 21:19:54 +0200
Message-Id: <20190724191757.558048310@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <devel@etsukata.com>

commit 6d54ceb539aacc3df65c89500e8b045924f3ef81 upstream.

Commit c5c27a0a5838 ("x86/stacktrace: Remove the pointless ULONG_MAX
marker") removes ULONG_MAX marker from user stack trace entries but
trace_user_stack_print() still uses the marker and it outputs unnecessary
"??".

For example:

            less-1911  [001] d..2    34.758944: <user stack trace>
   =>  <00007f16f2295910>
   => ??
   => ??
   => ??
   => ??
   => ??
   => ??
   => ??

The user stack trace code zeroes the storage before saving the stack, so if
the trace is shorter than the maximum number of entries it can terminate
the print loop if a zero entry is detected.

Link: http://lkml.kernel.org/r/20190630085438.25545-1-devel@etsukata.com

Cc: stable@vger.kernel.org
Fixes: 4285f2fcef80 ("tracing: Remove the ULONG_MAX stack trace hackery")
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_output.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1109,17 +1109,10 @@ static enum print_line_t trace_user_stac
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 		unsigned long ip = field->caller[i];
 
-		if (ip == ULONG_MAX || trace_seq_has_overflowed(s))
+		if (!ip || trace_seq_has_overflowed(s))
 			break;
 
 		trace_seq_puts(s, " => ");
-
-		if (!ip) {
-			trace_seq_puts(s, "??");
-			trace_seq_putc(s, '\n');
-			continue;
-		}
-
 		seq_print_user_ip(s, mm, ip, flags);
 		trace_seq_putc(s, '\n');
 	}


