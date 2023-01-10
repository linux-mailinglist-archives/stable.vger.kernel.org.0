Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019F6664A73
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbjAJSc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239504AbjAJScW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:32:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3220A983CC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:27:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A071ACE18D1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D033C433EF;
        Tue, 10 Jan 2023 18:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375259;
        bh=yZTy4/gnm8tmmet5Zn1TurtjLNdcgJolAOzjBtV3iJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZoBKWRbgnt+L78BrrkbnYVOyXqJN0rrJYC2JH0F11LkcCPWRwASjCrwa5SpvDXlg
         XU4kMGh5/+nPwckB3o6waO6NiO/RLFnXCiiMCuXPSjCaUJXBS8BAGPBc6IyWgo0UJn
         UlrGwJQYBJWPBXPHs/Jt8cxaQL96KfuS5aIZ3eOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        David Howells <dhowells@redhat.com>,
        kernel test robot <lkp@intel.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 101/290] tracing: Fix complicated dependency of CONFIG_TRACER_MAX_TRACE
Date:   Tue, 10 Jan 2023 19:03:13 +0100
Message-Id: <20230110180035.112925205@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit e25e43a4e5d8cb2323553d8b6a7ba08d2ebab21f upstream.

Both CONFIG_OSNOISE_TRACER and CONFIG_HWLAT_TRACER partially enables the
CONFIG_TRACER_MAX_TRACE code, but that is complicated and has
introduced a bug; It declares tracing_max_lat_fops data structure outside
of #ifdefs, but since it is defined only when CONFIG_TRACER_MAX_TRACE=y
or CONFIG_HWLAT_TRACER=y, if only CONFIG_OSNOISE_TRACER=y, that
declaration comes to a definition(!).

To fix this issue, and do not repeat the similar problem, makes
CONFIG_OSNOISE_TRACER and CONFIG_HWLAT_TRACER enables the
CONFIG_TRACER_MAX_TRACE always. It has there benefits;
- Fix the tracing_max_lat_fops bug
- Simplify the #ifdefs
- CONFIG_TRACER_MAX_TRACE code is fully enabled, or not.

Link: https://lore.kernel.org/linux-trace-kernel/167033628155.4111793.12185405690820208159.stgit@devnote3

Fixes: 424b650f35c7 ("tracing: Fix missing osnoise tracer on max_latency")
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: stable@vger.kernel.org
Reported-by: David Howells <dhowells@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/all/166992525941.1716618.13740663757583361463.stgit@warthog.procyon.org.uk/ (original thread and v1)
Link: https://lore.kernel.org/all/202212052253.VuhZ2ulJ-lkp@intel.com/T/#u (v1 error report)
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/Kconfig |    2 ++
 kernel/trace/trace.c |   23 +++++++++++++----------
 kernel/trace/trace.h |    8 +++-----
 3 files changed, 18 insertions(+), 15 deletions(-)

--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -328,6 +328,7 @@ config SCHED_TRACER
 config HWLAT_TRACER
 	bool "Tracer to detect hardware latencies (like SMIs)"
 	select GENERIC_TRACER
+	select TRACER_MAX_TRACE
 	help
 	 This tracer, when enabled will create one or more kernel threads,
 	 depending on what the cpumask file is set to, which each thread
@@ -363,6 +364,7 @@ config HWLAT_TRACER
 config OSNOISE_TRACER
 	bool "OS Noise tracer"
 	select GENERIC_TRACER
+	select TRACER_MAX_TRACE
 	help
 	  In the context of high-performance computing (HPC), the Operating
 	  System Noise (osnoise) refers to the interference experienced by an
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1409,6 +1409,7 @@ int tracing_snapshot_cond_disable(struct
 	return false;
 }
 EXPORT_SYMBOL_GPL(tracing_snapshot_cond_disable);
+#define free_snapshot(tr)	do { } while (0)
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
 void tracer_tracing_off(struct trace_array *tr)
@@ -1679,6 +1680,8 @@ static ssize_t trace_seq_to_buffer(struc
 }
 
 unsigned long __read_mostly	tracing_thresh;
