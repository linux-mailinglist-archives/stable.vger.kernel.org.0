Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE39637BB5
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 15:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiKXOs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 09:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiKXOs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 09:48:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F64EE0740;
        Thu, 24 Nov 2022 06:48:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE02062184;
        Thu, 24 Nov 2022 14:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD6EC43146;
        Thu, 24 Nov 2022 14:48:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oyDWa-001WsR-0V;
        Thu, 24 Nov 2022 09:48:24 -0500
Message-ID: <20221124144824.035022085@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 24 Nov 2022 09:47:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: [for-linus][PATCH 4/6] tracing: Fix race where histograms can be called before the event
References: <20221124144752.427194398@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 94eedf3dded5 ("tracing: Fix race where eprobes can be called before
the event") fixed an issue where if an event is soft disabled, and the
trigger is being added, there's a small window where the event sees that
there's a trigger but does not see that it requires reading the event yet,
and then calls the trigger with the record == NULL.

This could be solved with adding memory barriers in the hot path, or to
make sure that all the triggers requiring a record check for NULL. The
latter was chosen.

Commit 94eedf3dded5 set the eprobe trigger handle to check for NULL, but
the same needs to be done with histograms.

Link: https://lore.kernel.org/linux-trace-kernel/20221118211809.701d40c0f8a757b0df3c025a@kernel.org/
Link: https://lore.kernel.org/linux-trace-kernel/20221123164323.03450c3a@gandalf.local.home

Cc: Tom Zanussi <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 7491e2c442781 ("tracing: Add a probe that attaches to trace events")
Reported-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 087c19548049..1c82478e8dff 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5143,6 +5143,9 @@ static void event_hist_trigger(struct event_trigger_data *data,
 	void *key = NULL;
 	unsigned int i;
 
+	if (unlikely(!rbe))
+		return;
+
 	memset(compound_key, 0, hist_data->key_size);
 
 	for_each_hist_key_field(i, hist_data) {
-- 
2.35.1


