Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFFC3C48B3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbhGLGkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237969AbhGLGjs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 903BD611AF;
        Mon, 12 Jul 2021 06:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071754;
        bh=AaVeBHJ+hq/UItHnqJAyBABInzgok6huWFHNOds8KoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sK3wCGFx0Rb6uyINBEPYRcrEmR2fdCTi61wbB4wWTrnW0n564p/N0Z5I3EpE1PoT8
         Ba3lsLJ/gHdzjOugE+AyGDf0qF00DbXilNEbuzf2XFcw6uq+uhLf4CHp0047TH8AB1
         EWdz5EFxRRbVowoSZPnPxjhybB9TZsxW8VBc4x7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Boqun Feng <boqun.feng@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/593] lockding/lockdep: Avoid to find wrong lock dep path in check_irq_usage()
Date:   Mon, 12 Jul 2021 08:05:22 +0200
Message-Id: <20210712060900.878110304@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit 7b1f8c6179769af6ffa055e1169610b51d71edd5 ]

In the step #3 of check_irq_usage(), we seach backwards to find a lock
whose usage conflicts the usage of @target_entry1 on safe/unsafe.
However, we should only keep the irq-unsafe usage of @target_entry1 into
consideration, because it could be a case where a lock is hardirq-unsafe
but soft-safe, and in check_irq_usage() we find it because its
hardirq-unsafe could result into a hardirq-safe-unsafe deadlock, but
currently since we don't filter out the other usage bits, so we may find
a lock dependency path softirq-unsafe -> softirq-safe, which in fact
doesn't cause a deadlock. And this may cause misleading lockdep splats.

Fix this by only keeping LOCKF_ENABLED_IRQ_ALL bits when we try the
backwards search.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20210618170110.3699115-4-boqun.feng@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 78b51b8ad4f6..788629c06ce9 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2764,8 +2764,18 @@ static int check_irq_usage(struct task_struct *curr, struct held_lock *prev,
 	 * Step 3: we found a bad match! Now retrieve a lock from the backward
 	 * list whose usage mask matches the exclusive usage mask from the
 	 * lock found on the forward list.
+	 *
+	 * Note, we should only keep the LOCKF_ENABLED_IRQ_ALL bits, considering
+	 * the follow case:
+	 *
+	 * When trying to add A -> B to the graph, we find that there is a
+	 * hardirq-safe L, that L -> ... -> A, and another hardirq-unsafe M,
+	 * that B -> ... -> M. However M is **softirq-safe**, if we use exact
+	 * invert bits of M's usage_mask, we will find another lock N that is
+	 * **softirq-unsafe** and N -> ... -> A, however N -> .. -> M will not
+	 * cause a inversion deadlock.
 	 */
-	backward_mask = original_mask(target_entry1->class->usage_mask);
+	backward_mask = original_mask(target_entry1->class->usage_mask & LOCKF_ENABLED_IRQ_ALL);
 
 	ret = find_usage_backwards(&this, backward_mask, &target_entry);
 	if (bfs_error(ret)) {
-- 
2.30.2



