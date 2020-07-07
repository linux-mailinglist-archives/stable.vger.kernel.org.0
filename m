Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A2621718A
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgGGPVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgGGPVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:21:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 631B92065D;
        Tue,  7 Jul 2020 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135298;
        bh=XTimTEqhE29dFUv3QdkSkPZe+dBL0kqNKWi0Km7x8j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDEiCxN8PQPcgEcidX1TDCvaFDy70+KcKc3kvCpV593AP4MpJmF/DCfkqGUgttbJv
         1ugy7GloSC0IlOlFjdZNl6d1DiSDBZM847+HMmGcGNCUPS7H7EMwNL9Cqmq1kFfOzj
         CUk65A5u46g35fOTEq3AaveSfY0mBisiB6OCCe4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.4 34/65] kthread: save thread function
Date:   Tue,  7 Jul 2020 17:17:13 +0200
Message-Id: <20200707145754.124544082@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 52782c92ac85c4e393eb4a903a62e6c24afa633f ]

It's handy to keep the kthread_fn just as a unique cookie to identify
classes of kthreads.  E.g. if you can verify that a given task is
running your thread_fn, then you may know what sort of type kthread_data
points to.

We'll use this in nfsd to pass some information into the vfs.  Note it
will need kthread_data() exported too.

Original-patch-by: Tejun Heo <tj@kernel.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kthread.h |  1 +
 kernel/kthread.c        | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 0f9da966934e2..59bbc63ff8637 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -57,6 +57,7 @@ bool kthread_should_stop(void);
 bool kthread_should_park(void);
 bool __kthread_should_park(struct task_struct *k);
 bool kthread_freezable_should_stop(bool *was_frozen);
+void *kthread_func(struct task_struct *k);
 void *kthread_data(struct task_struct *k);
 void *kthread_probe_data(struct task_struct *k);
 int kthread_park(struct task_struct *k);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index b262f47046ca4..543dff6b576c7 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -46,6 +46,7 @@ struct kthread_create_info
 struct kthread {
 	unsigned long flags;
 	unsigned int cpu;
+	int (*threadfn)(void *);
 	void *data;
 	struct completion parked;
 	struct completion exited;
@@ -152,6 +153,20 @@ bool kthread_freezable_should_stop(bool *was_frozen)
 }
 EXPORT_SYMBOL_GPL(kthread_freezable_should_stop);
 
+/**
+ * kthread_func - return the function specified on kthread creation
+ * @task: kthread task in question
+ *
+ * Returns NULL if the task is not a kthread.
+ */
+void *kthread_func(struct task_struct *task)
+{
+	if (task->flags & PF_KTHREAD)
+		return to_kthread(task)->threadfn;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(kthread_func);
+
 /**
  * kthread_data - return data value specified on kthread creation
  * @task: kthread task in question
@@ -164,6 +179,7 @@ void *kthread_data(struct task_struct *task)
 {
 	return to_kthread(task)->data;
 }
+EXPORT_SYMBOL_GPL(kthread_data);
 
 /**
  * kthread_probe_data - speculative version of kthread_data()
@@ -237,6 +253,7 @@ static int kthread(void *_create)
 		do_exit(-ENOMEM);
 	}
 
+	self->threadfn = threadfn;
 	self->data = data;
 	init_completion(&self->exited);
 	init_completion(&self->parked);
-- 
2.25.1



