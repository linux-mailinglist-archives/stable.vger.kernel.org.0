Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15075F0105
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 00:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiI2Wz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 18:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiI2WzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 18:55:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E4582D3B;
        Thu, 29 Sep 2022 15:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72E72621C1;
        Thu, 29 Sep 2022 22:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A57C433B5;
        Thu, 29 Sep 2022 22:55:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oe2SJ-000cmX-2M;
        Thu, 29 Sep 2022 18:56:35 -0400
Message-ID: <20220929225635.339549783@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 29 Sep 2022 18:55:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-next][PATCH 03/15] ring-buffer: Have the shortest_full queue be the shortest not longest
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

The logic to know when the shortest waiters on the ring buffer should be
woken up or not has uses a less than instead of a greater than compare,
which causes the shortest_full to actually be the longest.

Link: https://lkml.kernel.org/r/20220927231823.718039222@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
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
