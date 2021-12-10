Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EF4470F13
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 00:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhLJX5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 18:57:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50002 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244068AbhLJX53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 18:57:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 636DBCE2D91;
        Fri, 10 Dec 2021 23:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7908FC341CA;
        Fri, 10 Dec 2021 23:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639180430;
        bh=YwioQUdsWG4JUxYMZuSlLWm6ViN/LLSAs8eKlkNttMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EukPzbBCScB7qE16zff5NkiLvnyMlksui4ynJ18hiYKLaLguNfLC90c6N6ZQx4Ueu
         8uDUJh4TZmeWNLaEQyh3GOyXynZ+qrL43iAp+pZwEcQXgkouaGAMWu6FK1YagermXi
         Zuth5xSAuIEZmMVJtiT+OgOIa2NLTg2h+2RaF9UIPrIZaA4y2fwsnZ/Ho+bTi4mCkd
         0cvbuzpGFJHAJ+d03vyEe6BWllEvtr7Cz2RA2VJjaZJLuekpTYfkSwIVYKCXRGp4K+
         RF4cgvC56rWUnSbig+L2NvPPl1rmbzAx7PPpQyhw2XoTMgZyE25O3c/d1ddZyBIh2d
         OkmwLfnFrqWtA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 3/5] signalfd: use wake_up_pollfree()
Date:   Fri, 10 Dec 2021 15:53:10 -0800
Message-Id: <20211210235312.40412-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210235312.40412-1-ebiggers@kernel.org>
References: <20211210235312.40412-1-ebiggers@kernel.org>
MIME-Version: 1.0
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
---
 fs/signalfd.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 3c40a3bf772ce..94e0ae01db5c8 100644
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

