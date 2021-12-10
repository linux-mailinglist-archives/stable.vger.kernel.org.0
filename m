Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B568470EEB
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 00:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345266AbhLJXw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 18:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345242AbhLJXwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 18:52:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2A7C0617A1;
        Fri, 10 Dec 2021 15:48:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7BF3CCE2DB0;
        Fri, 10 Dec 2021 23:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E83C341CB;
        Fri, 10 Dec 2021 23:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639180120;
        bh=tfHPsKPDv/TpAUNZ1F/gaPQatiGp0v3F1Uo/bPQJw44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6pfG15gWXDsL5NH6V9T921M//foqANalQdq/IlKCKTqOBsbPk8uUISYavBVZD2tf
         PtkVxwF6g23p+1A4h+92z8U8XydwuMBtPuuw4vF6/BNlNp6BGTUUFKyLqqqm0MLviO
         5Y1sPjTekY3u5ehSA8/x0JySoLdsGrWOeL9sxBy1rBlfUOGRAcCRjrG8eID9ZJZZNs
         wpD/M4RsR0wN/HzH+pDXunByFoG4nr79Xya7Iwl/TVHQWBRUWrj6B1lcdoCmMf1qUW
         kSCt+5ybrarF+5RUGgMxdB/oiHhzHXTk7gtSmE7GaZqTsME8Hc0p3aiUKnUdju5mPq
         T8euYGqqwx3Cg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 3/5] signalfd: use wake_up_pollfree()
Date:   Fri, 10 Dec 2021 15:48:03 -0800
Message-Id: <20211210234805.39861-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210234805.39861-1-ebiggers@kernel.org>
References: <20211210234805.39861-1-ebiggers@kernel.org>
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
index 456046e158737..b94fb5f81797a 100644
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

