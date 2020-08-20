Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955CD24B716
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgHTKrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731271AbgHTKQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:16:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 564A920738;
        Thu, 20 Aug 2020 10:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918562;
        bh=trfi2AxVJ0AEF8nUbeu26hKgCxUGkF/1dh/F7XujWuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFKwP91UJXIUZWe56ldopWqgQU45tq286eXlruXHfEhNKldtPQGZo9KN+igYYZixa
         tZeGYkm7lM1xDTvP7FfJoapylrJGNKW2zWM+jfnWBcU/2vQY3J3lbCJityBOogDsbf
         +fY0NfqrRKppo+KJNTDkN+LTc8/JnfbxYD5lqDO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Kevin Hao <haokexin@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 187/228] tracing/hwlat: Honor the tracing_cpumask
Date:   Thu, 20 Aug 2020 11:22:42 +0200
Message-Id: <20200820091616.921582889@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit 96b4833b6827a62c295b149213c68b559514c929 upstream.

In calculation of the cpu mask for the hwlat kernel thread, the wrong
cpu mask is used instead of the tracing_cpumask, this causes the
tracing/tracing_cpumask useless for hwlat tracer. Fixes it.

Link: https://lkml.kernel.org/r/20200730082318.42584-2-haokexin@gmail.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 0330f7aa8ee6 ("tracing: Have hwlat trace migrate across tracing_cpumask CPUs")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_hwlat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -272,6 +272,7 @@ static bool disable_migrate;
 static void move_to_next_cpu(void)
 {
 	struct cpumask *current_mask = &save_cpumask;
+	struct trace_array *tr = hwlat_trace;
 	int next_cpu;
 
 	if (disable_migrate)
@@ -285,7 +286,7 @@ static void move_to_next_cpu(void)
 		goto disable;
 
 	get_online_cpus();
-	cpumask_and(current_mask, cpu_online_mask, tracing_buffer_mask);
+	cpumask_and(current_mask, cpu_online_mask, tr->tracing_cpumask);
 	next_cpu = cpumask_next(smp_processor_id(), current_mask);
 	put_online_cpus();
 
@@ -359,7 +360,7 @@ static int start_kthread(struct trace_ar
 	/* Just pick the first CPU on first iteration */
 	current_mask = &save_cpumask;
 	get_online_cpus();
-	cpumask_and(current_mask, cpu_online_mask, tracing_buffer_mask);
+	cpumask_and(current_mask, cpu_online_mask, tr->tracing_cpumask);
 	put_online_cpus();
 	next_cpu = cpumask_first(current_mask);
 


