Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A58438A889
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbhETKvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238452AbhETKsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:48:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39B7161CBB;
        Thu, 20 May 2021 09:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504738;
        bh=Ab0KjWe/3oPlBT00cEJsIbOdiOuPeGiXJsW6+7XFwbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kurvXe9KZlNFHfCILp3MemrhkxcLdH5yfaO/JUx5Fq4KniFTdkItZOcVaCZYqrkCI
         lTN1a3dcztu2p077GEY5BWmi3aOoQ+yVysuiJyxomT1YQrxUpjyMWyWQWn1Fz0iNvk
         STiicMV1hCMAyn5Xb9BaAR0xFNAS5GGa3gvpyv7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 058/240] ftrace: Handle commands when closing set_ftrace_filter file
Date:   Thu, 20 May 2021 11:20:50 +0200
Message-Id: <20210520092110.638571049@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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


