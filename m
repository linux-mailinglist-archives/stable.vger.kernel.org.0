Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCEFDFD641
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfKOGW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:52544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbfKOGW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:56 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1686220728;
        Fri, 15 Nov 2019 06:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798975;
        bh=86jP8+z4QVaY3vIZpq/BJ2ilc7/qqeYkiwVfgqiBJJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J61hdkU880VNqtww0mpMMW13wINAy/z97YyGqSyoENCYBu75/WJ9qF+XZwrpELZHt
         9u3weHNiAdY7TzHVyX1QTIOpTEsDULdffhBW0knX5iKsoKxqKUM7MwXSrOVMuyIp8C
         TGUGfQUGl1Ad4lEwuSSWfOaD8r1OnZ44mMms8Z84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 29/31] kvm: Add helper function for creating VM worker threads
Date:   Fri, 15 Nov 2019 14:20:58 +0800
Message-Id: <20191115062020.017377287@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

commit c57c80467f90e5504c8df9ad3555d2c78800bf94 upstream.

Add a function to create a kernel thread associated with a given VM. In
particular, it ensures that the worker thread inherits the priority and
cgroups of the calling thread.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_host.h |    6 +++
 virt/kvm/kvm_main.c      |   84 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1208,4 +1208,10 @@ static inline bool vcpu_valid_wakeup(str
 }
 #endif /* CONFIG_HAVE_KVM_INVALID_WAKEUPS */
 
+typedef int (*kvm_vm_thread_fn_t)(struct kvm *kvm, uintptr_t data);
+
+int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
+				uintptr_t data, const char *name,
+				struct task_struct **thread_ptr);
+
 #endif
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -49,6 +49,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
+#include <linux/kthread.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -3987,3 +3988,86 @@ void kvm_exit(void)
 	kvm_vfio_ops_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
+
+struct kvm_vm_worker_thread_context {
+	struct kvm *kvm;
+	struct task_struct *parent;
+	struct completion init_done;
+	kvm_vm_thread_fn_t thread_fn;
+	uintptr_t data;
+	int err;
+};
+
+static int kvm_vm_worker_thread(void *context)
+{
+	/*
+	 * The init_context is allocated on the stack of the parent thread, so
+	 * we have to locally copy anything that is needed beyond initialization
+	 */
+	struct kvm_vm_worker_thread_context *init_context = context;
+	struct kvm *kvm = init_context->kvm;
+	kvm_vm_thread_fn_t thread_fn = init_context->thread_fn;
+	uintptr_t data = init_context->data;
+	int err;
+
+	err = kthread_park(current);
+	/* kthread_park(current) is never supposed to return an error */
+	WARN_ON(err != 0);
+	if (err)
+		goto init_complete;
+
+	err = cgroup_attach_task_all(init_context->parent, current);
+	if (err) {
+		kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
+			__func__, err);
+		goto init_complete;
+	}
+
+	set_user_nice(current, task_nice(init_context->parent));
+
+init_complete:
+	init_context->err = err;
+	complete(&init_context->init_done);
+	init_context = NULL;
+
+	if (err)
+		return err;
+
+	/* Wait to be woken up by the spawner before proceeding. */
+	kthread_parkme();
+
+	if (!kthread_should_stop())
+		err = thread_fn(kvm, data);
+
+	return err;
+}
+
+int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
+				uintptr_t data, const char *name,
+				struct task_struct **thread_ptr)
+{
+	struct kvm_vm_worker_thread_context init_context = {};
+	struct task_struct *thread;
+
+	*thread_ptr = NULL;
+	init_context.kvm = kvm;
+	init_context.parent = current;
+	init_context.thread_fn = thread_fn;
+	init_context.data = data;
+	init_completion(&init_context.init_done);
+
+	thread = kthread_run(kvm_vm_worker_thread, &init_context,
+			     "%s-%d", name, task_pid_nr(current));
+	if (IS_ERR(thread))
+		return PTR_ERR(thread);
+
+	/* kthread_run is never supposed to return NULL */
+	WARN_ON(thread == NULL);
+
+	wait_for_completion(&init_context.init_done);
+
+	if (!init_context.err)
+		*thread_ptr = thread;
+
+	return init_context.err;
+}


