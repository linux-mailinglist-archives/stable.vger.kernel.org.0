Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC07640C563
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 14:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbhIOMie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 08:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232824AbhIOMib (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 08:38:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A858161101;
        Wed, 15 Sep 2021 12:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631709433;
        bh=KyCLEzTBssGzDqpqwcwIKehdOtFdkvyPmtEtOgr66HE=;
        h=Subject:To:Cc:From:Date:From;
        b=a8Oap1oBUVmoLkg7iIBXDuCvmeMnjsPVAQiNz1nWUIRXsQZWCK9j3qkE/NRjrd9xf
         XSwcIVaVVXVxxOJof1dmUc5zjvpEK0rgGGp63XlticTYE3Xtx0DlOQ3+7m/aMGpN/T
         DkXoYgu8ED13hmdkUcXRFGD/Hk0i16+L0r8mTwCI=
Subject: FAILED: patch "[PATCH] tracing/osnoise: Fix missed cpus_read_unlock() in" failed to apply to 5.14-stable tree
To:     qiang.zhang@windriver.com, bristot@kernel.org, rostedt@goodmis.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 14:37:10 +0200
Message-ID: <1631709430188167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4b6b08f2e45edda4c067ac40833e3c1f84383c0b Mon Sep 17 00:00:00 2001
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

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 65b08b8e5bf8..ce053619f289 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1548,7 +1548,7 @@ static int start_kthread(unsigned int cpu)
 static int start_per_cpu_kthreads(struct trace_array *tr)
 {
 	struct cpumask *current_mask = &save_cpumask;
-	int retval;
+	int retval = 0;
 	int cpu;
 
 	cpus_read_lock();
@@ -1568,13 +1568,13 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
 		retval = start_kthread(cpu);
 		if (retval) {
 			stop_per_cpu_kthreads();
-			return retval;
+			break;
 		}
 	}
 
 	cpus_read_unlock();
 
-	return 0;
+	return retval;
 }
 
 #ifdef CONFIG_HOTPLUG_CPU

