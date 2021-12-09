Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D3D46E004
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 02:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241799AbhLIBKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 20:10:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51038 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241618AbhLIBKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 20:10:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88F17B8232C;
        Thu,  9 Dec 2021 01:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05239C00446;
        Thu,  9 Dec 2021 01:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639011989;
        bh=jAWUXBlQyvXEfpJAn1E/S/X3uoyx2HgNIOL0+pN1nDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfzBWjFlymDhjXEOvHkbTrFxydpYG+DYefKLzx2xn+arp8IPnGIbnzbazSL7/8olf
         hMVeSCieg0AUk6fTg9DEvDb5QSYXdp1NiY2VJw1p2xZLOTk7jrWZMMCDExlgUxCfx0
         MdhkKopwShy9J+CG406rifTktXsg8MXU97YT3Futiv6Hpu+CgFpq1PccpBCxm3MYj1
         YDJ5J1fm5S6fbJfG9DF+ONB/YniAipfsuqV+2zARqVaZ7gHTN3N0JNn8H+MnIh1Mio
         lrqQzToxy5An9+s2HLV1QC70AFbYcZU9bud+Xkx3X0w6lyXEE/CvyYhxtnzQ6MdzGT
         gFC7BZqBdE77A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: [PATCH v3 3/5] signalfd: use wake_up_pollfree()
Date:   Wed,  8 Dec 2021 17:04:53 -0800
Message-Id: <20211209010455.42744-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209010455.42744-1-ebiggers@kernel.org>
References: <20211209010455.42744-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

wake_up_poll() uses nr_exclusive=1, so it's not guaranteed to wake up
all exclusive waiters.  Yet, POLLFREE *must* wake up all waiters.  epoll
and aio poll are fortunately not affected by this, but it's very
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

