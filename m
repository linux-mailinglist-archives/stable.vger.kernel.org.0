Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FD827CC26
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbgI2Mdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729669AbgI2LW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:22:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A67723A7B;
        Tue, 29 Sep 2020 11:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378429;
        bh=1skrjOFlpg33Li9byXbrIzTcZgSsfVl0JOdN91rhDYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msEOhEVHvEeX0RygTAwqzYFBawv9La2eKcGBZQ37oGZLehG3P592V0atURKHEcwze
         tBY9cHxbCujo8TvSuvKzLHxWE1RLK4gvYuaRtoK5qXrjS3fbt/BZw5ElRmiRvat+kW
         ER98RQX0qQ8X4+55y9JRTUhC6nUtB9t1Iu/bPL3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/245] dma-fence: Serialise signal enabling (dma_fence_enable_sw_signaling)
Date:   Tue, 29 Sep 2020 12:57:34 +0200
Message-Id: <20200929105947.155740689@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 9c98f021e4e717ffd9948fa65340ea3ef12b7935 ]

Make dma_fence_enable_sw_signaling() behave like its
dma_fence_add_callback() and dma_fence_default_wait() counterparts and
perform the test to enable signaling under the fence->lock, along with
the action to do so. This ensure that should an implementation be trying
to flush the cb_list (by signaling) on retirement before freeing the
fence, it can do so in a race-free manner.

See also 0fc89b6802ba ("dma-fence: Simply wrap dma_fence_signal_locked
with dma_fence_signal").

v2: Refactor all 3 enable_signaling paths to use a common function.
v3: Don't argue, just keep the tracepoint in the existing spot.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191004101140.32713-1-chris@chris-wilson.co.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-fence.c | 78 +++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 43 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 1551ca7df3941..8586cc05def17 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -244,6 +244,30 @@ void dma_fence_free(struct dma_fence *fence)
 }
 EXPORT_SYMBOL(dma_fence_free);
 
+static bool __dma_fence_enable_signaling(struct dma_fence *fence)
+{
+	bool was_set;
+
+	lockdep_assert_held(fence->lock);
+
+	was_set = test_and_set_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
+				   &fence->flags);
+
+	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+		return false;
+
+	if (!was_set && fence->ops->enable_signaling) {
+		trace_dma_fence_enable_signal(fence);
+
+		if (!fence->ops->enable_signaling(fence)) {
+			dma_fence_signal_locked(fence);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 /**
  * dma_fence_enable_sw_signaling - enable signaling on fence
  * @fence: the fence to enable
@@ -256,19 +280,12 @@ void dma_fence_enable_sw_signaling(struct dma_fence *fence)
 {
 	unsigned long flags;
 
-	if (!test_and_set_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
-			      &fence->flags) &&
-	    !test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags) &&
-	    fence->ops->enable_signaling) {
-		trace_dma_fence_enable_signal(fence);
-
-		spin_lock_irqsave(fence->lock, flags);
-
-		if (!fence->ops->enable_signaling(fence))
-			dma_fence_signal_locked(fence);
+	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+		return;
 
-		spin_unlock_irqrestore(fence->lock, flags);
-	}
+	spin_lock_irqsave(fence->lock, flags);
+	__dma_fence_enable_signaling(fence);
+	spin_unlock_irqrestore(fence->lock, flags);
 }
 EXPORT_SYMBOL(dma_fence_enable_sw_signaling);
 
@@ -302,7 +319,6 @@ int dma_fence_add_callback(struct dma_fence *fence, struct dma_fence_cb *cb,
 {
 	unsigned long flags;
 	int ret = 0;
-	bool was_set;
 
 	if (WARN_ON(!fence || !func))
 		return -EINVAL;
@@ -314,25 +330,14 @@ int dma_fence_add_callback(struct dma_fence *fence, struct dma_fence_cb *cb,
 
 	spin_lock_irqsave(fence->lock, flags);
 
-	was_set = test_and_set_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
-				   &fence->flags);
-
-	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
-		ret = -ENOENT;
-	else if (!was_set && fence->ops->enable_signaling) {
-		trace_dma_fence_enable_signal(fence);
-
-		if (!fence->ops->enable_signaling(fence)) {
-			dma_fence_signal_locked(fence);
-			ret = -ENOENT;
-		}
-	}
-
-	if (!ret) {
+	if (__dma_fence_enable_signaling(fence)) {
 		cb->func = func;
 		list_add_tail(&cb->node, &fence->cb_list);
-	} else
+	} else {
 		INIT_LIST_HEAD(&cb->node);
+		ret = -ENOENT;
+	}
+
 	spin_unlock_irqrestore(fence->lock, flags);
 
 	return ret;
@@ -432,7 +437,6 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 	struct default_wait_cb cb;
 	unsigned long flags;
 	signed long ret = timeout ? timeout : 1;
-	bool was_set;
 
 	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 		return ret;
@@ -444,21 +448,9 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 		goto out;
 	}
 
-	was_set = test_and_set_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
-				   &fence->flags);
-
-	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
+	if (!__dma_fence_enable_signaling(fence))
 		goto out;
 
-	if (!was_set && fence->ops->enable_signaling) {
-		trace_dma_fence_enable_signal(fence);
-
-		if (!fence->ops->enable_signaling(fence)) {
-			dma_fence_signal_locked(fence);
-			goto out;
-		}
-	}
-
 	if (!timeout) {
 		ret = 0;
 		goto out;
-- 
2.25.1



