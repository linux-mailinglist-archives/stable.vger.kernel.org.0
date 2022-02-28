Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676D94C769B
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbiB1SF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240742AbiB1SD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C534D2D1C0;
        Mon, 28 Feb 2022 09:47:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACA4DB815C8;
        Mon, 28 Feb 2022 17:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1423EC340F0;
        Mon, 28 Feb 2022 17:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070445;
        bh=yGsnh7E9L/fH8YmBeB2NY1p2xZReP1YIkd/qtKneqIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zq6UhOJpjxJ8gS/17YyphxC7iHXJT0wbZJfJREUMsFRid+jzqA9ivoud2Vnov/S+c
         jImkXKMKWfvbCrD5UfPzI+F/A23AaXQkCz3rULwnysXRwu1vXz5bEkoKozqOcZSTae
         NlVPfIB2dvyHyID10g3WUS6nDT8ur5XM0VN81zOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.16 112/164] tracing: Dump stacktrace trigger to the corresponding instance
Date:   Mon, 28 Feb 2022 18:24:34 +0100
Message-Id: <20220228172410.556772624@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit ce33c845b030c9cf768370c951bc699470b09fa7 upstream.

The stacktrace event trigger is not dumping the stacktrace to the instance
where it was enabled, but to the global "instance."

Use the private_data, pointing to the trigger file, to figure out the
corresponding trace instance, and use it in the trigger action, like
snapshot_trigger does.

Link: https://lkml.kernel.org/r/afbb0b4f18ba92c276865bc97204d438473f4ebc.1645396236.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Fixes: ae63b31e4d0e2 ("tracing: Separate out trace events from global variables")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Tested-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1200,7 +1200,12 @@ stacktrace_trigger(struct event_trigger_
 		   struct trace_buffer *buffer,  void *rec,
 		   struct ring_buffer_event *event)
 {
-	trace_dump_stack(STACK_SKIP);
+	struct trace_event_file *file = data->private_data;
+
+	if (file)
+		__trace_stack(file->tr, tracing_gen_ctx(), STACK_SKIP);
+	else
+		trace_dump_stack(STACK_SKIP);
 }
 
 static void


