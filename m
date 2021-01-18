Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922DA2FAADE
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 21:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437696AbhART6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390385AbhARLhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:37:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E74C8223DB;
        Mon, 18 Jan 2021 11:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969763;
        bh=7maAhltJ5Z5JyNXUAOleDHb3F61gQUILqKDye9c6jOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJePsrIlVdAyb45tEf6Lp8ls6W06JZC8jccYEyh2zLETnaZ+3uuKorr0IxQcYpf5Q
         GZ78WUQxfFiuw232sqtqfo60xiOO39Ht3prHcp4/rrgHbUAys3ONEQWbxjFTkxJUY1
         I3PHYbZkp74qzHwms63NJB16vO51pwp4pua0dyCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 03/43] tracing/kprobes: Do the notrace functions check without kprobes on ftrace
Date:   Mon, 18 Jan 2021 12:34:26 +0100
Message-Id: <20210118113335.133250737@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 7bb83f6fc4ee84e95d0ac0d14452c2619fb3fe70 upstream.

Enable the notrace function check on the architecture which doesn't
support kprobes on ftrace but support dynamic ftrace. This notrace
function check is not only for the kprobes on ftrace but also
sw-breakpoint based kprobes.
Thus there is no reason to limit this check for the arch which
supports kprobes on ftrace.

This also changes the dependency of Kconfig. Because kprobe event
uses the function tracer's address list for identifying notrace
function, if the CONFIG_DYNAMIC_FTRACE=n, it can not check whether
the target function is notrace or not.

Link: https://lkml.kernel.org/r/20210105065730.2634785-1-naveen.n.rao@linux.vnet.ibm.com
Link: https://lkml.kernel.org/r/161007957862.114704.4512260007555399463.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 45408c4f92506 ("tracing: kprobes: Prohibit probing on notrace function")
Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/Kconfig        |    2 +-
 kernel/trace/trace_kprobe.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -476,7 +476,7 @@ config KPROBE_EVENTS
 config KPROBE_EVENTS_ON_NOTRACE
 	bool "Do NOT protect notrace function from kprobe events"
 	depends on KPROBE_EVENTS
-	depends on KPROBES_ON_FTRACE
+	depends on DYNAMIC_FTRACE
 	default n
 	help
 	  This is only for the developers who want to debug ftrace itself
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -517,7 +517,7 @@ disable_trace_kprobe(struct trace_kprobe
 	return ret;
 }
 
-#if defined(CONFIG_KPROBES_ON_FTRACE) && \
+#if defined(CONFIG_DYNAMIC_FTRACE) && \
 	!defined(CONFIG_KPROBE_EVENTS_ON_NOTRACE)
 static bool __within_notrace_func(unsigned long addr)
 {


