Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9509D53EB2F
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbiFFMUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236687AbiFFMUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C19929381B
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4367611B4
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84FBC34119;
        Mon,  6 Jun 2022 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654518013;
        bh=pPr2DTHJo4wBvKkvI21NKiGXqgASHIjbPPuuqLzaaQI=;
        h=Subject:To:Cc:From:Date:From;
        b=Cj/lJ3vlTXGROOwp1J5pE+sBE7TU3f4DPIx7G6IHFVMtviCdWYHVIJ5y8MAX8qGBb
         DytK0bPfSEYuOeKM2q5+m6fIFCbUwcMsAMOOv6s2wzzBzM75i0c7iVVbXDrOARfZ06
         NcZalJuA6jKbc2/CDsnotv3z59jnihl7Yf64UEnU=
Subject: FAILED: patch "[PATCH] tracing: Have event format check not flag %p* on" failed to apply to 5.17-stable tree
To:     rostedt@goodmis.org, sfr@canb.auug.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 14:20:02 +0200
Message-ID: <165451800221189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 499f12168aebd6da8fa32c9b7d6203ca9b5eb88d Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Thu, 7 Apr 2022 14:56:32 -0400
Subject: [PATCH] tracing: Have event format check not flag %p* on
 __get_dynamic_array()

The print fmt check against trace events to make sure that the format does
not use pointers that may be freed from the time of the trace to the time
the event is read, gives a false positive on %pISpc when reading data that
was saved in __get_dynamic_array() when it is perfectly fine to do so, as
the data being read is on the ring buffer.

Link: https://lore.kernel.org/all/20220407144524.2a592ed6@canb.auug.org.au/

Cc: stable@vger.kernel.org
Fixes: 5013f454a352c ("tracing: Add check of trace event print fmts for dereferencing pointers")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 78f313b7b315..d5913487821a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -392,12 +392,6 @@ static void test_event_printk(struct trace_event_call *call)
 			if (!(dereference_flags & (1ULL << arg)))
 				goto next_arg;
 
-			/* Check for __get_sockaddr */;
-			if (str_has_prefix(fmt + i, "__get_sockaddr(")) {
-				dereference_flags &= ~(1ULL << arg);
-				goto next_arg;
-			}
-
 			/* Find the REC-> in the argument */
 			c = strchr(fmt + i, ',');
 			r = strstr(fmt + i, "REC->");
@@ -413,7 +407,14 @@ static void test_event_printk(struct trace_event_call *call)
 				a = strchr(fmt + i, '&');
 				if ((a && (a < r)) || test_field(r, call))
 					dereference_flags &= ~(1ULL << arg);
+			} else if ((r = strstr(fmt + i, "__get_dynamic_array(")) &&
+				   (!c || r < c)) {
+				dereference_flags &= ~(1ULL << arg);
+			} else if ((r = strstr(fmt + i, "__get_sockaddr(")) &&
+				   (!c || r < c)) {
+				dereference_flags &= ~(1ULL << arg);
 			}
+
 		next_arg:
 			i--;
 			arg++;

