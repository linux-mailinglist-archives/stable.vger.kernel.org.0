Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B89470F5A
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345411AbhLKAXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:23:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50972 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345409AbhLKAXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:23:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2038EB82A0F;
        Sat, 11 Dec 2021 00:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA49FC341CA;
        Sat, 11 Dec 2021 00:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639181980;
        bh=g2fpJY8Ik0eUgfvQC3WA/DMV+Xj4NaJeRayahqJ4rYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EorNVSTi/q9L0x8kOHiVLSu76IuTM9/mnbq+XNRPUN4Mi2XCAf1QVdfMiAZrrYuHt
         nt8y1HpkYyb3V7EpBYaWPFNo4m7KuI57icV7HGGsxcbhbiKGnDg9Tp2cEr+vKASPB2
         EhJbqRJO5k5ZmhHjeabcp7DLJw79XyKuhe/oDwq4DFI0XOJBRUJPXF7gIk8+3u1dU5
         G2qa0TGfR2QUH20lF/dB6PqJJPAYmGqj1JtjnEEiJIC0sgGj584dRtlbV6Wuvb0wno
         yCLLvfMw9ypBNBlgdO4AO6F+kmBTuhIj2pnYFmg/30PHiTdbp3qB9q0Wk1H6QezBrg
         aA/4sIOjdVMeg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 v2 3/3] signalfd: use wake_up_pollfree()
Date:   Fri, 10 Dec 2021 16:19:26 -0800
Message-Id: <20211211001926.100856-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211211001926.100856-1-ebiggers@kernel.org>
References: <20211211001926.100856-1-ebiggers@kernel.org>
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
index 1c667af86da52..0b7c6c2c95b89 100644
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
-	wake_up_poll(wqh, POLLHUP | POLLFREE);
+	wake_up_pollfree(&sighand->signalfd_wqh);
 }
 
 struct signalfd_ctx {
-- 
2.34.1

