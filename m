Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D971B40C726
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 16:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbhIOON6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 10:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237842AbhIOON5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 10:13:57 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 777EC6112E;
        Wed, 15 Sep 2021 14:12:38 +0000 (UTC)
Date:   Wed, 15 Sep 2021 10:12:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     qiang.zhang@windriver.com, bristot@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing/osnoise: Fix missed
 cpus_read_unlock() in" failed to apply to 5.14-stable tree
Message-ID: <20210915101231.71bf18dd@oasis.local.home>
In-Reply-To: <1631709430188167@kroah.com>
References: <1631709430188167@kroah.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Sep 2021 14:37:10 +0200
<gregkh@linuxfoundation.org> wrote:

>  
>  	cpus_read_unlock();
>  
> -	return 0;
> +	return retval;
>  }
>  

The issue was that the latest kernel uses cpu_read_unlock() instead of
put_online_cpus(), other than that, it was trivial to fix.

Below should apply cleanly to 5.14.

-- Steve

>From 4b6b08f2e45edda4c067ac40833e3c1f84383c0b Mon Sep 17 00:00:00 2001
From: "Qiang.Zhang" <qiang.zhang@windriver.com>
Date: Tue, 31 Aug 2021 10:29:19 +0800
Subject: [PATCH] tracing/osnoise: Fix missed cpus_read_unlock() in
 start_per_cpu_kthreads()

When start_kthread() return error, the cpus_read_unlock() need
to be called.

Link: https://lkml.kernel.org/r/20210831022919.27630-1-qiang.zhang@windriver.com

Cc: <stable@vger.kernel.org>
Fixes: c8895e271f79 ("trace/osnoise: Support hotplug operations")
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Qiang.Zhang <qiang.zhang@windriver.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/kernel/trace/trace_osnoise.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_osnoise.c
+++ linux-test.git/kernel/trace/trace_osnoise.c
@@ -1548,7 +1548,7 @@ static int start_kthread(unsigned int cp
 static int start_per_cpu_kthreads(struct trace_array *tr)
 {
 	struct cpumask *current_mask = &save_cpumask;
-	int retval;
+	int retval = 0;
 	int cpu;
 
 	get_online_cpus();
@@ -1568,13 +1568,13 @@ static int start_per_cpu_kthreads(struct
 		retval = start_kthread(cpu);
 		if (retval) {
 			stop_per_cpu_kthreads();
-			return retval;
+			break;
 		}
 	}
 
 	put_online_cpus();
 
-	return 0;
+	return retval;
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
