Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBB360FE49
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbiJ0RDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236899AbiJ0RDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:03:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7D2196EE5
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91460B82561
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E846DC433C1;
        Thu, 27 Oct 2022 17:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890230;
        bh=N7nohslEYX3NsQCd3ymV0TNIiMry2Kf4+ZGZdLStZts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgQd72ZXEb9X+6e4I6PrWBP/Dd0tNQglC+R0QgLGALl/h4N/ZyYafraLUSrZfCcl/
         W9czPdEkBumvJ/3ey00OwYg9fVa+JRa557z03IlvVpPF2ygVcAXKfiU0oIgbiD4i+/
         SHjZxjvFAYhnq63h2SZR9nE0vZ0UWGmut7nDeLMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ross Zwisler <zwisler@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 72/79] tracing: Do not free snapshot if tracer is on cmdline
Date:   Thu, 27 Oct 2022 18:56:10 +0200
Message-Id: <20221027165057.316953988@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit a541a9559bb0a8ecc434de01d3e4826c32e8bb53 ]

The ftrace_boot_snapshot and alloc_snapshot cmdline options allocate the
snapshot buffer at boot up for use later. The ftrace_boot_snapshot in
particular requires the snapshot to be allocated because it will take a
snapshot at the end of boot up allowing to see the traces that happened
during boot so that it's not lost when user space takes over.

When a tracer is registered (started) there's a path that checks if it
requires the snapshot buffer or not, and if it does not and it was
allocated it will do a synchronization and free the snapshot buffer.

This is only required if the previous tracer was using it for "max
latency" snapshots, as it needs to make sure all max snapshots are
complete before freeing. But this is only needed if the previous tracer
was using the snapshot buffer for latency (like irqoff tracer and
friends). But it does not make sense to free it, if the previous tracer
was not using it, and the snapshot was allocated by the cmdline
parameters. This basically takes away the point of allocating it in the
first place!

Note, the allocated snapshot worked fine for just trace events, but fails
when a tracer is enabled on the cmdline.

Further investigation, this goes back even further and it does not require
a tracer on the cmdline to fail. Simply enable snapshots and then enable a
tracer, and it will remove the snapshot.

Link: https://lkml.kernel.org/r/20221005113757.041df7fe@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: 45ad21ca5530 ("tracing: Have trace_array keep track if snapshot buffer is allocated")
Reported-by: Ross Zwisler <zwisler@kernel.org>
Tested-by: Ross Zwisler <zwisler@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 21795777587b..24a5ea9a2cc0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6399,12 +6399,12 @@ int tracing_set_tracer(struct trace_array *tr, const char *buf)
 	if (tr->current_trace->reset)
 		tr->current_trace->reset(tr);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
+	had_max_tr = tr->current_trace->use_max_tr;
+
 	/* Current trace needs to be nop_trace before synchronize_rcu */
 	tr->current_trace = &nop_trace;
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-	had_max_tr = tr->allocated_snapshot;
-
 	if (had_max_tr && !t->use_max_tr) {
 		/*
 		 * We need to make sure that the update_max_tr sees that
@@ -6417,11 +6417,13 @@ int tracing_set_tracer(struct trace_array *tr, const char *buf)
 		free_snapshot(tr);
 	}
 
-	if (t->use_max_tr && !had_max_tr) {
+	if (t->use_max_tr && !tr->allocated_snapshot) {
 		ret = tracing_alloc_snapshot_instance(tr);
 		if (ret < 0)
 			goto out;
 	}
+#else
+	tr->current_trace = &nop_trace;
 #endif
 
 	if (t->init) {
-- 
2.35.1



