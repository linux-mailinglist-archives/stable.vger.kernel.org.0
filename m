Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEEE60AC28
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiJXODG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236946AbiJXOCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:02:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814F2BEF95;
        Mon, 24 Oct 2022 05:48:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E78B461313;
        Mon, 24 Oct 2022 12:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01113C433C1;
        Mon, 24 Oct 2022 12:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615075;
        bh=LGRvqM2j5vuLr7KKaqFWlA2XwuABWZFkef9uOBPwf60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8aEDKOxM0UYh/kJ9HIRL3cX7UvrKcFTNwkygZ6dt0fOPIk86p5yxdamAtxOwczH2
         Kx6DSOUw6EfM8lbJ8c8ahwKstc8Wc0v+vgFS35ORkuBGSfsVS53zy14cl5p+oXIWvs
         +Yz3MDrACMItk5aEMN2EQ0Bw9kGfwSYdWCc4//9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 113/530] tracing: Wake up waiters when tracing is disabled
Date:   Mon, 24 Oct 2022 13:27:37 +0200
Message-Id: <20221024113050.140456372@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

commit 2b0fd9a59b7990c161fa1cb7b79edb22847c87c2 upstream.

When tracing is disabled, there's no reason that waiters should stay
waiting, wake them up, otherwise tasks get stuck when they should be
flushing the buffers.

Cc: stable@vger.kernel.org
Fixes: e30f53aad2202 ("tracing: Do not busy wait in buffer splice")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8291,6 +8291,10 @@ tracing_buffers_splice_read(struct file
 		if (ret)
 			goto out;
 
+		/* No need to wait after waking up when tracing is off */
+		if (!tracer_tracing_is_on(iter->tr))
+			goto out;
+
 		/* Make sure we see the new wait_index */
 		smp_rmb();
 		if (wait_index != iter->wait_index)
@@ -9000,6 +9004,8 @@ rb_simple_write(struct file *filp, const
 			tracer_tracing_off(tr);
 			if (tr->current_trace->stop)
 				tr->current_trace->stop(tr);
+			/* Wake up any waiters */
+			ring_buffer_wake_waiters(buffer, RING_BUFFER_ALL_CPUS);
 		}
 		mutex_unlock(&trace_types_lock);
 	}


