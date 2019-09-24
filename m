Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE34BCFAE
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbfIXRAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 13:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410016AbfIXQpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:45:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D074A217F4;
        Tue, 24 Sep 2019 16:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343540;
        bh=9JDnUe+bzR1K2h89N2eGq+vFz+UQRtG1DOZSfGbpTE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWaWsbweW9XrsJD5KsMPChVpQ027+CIV+2olw4Cvamhe7HMnBLwUL0E5zk3ikZ8D0
         COb0sUd9jqjmHaz/po8z1Kde5R71vwkiKBNgCsvSELdqeEL7mB7Gwrdymtza3+fhrl
         M9W6Nhl0mM4z2xD7YpAcQ2AxbDc+fPJJsOMjrnoA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Sean Paul <seanpaul@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 84/87] dma-buf/sw_sync: Synchronize signal vs syncpt free
Date:   Tue, 24 Sep 2019 12:41:40 -0400
Message-Id: <20190924164144.25591-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
References: 0e2f733addbf ("dma-buf: make dma_fence structure a bit smaller v2")
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
index 051f6c2873c7a..6713cfb1995c6 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -132,17 +132,14 @@ static void timeline_fence_release(struct dma_fence *fence)
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
@@ -265,7 +262,8 @@ static struct sync_pt *sync_pt_create(struct sync_timeline *obj,
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

