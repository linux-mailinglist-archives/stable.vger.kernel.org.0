Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615D3329210
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243623AbhCAUij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:38:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242190AbhCAUbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:31:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFFB264EFC;
        Mon,  1 Mar 2021 18:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622129;
        bh=XzzrrzqM/QAmJDO9/h9kFE/WyVMMOFQjF28RpQ7x6YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqbFMUeybX/3q+ml/3u+jYDyTTdJwxwueYdu70Z30tpMiEsSUCNIImj7PdOp79Uiv
         zTEir/xXVqOdDwMBiC7ylqX4NCeRsdwA2OaVzT+oLl7zsFkhfds4mgQP/rvYRTcJrL
         56AXEnkV0T/Lncu9jNFbZwMgy8e/e9N/XCKud05o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 768/775] kgdb: fix to kill breakpoints on initmem after boot
Date:   Mon,  1 Mar 2021 17:15:36 +0100
Message-Id: <20210301161239.264500655@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Garg <sumit.garg@linaro.org>

commit d54ce6158e354f5358a547b96299ecd7f3725393 upstream.

Currently breakpoints in kernel .init.text section are not handled
correctly while allowing to remove them even after corresponding pages
have been freed.

Fix it via killing .init.text section breakpoints just prior to initmem
pages being freed.

Doug: "HW breakpoints aren't handled by this patch but it's probably
not such a big deal".

Link: https://lkml.kernel.org/r/20210224081652.587785-1-sumit.garg@linaro.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Suggested-by: Doug Anderson <dianders@chromium.org>
Acked-by: Doug Anderson <dianders@chromium.org>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kgdb.h      |    2 ++
 init/main.c               |    1 +
 kernel/debug/debug_core.c |   11 +++++++++++
 3 files changed, 14 insertions(+)

--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -360,9 +360,11 @@ extern atomic_t			kgdb_active;
 extern bool dbg_is_early;
 extern void __init dbg_late_init(void);
 extern void kgdb_panic(const char *msg);
+extern void kgdb_free_init_mem(void);
 #else /* ! CONFIG_KGDB */
 #define in_dbg_master() (0)
 #define dbg_late_init()
 static inline void kgdb_panic(const char *msg) {}
+static inline void kgdb_free_init_mem(void) { }
 #endif /* ! CONFIG_KGDB */
 #endif /* _KGDB_H_ */
--- a/init/main.c
+++ b/init/main.c
@@ -1423,6 +1423,7 @@ static int __ref kernel_init(void *unuse
 	async_synchronize_full();
 	kprobe_free_init_mem();
 	ftrace_free_init_mem();
+	kgdb_free_init_mem();
 	free_initmem();
 	mark_readonly();
 
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -456,6 +456,17 @@ setundefined:
 	return 0;
 }
 
+void kgdb_free_init_mem(void)
+{
+	int i;
+
+	/* Clear init memory breakpoints. */
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (init_section_contains((void *)kgdb_break[i].bpt_addr, 0))
+			kgdb_break[i].state = BP_UNDEFINED;
+	}
+}
+
 #ifdef CONFIG_KGDB_KDB
 void kdb_dump_stack_on_cpu(int cpu)
 {


