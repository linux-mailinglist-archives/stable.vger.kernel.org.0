Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A050C4CF6BA
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbiCGJnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239095AbiCGJjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5D76D194;
        Mon,  7 Mar 2022 01:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40E9261140;
        Mon,  7 Mar 2022 09:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CEEC340F3;
        Mon,  7 Mar 2022 09:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645657;
        bh=7HCGrtQjAyeNpnXDtKIWTjQRngzq/AR+fwSQ5h9u4OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+p+UEbpieSsDgd1j6MtAo9ksybSNVz5L0w+pZFjKq/mL6B039zw0HixwS7KR2d6e
         3SByn+sjzdUAIR1i8xeny9UtEBi1dtON+rofc74UHCV/adgp9cCV4NOSRhx4xZbn4m
         rSwqHUYJ2HZ0LoRvuM0Fch6xeumttHghHjlWiEiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 101/105] tracing: Fix return value of __setup handlers
Date:   Mon,  7 Mar 2022 10:19:44 +0100
Message-Id: <20220307091647.017777244@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 1d02b444b8d1345ea4708db3bab4db89a7784b55 upstream.

__setup() handlers should generally return 1 to indicate that the
boot options have been handled.

Using invalid option values causes the entire kernel boot option
string to be reported as Unknown and added to init's environment
strings, polluting it.

  Unknown kernel command line parameters "BOOT_IMAGE=/boot/bzImage-517rc6
    kprobe_event=p,syscall_any,$arg1 trace_options=quiet
    trace_clock=jiffies", will be passed to user space.

 Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc6
     kprobe_event=p,syscall_any,$arg1
     trace_options=quiet
     trace_clock=jiffies

Return 1 from the __setup() handlers so that init's environment is not
polluted with kernel boot options.

Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Link: https://lkml.kernel.org/r/20220303031744.32356-1-rdunlap@infradead.org

Cc: stable@vger.kernel.org
Fixes: 7bcfaf54f591 ("tracing: Add trace_options kernel command line parameter")
Fixes: e1e232ca6b8f ("tracing: Add trace_clock=<clock> kernel parameter")
Fixes: 970988e19eb0 ("tracing/kprobe: Add kprobe_event= boot parameter")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c        |    4 ++--
 kernel/trace/trace_kprobe.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -233,7 +233,7 @@ static char trace_boot_options_buf[MAX_T
 static int __init set_trace_boot_options(char *str)
 {
 	strlcpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
-	return 0;
+	return 1;
 }
 __setup("trace_options=", set_trace_boot_options);
 
@@ -244,7 +244,7 @@ static int __init set_trace_boot_clock(c
 {
 	strlcpy(trace_boot_clock_buf, str, MAX_TRACER_SIZE);
 	trace_boot_clock = trace_boot_clock_buf;
-	return 0;
+	return 1;
 }
 __setup("trace_clock=", set_trace_boot_clock);
 
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -31,7 +31,7 @@ static int __init set_kprobe_boot_events
 	strlcpy(kprobe_boot_events_buf, str, COMMAND_LINE_SIZE);
 	disable_tracing_selftest("running kprobe events");
 
-	return 0;
+	return 1;
 }
 __setup("kprobe_event=", set_kprobe_boot_events);
 


