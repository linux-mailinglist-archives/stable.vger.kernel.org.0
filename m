Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99EA3137CE
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhBHPbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:31:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233134AbhBHP1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:27:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89F8464F1E;
        Mon,  8 Feb 2021 15:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797352;
        bh=RNoh83kxVOU4Gtrg4nivMqd2efMokmECrv5Cv7x2qOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neZ4UHV0fO7ILmEVTHIEDAeGOvAuTMxbfcQPklGfhCDxNXUZeOSOa+FQXBK6VnK8T
         9Oc56p5qmD0z7OZGhffgo/nM2bXpiQjXY5O06WjguXjk2fFyxQSpqY+6DOJS/grXWk
         rtSsnzfu2SXRa5GpDIn6xDBgEhz7zO2r1nN6NNiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viktor Rosendahl <Viktor.Rosendahl@bmw.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 062/120] tracing: Use pause-on-trace with the latency tracers
Date:   Mon,  8 Feb 2021 16:00:49 +0100
Message-Id: <20210208145820.896248889@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viktor Rosendahl <Viktor.Rosendahl@bmw.de>

commit da7f84cdf02fd5f66864041f45018b328911b722 upstream.

Eaerlier, tracing was disabled when reading the trace file. This behavior
was changed with:

commit 06e0a548bad0 ("tracing: Do not disable tracing when reading the
trace file").

This doesn't seem to work with the latency tracers.

The above mentioned commit dit not only change the behavior but also added
an option to emulate the old behavior. The idea with this patch is to
enable this pause-on-trace option when the latency tracers are used.

Link: https://lkml.kernel.org/r/20210119164344.37500-2-Viktor.Rosendahl@bmw.de

Cc: stable@vger.kernel.org
Fixes: 06e0a548bad0 ("tracing: Do not disable tracing when reading the trace file")
Signed-off-by: Viktor Rosendahl <Viktor.Rosendahl@bmw.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_irqsoff.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -562,6 +562,8 @@ static int __irqsoff_tracer_init(struct
 	/* non overwrite screws up the latency tracers */
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, 1);
+	/* without pause, we will produce garbage if another latency occurs */
+	set_tracer_flag(tr, TRACE_ITER_PAUSE_ON_TRACE, 1);
 
 	tr->max_latency = 0;
 	irqsoff_trace = tr;
@@ -583,11 +585,13 @@ static void __irqsoff_tracer_reset(struc
 {
 	int lat_flag = save_flags & TRACE_ITER_LATENCY_FMT;
 	int overwrite_flag = save_flags & TRACE_ITER_OVERWRITE;
+	int pause_flag = save_flags & TRACE_ITER_PAUSE_ON_TRACE;
 
 	stop_irqsoff_tracer(tr, is_graph(tr));
 
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
+	set_tracer_flag(tr, TRACE_ITER_PAUSE_ON_TRACE, pause_flag);
 	ftrace_reset_array_ops(tr);
 
 	irqsoff_busy = false;


