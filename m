Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67B9378557
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhEJLAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234110AbhEJKzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98AA561956;
        Mon, 10 May 2021 10:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643439;
        bh=bbNokWG/OOTmYxR7K9p8wj7ATK+qZNNE29KRCIpvPAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuC/TWcDTA3+Bjale8IfoA5skOkLnDBPuB1rYXZ4HqZroLyMqkiLqY/pHpJsXWMlJ
         6lP/R8WURbS7cqwgOCPLKmv+lR6bjuF7JvS2dIsT/6LKH0VbXdlbpwRUm5/VrID88G
         huheCngK3KJoE93/OirRTbGtbi1iMMc9Kuukzad8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.11 016/342] ftrace: Handle commands when closing set_ftrace_filter file
Date:   Mon, 10 May 2021 12:16:46 +0200
Message-Id: <20210510102010.639536420@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
@@ -5631,7 +5631,10 @@ int ftrace_regex_release(struct inode *i
 
 	parser = &iter->parser;
 	if (trace_parser_loaded(parser)) {
-		ftrace_match_records(iter->hash, parser->buffer, parser->idx);
+		int enable = !(iter->flags & FTRACE_ITER_NOTRACE);
+
+		ftrace_process_regex(iter, parser->buffer,
+				     parser->idx, enable);
 	}
 
 	trace_parser_put(parser);


