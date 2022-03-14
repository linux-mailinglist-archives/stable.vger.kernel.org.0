Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60CD4D8421
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241517AbiCNMW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243877AbiCNMVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3256121AC;
        Mon, 14 Mar 2022 05:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88983B80DF9;
        Mon, 14 Mar 2022 12:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB44EC340E9;
        Mon, 14 Mar 2022 12:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260250;
        bh=1YcsxDwy55FRMcevWNunqDFXcYipB2vLzDPAXkg5MwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TI4AYlTs9i72kTJX56OkWzuCM/eCvrozif1mkhjBQ9SG8H4hq0ysNnG0XFVQ2890D
         an+5h5X/1yfGsjw9pdEKsDhQ4LbvrAq3SMKI7TBDYrS3mHsIb6XIGxw026r5Z0AT4j
         Ee0UDl6y4qk7XzyqC1NTiJ6FWgPZP9WjKfsdZtc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.16 096/121] tracing/osnoise: Do not unregister events twice
Date:   Mon, 14 Mar 2022 12:54:39 +0100
Message-Id: <20220314112746.792467396@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit f0cfe17bcc1dd2f0872966b554a148e888833ee9 upstream.

Nicolas reported that using:

 # trace-cmd record -e all -M 10 -p osnoise --poll

Resulted in the following kernel warning:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 1217 at kernel/tracepoint.c:404 tracepoint_probe_unregister+0x280/0x370
 [...]
 CPU: 0 PID: 1217 Comm: trace-cmd Not tainted 5.17.0-rc6-next-20220307-nico+ #19
 RIP: 0010:tracepoint_probe_unregister+0x280/0x370
 [...]
 CR2: 00007ff919b29497 CR3: 0000000109da4005 CR4: 0000000000170ef0
 Call Trace:
  <TASK>
  osnoise_workload_stop+0x36/0x90
  tracing_set_tracer+0x108/0x260
  tracing_set_trace_write+0x94/0xd0
  ? __check_object_size.part.0+0x10a/0x150
  ? selinux_file_permission+0x104/0x150
  vfs_write+0xb5/0x290
  ksys_write+0x5f/0xe0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7ff919a18127
 [...]
 ---[ end trace 0000000000000000 ]---

The warning complains about an attempt to unregister an
unregistered tracepoint.

This happens on trace-cmd because it first stops tracing, and
then switches the tracer to nop. Which is equivalent to:

  # cd /sys/kernel/tracing/
  # echo osnoise > current_tracer
  # echo 0 > tracing_on
  # echo nop > current_tracer

The osnoise tracer stops the workload when no trace instance
is actually collecting data. This can be caused both by
disabling tracing or disabling the tracer itself.

To avoid unregistering events twice, use the existing
trace_osnoise_callback_enabled variable to check if the events
(and the workload) are actually active before trying to
deactivate them.

Link: https://lore.kernel.org/all/c898d1911f7f9303b7e14726e7cc9678fbfb4a0e.camel@redhat.com/
Link: https://lkml.kernel.org/r/938765e17d5a781c2df429a98f0b2e7cc317b022.1646823913.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Fixes: 2fac8d6486d5 ("tracing/osnoise: Allow multiple instances of the same tracer")
Reported-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -2222,6 +2222,17 @@ static void osnoise_workload_stop(void)
 	if (osnoise_has_registered_instances())
 		return;
 
+	/*
+	 * If callbacks were already disabled in a previous stop
+	 * call, there is no need to disable then again.
+	 *
+	 * For instance, this happens when tracing is stopped via:
+	 * echo 0 > tracing_on
+	 * echo nop > current_tracer.
+	 */
+	if (!trace_osnoise_callback_enabled)
+		return;
+
 	trace_osnoise_callback_enabled = false;
 	/*
 	 * Make sure that ftrace_nmi_enter/exit() see


