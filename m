Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B964C2F5887
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 04:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbhANCiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 21:38:54 -0500
Received: from m12-11.163.com ([220.181.12.11]:52837 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbhANCix (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 21:38:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=dYhSC
        BtK7IgBAyN5CS8nFvDn+yQSu9qC8x4eVknweMM=; b=P7I1QVxjzQ8uZHBplMfzS
        XxZCdXmjPvQVYt4+HI7j5/YRWQjHwi2GLkkAh7J9VDBD8I1YNUuVKu1+aShUIpgJ
        EfaZrWYPQd5UJLIJ3cVXFzxyg8IQPlDv0C7ns2kLwQKlbU4eR6hBNQFC7m8tJKYx
        Q8RuILzmTKtot1/wgbyQJg=
Received: from COOL-20200911ZP.ccdomain.com (unknown [218.94.48.178])
        by smtp7 (Coremail) with SMTP id C8CowADHgbEirv9ffk7VIg--.47833S2;
        Thu, 14 Jan 2021 10:36:31 +0800 (CST)
From:   ChunyouTang <tangchunyou@163.com>
To:     tangchunyou@yulong.com
Cc:     tangchunyou@163.com, Masami Hiramatsu <mhiramat@kernel.org>,
        stable@vger.kernel.org,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] tracing/kprobes: Do the notrace functions check without kprobes on ftrace
Date:   Thu, 14 Jan 2021 10:36:27 +0800
Message-Id: <20210114023627.1555-1-tangchunyou@163.com>
X-Mailer: git-send-email 2.30.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowADHgbEirv9ffk7VIg--.47833S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw4kur18Gr1DKrWxtryrWFg_yoW8tFy5pF
        9rArnIgr4UJF45t3y09w1v9ry7Aw4DAryakF1DJw1rXr95Jw4UXrnF9r4qq3s5tryfKaya
        yFWUuFyUKay7ZrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRP73QUUUUU=
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5wdqwu5kxq50rx6rljoofrz/1tbipREaUVUMb0eSiQAAsV
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

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
---
 kernel/trace/Kconfig        | 2 +-
 kernel/trace/trace_kprobe.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d5a19413d4f8..c1a62ae7e812 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -538,7 +538,7 @@ config KPROBE_EVENTS
 config KPROBE_EVENTS_ON_NOTRACE
 	bool "Do NOT protect notrace function from kprobe events"
 	depends on KPROBE_EVENTS
-	depends on KPROBES_ON_FTRACE
+	depends on DYNAMIC_FTRACE
 	default n
 	help
 	  This is only for the developers who want to debug ftrace itself
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9c31f42245e9..e6fba1798771 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -434,7 +434,7 @@ static int disable_trace_kprobe(struct trace_event_call *call,
 	return 0;
 }
 
-#if defined(CONFIG_KPROBES_ON_FTRACE) && \
+#if defined(CONFIG_DYNAMIC_FTRACE) && \
 	!defined(CONFIG_KPROBE_EVENTS_ON_NOTRACE)
 static bool __within_notrace_func(unsigned long addr)
 {
-- 
2.30.0.windows.1

