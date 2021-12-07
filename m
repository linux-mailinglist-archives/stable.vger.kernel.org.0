Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7989F46B846
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbhLGKCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 05:02:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51654 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbhLGKCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 05:02:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3BCA3CE1A2D;
        Tue,  7 Dec 2021 09:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1DBC341CA;
        Tue,  7 Dec 2021 09:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638871153;
        bh=q0axvWjUR9JvT6UrywriXxF8qBrpbxelwDD6Sl6hDnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrwCcY8vYARI03xkh734NgeLRCaGeYHVJDuvLTXchr3/ARtLTOKzRaDYsGppPwFU7
         wB1MbEfSgrC8XMu+KyMN2gmiqa13uiUwN+xnZuV7C2a1xTZsLla3A/zoRC5N8X7IeJ
         YOq3ygtgZbLxEXc34lsJFgGrxV985kupO4hJ335F4QCctkxWy7U0n2wu5vMnJbBDBG
         hsXMYJd3oa2iXYVKZIjISBdCTPXbW6rhRCbvlaJ85+kuQwOwAk51hExiGj+I+uK05I
         AlWPxRO3B4q+ZPK08CUKk23CQ/Lga8E4EymMyrOPlQWSNkSqTIi7HO32QEYUZ8gKMP
         7wHF2dCu06bCg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: [PATCH v2 3/5] signalfd: use wake_up_pollfree()
Date:   Tue,  7 Dec 2021 01:57:24 -0800
Message-Id: <20211207095726.169766-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211207095726.169766-1-ebiggers@kernel.org>
References: <20211207095726.169766-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

wake_up_poll() uses nr_exclusive=1, so it's not guaranteed to wake up
all non-exclusive waiters.  Yet, POLLFREE *must* wake up all waiters.
epoll and aio poll are fortunately not affected by this, but it's very
fragile.  Thus, the new function wake_up_pollfree() has been introduced.

Convert signalfd to use wake_up_pollfree().

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: d80e731ecab4 ("epoll: introduce POLLFREE to flush ->signalfd_wqh before kfree()")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/signalfd.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 040e1cf905282..65ce0e72e7b95 100644
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

