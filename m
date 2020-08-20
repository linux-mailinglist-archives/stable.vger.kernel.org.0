Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9688324B646
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgHTKTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731366AbgHTKTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:19:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50DF12067C;
        Thu, 20 Aug 2020 10:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918752;
        bh=0dL8pYVd9qMBr7zVzJoGqGXN8Z9c9tLEAYuKy1M5Sao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7m/U16TdyGLKiUpZ6bivOW1Jasf+OXXJmjyiY2zTUtozMHohQt4ELOWS60wc+nFh
         84FckLpFG5r4EuhlQlDajcAHjjctx/vYPHDIAhS5DQ9HMOVemvZizVWHL2q3zcmNjr
         NZtiM4I686bXnZtTFlA9HRqMADUeBauZOIGEKgZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Tim Murray <timmurray@google.com>,
        Simon MacMullen <simonmacm@google.com>,
        Greg Hackmann <ghackmann@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.4 054/149] tracepoint: Mark __tracepoint_strings __used
Date:   Thu, 20 Aug 2020 11:22:11 +0200
Message-Id: <20200820092128.347118822@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit f3751ad0116fb6881f2c3c957d66a9327f69cefb upstream.

__tracepoint_string's have their string data stored in .rodata, and an
address to that data stored in the "__tracepoint_str" section. Functions
that refer to those strings refer to the symbol of the address. Compiler
optimization can replace those address references with references
directly to the string data. If the address doesn't appear to have other
uses, then it appears dead to the compiler and is removed. This can
break the /tracing/printk_formats sysfs node which iterates the
addresses stored in the "__tracepoint_str" section.

Like other strings stored in custom sections in this header, mark these
__used to inform the compiler that there are other non-obvious users of
the address, so they should still be emitted.

Link: https://lkml.kernel.org/r/20200730224555.2142154-2-ndesaulniers@google.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 102c9323c35a8 ("tracing: Add __tracepoint_string() to export string pointers")
Reported-by: Tim Murray <timmurray@google.com>
Reported-by: Simon MacMullen <simonmacm@google.com>
Suggested-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/tracepoint.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -328,7 +328,7 @@ extern void syscall_unregfunc(void);
 		static const char *___tp_str __tracepoint_string = str; \
 		___tp_str;						\
 	})
-#define __tracepoint_string	__attribute__((section("__tracepoint_str")))
+#define __tracepoint_string	__attribute__((section("__tracepoint_str"), used))
 #else
 /*
  * tracepoint_string() is used to save the string address for userspace


