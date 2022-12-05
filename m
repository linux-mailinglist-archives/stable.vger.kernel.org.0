Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0829F6433CB
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbiLETje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbiLETjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:39:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA31C77E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:36:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC07B61321
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC9CC433C1;
        Mon,  5 Dec 2022 19:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268987;
        bh=5KgF5ZkHir4Trjt/hHV4rvsUTQBlf/ow/p9nBkSFD+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/wTOKldL969MYdK81ucZwAtiiV+egjCJS/VaK1S/wEn8Tkd9Qpy9j6Ggxjmky+sf
         +TwhPbBgFnBxWYzU+0CyE4IX2rHh8g/tMyTZX76DIpQMoUNJpX+HFgtHNtTVlmpzwB
         bsINrusiteYktqyUxzXi9cJn3RnVDTRHsc6yJFwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.15 085/120] tracing/osnoise: Fix duration type
Date:   Mon,  5 Dec 2022 20:10:25 +0100
Message-Id: <20221205190809.146573093@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit 022632f6c43a86f2135642dccd5686de318e861d upstream.

The duration type is a 64 long value, not an int. This was
causing some long noise to report wrong values.

Change the duration to a 64 bits value.

Link: https://lkml.kernel.org/r/a93d8a8378c7973e9c609de05826533c9e977939.1668692096.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Fixes: bce29ac9ce0b ("trace: Add osnoise tracer")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -730,7 +730,7 @@ void osnoise_trace_irq_entry(int id)
 void osnoise_trace_irq_exit(int id, const char *desc)
 {
 	struct osnoise_variables *osn_var = this_cpu_osn_var();
-	int duration;
+	s64 duration;
 
 	if (!osn_var->sampling)
 		return;
@@ -861,7 +861,7 @@ static void trace_softirq_entry_callback
 static void trace_softirq_exit_callback(void *data, unsigned int vec_nr)
 {
 	struct osnoise_variables *osn_var = this_cpu_osn_var();
-	int duration;
+	s64 duration;
 
 	if (!osn_var->sampling)
 		return;
@@ -969,7 +969,7 @@ thread_entry(struct osnoise_variables *o
 static void
 thread_exit(struct osnoise_variables *osn_var, struct task_struct *t)
 {
-	int duration;
+	s64 duration;
 
 	if (!osn_var->sampling)
 		return;


