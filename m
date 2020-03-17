Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6068188085
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgCQLKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729109AbgCQLKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:10:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6166520658;
        Tue, 17 Mar 2020 11:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443438;
        bh=LOwO1tNMBcdQgjkXNiDY+TMnSmzF8tRAF1qDoS8uw5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEpaiBZynaNf7O+YDhTkU+QRJxq+dojkryw/Cr/TLX5Zo7/xmAfZwq6AXZsnjLo9m
         Ba3QE/OT3Lp4bWXrz5P/DG8Q7BTQNYvW3GwVIjQVLhCvB9qIJetm0w/1PGMEEKSByY
         zK+AiooRu+EKE6RGjqOsfdotGqfFrzBDdUsZe154=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: [PATCH 5.5 083/151] workqueue: dont use wq_select_unbound_cpu() for bound works
Date:   Tue, 17 Mar 2020 11:54:53 +0100
Message-Id: <20200317103332.354594035@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

commit aa202f1f56960c60e7befaa0f49c72b8fa11b0a8 upstream.

wq_select_unbound_cpu() is designed for unbound workqueues only, but
it's wrongly called when using a bound workqueue too.

Fixing this ensures work queued to a bound workqueue with
cpu=WORK_CPU_UNBOUND always runs on the local CPU.

Before, that would happen only if wq_unbound_cpumask happened to include
it (likely almost always the case), or was empty, or we got lucky with
forced round-robin placement.  So restricting
/sys/devices/virtual/workqueue/cpumask to a small subset of a machine's
CPUs would cause some bound work items to run unexpectedly there.

Fixes: ef557180447f ("workqueue: schedule WORK_CPU_UNBOUND work on wq_unbound_cpumask CPUs")
Cc: stable@vger.kernel.org # v4.5+
Signed-off-by: Hillf Danton <hdanton@sina.com>
[dj: massage changelog]
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1411,14 +1411,16 @@ static void __queue_work(int cpu, struct
 		return;
 	rcu_read_lock();
 retry:
-	if (req_cpu == WORK_CPU_UNBOUND)
-		cpu = wq_select_unbound_cpu(raw_smp_processor_id());
-
 	/* pwq which will be used unless @work is executing elsewhere */
-	if (!(wq->flags & WQ_UNBOUND))
-		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
-	else
+	if (wq->flags & WQ_UNBOUND) {
+		if (req_cpu == WORK_CPU_UNBOUND)
+			cpu = wq_select_unbound_cpu(raw_smp_processor_id());
 		pwq = unbound_pwq_by_node(wq, cpu_to_node(cpu));
+	} else {
+		if (req_cpu == WORK_CPU_UNBOUND)
+			cpu = raw_smp_processor_id();
+		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
+	}
 
 	/*
 	 * If @work was previously on a different pool, it might still be


