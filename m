Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F0A470F70
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241482AbhLKAcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244279AbhLKAcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:32:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49E5C061714;
        Fri, 10 Dec 2021 16:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80C0AB82A4A;
        Sat, 11 Dec 2021 00:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A114C341CA;
        Sat, 11 Dec 2021 00:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639182524;
        bh=XuaZ1fZ6TwT9fwMbUAdcVm8nv57KY1gx1t0F0FZ5++o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDEJfKUPBqkEOTsZ9D35lUwCEG8DDVjBINAjB/pDg89ibdvTEkM4cZGDxUKY1lo86
         8ShIaWg63ZuTczE3pekMNneJ/hLcghUF2yJOYgx5/nas3RNfsjVhC14+Kkj9HCUIzi
         340DIgASHmULinIHKjgw9RBpa3ETlG6TExDtQR0xZ3lbHEzVVsPMydTpEfVndk1Vpn
         4BM78qwYih9FL341priu19QTNYkRcoouyXPV25cTOpeIJCwKbH8+DblGukji2Idjsv
         WpGpq2XbVN3b1ETRM1QuOUgr8Ydbb48TnurP5QDO0cin8yBaA5YkwabKtdCq4o8p2z
         d4ucKqUpgn6nA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4,4.9 3/3] signalfd: use wake_up_pollfree()
Date:   Fri, 10 Dec 2021 16:28:32 -0800
Message-Id: <20211211002832.153742-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211211002832.153742-1-ebiggers@kernel.org>
References: <20211211002832.153742-1-ebiggers@kernel.org>
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
index 270221fcef42c..9c5fa0ab5e0fe 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -34,17 +34,7 @@
 
 void signalfd_cleanup(struct sighand_struct *sighand)
 {
-	wait_queue_head_t *wqh = &sighand->signalfd_wqh;
-	/*
-	 * The lockless check can race with remove_wait_queue() in progress,
-	 * but in this case its caller should run under rcu_read_lock() and
-	 * sighand_cachep is SLAB_DESTROY_BY_RCU, we can safely return.
-	 */
-	if (likely(!waitqueue_active(wqh)))
-		return;
-
-	/* wait_queue_t->func(POLLFREE) should do remove_wait_queue() */
-	wake_up_poll(wqh, POLLHUP | POLLFREE);
+	wake_up_pollfree(&sighand->signalfd_wqh);
 }
 
 struct signalfd_ctx {
-- 
2.34.1

