Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C9460BAFE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiJXUp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiJXUnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:43:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508D92A79F6;
        Mon, 24 Oct 2022 11:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 83976CE1626;
        Mon, 24 Oct 2022 12:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77173C433D6;
        Mon, 24 Oct 2022 12:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615059;
        bh=3xvPPvWzQmePh6RlMMVxusvvqnAQhgJqPfNOznnuano=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxQAE9h1qPzVNT/G1VQYw+Y4HA4EeUhIEheazhFK4mSdc39YS/Si9Pr1blXRjpY83
         2Hp2OjXYebvkhTRWXioP/8jE+fTkvCGX/EeOUaGc43xRg26mtt8F5OnnDE5W2eKQq/
         nHvTSs7j4YWFDOQHKtYn2YIBaSrFPga94CrC8i30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 107/530] ring-buffer: Have the shortest_full queue be the shortest not longest
Date:   Mon, 24 Oct 2022 13:27:31 +0200
Message-Id: <20221024113049.873081461@linuxfoundation.org>
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

commit 3b19d614b61b93a131f463817e08219c9ce1fee3 upstream.

The logic to know when the shortest waiters on the ring buffer should be
woken up or not has uses a less than instead of a greater than compare,
which causes the shortest_full to actually be the longest.

Link: https://lkml.kernel.org/r/20220927231823.718039222@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 2c2b0a78b3739 ("ring-buffer: Add percentage of ring buffer full to wake up reader")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -975,7 +975,7 @@ int ring_buffer_wait(struct trace_buffer
 			nr_pages = cpu_buffer->nr_pages;
 			dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
 			if (!cpu_buffer->shortest_full ||
-			    cpu_buffer->shortest_full < full)
+			    cpu_buffer->shortest_full > full)
 				cpu_buffer->shortest_full = full;
 			raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 			if (!pagebusy &&