+
+#ifdef CONFIG_TRACER_MAX_TRACE
 static const struct file_operations tracing_max_lat_fops;
 
 #ifdef LATENCY_FS_NOTIFY
@@ -1735,18 +1738,14 @@ void latency_fsnotify(struct trace_array
 	irq_work_queue(&tr->fsnotify_irqwork);
 }
 
-#elif defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)	\
-	|| defined(CONFIG_OSNOISE_TRACER)
+#else /* !LATENCY_FS_NOTIFY */
 
 #define trace_create_maxlat_file(tr, d_tracer)				\
 	trace_create_file("tracing_max_latency", TRACE_MODE_WRITE,	\
 			  d_tracer, &tr->max_latency, &tracing_max_lat_fops)
 
-#else
-#define trace_create_maxlat_file(tr, d_tracer)	 do { } while (0)
 #endif
 
-#ifdef CONFIG_TRACER_MAX_TRACE
 /*
  * Copy the new maximum trace into the separate maximum-trace
  * structure. (this way the maximum trace is permanently saved,
@@ -1821,14 +1820,15 @@ update_max_tr(struct trace_array *tr, st
 		ring_buffer_record_off(tr->max_buffer.buffer);
 
 #ifdef CONFIG_TRACER_SNAPSHOT
-	if (tr->cond_snapshot && !tr->cond_snapshot->update(tr, cond_data))
-		goto out_unlock;
+	if (tr->cond_snapshot && !tr->cond_snapshot->update(tr, cond_data)) {
+		arch_spin_unlock(&tr->max_lock);
+		return;
+	}
 #endif
 	swap(tr->array_buffer.buffer, tr->max_buffer.buffer);
 
 	__update_max_tr(tr, tsk, cpu);
 
- out_unlock:
 	arch_spin_unlock(&tr->max_lock);
 }
 
@@ -1875,6 +1875,7 @@ update_max_tr_single(struct trace_array
 	__update_max_tr(tr, tsk, cpu);
 	arch_spin_unlock(&tr->max_lock);
 }
+
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
 static int wait_on_pipe(struct trace_iterator *iter, int full)
@@ -6536,7 +6537,7 @@ out:
 	return ret;
 }
 
-#if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)
+#ifdef CONFIG_TRACER_MAX_TRACE
 
 static ssize_t
 tracing_max_lat_read(struct file *filp, char __user *ubuf,
@@ -7560,7 +7561,7 @@ static const struct file_operations trac
 	.llseek		= generic_file_llseek,
 };
 
-#if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)
+#ifdef CONFIG_TRACER_MAX_TRACE
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -9549,7 +9550,9 @@ init_tracer_tracefs(struct trace_array *
 
 	create_trace_options_dir(tr);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_maxlat_file(tr, d_tracer);
+#endif
 
 	if (ftrace_create_function_files(tr, d_tracer))
 		MEM_FAIL(1, "Could not allocate function filter files");
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -309,8 +309,7 @@ struct trace_array {
 	struct array_buffer	max_buffer;
 	bool			allocated_snapshot;
 #endif
-#if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER) \
-	|| defined(CONFIG_OSNOISE_TRACER)
+#ifdef CONFIG_TRACER_MAX_TRACE
 	unsigned long		max_latency;
 #ifdef CONFIG_FSNOTIFY
 	struct dentry		*d_max_latency;
@@ -688,12 +687,11 @@ void update_max_tr(struct trace_array *t
 		   void *cond_data);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
-#endif /* CONFIG_TRACER_MAX_TRACE */
 
-#if (defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER) \
-	|| defined(CONFIG_OSNOISE_TRACER)) && defined(CONFIG_FSNOTIFY)
+#ifdef CONFIG_FSNOTIFY
 #define LATENCY_FS_NOTIFY
 #endif
+#endif /* CONFIG_TRACER_MAX_TRACE */
 
 #ifdef LATENCY_FS_NOTIFY
 void latency_fsnotify(struct trace_array *tr);


