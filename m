Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0404600092
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJPPVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiJPPVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:21:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8552FB4B9
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:21:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23AC060BA8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6ABC433D6;
        Sun, 16 Oct 2022 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665933699;
        bh=6DyMz4dMGJ8U0u0N502RJhLEFa9D8fX2s1ijlij9EbE=;
        h=Subject:To:Cc:From:Date:From;
        b=muQ1J76aMdL2BQvT7/zH7aBgp9zZ18DMjMG2nEwqsbeW9Yp8R5xVyufNbglhhhpzt
         E9nTW6XC9bby1qILnwgklbOUpVVaS4xZnt9k/FhFAz+s3YcqgvmfCF5+wL6keS0uH2
         QK9WHU/ApH5TchkFLGSwSC3yElG1ZOWcCpBb9HNA=
Subject: FAILED: patch "[PATCH] tracing: Wake up waiters when tracing is disabled" failed to apply to 5.10-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:22:25 +0200
Message-ID: <1665933745170186@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2b0fd9a59b79 ("tracing: Wake up waiters when tracing is disabled")
f3ddb74ad079 ("tracing: Wake up ring buffer waiters on closing of the file")
efbbdaa22bb7 ("tracing: Show real address for trace event arguments")

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

