Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF6ACD777
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbfJFR3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729056AbfJFR3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:29:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBAC92080F;
        Sun,  6 Oct 2019 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382989;
        bh=xd9FKbZCNcSShJBGOLUkhgzrMnFgc/j0qXHYi6FfljA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9TSdNp+VdDSA7qne2l80GgW+4cpfOAkAf9IHZcFdVFOLLqhwifKopILflvSlF1dE
         WyVy3I9hoFcbfTyAy5kNmpsFmcSUGeKxCnr4kPhdxHFdRFBR/OLoUqLMwUK6ZfFJtN
         h8R3WralV4LBL31KPgPeEiOe9yhQ4/ITbrEUhbPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Sean Paul <seanpaul@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/106] dma-buf/sw_sync: Synchronize signal vs syncpt free
Date:   Sun,  6 Oct 2019 19:20:52 +0200
Message-Id: <20191006171143.424340388@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit d3c6dd1fb30d3853c2012549affe75c930f4a2f9 ]

During release of the syncpt, we remove it from the list of syncpt and
the tree, but only if it is not already been removed. However, during
signaling, we first remove the syncpt from the list. So, if we
concurrently free and signal the syncpt, the free may decide that it is
not part of the tree and immediately free itself -- meanwhile the
signaler goes on to use the now freed datastructure.

In particular, we get struck by commit 0e2f733addbf ("dma-buf: make
dma_fence structure a bit smaller v2") as the cb_list is immediately
clobbered by the kfree_rcu.

v2: Avoid calling into timeline_fence_release() from under the spinlock

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111381
Fixes: d3862e44daa7 ("dma-buf/sw-sync: Fix locking around sync_timeline lists")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org> # v4.14+
Acked-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190812154247.20508-1-chris@chris-wilson.co.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/sw_sync.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 53c1d6d36a642..81ba4eb348909 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -141,17 +141,14 @@ static void timeline_fence_release(struct dma_fence *fence)
 {
 	struct sync_pt *pt = dma_fence_to_sync_pt(fence);
 	struct sync_timeline *parent = dma_fence_parent(fence);
+	unsigned long flags;
 
+	spin_lock_irqsave(fence->lock, flags);
 	if (!list_empty(&pt->link)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(fence->lock, flags);
-		if (!list_empty(&pt->link)) {
-			list_del(&pt->link);
-			rb_erase(&pt->node, &parent->pt_tree);
-		}
-		spin_unlock_irqrestore(fence->lock, flags);
+		list_del(&pt->link);
+		rb_erase(&pt->node, &parent->pt_tree);
 	}
+	spin_unlock_irqrestore(fence->lock, flags);
 
 	sync_timeline_put(parent);
 	dma_fence_free(fence);
@@ -274,7 +271,8 @@ static struct sync_pt *sync_pt_create(struct sync_timeline *obj,
 				p = &parent->rb_left;
 			} else {
 				if (dma_fence_get_rcu(&other->base)) {
-					dma_fence_put(&pt->base);
+					sync_timeline_put(obj);
+					kfree(pt);
 					pt = other;
 					goto unlock;
 				}
-- 
2.20.1



