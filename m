Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D91D2062F3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391484AbgFWVJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391483AbgFWUeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:34:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6DF52064B;
        Tue, 23 Jun 2020 20:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944442;
        bh=ZGdBxKQkCpdkOwGotuNsaRRU1i75i+LyQ6mnSPfgiF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8I+tKsQazPixrE3Rp3jP8AdwTPKPTLk561VdeXhmel5508Na0uJ878IwTrkrJCOO
         8naQmf1OoU15ybJAXKr62LygUzlgP84Ks40IY/1XmL2zKkJF20vNFteovXDHNcsUEw
         vntGh+x55BFZDTvGOU4hs4hZFmWwJLDac8YJFfuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 307/314] tracing/probe: Fix memleak in fetch_op_data operations
Date:   Tue, 23 Jun 2020 21:58:22 +0200
Message-Id: <20200623195353.645232575@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>

commit 3aa8fdc37d16735e8891035becf25b3857d3efe0 upstream.

kmemleak report:
    [<57dcc2ca>] __kmalloc_track_caller+0x139/0x2b0
    [<f1c45d0f>] kstrndup+0x37/0x80
    [<f9761eb0>] parse_probe_arg.isra.7+0x3cc/0x630
    [<055bf2ba>] traceprobe_parse_probe_arg+0x2f5/0x810
    [<655a7766>] trace_kprobe_create+0x2ca/0x950
    [<4fc6a02a>] create_or_delete_trace_kprobe+0xf/0x30
    [<6d1c8a52>] trace_run_command+0x67/0x80
    [<be812cc0>] trace_parse_run_command+0xa7/0x140
    [<aecfe401>] probes_write+0x10/0x20
    [<2027641c>] __vfs_write+0x30/0x1e0
    [<6a4aeee1>] vfs_write+0x96/0x1b0
    [<3517fb7d>] ksys_write+0x53/0xc0
    [<dad91db7>] __ia32_sys_write+0x15/0x20
    [<da347f64>] do_syscall_32_irqs_on+0x3d/0x260
    [<fd0b7e7d>] do_fast_syscall_32+0x39/0xb0
    [<ea5ae810>] entry_SYSENTER_32+0xaf/0x102

Post parse_probe_arg(), the FETCH_OP_DATA operation type is overwritten
to FETCH_OP_ST_STRING, as a result memory is never freed since
traceprobe_free_probe_arg() iterates only over SYMBOL and DATA op types

Setup fetch string operation correctly after fetch_op_data operation.

Link: https://lkml.kernel.org/r/20200615143034.GA1734@cosmos

Cc: stable@vger.kernel.org
Fixes: a42e3c4de964 ("tracing/probe: Add immediate string parameter support")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_probe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -639,8 +639,8 @@ static int traceprobe_parse_probe_arg_bo
 			ret = -EINVAL;
 			goto fail;
 		}
-		if ((code->op == FETCH_OP_IMM || code->op == FETCH_OP_COMM) ||
-		     parg->count) {
+		if ((code->op == FETCH_OP_IMM || code->op == FETCH_OP_COMM ||
+		     code->op == FETCH_OP_DATA) || parg->count) {
 			/*
 			 * IMM, DATA and COMM is pointing actual address, those
 			 * must be kept, and if parg->count != 0, this is an


