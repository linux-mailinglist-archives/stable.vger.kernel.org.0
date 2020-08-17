Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B632471E3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391275AbgHQSe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730981AbgHQP7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:59:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B803207FF;
        Mon, 17 Aug 2020 15:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679984;
        bh=/d13emKXOPJnq5GBTbPRguK+q5og1B4oQGfXbNOjAfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2Oku4ny/BhbWM1fKumb/8ZAgKSbD0C2qPJrP5b0U1fBrjU94wu/k4bYrl9cgETZR
         MxwWk2jUMEOBC14ajJNo7bxDCKgdwz7Rm8DksiGL8T5rrp2fbzkZq0wM6iygkvLdyY
         Nvtom6FXyTX2ipEzx2cgzRzfNxwb2fl3ySJLpzmU=
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
Subject: [PATCH 5.4 001/270] tracepoint: Mark __tracepoint_strings __used
Date:   Mon, 17 Aug 2020 17:13:22 +0200
Message-Id: <20200817143755.884559091@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -362,7 +362,7 @@ static inline struct tracepoint *tracepo
 		static const char *___tp_str __tracepoint_string = str; \
 		___tp_str;						\
 	})
-#define __tracepoint_string	__attribute__((section("__tracepoint_str")))
+#define __tracepoint_string	__attribute__((section("__tracepoint_str"), used))
 #else
 /*
  * tracepoint_string() is used to save the string address for userspace


