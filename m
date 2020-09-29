Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60DE27C779
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbgI2Lpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729724AbgI2Lp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F40CA206E5;
        Tue, 29 Sep 2020 11:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379926;
        bh=3G74lMHIvO2jqUSsc3xQbKaOeDcz4Un0sJZvzINicxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aevQEA4//fERMFZsgnzHxuQu4RY0/DHPscVXNq5fVlP+Fr+Gn7YlF8pY7Lu1SaWaO
         vZ0ypJQqg+mL+K9TMIYIJSNPtgVj0w9pU1EXT+2yggwGltgi/ugfLJIJ8fHHcBcut/
         b16UrwP36KpZd5MmVGPuqKL5G+neaCUGEPkFmGXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 377/388] kprobes: tracing/kprobes: Fix to kill kprobes on initmem after boot
Date:   Tue, 29 Sep 2020 13:01:48 +0200
Message-Id: <20200929110028.712621169@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 82d083ab60c3693201c6f5c7a5f23a6ed422098d upstream.

Since kprobe_event= cmdline option allows user to put kprobes on the
functions in initmem, kprobe has to make such probes gone after boot.
Currently the probes on the init functions in modules will be handled
by module callback, but the kernel init text isn't handled.
Without this, kprobes may access non-exist text area to disable or
remove it.

Link: https://lkml.kernel.org/r/159972810544.428528.1839307531600646955.stgit@devnote2

Fixes: 970988e19eb0 ("tracing/kprobe: Add kprobe_event= boot parameter")
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kprobes.h |    5 +++++
 init/main.c             |    2 ++
 kernel/kprobes.c        |   22 ++++++++++++++++++++++
 3 files changed, 29 insertions(+)

--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -369,6 +369,8 @@ void unregister_kretprobes(struct kretpr
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
 
+void kprobe_free_init_mem(void);
+
 int disable_kprobe(struct kprobe *kp);
 int enable_kprobe(struct kprobe *kp);
 
@@ -426,6 +428,9 @@ static inline void unregister_kretprobes
 static inline void kprobe_flush_task(struct task_struct *tk)
 {
 }
+static inline void kprobe_free_init_mem(void)
+{
+}
 static inline int disable_kprobe(struct kprobe *kp)
 {
 	return -ENOSYS;
--- a/init/main.c
+++ b/init/main.c
@@ -32,6 +32,7 @@
 #include <linux/nmi.h>
 #include <linux/percpu.h>
 #include <linux/kmod.h>
+#include <linux/kprobes.h>
 #include <linux/vmalloc.h>
 #include <linux/kernel_stat.h>
 #include <linux/start_kernel.h>
@@ -1111,6 +1112,7 @@ static int __ref kernel_init(void *unuse
 	kernel_init_freeable();
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
+	kprobe_free_init_mem();
 	ftrace_free_init_mem();
 	free_initmem();
 	mark_readonly();
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2309,6 +2309,28 @@ static struct notifier_block kprobe_modu
 extern unsigned long __start_kprobe_blacklist[];
 extern unsigned long __stop_kprobe_blacklist[];
 
+void kprobe_free_init_mem(void)
+{
+	void *start = (void *)(&__init_begin);
+	void *end = (void *)(&__init_end);
+	struct hlist_head *head;
+	struct kprobe *p;
+	int i;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* Kill all kprobes on initmem */
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry(p, head, hlist) {
+			if (start <= (void *)p->addr && (void *)p->addr < end)
+				kill_kprobe(p);
+		}
+	}
+
+	mutex_unlock(&kprobe_mutex);
+}
+
 static int __init init_kprobes(void)
 {
 	int i, err = 0;


