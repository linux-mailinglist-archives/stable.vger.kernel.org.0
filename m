Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAB749731F
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbiAWQra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:47:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35872 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238862AbiAWQr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:47:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45C65CE0EC1
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5462DC340E2;
        Sun, 23 Jan 2022 16:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642956446;
        bh=2cUrzLqiusrkk1gtv2RzIAnREqlBB7ViiFDPVEzuGFs=;
        h=Subject:To:Cc:From:Date:From;
        b=bnOhvP73MnY04B4cClpqwqSyQAXJ5vWVa6buqQsmCWiKEyrxezBeueDjY8ohHt+pZ
         DHoCBdtZtxLKQOTUAZ1v34KNkyQ+T0FXLPfPdH4SPGdtItv67VUpniFcJltgyMOlHo
         j3g74eO0Y3jUozi7hXQYR2F7MZrdr83H9hCzmUI8=
Subject: FAILED: patch "[PATCH] tracing/kprobes: 'nmissed' not showed correctly for kretprobe" failed to apply to 4.14-stable tree
To:     xyz.sun.ok@gmail.com, mhiramat@kernel.org, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:47:10 +0100
Message-ID: <164295643040222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

