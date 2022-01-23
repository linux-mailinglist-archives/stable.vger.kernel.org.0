Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CB749731C
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbiAWQrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiAWQrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:47:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9162C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 08:47:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 64C36CE0EBF
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20399C340E2;
        Sun, 23 Jan 2022 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642956440;
        bh=8ZE06CGKm/eUtORNjjCKr/l0XkjvhJ2RwT0ygrwY6Ns=;
        h=Subject:To:Cc:From:Date:From;
        b=sAqYrGLNogJhGX+nchwt2EtqkQCPq+dRdXaluLBFBSkwLFVRXA+BC4Ae3QybUpd7X
         vva8nT7AXt/cw4aSw708UaKbZ1qQ7ZzAGBAkxU9CIbO4qt5yZ0Gd835oEaiIFeQqqt
         Fafx6uenxfRWajk5pe1j100AYwxa82LgDgI3tfuo=
Subject: FAILED: patch "[PATCH] tracing/kprobes: 'nmissed' not showed correctly for kretprobe" failed to apply to 4.9-stable tree
To:     xyz.sun.ok@gmail.com, mhiramat@kernel.org, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:47:10 +0100
Message-ID: <164295643019991@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dfea08a2116fe327f79d8f4d4b2cf6e0c88be11f Mon Sep 17 00:00:00 2001
From: Xiangyang Zhang <xyz.sun.ok@gmail.com>
Date: Fri, 7 Jan 2022 23:02:42 +0800
Subject: [PATCH] tracing/kprobes: 'nmissed' not showed correctly for kretprobe

The 'nmissed' column of the 'kprobe_profile' file for kretprobe is
not showed correctly, kretprobe can be skipped by two reasons,
shortage of kretprobe_instance which is counted by tk->rp.nmissed,
and kprobe itself is missed by some reason, so to show the sum.

Link: https://lkml.kernel.org/r/20220107150242.5019-1-xyz.sun.ok@gmail.com

Cc: stable@vger.kernel.org
Fixes: 4a846b443b4e ("tracing/kprobes: Cleanup kprobe tracer code")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Xiangyang Zhang <xyz.sun.ok@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f8c26ee72de3..3d85323278ed 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1170,15 +1170,18 @@ static int probes_profile_seq_show(struct seq_file *m, void *v)
 {
 	struct dyn_event *ev = v;
 	struct trace_kprobe *tk;
+	unsigned long nmissed;
 
 	if (!is_trace_kprobe(ev))
 		return 0;
 
 	tk = to_trace_kprobe(ev);
+	nmissed = trace_kprobe_is_return(tk) ?
+		tk->rp.kp.nmissed + tk->rp.nmissed : tk->rp.kp.nmissed;
 	seq_printf(m, "  %-44s %15lu %15lu\n",
 		   trace_probe_name(&tk->tp),
 		   trace_kprobe_nhit(tk),
-		   tk->rp.kp.nmissed);
+		   nmissed);
 
 	return 0;
 }

