Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B5B4727CB
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbhLMKFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235516AbhLMKBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:01:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19529C09B199;
        Mon, 13 Dec 2021 01:49:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 56B79CE0E80;
        Mon, 13 Dec 2021 09:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3407C00446;
        Mon, 13 Dec 2021 09:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388952;
        bh=88bD+0eVAyErUZ6i+GDacBhgOkMhOWGnzvTtleDap9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWvpUuhqSGjJtKpmxJhrkvn21l4NJ5E9VUPGg5fYUTSu4PZvfQKbr97nQ/yOrSQdv
         tfERV1BCVQ59Jm5PZBqx0rB5GGzs1Pp8DJ70j9Q8Q5UK6j+PGO8hEOoEyEctpLc+zP
         AUWulReU9NZYk/ClqP33PfgvDgnCxiuAQzd/3YNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.10 066/132] signalfd: use wake_up_pollfree()
Date:   Mon, 13 Dec 2021 10:30:07 +0100
Message-Id: <20211213092941.379199511@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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
 fs/signalfd.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 040e1cf90528..65ce0e72e7b9 100644
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
-- 
2.34.1



