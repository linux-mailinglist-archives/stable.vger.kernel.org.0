Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559EC5ED0E7
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 01:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiI0XRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 19:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiI0XRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 19:17:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DBE1129F7;
        Tue, 27 Sep 2022 16:17:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D478961C30;
        Tue, 27 Sep 2022 23:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C3BC433B5;
        Tue, 27 Sep 2022 23:17:13 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1odJqK-00HDdk-0N;
        Tue, 27 Sep 2022 19:18:24 -0400
Message-ID: <20220927231823.718039222@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 27 Sep 2022 19:15:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/5] ring-buffer: Have the shortest_full queue be the shortest not longest
References: <20220927231523.298295015@goodmis.org>
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

The logic to know when the shortest waiters on the ring buffer should be
woken up or not has uses a less than instead of a greater than compare,
which causes the shortest_full to actually be the longest.

Cc: stable@vger.kernel.org
Fixes: 2c2b0a78b3739 ("ring-buffer: Add percentage of ring buffer full to wake up reader")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6b145d48dfd1..02db92c9eb1b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1011,7 +1011,7 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 			nr_pages = cpu_buffer->nr_pages;
 			dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
 			if (!cpu_buffer->shortest_full ||
-			    cpu_buffer->shortest_full < full)
+			    cpu_buffer->shortest_full > full)
 				cpu_buffer->shortest_full = full;
 			raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 			if (!pagebusy &&
-- 
2.35.1
