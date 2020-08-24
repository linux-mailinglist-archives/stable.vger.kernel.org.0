Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7283324F82C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgHXIwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730078AbgHXIwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:52:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 733582072D;
        Mon, 24 Aug 2020 08:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259137;
        bh=IF5nfiHipkq+Pu0fcMTYDw8w2uTN6DtQ/0OPb5Wh6Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viCVitd7x1BshNUotRfHfQYjEKbKGCTWkDuLoYNkHFKw4fNgDfki1kR6Z99Qpvbw1
         HvhEdVKE6Wssuy13sMcbs4A545bW7l/UkRSG6cF5PLLh/8D3etk68xRvPgVnqgqnAR
         H+XXkZL363XgMm4JZNTSpiPEn/ffjATCedJ7cjhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/39] tracing: Clean up the hwlat binding code
Date:   Mon, 24 Aug 2020 10:31:04 +0200
Message-Id: <20200824082348.745810260@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082348.445866152@linuxfoundation.org>
References: <20200824082348.445866152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit f447c196fe7a3a92c6396f7628020cb8d564be15 ]

Instead of initializing the affinity of the hwlat kthread in the thread
itself, simply set up the initial affinity at thread creation. This
simplifies the code.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_hwlat.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index 5fe23f0ee7db6..158af5ddbc3aa 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -268,24 +268,13 @@ out:
 static struct cpumask save_cpumask;
 static bool disable_migrate;
 
-static void move_to_next_cpu(bool initmask)
+static void move_to_next_cpu(void)
 {
-	static struct cpumask *current_mask;
+	struct cpumask *current_mask = &save_cpumask;
 	int next_cpu;
 
 	if (disable_migrate)
 		return;
-
-	/* Just pick the first CPU on first iteration */
-	if (initmask) {
-		current_mask = &save_cpumask;
-		get_online_cpus();
-		cpumask_and(current_mask, cpu_online_mask, tracing_buffer_mask);
-		put_online_cpus();
-		next_cpu = cpumask_first(current_mask);
-		goto set_affinity;
-	}
-
 	/*
 	 * If for some reason the user modifies the CPU affinity
 	 * of this thread, than stop migrating for the duration
@@ -302,7 +291,6 @@ static void move_to_next_cpu(bool initmask)
 	if (next_cpu >= nr_cpu_ids)
 		next_cpu = cpumask_first(current_mask);
 
- set_affinity:
 	if (next_cpu >= nr_cpu_ids) /* Shouldn't happen! */
 		goto disable;
 
@@ -332,12 +320,10 @@ static void move_to_next_cpu(bool initmask)
 static int kthread_fn(void *data)
 {
 	u64 interval;
-	bool initmask = true;
 
 	while (!kthread_should_stop()) {
 
-		move_to_next_cpu(initmask);
-		initmask = false;
+		move_to_next_cpu();
 
 		local_irq_disable();
 		get_sample();
@@ -368,13 +354,27 @@ static int kthread_fn(void *data)
  */
 static int start_kthread(struct trace_array *tr)
 {
+	struct cpumask *current_mask = &save_cpumask;
 	struct task_struct *kthread;
+	int next_cpu;
+
+	/* Just pick the first CPU on first iteration */
+	current_mask = &save_cpumask;
+	get_online_cpus();
+	cpumask_and(current_mask, cpu_online_mask, tracing_buffer_mask);
+	put_online_cpus();
+	next_cpu = cpumask_first(current_mask);
 
 	kthread = kthread_create(kthread_fn, NULL, "hwlatd");
 	if (IS_ERR(kthread)) {
 		pr_err(BANNER "could not start sampling thread\n");
 		return -ENOMEM;
 	}
+
+	cpumask_clear(current_mask);
+	cpumask_set_cpu(next_cpu, current_mask);
+	sched_setaffinity(kthread->pid, current_mask);
+
 	hwlat_kthread = kthread;
 	wake_up_process(kthread);
 
-- 
2.25.1



