Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7630C5F0104
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 00:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiI2WzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 18:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiI2WzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 18:55:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2B7A50E3;
        Thu, 29 Sep 2022 15:55:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12C2A618D5;
        Thu, 29 Sep 2022 22:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3EBC43470;
        Thu, 29 Sep 2022 22:55:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oe2SJ-000clz-0l;
        Thu, 29 Sep 2022 18:56:35 -0400
Message-ID: <20220929225634.862151649@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 29 Sep 2022 18:55:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-next][PATCH 02/15] ring-buffer: Allow splice to read previous partially read pages
References: <20220929225542.784716766@goodmis.org>
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

If a page is partially read, and then the splice system call is run
against the ring buffer, it will always fail to read, no matter how much
is in the ring buffer. That's because the code path for a partial read of
the page does will fail if the "full" flag is set.

The splice system call wants full pages, so if the read of the ring buffer
is not yet full, it should return zero, and the splice will block. But if
a previous read was done, where the beginning has been consumed, it should
still be given to the splice caller if the rest of the page has been
written to.

This caused the splice command to never consume data in this scenario, and
let the ring buffer just fill up and lose events.

Link: https://lkml.kernel.org/r/20220927144317.46be6b80@gandalf.local.home

Cc: stable@vger.kernel.org
Fixes: 8789a9e7df6bf ("ring-buffer: read page interface")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d59b6a328b7f..6b145d48dfd1 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5616,7 +5616,15 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 		unsigned int pos = 0;
 		unsigned int size;
 
-		if (full)
+		/*
+		 * If a full page is expected, this can still be returned
+		 * if there's been a previous partial read and the
+		 * rest of the page can be read and the commit page is off
+		 * the reader page.
+		 */
+		if (full &&
+		    (!read || (len < (commit - read)) ||
+		     cpu_buffer->reader_page == cpu_buffer->commit_page))
 			goto out_unlock;
 
 		if (len > (commit - read))
-- 
2.35.1
