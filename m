Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A496376AD4
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 21:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhEGTo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 15:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhEGTo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 15:44:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C66E61426;
        Fri,  7 May 2021 19:43:26 +0000 (UTC)
Date:   Fri, 7 May 2021 15:43:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ftrace: Handle commands when closing
 set_ftrace_filter file" failed to apply to 4.9-stable tree
Message-ID: <20210507154324.4c4a2714@gandalf.local.home>
In-Reply-To: <162039547465171@kroah.com>
References: <162039547465171@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 07 May 2021 15:51:14 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 

This works for both 4.9 and 4.4.

-- Steve


>From 8c9af478c06bb1ab1422f90d8ecbc53defd44bc3 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Wed, 5 May 2021 10:38:24 -0400
Subject: [PATCH] ftrace: Handle commands when closing set_ftrace_filter file

 # echo switch_mm:traceoff > /sys/kernel/tracing/set_ftrace_filter

will cause switch_mm to stop tracing by the traceoff command.

 # echo -n switch_mm:traceoff > /sys/kernel/tracing/set_ftrace_filter

does nothing.

The reason is that the parsing in the write function only processes
commands if it finished parsing (there is white space written after the
command). That's to handle:

 write(fd, "switch_mm:", 10);
 write(fd, "traceoff", 8);

cases, where the command is broken over multiple writes.

The problem is if the file descriptor is closed, then the write call is
not processed, and the command needs to be processed in the release code.
The release code can handle matching of functions, but does not handle
commands.

Cc: stable@vger.kernel.org
Fixes: eda1e32855656 ("tracing: handle broken names in ftrace filter")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/kernel/trace/ftrace.c
===================================================================
--- linux-test.git.orig/kernel/trace/ftrace.c
+++ linux-test.git/kernel/trace/ftrace.c
@@ -4486,8 +4486,11 @@ int ftrace_regex_release(struct inode *i
 
 	parser = &iter->parser;
 	if (trace_parser_loaded(parser)) {
+		int enable = !(iter->flags & FTRACE_ITER_NOTRACE);
+
 		parser->buffer[parser->idx] = 0;
-		ftrace_match_records(iter->hash, parser->buffer, parser->idx);
+		ftrace_process_regex(iter->hash, parser->buffer,
+				     parser->idx, enable);
 	}
 
 	trace_parser_put(parser);
