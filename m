Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3162D047F
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgLFLqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:46:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729617AbgLFLqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:46:04 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.9 43/46] tracing: Fix alignment of static buffer
Date:   Sun,  6 Dec 2020 12:17:51 +0100
Message-Id: <20201206111558.535748209@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

commit 8fa655a3a0013a0c2a2aada6f39a93ee6fc25549 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3516,7 +3516,7 @@ __find_next_entry(struct trace_iterator
 }
 
 #define STATIC_TEMP_BUF_SIZE	128
-static char static_temp_buf[STATIC_TEMP_BUF_SIZE];
+static char static_temp_buf[STATIC_TEMP_BUF_SIZE] __aligned(4);
 
 /* Find the next real entry, without updating the iterator itself */
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,


