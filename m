Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2F9600093
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiJPPVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiJPPVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:21:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D2BB4B9
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F388360BA8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FBAC433C1;
        Sun, 16 Oct 2022 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665933708;
        bh=cJTRKih2WF7NaE4z8rkjyd3uN2Wy8pvV8vDMrA3LyK0=;
        h=Subject:To:Cc:From:Date:From;
        b=2MICINLMtXit/EHyAovR2++ClT0cx3dfNrngB+y2AtOrMOqaVEwxe3dmSSqUVkTkk
         C5mBqmqFqyZ3oAfGQ39kMM7vTibxU+RFbjTF+4P5VCN3SS6bJ4sR44IhjMKD9rM5R5
         VG2RtV7dDwjToOh5vAKiap2nhzAmgMK+r5JzxnKE=
Subject: FAILED: patch "[PATCH] tracing: Wake up waiters when tracing is disabled" failed to apply to 4.19-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:22:26 +0200
Message-ID: <1665933746182188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2b0fd9a59b79 ("tracing: Wake up waiters when tracing is disabled")
f3ddb74ad079 ("tracing: Wake up ring buffer waiters on closing of the file")
efbbdaa22bb7 ("tracing: Show real address for trace event arguments")
8e99cf91b99b ("tracing: Do not allocate buffer in trace_find_next_entry() in atomic")
ff895103a84a ("tracing: Save off entry when peeking at next entry")
03329f993978 ("tracing: Add tracefs file buffer_percentage")
2c2b0a78b373 ("ring-buffer: Add percentage of ring buffer full to wake up reader")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2b0fd9a59b7990c161fa1cb7b79edb22847c87c2 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Wed, 28 Sep 2022 18:22:20 -0400
Subject: [PATCH] tracing: Wake up waiters when tracing is disabled

When tracing is disabled, there's no reason that waiters should stay
waiting, wake them up, otherwise tasks get stuck when they should be
flushing the buffers.

Cc: stable@vger.kernel.org
Fixes: e30f53aad2202 ("tracing: Do not busy wait in buffer splice")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 58afc83afc9d..bb5597c6bfc1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8334,6 +8334,10 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		if (ret)
 			goto out;
 
+		/* No need to wait after waking up when tracing is off */
+		if (!tracer_tracing_is_on(iter->tr))
+			goto out;
+
 		/* Make sure we see the new wait_index */
 		smp_rmb();
 		if (wait_index != iter->wait_index)
@@ -9065,6 +9069,8 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 			tracer_tracing_off(tr);
 			if (tr->current_trace->stop)
 				tr->current_trace->stop(tr);
+			/* Wake up any waiters */
+			ring_buffer_wake_waiters(buffer, RING_BUFFER_ALL_CPUS);
 		}
 		mutex_unlock(&trace_types_lock);
 	}

