Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C6E38A683
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbhETK1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236349AbhETKZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:25:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2345761480;
        Thu, 20 May 2021 09:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504195;
        bh=qivATiHf16OvUEzdc6XayNzgWAB5IFNxqPbnfVlp3n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p44P0yZWJMy7f4iY1K9UuThyyfrgrv0y8HdJTnZ+LSaFiclvDfRQo62Gk1cOoyPIV
         oJrTdk87LQYLqqSx8YqbbIgS6/COm9qIe8svnlUDO8Rk+dcwxK+Qelp81LPCi6agPj
         C71EUAmlPhpcvi6Pyax2XBh9wROCJKoYknhJC3+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 091/323] ftrace: Handle commands when closing set_ftrace_filter file
Date:   Thu, 20 May 2021 11:19:43 +0200
Message-Id: <20210520092123.215653929@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 8c9af478c06bb1ab1422f90d8ecbc53defd44bc3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5096,8 +5096,11 @@ int ftrace_regex_release(struct inode *i
 
 	parser = &iter->parser;
 	if (trace_parser_loaded(parser)) {
+		int enable = !(iter->flags & FTRACE_ITER_NOTRACE);
+
 		parser->buffer[parser->idx] = 0;
-		ftrace_match_records(iter->hash, parser->buffer, parser->idx);
+		ftrace_process_regex(iter, parser->buffer,
+				     parser->idx, enable);
 	}
 
 	trace_parser_put(parser);


