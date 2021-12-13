Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF785472599
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbhLMJof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236080AbhLMJmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:42:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1B0C08E858;
        Mon, 13 Dec 2021 01:39:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BAA9B80D1F;
        Mon, 13 Dec 2021 09:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893CAC341C5;
        Mon, 13 Dec 2021 09:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388397;
        bh=wFDzVQg1q14Bxkecb1ysJs8MPnCV/er3LoVjFg6sZ+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1/07eEvg4HwFg1F8L67B0iBO+2p0cV4XzRvK9zpZ37ijzBOjsCJVSXTJA03kZQ+q
         62blu9PYFYDlJVOgTF78RwdTadAWXeJnV138X1jxmUw5Z+gUD/rAIS1q98JnQMLQzn
         7BYFqo7lK5Zgqs8Ry2AkdTWgYwg47nkhcxdxyEek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org, Linus Torvalds" 
        <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 36/74] signalfd: use wake_up_pollfree()
Date:   Mon, 13 Dec 2021 10:30:07 +0100
Message-Id: <20211213092932.026311735@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 9537bae0da1f8d1e2361ab6d0479e8af7824e160 upstream.

wake_up_poll() uses nr_exclusive=1, so it's not guaranteed to wake up
all exclusive waiters.  Yet, POLLFREE *must* wake up all waiters.  epoll
and aio poll are fortunately not affected by this, but it's very
fragile.  Thus, the new function wake_up_pollfree() has been introduced.

Convert signalfd to use wake_up_pollfree().

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: d80e731ecab4 ("epoll: introduce POLLFREE to flush ->signalfd_wqh before kfree()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211209010455.42744-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/signalfd.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -35,17 +35,7 @@
 
 void signalfd_cleanup(struct sighand_struct *sighand)
 {
-	wait_queue_head_t *wqh = &sighand->signalfd_wqh;
-	/*
-	 * The lockless check can race with remove_wait_queue() in progress,
-	 * but in this case its caller should run under rcu_read_lock() and
-	 * sighand_cachep is SLAB_TYPESAFE_BY_RCU, we can safely return.
-	 */
-	if (likely(!waitqueue_active(wqh)))
-		return;
-
-	/* wait_queue_entry_t->func(POLLFREE) should do remove_wait_queue() */
-	wake_up_poll(wqh, EPOLLHUP | POLLFREE);
+	wake_up_pollfree(&sighand->signalfd_wqh);
 }
 
 struct signalfd_ctx {


