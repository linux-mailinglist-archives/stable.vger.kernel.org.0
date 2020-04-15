Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B201AB15A
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 21:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441693AbgDOTOF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 15 Apr 2020 15:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441688AbgDOTOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 15:14:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFEC620768;
        Wed, 15 Apr 2020 19:14:01 +0000 (UTC)
Date:   Wed, 15 Apr 2020 15:14:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     mhiramat@kernel.org, treeze.taeung@gmail.com,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ftrace/kprobe: Show the maxactive number
 on kprobe_events" failed to apply to 4.19-stable tree
Message-ID: <20200415151400.2347497b@gandalf.local.home>
In-Reply-To: <158695112724822@kroah.com>
References: <158695112724822@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Apr 2020 13:45:27 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
>

This should apply to both 4.14 and 4.19 and fix the same issue:

From 6a13a0d7b4d1171ef9b80ad69abc37e1daa941b3 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Tue, 24 Mar 2020 16:34:48 +0900
Subject: [PATCH] ftrace/kprobe: Show the maxactive number on kprobe_events

Show maxactive parameter on kprobe_events.
This allows user to save the current configuration and
restore it without losing maxactive parameter.

Link: http://lkml.kernel.org/r/4762764a-6df7-bc93-ed60-e336146dce1f@gmail.com
Link: http://lkml.kernel.org/r/158503528846.22706.5549974121212526020.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 696ced4fb1d76 ("tracing/kprobes: expose maxactive for kretprobe in kprobe_events")
Reported-by: Taeung Song <treeze.taeung@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/kernel/trace/trace_kprobe.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_kprobe.c
+++ linux-test.git/kernel/trace/trace_kprobe.c
@@ -975,6 +975,8 @@ static int probes_seq_show(struct seq_fi
 	int i;
 
 	seq_putc(m, trace_kprobe_is_return(tk) ? 'r' : 'p');
+	if (trace_kprobe_is_return(tk) && tk->rp.maxactive)
+		seq_printf(m, "%d", tk->rp.maxactive);
 	seq_printf(m, ":%s/%s", tk->tp.call.class->system,
 			trace_event_name(&tk->tp.call));
 


-- Steve
