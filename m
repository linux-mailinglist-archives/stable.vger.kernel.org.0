Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2B744183A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhKAJpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232682AbhKAJlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:41:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 154D061378;
        Mon,  1 Nov 2021 09:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758898;
        bh=J/h0LxKY1yQH+pyzD7ICnpz3StfVqR+HLLpc4504Vvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMhTquQbca/WImKtG2OoiKv1wP4EefBPthDzS/QxSOYwmCHTJqAn48alJoHk5rhgN
         eWcsfmd0QDY7LtXyth1DDNW8RI7S9IMLC+yWlPNnFb5KKA+4tlgEgrwGD1PsPjMrO+
         RZ8Fwg+N+Uq8+KYlpPvBmXicq2n96HYi1hJTWRdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.14 028/125] ftrace/nds32: Update the proto for ftrace_trace_function to match ftrace_stub
Date:   Mon,  1 Nov 2021 10:16:41 +0100
Message-Id: <20211101082538.718189671@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 4e84dc47bb48accbbeeba4e6bb3f31aa7895323c upstream.

The ftrace callback prototype was changed to pass a special ftrace_regs
instead of pt_regs as the last parameter, but the static ftrace for nds32
missed updating ftrace_trace_function and this caused a warning when
compared to ftrace_stub:

../arch/nds32/kernel/ftrace.c: In function '_mcount':
../arch/nds32/kernel/ftrace.c:24:35: error: comparison of distinct pointer types lacks a cast [-Werror]
   24 |         if (ftrace_trace_function != ftrace_stub)
      |                                   ^~

Link: https://lore.kernel.org/all/20211027055554.19372-1-rdunlap@infradead.org/
Link: https://lkml.kernel.org/r/20211027125101.33449969@gandalf.local.home

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Fixes: d19ad0775dcd6 ("ftrace: Have the callbacks receive a struct ftrace_regs instead of pt_regs")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nds32/kernel/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/nds32/kernel/ftrace.c
+++ b/arch/nds32/kernel/ftrace.c
@@ -6,7 +6,7 @@
 
 #ifndef CONFIG_DYNAMIC_FTRACE
 extern void (*ftrace_trace_function)(unsigned long, unsigned long,
-				     struct ftrace_ops*, struct pt_regs*);
+				     struct ftrace_ops*, struct ftrace_regs*);
 extern void ftrace_graph_caller(void);
 
 noinline void __naked ftrace_stub(unsigned long ip, unsigned long parent_ip,


